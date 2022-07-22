/*
* File : Login
* Version : 1.0.0
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:geolocator/geolocator.dart';

import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';

class SuccessPaymentPage extends StatefulWidget {
  @override
  _SuccessPaymentPage createState() => _SuccessPaymentPage();
}

class _SuccessPaymentPage extends State<SuccessPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                    child: FxText.h4(
                  "Congratulations!",
                  textAlign: TextAlign.center,
                  height: 1,
                  color: CustomTheme.green,
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 0),
                child: Icon(
                  Icons.check,
                  size: 120,
                  color: CustomTheme.green,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                    child: FxText.h4(
                  "Your order has been placed successfully!\n\n"
                  "We are going to contact you as soon possible.",
                  textAlign: TextAlign.center,
                  height: 1,
                  color: CustomTheme.green,
                )),
              ),
              InkWell(
                onTap: () => {pay_online()},
                child: Container(
                  color: CustomTheme.green,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin:
                      EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
                  child: Text(
                    "SOUNDS GOOD",
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

  pay_online() {
    Navigator.pushNamedAndRemoveUntil(context, "/HomesScreen", (r) => false);


    // Utils.navigate_to(
    //     AppConfig., context,
    //     data: {'e_id': itemModel.e_id})
  }
}
