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

// Lazy-load Stripe with config
let stripe;
function getStripe() {
  if (!stripe) {
    stripe = require("stripe")(functions.config().stripe.secret_key);
  }
  return stripe;
}

/**
 * Creates a Stripe PaymentIntent
 *
 * Called from Flutter via cloud_functions package:
 *   FirebaseFunctions.instance.httpsCallable('createPaymentIntent').call({
 *     'amount': 1000,   // $10.00 in cents
 *     'currency': 'usd',
 *   });
 */
exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be logged in to create a payment."
    );
  }

  const { amount, currency } = data;

  // Validate amount
  if (!amount || amount < 50) {
    // Stripe minimum is 50 cents
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Amount must be at least $0.50 (50 cents)."
    );
  }

  try {
    const paymentIntent = await getStripe().paymentIntents.create({
      amount: amount,
      currency: currency || "usd",
      metadata: {
        userId: context.auth.uid,
        purpose: "wallet_top_up",
      },
    });

    return {
      clientSecret: paymentIntent.client_secret,
    };
  } catch (error) {
    console.error("Stripe error:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});

/**
 * Stripe Webhook Handler (Optional but recommended for production)
 *
 * Listens for payment_intent.succeeded events from Stripe
 * and updates the user's wallet balance in Firestore.
 *
 * To set up:
 * 1. In Stripe Dashboard → Webhooks → Add endpoint
 * 2. URL: https://<region>-<project-id>.cloudfunctions.net/stripeWebhook
 * 3. Events: payment_intent.succeeded
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
    const paymentIntent = event.data.object;
    const userId = paymentIntent.metadata.userId;
    const amount = paymentIntent.amount / 100; // Convert cents to dollars

    if (userId) {
      const userRef = admin.firestore().collection("users").doc(userId);

      await admin.firestore().runTransaction(async (transaction) => {
        const userDoc = await transaction.get(userRef);
        const currentBalance = userDoc.exists
          ? userDoc.data().walletBalance || 0
          : 0;

        transaction.update(userRef, {
          walletBalance: currentBalance + amount,
        });

        // Record transaction
        const txnRef = admin.firestore().collection("transactions").doc();
        transaction.set(txnRef, {
          id: txnRef.id,
          userId: userId,
          amount: amount,
          currency: paymentIntent.currency,
          status: "success",
          type: "deposit",
          stripePaymentIntentId: paymentIntent.id,
          description: "Wallet top-up via Stripe",
          createdAt: new Date().toISOString(),
        });
      });

      console.log(`Wallet updated for user ${userId}: +$${amount}`);
    }
  }

  res.json({ received: true });
});
