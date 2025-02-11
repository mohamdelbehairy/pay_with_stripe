import 'package:pay_with_stripe/src/models/payment_model.dart';

import 'models/customer_model.dart';
import 'service/stripe_service.dart';

class PayWithStripe {
  PayWithStripe._();

  static final StripeService _stripService = StripeService();
  static Future<Map> makePayment({required PaymentModel paymentModel}) async {
    return await _stripService.makePayment(paymentModel);
  }

  static Future<Map> createCustomer(
      {required CustomerModel customerModel}) async {
    return await _stripService.createCustomer(customerModel);
  }
}
