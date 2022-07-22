/*
* File : Custom Onboarding
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../widgets/images.dart';

class OnBoardingWidget2 extends StatefulWidget {
  @override
  _OnBoardingWidget2State createState() => _OnBoardingWidget2State();
}

class _OnBoardingWidget2State extends State<OnBoardingWidget2> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    my_delay();
  }

  Future<void> my_delay() async{

    //return;
    ProductModel.get_trending();
    await Future.delayed(Duration(seconds: 5), () {
      Utils.navigate_to(AppConfig.switcher_screen, context);
      return;
      Navigator.pushNamedAndRemoveUntil(
          context, "/HomesScreen", (r) => false);
      // Your code
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
        home: Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: ((MediaQuery.of(context).size.height / 2) - 200)),
                      child: Image.asset(
                        Images.logo_1,
                        height: 150,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: ((MediaQuery.of(context).size.height / 2) - 100)),
                      child: CircularProgressIndicator(
                        color: CustomTheme.primary,
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
