import 'package:flutter/material.dart';
import 'package:pay_with_stripe/pay_with_stripe.dart';

class PaymentModel {
  final num amount;
  CURRENCY currency;
  String merchantDisplayName;
  ThemeMode? style;
  String? customId;
  final bool saveCard;
  final String secretKey, publishableKey;

  PaymentModel({
    required this.amount,
    this.currency = CURRENCY.usd,
    this.merchantDisplayName = 'Flutter Stripe Store Demo',
    this.style,
    this.customId,
    this.saveCard = false,
    required this.secretKey,
    required this.publishableKey,
  });
}
