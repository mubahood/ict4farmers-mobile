import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

import '../pages/homes/pricing/pricing_chart_screen.dart';
import '../theme/app_theme.dart';
import '../theme/material_theme.dart';

class switcher_screen extends StatefulWidget {
  const switcher_screen({Key? key}) : super(key: key);

  @override
  _switcher_screenState createState() => _switcher_screenState();
}

class _switcher_screenState extends State<switcher_screen> {
  late ThemeData theme;
  late MaterialThemeData mTheme;

  late SplashController controller;

  @override
  initState() {
    super.initState();

    FxControllerStore.resetStore();
    theme = AppTheme.theme;
    mTheme = MaterialTheme.estateTheme;

    controller = FxControllerStore.putOrFind(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.copyWith(
          colorScheme:
              theme.colorScheme.copyWith(secondary: mTheme.primaryContainer)),
      debugShowCheckedModeBanner: false,
      home: FxBuilder<SplashController>(
          controller: controller,
          builder: (controller) {
            return Scaffold(
              body: Stack(
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/project/switcher_bg.jpg"),
                  ),
                  Positioned(
                    top: 132,
                    left: 0,
                    right: 0,
                    child: FxText.h3(
                      'What would you like',
                      color: mTheme.onPrimary,
                      textAlign: TextAlign.center,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Positioned(
                    top: 180,
                    left: 0,
                    right: 0,
                    child: FxText.d3(
                      'To See?',
                      color: mTheme.onPrimary,
                      textAlign: TextAlign.center,
                      fontWeight: 800,
                    ),
                  ),
                  Positioned(
                    top: 320,
                    child: FxContainer(
                      onTap: () {
                        Utils.navigate_to(AppConfig.Dashboard, context,data: context);

                      },
                      borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(mTheme.containerRadius.large),
                          topRight:
                              Radius.circular(mTheme.containerRadius.large)),
                      width: MediaQuery.of(context).size.width - 64,
                      marginAll: 32,
                      paddingAll: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FxText.b2(
                            'Market place',
                            fontWeight: 700,
                            color: mTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 380,
                    child: FxCard(
                      onTap: () {
                        Utils.navigate_to(AppConfig.HomePage, context);
                      },
                      paddingAll: 24,
                      color: mTheme.primary,
                      borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(mTheme.containerRadius.large),
                          bottomRight:
                              Radius.circular(mTheme.containerRadius.large)),
                      width: MediaQuery.of(context).size.width - 64,
                      marginAll: 32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FxText.b2(
                            'Farm Management',
                            fontWeight: 700,
                            color: mTheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
