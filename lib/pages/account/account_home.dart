import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict4farmers/pages/account/account_splash.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:provider/provider.dart';

class AccountHome extends StatefulWidget {
  @override
  AccountHomeState createState() => AccountHomeState();
}


class AccountHomeState extends State<AccountHome> {
  late CustomTheme customTheme;
  late ThemeData theme;

  void check_login(){

  }

  @override
  void initState() {
    super.initState();
    check_login();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      theme = AppTheme.theme;
      customTheme = AppTheme.customTheme;

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
        home: Scaffold(
          body: Container(
            margin: FxSpacing.fromLTRB(24, 50, 24, 32),
            child: Column(
              children: [
                FxText.h3(
                  "Account Home",
                  color: customTheme.cookifyPrimary,
                ),

              ],
            ),
          ),
        ),
      );
    });
  }
}
