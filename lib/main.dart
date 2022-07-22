import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:ict4farmers/localizations/app_localization_delegate.dart';
import 'package:ict4farmers/localizations/language.dart';
import 'package:ict4farmers/pages/Dashboard.dart';
import 'package:ict4farmers/pages/account/onboarding_widget.dart';
import 'package:ict4farmers/pages/homes/homes_screen.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

//I love romina
//FROM DISK D

void main() {


  //Utils.init_one_signal();


  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  Utils.boot_system();
  AppTheme.init();
  //
  Utils.init_databse();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider<AppNotifier>(
      create: (context) => AppNotifier(),
      child: ChangeNotifierProvider<FxAppThemeNotifier>(
        create: (context) => FxAppThemeNotifier(),
        child: MyApp(),
      ),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          builder: (context, child) {
            return Directionality(
              textDirection: AppTheme.textDirection,
              child: child!,
            );
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(context), // Add this line
          ],
          supportedLocales: Language.getLocales(),
          home: OnBoardingWidget2(),
          routes: {
            '/OnBoardingWidget': (context) => OnBoardingWidget2(),
            '/HomesScreen': (context) => Dashboard(context),
          },
        );
      },
    );
  }
}

class GlobalMaterialLocalizations {}
