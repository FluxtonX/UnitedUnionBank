class StripeConstants {
  // Replace with your Stripe PUBLISHABLE key from https://dashboard.stripe.com/apikeys
  // NEVER put your Secret Key here — it must stay on the server (Cloud Function)
  static const String publishableKey = 'pk_test_51TM6IB614xu5mJHSMcc79U54h9ERGqy0pIMZKCAoZkjTQqVikRz9Wkh7Lv5c187M1vW7rLRyTI4y7HKs67DQ1qf10039XYnVda';

  // The merchant display name shown on the Stripe Payment Sheet
  static const String merchantDisplayName = 'United Union Bank';

  // Currency code
  static const String defaultCurrency = 'usd';
}
