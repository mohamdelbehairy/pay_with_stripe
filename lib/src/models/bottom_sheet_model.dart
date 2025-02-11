import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class BottomSheetModel {
  bool customFlow;
  String? customerId;
  String? primaryButtonLabel;
  String? customerEphemeralKeySecret;
  String? customerSessionClientSecret;
  String? paymentIntentClientSecret;
  final String? clientSecret;
  IntentConfiguration? intentConfiguration;
  String? merchantDisplayName;
  PaymentSheetApplePay? applePay;
  ThemeMode? style;
  PaymentSheetGooglePay? googlePay;
  bool allowsDelayedPaymentMethods;
  PaymentSheetAppearance? appearance;
  BillingDetails? billingDetails;
  bool? allowsRemovalOfLastSavedPaymentMethod;
  List<String>? paymentMethodOrder;
  String? returnURL;
  BillingDetailsCollectionConfiguration? billingDetailsCollectionConfiguration;
  String? removeSavedPaymentMethodMessage;
  List<CardBrand>? preferredNetworks;

  BottomSheetModel(
      {this.customFlow = false,
      this.customerId,
      this.primaryButtonLabel,
      this.customerEphemeralKeySecret,
      this.customerSessionClientSecret,
      this.paymentIntentClientSecret,
      required this.clientSecret,
      this.intentConfiguration,
      this.merchantDisplayName = 'Flutter Stripe Store Demo',
      this.applePay,
      this.style,
      this.googlePay,
      this.allowsDelayedPaymentMethods = false,
      this.appearance,
      this.billingDetails,
      this.allowsRemovalOfLastSavedPaymentMethod,
      this.paymentMethodOrder,
      this.returnURL,
      this.billingDetailsCollectionConfiguration,
      this.removeSavedPaymentMethodMessage,
      this.preferredNetworks});
}
