class PaymentInputModel {
  final int amount;
  String? currency;
  String? customerId;
  final String secretKey, publishableKey;

  PaymentInputModel(
      {required this.amount,
      this.currency,
      this.customerId,
      required this.secretKey,
      required this.publishableKey});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'customer': customerId,
      };
}
