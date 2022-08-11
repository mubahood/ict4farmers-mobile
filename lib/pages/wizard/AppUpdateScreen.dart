/*
* File : Custom Onboarding
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict4farmers/utils/AppConfig.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

class AppUpdateScreen extends StatefulWidget {
  @override
  _AppUpdateScreenState createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: Scaffold(
            body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxContainer(
                color: Colors.white,
                width: double.infinity,
                height: ((MediaQuery.of(context).size.height / 2) - 60),
                margin: EdgeInsets.all(5),
                child: Image.asset(
                  "${AppConfig.ASSETS_PATH}/wizard/update.png",
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FxText.h1(
                    "Mandatory Update!",
                    color: Colors.black,
                    fontWeight: 700,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: FxText.b1(
                  "We have just updated ${AppConfig.AppName} with new features."
                  " Please go ahead and update your APP version now.",
                  color: Colors.grey.shade800,
                  fontWeight: 500,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 35),
                child: FxButton.block(
                    borderRadiusAll: 5,
                    onPressed: () {
                      Utils.launchURL(AppConfig.MOBILE_APP_LINK);
                    },
                    shadowColor: Colors.white,
                    backgroundColor: CustomTheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FxText.b1(
                          "UPDATE",
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 30,
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        )));
  }
}
