class StripeConstants {
  // Replace with your Stripe PUBLISHABLE key from https://dashboard.stripe.com/apikeys
  // NEVER put your Secret Key here — it must stay on the server (Cloud Function)
  static const String publishableKey = 'pk_live_51TE5heFzACYiAnySFx2qgRuQa06VEJ26I0NIMBvosz8M6PeVzFBmpoU55U9Cnoqmcl9sATpAZrRQUNKwaE2aowW200hebHelkk';

  // The merchant display name shown on the Stripe Payment Sheet
  static const String merchantDisplayName = 'United Union Bank';

  // Currency code
  static const String defaultCurrency = 'usd';
}
