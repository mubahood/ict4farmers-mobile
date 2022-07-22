import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widget/shimmer_list_loading_widget.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'logged_in_screen.dart';
import 'not_logged_screen.dart';

class AccountSplash extends StatefulWidget {
  @override
  AaccountSplashState createState() => AaccountSplashState();
}

class AaccountSplashState extends State<AccountSplash> {
  late CustomTheme customTheme;
  late ThemeData theme;
  bool is_loading = true;
  bool is_logged_in = true;

  @override
  void initState() {
    super.initState();
    check_login();

    FxTextStyle.changeFontFamily(GoogleFonts.openSans);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w400,
      500: FontWeight.w500,
      600: FontWeight.w600,
      700: FontWeight.w700,
      800: FontWeight.w800,
      900: FontWeight.w900,
    });
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
          body: (is_loading)
              ? ShimmerListLoadingWidget()
              : (is_logged_in)
                  ? LoggedInScreen()
                  : not_logged_screen(context),
        ),
      );
    });
  }

  void check_login() async {
    is_loading = true;
    is_logged_in = await Utils.is_login();
    setState(() {
      is_loading = false;
    });
  }
}
