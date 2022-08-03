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

class WizardHomeScreen extends StatefulWidget {
  @override
  _WizardHomeScreenState createState() => _WizardHomeScreenState();
}

class _WizardHomeScreenState extends State<WizardHomeScreen> {
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
                color: Colors.green.shade100,
                width: double.infinity,
                height: ((MediaQuery.of(context).size.height / 2) - 80),
                margin: EdgeInsets.all(20),
                child: Image.asset(
                  "${AppConfig.ASSETS_PATH}/wizard/wizard-1.png",
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: FxText.h1(
                  "Let's help you set up your system",
                  color: Colors.black,
                  fontWeight: 700,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: FxText.b1(
                  "This wizard will help you perfectly set up your system step by step. Just give it a try!",
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
                      Utils.navigate_to(
                          AppConfig.WizardCheckListScreen, context);
                    },
                    shadowColor: Colors.white,
                    backgroundColor: CustomTheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FxText.b1(
                          "PROCEED TO CHECKLIST",
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
              Center(
                child: FxButton.text(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashColor: CustomTheme.primary.withAlpha(40),
                    child: FxText.l2("Not today, I will do this later.",
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        color: CustomTheme.accent)),
              ),
            ],
          ),
        )));
  }
}
