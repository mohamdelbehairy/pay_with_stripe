import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pay_with_strip/pay_with_strip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Pay With Strip"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await PayWithStrip.makePayment(
                paymentModel: PaymentModel(
                    publishableKey: '', // get publish key from strip dashboard
                    secretKey: '', // get secretKey key from strip dashboard
                    amount: 100)); // $100

            log("result: $result");
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
