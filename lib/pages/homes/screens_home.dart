import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/pages/TestPage.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:provider/provider.dart';

import 'single_grid_item.dart';

class ScreensHome extends StatefulWidget {
  @override
  _ScreensHomeState createState() => _ScreensHomeState();
}

class _ScreensHomeState extends State<ScreensHome> {
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
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return Container(
            padding: FxSpacing.fromLTRB(20, 0, 20, 20),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                FxText.t3(
                  "APPS",
                  fontWeight: 700,
                  muted: true,
                ),
                GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    padding: FxSpacing.top(20),
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    children: <Widget>[
                      SinglePageItem(
                        title: "Shopping",
                        icon: './assets/icons/shop-outline.png',
                        navigation: TestPage(),
                      )
                    ]),
                FxSpacing.height(20),
                FxText.t3(
                  "PAGES",
                  fontWeight: 700,
                  muted: true,
                ),
                GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    padding: FxSpacing.top(20),
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    children: <Widget>[
                      SingleGridItem(
                        title: "Quiz",
                        icon: './assets/icons/quiz-outline.png',
                        isComingSoon: true,
                        comingSoonText: "Quiz app is coming soon",
                        items: [
                          SinglePageItem(
                            title: "Shopping",
                            icon: './assets/icons/shop-outline.png',
                            navigation: TestPage(),
                          ),
                        ],
                      ),
                    ]),
                FxContainer(
                  margin: FxSpacing.top(20),
                  borderRadiusAll: 4,
                  color: theme.colorScheme.primary.withAlpha(24),
                  child: Center(
                    child: FxText.b2("More Apps are coming soon...",
                        fontWeight: 600, color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
