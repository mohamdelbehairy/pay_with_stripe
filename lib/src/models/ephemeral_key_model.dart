class EphemeralKeyModel {
  final String? customerId, secretKey;
  final String stripeVersion;

  EphemeralKeyModel(
      {required this.customerId,
      this.stripeVersion = "2024-06-20",
      required this.secretKey});
}
