class CustomerModel {
  final String customerId;
  final String secretKey;
  final String? customerName;

  CustomerModel(
      {required this.customerId, required this.secretKey, this.customerName});
}
