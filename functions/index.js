/**
 * Firebase Cloud Functions — Stripe Payment Intent
 *
 * SETUP INSTRUCTIONS:
 * 1. Install Firebase CLI: npm install -g firebase-tools
 * 2. Navigate to this directory: cd functions
 * 3. Run: npm install
 * 4. Set Stripe secret key:
 *    firebase functions:config:set stripe.secret_key="sk_test_YOUR_SECRET_KEY"
 * 5. Deploy: firebase deploy --only functions
 *
 * IMPORTANT: Never commit your Stripe secret key to source control.
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

const KYC_STATUSES = new Set([
  "not_started",
  "submitted",
  "under_review",
  "approved",
  "rejected",
]);

const ALLOWED_ROLES = new Set([
  "user",
  "admin",
  "partner",
  "compliance",
]);

const DEFAULT_CURRENCY = "usd";
const MIN_DEPOSIT_AMOUNT_CENTS = 100;
const MAX_DEPOSIT_AMOUNT_CENTS = 500000;
const DEFAULT_PROJECTS = {
  meals_global: {
    title: "Global Meal Support",
    category: "meals",
    status: "active",
    targetAmount: 50000,
    totalDonated: 0,
    metrics: { mealsFunded: 0, treesPlanted: 0, healthcareSupport: 0 },
  },
  trees_reforestation: {
    title: "Community Reforestation",
    category: "trees",
    status: "active",
    targetAmount: 75000,
    totalDonated: 0,
    metrics: { mealsFunded: 0, treesPlanted: 0, healthcareSupport: 0 },
  },
  healthcare_access: {
    title: "Healthcare Access Fund",
    category: "healthcare",
    status: "active",
    targetAmount: 100000,
    totalDonated: 0,
    metrics: { mealsFunded: 0, treesPlanted: 0, healthcareSupport: 0 },
  },
};

function requireAuth(context) {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be logged in."
    );
  }
}

function requireAdminOrCompliance(context) {
  requireAuth(context);
  const role = context.auth.token.role;
  if (role !== "admin" && role !== "compliance") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Admin or compliance role is required."
    );
  }
}

function requireAdmin(context) {
  requireAuth(context);
  if (context.auth.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Admin role is required."
    );
  }
}

async function writeAuditLog({
  actorUid,
  actorRole,
  action,
  resourceType,
  resourceId,
  after,
}) {
  await db.collection("audit_logs").add({
    actorUid: actorUid || "system",
    actorRole: actorRole || "system",
    action,
    resourceType,
    resourceId,
    after: after || null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

exports.onUserCreate = functions.auth.user().onCreate(async (user) => {
  const now = admin.firestore.FieldValue.serverTimestamp();
  await db.collection("users").doc(user.uid).set({
    uid: user.uid,
    email: user.email || "",
    name: user.displayName || "",
    phoneNumber: user.phoneNumber || null,
    profileImage: user.photoURL || null,
    role: "user",
    status: "active",
    kycStatus: "not_started",
    kycCompleted: false,
    onboardingCompleted: false,
    interests: [],
    createdAt: now,
    updatedAt: now,
  }, { merge: true });

  await admin.auth().setCustomUserClaims(user.uid, { role: "user" });

  await writeAuditLog({
    actorUid: "system",
    actorRole: "system",
    action: "user_created",
    resourceType: "user",
    resourceId: user.uid,
    after: { role: "user", status: "active" },
  });
});

exports.setUserRole = functions.https.onCall(async (data, context) => {
  requireAdmin(context);

  const { uid, role } = data;
  if (!uid || !ALLOWED_ROLES.has(role)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A valid uid and role are required."
    );
  }

  await admin.auth().setCustomUserClaims(uid, { role });
  await db.collection("users").doc(uid).set({
    role,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });

  await writeAuditLog({
    actorUid: context.auth.uid,
    actorRole: context.auth.token.role,
    action: "user_role_changed",
    resourceType: "user",
    resourceId: uid,
    after: { role },
  });

  return { uid, role };
});

// Lazy-load Stripe with config
let stripe;
function getStripe() {
  if (!stripe) {
    stripe = require("stripe")(functions.config().stripe.secret_key);
  }
  return stripe;
}

async function createDepositIntentHandler(data, context) {
  requireAuth(context);

  const uid = context.auth.uid;
  const amount = Number(data.amount);
  const currency = String(data.currency || DEFAULT_CURRENCY).toLowerCase();

  if (!Number.isInteger(amount) ||
      amount < MIN_DEPOSIT_AMOUNT_CENTS ||
      amount > MAX_DEPOSIT_AMOUNT_CENTS) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      `Deposit amount must be between ${MIN_DEPOSIT_AMOUNT_CENTS} and ` +
        `${MAX_DEPOSIT_AMOUNT_CENTS} cents.`
    );
  }

  if (currency !== DEFAULT_CURRENCY) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Only USD deposits are supported in the MVP."
    );
  }

  const userDoc = await db.collection("users").doc(uid).get();
  if (!userDoc.exists) {
    throw new functions.https.HttpsError("failed-precondition", "User profile not found.");
  }

  const user = userDoc.data();
  if (user.status && user.status !== "active") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "User account is not active."
    );
  }

  if (user.kycStatus !== "approved") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "KYC approval is required before adding funds."
    );
  }

  const walletDoc = await db.collection("wallets").doc(uid).get();
  if (!walletDoc.exists || walletDoc.data().status !== "active") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "An active wallet is required before adding funds."
    );
  }

  try {
    const idempotencyKey = `deposit_intent:${uid}:${Date.now()}:${amount}:${currency}`;
    const paymentIntent = await getStripe().paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: { enabled: true },
      metadata: {
        userId: uid,
        purpose: "wallet_top_up",
      },
    }, { idempotencyKey });

    const now = admin.firestore.FieldValue.serverTimestamp();
    await db.collection("payment_intents").doc(paymentIntent.id).set({
      uid,
      stripePaymentIntentId: paymentIntent.id,
      amount: amount / 100,
      amountInCents: amount,
      currency,
      status: "pending",
      purpose: "wallet_top_up",
      idempotencyKey,
      createdAt: now,
      updatedAt: now,
    }, { merge: true });

    await writeAuditLog({
      actorUid: uid,
      actorRole: context.auth.token.role || "user",
      action: "deposit_intent_created",
      resourceType: "payment_intent",
      resourceId: paymentIntent.id,
      after: { amount, currency, status: "pending" },
    });

    return {
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
      status: "pending",
    };
  } catch (error) {
    console.error("Stripe error:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
}

exports.createDepositIntent = functions.https.onCall(createDepositIntentHandler);
exports.createPaymentIntent = functions.https.onCall(createDepositIntentHandler);

/**
 * Mock Onfido KYC submission.
 * Flutter uploads placeholder images to Storage, then calls this function.
 * Approval is intentionally not controlled by Flutter.
 */
exports.submitKycCase = functions.https.onCall(async (data, context) => {
  requireAuth(context);

  const uid = context.auth.uid;
  const {
    caseId,
    provider,
    documentType,
    documentFrontPath,
    documentBackPath,
    selfiePath,
    addressProofPath,
    personalInfo,
  } = data;

  if (!caseId || !documentFrontPath || !documentBackPath || !selfiePath ||
      !addressProofPath) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "KYC submission is missing required document paths."
    );
  }

  const allowedPrefix = `kyc/${uid}/${caseId}/`;
  const paths = [
    documentFrontPath,
    documentBackPath,
    selfiePath,
    addressProofPath,
  ];
  if (!paths.every((path) => path.startsWith(allowedPrefix))) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "KYC document paths must belong to the authenticated user."
    );
  }

  const now = admin.firestore.FieldValue.serverTimestamp();
  const caseRef = db.collection("kyc_cases").doc(caseId);
  const userRef = db.collection("users").doc(uid);

  await db.runTransaction(async (transaction) => {
    const existingCase = await transaction.get(caseRef);
    if (existingCase.exists) {
      throw new functions.https.HttpsError(
        "already-exists",
        "This KYC case already exists."
      );
    }

    transaction.set(caseRef, {
      caseId,
      uid,
      provider: provider || "mock_onfido",
      status: "submitted",
      documentType: documentType || "unknown",
      documentFrontPath,
      documentBackPath,
      selfiePath,
      addressProofPath,
      personalInfo: personalInfo || {},
      submittedAt: now,
      createdAt: now,
      updatedAt: now,
    });

    transaction.set(userRef, {
      kycStatus: "submitted",
      kycCompleted: false,
      activeKycCaseId: caseId,
      updatedAt: now,
    }, { merge: true });
  });

  await writeAuditLog({
    actorUid: uid,
    actorRole: "user",
    action: "kyc_case_submitted",
    resourceType: "kyc_case",
    resourceId: caseId,
    after: { status: "submitted" },
  });

  return { caseId, status: "submitted" };
});

/**
 * Mock compliance/admin review for KYC cases.
 * Allowed statuses: under_review, approved, rejected.
 */
exports.reviewKycCase = functions.https.onCall(async (data, context) => {
  requireAdminOrCompliance(context);

  const { caseId, status, rejectionReason } = data;

  if (!caseId || !KYC_STATUSES.has(status) ||
      !["under_review", "approved", "rejected"].includes(status)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A valid caseId and review status are required."
    );
  }

  if (status === "rejected" && !rejectionReason) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A rejection reason is required when rejecting KYC."
    );
  }

  const caseRef = db.collection("kyc_cases").doc(caseId);
  const now = admin.firestore.FieldValue.serverTimestamp();
  let uid;

  await db.runTransaction(async (transaction) => {
    const caseDoc = await transaction.get(caseRef);
    if (!caseDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "KYC case not found."
      );
    }

    const caseData = caseDoc.data();
    uid = caseData.uid;
    const userRef = db.collection("users").doc(uid);

    transaction.update(caseRef, {
      status,
      rejectionReason: status === "rejected" ? rejectionReason : null,
      reviewedAt: status === "approved" || status === "rejected" ? now : null,
      reviewedBy: context.auth.uid,
      updatedAt: now,
    });

    transaction.set(userRef, {
      kycStatus: status,
      kycCompleted: status === "approved",
      updatedAt: now,
    }, { merge: true });

    if (status === "approved") {
      const walletRef = db.collection("wallets").doc(uid);
      const balanceRef = walletRef.collection("balances").doc("usd");
      transaction.set(walletRef, {
        uid,
        status: "active",
        baseCurrency: "usd",
        createdAt: now,
        updatedAt: now,
      }, { merge: true });
      transaction.set(balanceRef, {
        currency: "usd",
        available: 0,
        pending: 0,
        totalCredits: 0,
        totalDebits: 0,
        updatedAt: now,
      }, { merge: true });
    }
  });

  await writeAuditLog({
    actorUid: context.auth.uid,
    actorRole: context.auth.token.role,
    action: "kyc_case_reviewed",
    resourceType: "kyc_case",
    resourceId: caseId,
    after: { status, uid },
  });

  return { caseId, status };
});

async function handlePaymentSucceeded(paymentIntent) {
  const userId = paymentIntent.metadata.userId;
  const amount = paymentIntent.amount / 100;
  const currency = paymentIntent.currency;

  if (!userId) return;

  const walletRef = db.collection("wallets").doc(userId);
  const balanceRef = walletRef.collection("balances").doc(currency);
  const ledgerRef = db.collection("ledger_entries")
    .doc(`stripe_${paymentIntent.id}_deposit`);
  const paymentRef = db.collection("payment_intents").doc(paymentIntent.id);

  await db.runTransaction(async (transaction) => {
    const existingLedger = await transaction.get(ledgerRef);
    if (existingLedger.exists) {
      transaction.set(paymentRef, {
        uid: userId,
        stripePaymentIntentId: paymentIntent.id,
        amount,
        amountInCents: paymentIntent.amount,
        currency,
        status: "succeeded",
        ledgerEntryId: ledgerRef.id,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
      return;
    }

    const balanceDoc = await transaction.get(balanceRef);
    const currentAvailable = balanceDoc.exists
      ? balanceDoc.data().available || 0
      : 0;
    const currentCredits = balanceDoc.exists
      ? balanceDoc.data().totalCredits || 0
      : 0;
    const balanceAfter = currentAvailable + amount;
    const now = admin.firestore.FieldValue.serverTimestamp();

    transaction.set(walletRef, {
      uid: userId,
      status: "active",
      baseCurrency: currency,
      updatedAt: now,
    }, { merge: true });

    transaction.set(balanceRef, {
      currency,
      available: balanceAfter,
      pending: 0,
      totalCredits: currentCredits + amount,
      updatedAt: now,
    }, { merge: true });

    transaction.set(ledgerRef, {
      entryId: ledgerRef.id,
      uid: userId,
      walletId: userId,
      currency,
      amount,
      direction: "credit",
      type: "deposit",
      status: "posted",
      sourceType: "stripe_payment",
      sourceId: paymentIntent.id,
      idempotencyKey: `stripe:payment_intent:${paymentIntent.id}:deposit`,
      balanceAfter,
      description: "Wallet top-up via Stripe",
      createdAt: now,
      createdBy: "stripeWebhook",
    });

    transaction.set(paymentRef, {
      uid: userId,
      stripePaymentIntentId: paymentIntent.id,
      amount,
      amountInCents: paymentIntent.amount,
      currency,
      status: "succeeded",
      ledgerEntryId: ledgerRef.id,
      idempotencyKey: `stripe:payment_intent:${paymentIntent.id}:deposit`,
      updatedAt: now,
    }, { merge: true });
  });

  await writeAuditLog({
    actorUid: "stripe",
    actorRole: "system",
    action: "deposit_succeeded",
    resourceType: "payment_intent",
    resourceId: paymentIntent.id,
    after: { uid: userId, amount, currency },
  });
}

async function handlePaymentFailed(paymentIntent) {
  const userId = paymentIntent.metadata.userId;
  if (!userId) return;

  await db.collection("payment_intents").doc(paymentIntent.id).set({
    uid: userId,
    stripePaymentIntentId: paymentIntent.id,
    amount: paymentIntent.amount / 100,
    amountInCents: paymentIntent.amount,
    currency: paymentIntent.currency,
    status: "failed",
    failureCode: paymentIntent.last_payment_error?.code || null,
    failureMessage: paymentIntent.last_payment_error?.message || null,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });

  await writeAuditLog({
    actorUid: "stripe",
    actorRole: "system",
    action: "deposit_failed",
    resourceType: "payment_intent",
    resourceId: paymentIntent.id,
    after: { uid: userId, status: "failed" },
  });
}

async function handleChargeRefunded(charge) {
  const paymentIntentId = charge.payment_intent;
  if (!paymentIntentId) return;

  const paymentRef = db.collection("payment_intents").doc(paymentIntentId);
  const paymentDoc = await paymentRef.get();
  if (!paymentDoc.exists) return;

  const payment = paymentDoc.data();
  const userId = payment.uid;
  const amount = (charge.amount_refunded || charge.amount || 0) / 100;
  const currency = charge.currency || payment.currency || DEFAULT_CURRENCY;
  if (!userId || amount <= 0) return;

  const walletRef = db.collection("wallets").doc(userId);
  const balanceRef = walletRef.collection("balances").doc(currency);
  const ledgerRef = db.collection("ledger_entries")
    .doc(`stripe_${paymentIntentId}_refund`);

  await db.runTransaction(async (transaction) => {
    const existingLedger = await transaction.get(ledgerRef);
    if (existingLedger.exists) {
      transaction.set(paymentRef, {
        status: "refunded",
        refundedAmount: amount,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
      return;
    }

    const balanceDoc = await transaction.get(balanceRef);
    const currentAvailable = balanceDoc.exists
      ? balanceDoc.data().available || 0
      : 0;
    const currentDebits = balanceDoc.exists
      ? balanceDoc.data().totalDebits || 0
      : 0;
    const balanceAfter = currentAvailable - amount;
    const now = admin.firestore.FieldValue.serverTimestamp();

    transaction.set(walletRef, {
      uid: userId,
      status: "active",
      baseCurrency: currency,
      updatedAt: now,
    }, { merge: true });

    transaction.set(balanceRef, {
      currency,
      available: balanceAfter,
      pending: 0,
      totalDebits: currentDebits + amount,
      updatedAt: now,
    }, { merge: true });

    transaction.set(ledgerRef, {
      entryId: ledgerRef.id,
      uid: userId,
      walletId: userId,
      currency,
      amount,
      direction: "debit",
      type: "deposit_refund",
      status: "posted",
      sourceType: "stripe_refund",
      sourceId: paymentIntentId,
      idempotencyKey: `stripe:payment_intent:${paymentIntentId}:refund`,
      balanceAfter,
      description: "Stripe deposit refund",
      createdAt: now,
      createdBy: "stripeWebhook",
    });

    transaction.set(paymentRef, {
      status: "refunded",
      refundedAmount: amount,
      refundLedgerEntryId: ledgerRef.id,
      updatedAt: now,
    }, { merge: true });
  });

  await writeAuditLog({
    actorUid: "stripe",
    actorRole: "system",
    action: "deposit_refunded",
    resourceType: "payment_intent",
    resourceId: paymentIntentId,
    after: { uid: userId, amount, currency },
  });
}

async function requireApprovedWalletUser(uid) {
  const userDoc = await db.collection("users").doc(uid).get();
  if (!userDoc.exists) {
    throw new functions.https.HttpsError("failed-precondition", "User profile not found.");
  }

  const user = userDoc.data();
  if (user.status && user.status !== "active") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "User account is not active."
    );
  }

  if (user.kycStatus !== "approved") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "KYC approval is required for wallet actions."
    );
  }
}

function validateWalletAmount(amountInCents, operation) {
  const amount = Number(amountInCents);
  if (!Number.isInteger(amount) || amount < 100 || amount > 500000) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      `${operation} amount must be between 100 and 500000 cents.`
    );
  }
  return amount / 100;
}

exports.createDonation = functions.https.onCall(async (data, context) => {
  requireAuth(context);

  const uid = context.auth.uid;
  await requireApprovedWalletUser(uid);

  const amount = validateWalletAmount(data.amountInCents, "Donation");
  const currency = String(data.currency || DEFAULT_CURRENCY).toLowerCase();
  const projectId = String(data.projectId || "");

  if (currency !== DEFAULT_CURRENCY) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Only USD donations are supported in the MVP."
    );
  }

  if (!projectId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A projectId is required."
    );
  }

  const donationRef = db.collection("donations").doc();
  const ledgerRef = db.collection("ledger_entries").doc(`donation_${donationRef.id}`);
  const walletRef = db.collection("wallets").doc(uid);
  const balanceRef = walletRef.collection("balances").doc(currency);
  const projectRef = db.collection("projects").doc(projectId);
  const receiptNumber = `DON-${Date.now()}-${donationRef.id.slice(0, 6).toUpperCase()}`;

  await db.runTransaction(async (transaction) => {
    const walletDoc = await transaction.get(walletRef);
    if (!walletDoc.exists || walletDoc.data().status !== "active") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "An active wallet is required."
      );
    }

    const balanceDoc = await transaction.get(balanceRef);
    const available = balanceDoc.exists ? balanceDoc.data().available || 0 : 0;
    const totalDebits = balanceDoc.exists ? balanceDoc.data().totalDebits || 0 : 0;
    if (available < amount) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Insufficient wallet balance."
      );
    }

    const projectDoc = await transaction.get(projectRef);
    let project;
    if (!projectDoc.exists && DEFAULT_PROJECTS[projectId]) {
      project = DEFAULT_PROJECTS[projectId];
      transaction.set(projectRef, {
        projectId,
        ...project,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
    } else if (projectDoc.exists) {
      project = projectDoc.data();
    }

    if (!project || project.status !== "active") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Selected impact project is not active."
      );
    }

    const balanceAfter = available - amount;
    const now = admin.firestore.FieldValue.serverTimestamp();
    const meals = Math.floor(amount / 5);
    const trees = Math.floor(amount / 10);
    const healthcare = Math.floor(amount / 25);

    transaction.set(balanceRef, {
      currency,
      available: balanceAfter,
      totalDebits: totalDebits + amount,
      updatedAt: now,
    }, { merge: true });

    transaction.set(ledgerRef, {
      entryId: ledgerRef.id,
      uid,
      walletId: uid,
      currency,
      amount,
      direction: "debit",
      type: "donation",
      status: "posted",
      sourceType: "donation",
      sourceId: donationRef.id,
      idempotencyKey: `donation:${donationRef.id}`,
      balanceAfter,
      description: `Donation to ${project.title || "Impact Project"}`,
      createdAt: now,
      createdBy: "createDonation",
    });

    transaction.set(donationRef, {
      donationId: donationRef.id,
      uid,
      projectId,
      projectTitle: project.title || "Impact Project",
      amount,
      amountInCents: Math.round(amount * 100),
      currency,
      ledgerEntryId: ledgerRef.id,
      receiptNumber,
      status: "succeeded",
      impactMetrics: { meals, trees, healthcare },
      createdAt: now,
    });

    transaction.set(projectRef, {
      totalDonated: (project.totalDonated || 0) + amount,
      metrics: {
        mealsFunded: (project.metrics?.mealsFunded || 0) + meals,
        treesPlanted: (project.metrics?.treesPlanted || 0) + trees,
        healthcareSupport: (project.metrics?.healthcareSupport || 0) + healthcare,
      },
      updatedAt: now,
    }, { merge: true });
  });

  await writeAuditLog({
    actorUid: uid,
    actorRole: context.auth.token.role || "user",
    action: "donation_created",
    resourceType: "donation",
    resourceId: donationRef.id,
    after: { projectId, amount, currency, receiptNumber },
  });

  return {
    donationId: donationRef.id,
    receiptNumber,
    ledgerEntryId: ledgerRef.id,
    status: "succeeded",
  };
});

exports.createWithdrawalRequest = functions.https.onCall(async (data, context) => {
  requireAuth(context);

  const uid = context.auth.uid;
  await requireApprovedWalletUser(uid);

  const amount = validateWalletAmount(data.amountInCents, "Withdrawal");
  const currency = String(data.currency || DEFAULT_CURRENCY).toLowerCase();
  const destination = data.destination || {};

  if (currency !== DEFAULT_CURRENCY) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Only USD withdrawals are supported in the MVP."
    );
  }

  if (!destination.accountHolderName || !destination.bankName ||
      !destination.accountNumberLast4 || !destination.routingNumberLast4) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Withdrawal destination details are incomplete."
    );
  }

  const requestRef = db.collection("withdrawal_requests").doc();
  const ledgerRef = db.collection("ledger_entries").doc(`withdrawal_hold_${requestRef.id}`);
  const walletRef = db.collection("wallets").doc(uid);
  const balanceRef = walletRef.collection("balances").doc(currency);

  await db.runTransaction(async (transaction) => {
    const walletDoc = await transaction.get(walletRef);
    if (!walletDoc.exists || walletDoc.data().status !== "active") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "An active wallet is required."
      );
    }

    const balanceDoc = await transaction.get(balanceRef);
    const available = balanceDoc.exists ? balanceDoc.data().available || 0 : 0;
    const pending = balanceDoc.exists ? balanceDoc.data().pending || 0 : 0;
    const totalDebits = balanceDoc.exists ? balanceDoc.data().totalDebits || 0 : 0;
    if (available < amount) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Insufficient wallet balance."
      );
    }

    const balanceAfter = available - amount;
    const now = admin.firestore.FieldValue.serverTimestamp();

    transaction.set(balanceRef, {
      currency,
      available: balanceAfter,
      pending: pending + amount,
      totalDebits: totalDebits + amount,
      updatedAt: now,
    }, { merge: true });

    transaction.set(ledgerRef, {
      entryId: ledgerRef.id,
      uid,
      walletId: uid,
      currency,
      amount,
      direction: "debit",
      type: "withdrawal_hold",
      status: "pending",
      sourceType: "withdrawal",
      sourceId: requestRef.id,
      idempotencyKey: `withdrawal:${requestRef.id}:hold`,
      balanceAfter,
      description: "Withdrawal request hold",
      createdAt: now,
      createdBy: "createWithdrawalRequest",
    });

    transaction.set(requestRef, {
      requestId: requestRef.id,
      uid,
      amount,
      amountInCents: Math.round(amount * 100),
      currency,
      status: "pending_review",
      destination: {
        accountHolderName: destination.accountHolderName,
        bankName: destination.bankName,
        accountNumberLast4: destination.accountNumberLast4,
        routingNumberLast4: destination.routingNumberLast4,
      },
      ledgerEntryId: ledgerRef.id,
      payoutProvider: "not_configured",
      createdAt: now,
      updatedAt: now,
    });
  });

  await writeAuditLog({
    actorUid: uid,
    actorRole: context.auth.token.role || "user",
    action: "withdrawal_requested",
    resourceType: "withdrawal_request",
    resourceId: requestRef.id,
    after: { amount, currency, status: "pending_review" },
  });

  return {
    requestId: requestRef.id,
    ledgerEntryId: ledgerRef.id,
    status: "pending_review",
  };
});

/**
 * Stripe Webhook Handler
 *
 * To set up:
 * 1. In Stripe Dashboard → Webhooks → Add endpoint
 * 2. URL: https://<region>-<project-id>.cloudfunctions.net/stripeWebhook
 * 3. Events: payment_intent.succeeded, payment_intent.payment_failed,
 *    charge.refunded
 * 4. Get the webhook signing secret and set it:
 *    firebase functions:config:set stripe.webhook_secret="whsec_..."
 */
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers["stripe-signature"];
  const endpointSecret = functions.config().stripe.webhook_secret;

  let event;
  try {
    event = getStripe().webhooks.constructEvent(req.rawBody, sig, endpointSecret);
  } catch (err) {
    console.error("Webhook signature verification failed:", err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  if (event.type === "payment_intent.succeeded") {
    await handlePaymentSucceeded(event.data.object);
  } else if (event.type === "payment_intent.payment_failed") {
    await handlePaymentFailed(event.data.object);
  } else if (event.type === "charge.refunded") {
    await handleChargeRefunded(event.data.object);
  }

  res.json({ received: true });
});
