/*
* File : Login
* Version : 1.0.0
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:geolocator/geolocator.dart';

import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPage createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                    child: FxText.h4(
                  "How do you want to pay us?",
                  textAlign: TextAlign.center,
                  height: 1,
                  color: CustomTheme.primary,
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 0),
                child: Icon(
                  Icons.monetization_on_outlined,
                  size: 120,
                  color: CustomTheme.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                color: CustomTheme.primary,
                child: FxText.b1(
                  "At ${AppConfig.AppName}, we support 2 modes of payment, Online payment and Cash on delivery.\n\n"
                  "Press the PAY ONLINE button to securely pay us online, use the custom token provided in the payment form "
                  "to help use uniquely you! Thanks."
                  "\n\n"
                  "CUSTOMER TOKEN: #12019",
                  fontSize: 16,
                  textAlign: TextAlign.justify,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () => {pay_online()},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: CustomTheme.primary,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin:
                      EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
                  child: Text(
                    "PAY ONLINE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: CustomTheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () => {cash_on_delivery()},
                child: Container(
                  color: CustomTheme.primary,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin:
                      EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
                  child: Text(
                    "CASH ON DELIVERY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  Future<void> get_location() async {
    Position p = await Utils.get_device_location();
    if (p != null) {
      if (p.latitude != null && p.longitude != null) {
        Navigator.pushNamedAndRemoveUntil(context, "/HomesScreen", (r) => false);
      }
    }
  }

  cash_on_delivery() {
    Utils.navigate_to(AppConfig.SuccessPaymentPage, context);
  }

  pay_online() {
    Utils.launch_browser(
        'https://ravesandbox.flutterwave.com/pay/lp8fz2bblnfp');
    Utils.navigate_to(AppConfig.SuccessPaymentPage, context);
    //Utils.launch_browser(
    //   AppConfig.BASE_URL + "/privacy-policy.html");
  }
}
