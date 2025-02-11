import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay_with_stripe/src/models/bottom_sheet_model.dart';
import 'package:pay_with_stripe/src/models/customer_model.dart';
import 'package:pay_with_stripe/src/models/ephemeral_key_model.dart';
import 'package:pay_with_stripe/src/models/payment_input_model.dart';
import 'package:pay_with_stripe/src/models/create_payment_intent_model/create_payment_intent_model.dart';
import 'package:pay_with_stripe/src/models/payment_model.dart';

class StripeService {
  final Dio _dio = Dio();

  // create payment intent this request will call strip dashboard to init payment
  Future<Map> _createPaymentIntent(PaymentInputModel paymentInputModel) async {
    try {
      Stripe.publishableKey = paymentInputModel.publishableKey;
      final response = await _dio.post(
        _createPaymentIntentUrl,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${paymentInputModel.secretKey}",
          },
        ),
        data: paymentInputModel.toJson(),
      );

      return {
        'error': false,
        'data': CreatePaymentIntentModel.fromJson(response.data)
      };
    } on DioException catch (e) {
      return {
        'error': true,
        'data': {
          'code': e.response?.data['error']['code'],
          'message': e.response?.data['error']['message']
        }
      };
    } catch (e) {
      return {
        'error': true,
        'data': {'code': 'unknown', 'message': e.toString()}
      };
    }
  }

  // init payment sheet this init strip payment sheet
  Future<void> _initPaymentSheet(BottomSheetModel bottomSheetModeld) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: bottomSheetModeld.customFlow,
          merchantDisplayName: bottomSheetModeld.merchantDisplayName,
          paymentIntentClientSecret: bottomSheetModeld.clientSecret,
          style: bottomSheetModeld.style,
          customerId: bottomSheetModeld.customerId,
          customerEphemeralKeySecret:
              bottomSheetModeld.customerEphemeralKeySecret),
    );
  }

  // this method will display payment sheet
  Future<Map> _presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return {'error': false, 'data': 'The payment was successful'};
    } on StripeException catch (e) {
      return {
        'error': true,
        'data': {'code': e.error.code, 'message': e.error.message}
      };
    } catch (e) {
      return {
        'error': true,
        'data': {'code': 'unknown', 'message': e.toString()}
      };
    }
  }

  // this method will check transaction done or not
  Future<Map> _displayPaymentSheet(String id, String secretKey) async {
    final result = await _presentPaymentSheet();
    if (result['error'] == false) {
      final transaction = await _getTransaction(id, secretKey);
      return {'error': false, 'data': transaction['data']};
    } else {
      return {'error': true, 'data': result['data']};
    }
  }

  // this method contain init and display payment sheet
  Future<Map> _createPaymentSheet(
      CreatePaymentIntentModel createPaymentIntent, PaymentModel paymentModel,
      {String? ephemeraKey}) async {
    await _initPaymentSheet(BottomSheetModel(
        clientSecret: createPaymentIntent.clientSecret,
        merchantDisplayName: paymentModel.merchantDisplayName,
        style: paymentModel.style,
        customerId: paymentModel.customId,
        customerEphemeralKeySecret: ephemeraKey));
    return await _displayPaymentSheet(
        createPaymentIntent.id!, paymentModel.secretKey);
  }

  // this method check ephemeral key is valid or not
  Future<Map> _useEphemeralKey(
      Map<dynamic, dynamic> ephemeralResponse,
      CreatePaymentIntentModel createPaymentIntent,
      PaymentModel paymentModel) async {
    if (ephemeralResponse['error'] == false) {
      final result = await _createPaymentSheet(
          createPaymentIntent, paymentModel,
          ephemeraKey: ephemeralResponse['data']!);

      if (result['error'] == false) {
        return {'error': false, 'data': result['data']};
      }
      return {'error': true, 'data': result['data']};
    }
    return {'error': true, 'data': ephemeralResponse['data']};
  }

  // this method check if user want to save card or not
  Future<Map> _buildPayment(PaymentModel paymentModel,
      CreatePaymentIntentModel createPaymentIntent) async {
    if (paymentModel.saveCard) {
      final ephemeralResponse = await _createEphemeralKey(EphemeralKeyModel(
          customerId: paymentModel.customId,
          secretKey: paymentModel.secretKey));
      return await _useEphemeralKey(
          ephemeralResponse, createPaymentIntent, paymentModel);
    }
    return await _createPaymentSheet(createPaymentIntent, paymentModel);
  }

  // this method create ephemeral key
  Future<Map> _createEphemeralKey(EphemeralKeyModel ephemeralKey) async {
    try {
      final response = await _dio.post(
        _createEphemeralKeyUrl,
        data: {
          'customer': ephemeralKey.customerId,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Stripe-Version": ephemeralKey.stripeVersion,
            'Authorization': 'Bearer ${ephemeralKey.secretKey}',
          },
        ),
      );
      return {'error': false, 'data': response.data['secret']};
    } on DioException catch (e) {
      return {
        'error': true,
        'data': {
          'code': 'check customer id or secret key',
          'message': e.response?.data['error']['message']
        }
      };
    } catch (e) {
      return {
        'error': true,
        'data': {'code': 'unknown', 'message': e.toString()}
      };
    }
  }

  // this method make payment (final method)
  Future<Map> makePayment(PaymentModel paymentModel) async {
    final response = await _createPaymentIntent(PaymentInputModel(
        secretKey: paymentModel.secretKey,
        publishableKey: paymentModel.publishableKey,
        amount: (paymentModel.amount * 100).toInt(),
        currency: paymentModel.currency.name,
        customerId: paymentModel.customId));

    if (response['error'] == false) {
      final CreatePaymentIntentModel paymentIntent = response['data'];

      final result = await _buildPayment(paymentModel, paymentIntent);

      if (result['error'] == false) {
        return {'error': false, 'data': result['data']};
      } else {
        return {'error': true, 'data': result['data']};
      }
    } else {
      return {'error': true, 'data': response['data']};
    }
  }

  // this method create customer
  Future<Map> createCustomer(CustomerModel customerModel) async {
    try {
      final response = await _dio.post(
        _createCustomerUrl,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${customerModel.secretKey}",
          },
        ),
        data: {
          'id': customerModel.customerId,
          'name': customerModel.customerName,
        },
      );

      return {
        'error': false,
        'data': {
          'message': 'Your customer was created successfully',
          'id': response.data['id'],
          'name': response.data['name'],
          'created': response.data['created'],
          'email': response.data['email'],
          'phone': response.data['phone'],
          'object': response.data['object'],
          'address': response.data['address'],
        },
      };
    } on DioException catch (e) {
      return {
        'error': true,
        'data': {
          'code': e.response?.data['error']['code'],
          'message': e.response?.data['error']['message']
        }
      };
    } catch (e) {
      return {
        'error': true,
        'data': {'code': 'unknown', 'message': e.toString()}
      };
    }
  }

  // this method get transaction
  Future<Map> _getTransaction(String id, String secretKey) async {
    try {
      final response = await Dio().get("$_getTransactionUrl?$id",
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer $secretKey",
            },
          ));
      return {
        'error': false,
        'data': {
          'message': 'The payment was successful',
          'customer': response.data['data'][0]['customer'],
          'created': response.data['data'][0]['created'],
          'currency': response.data['data'][0]['currency'],
          'description': response.data['data'][0]['description'],
          'payment_method_details': response.data['data'][0]
              ['payment_method_details']['card'],
        },
      };
    } on DioException catch (e) {
      return {
        'error': true,
        'data': {
          'code': e.response?.data['error']['code'],
          'message': e.response?.data['error']['message']
        }
      };
    } catch (e) {
      return {
        'error': true,
        'data': {'code': 'unknown', 'message': e.toString()}
      };
    }
  }
}

const _createPaymentIntentUrl = 'https://api.stripe.com/v1/payment_intents';

const _createEphemeralKeyUrl = 'https://api.stripe.com/v1/ephemeral_keys';

const _createCustomerUrl = 'https://api.stripe.com/v1/customers';

const _getTransactionUrl = 'https://api.stripe.com/v1/charges';
