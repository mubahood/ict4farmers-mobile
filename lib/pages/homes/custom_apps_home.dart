import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/icons/box_icon/box_icon_data.dart';
import 'package:ict4farmers/pages/TestPage.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'single_grid_item.dart';

class CustomAppsHome extends StatefulWidget {
  @override
  _CustomAppsHomeState createState() => _CustomAppsHomeState();
}

class _CustomAppsHomeState extends State<CustomAppsHome>
    with TickerProviderStateMixin {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
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
                  "FULL APPS",
                  fontWeight: 700,
                  muted: true,
                ),
                FxSpacing.height(20),
                GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    padding: FxSpacing.zero,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    children: <Widget>[
                      SinglePageItem(
                        iconData: MdiIcons.shoppingOutline,
                        navigation: TestPage(),
                        title: "Shopping",
                      ),
                      SinglePageItem(
                        iconData: Icons.cake_outlined,
                        navigation: TestPage(),
                        title: "Homemade",
                      ),
                      SinglePageItem(
                        iconData: Icons.outdoor_grill_outlined,
                        navigation: TestPage(),
                        title: "Cookify",
                      ),
                      SinglePageItem(
                        iconData: Icons.health_and_safety_outlined,
                        navigation: TestPage(),
                        title: "Medi Care",
                      ),
                      SinglePageItem(
                        iconData: Icons.home_work_outlined,
                        navigation: TestPage(),
                        title: "Estate",
                      ),
                      SinglePageItem(
                        iconData: MdiIcons.foodAppleOutline,
                        title: "Grocery",
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        iconData: Icons.favorite_outline_rounded,
                        navigation: TestPage(),
                        title: "Dating",
                      ),
                      SinglePageItem(
                        iconData: Icons.live_tv,
                        navigation: TestPage(),
                        title: "Muvi",
                      ),
                    ]),
                FxSpacing.height(20),
                FxText.t3(
                  "MATERIAL YOU",
                  fontWeight: 700,
                  muted: true,
                ),
                FxSpacing.height(20),
                GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    padding: FxSpacing.zero,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    children: <Widget>[
                      SinglePageItem(
                        iconData: FxBoxIcons.bx_book_open,
                        navigation: TestPage(),
                        title: "Learning",
                      ),
                      SinglePageItem(
                        iconData: FxBoxIcons.bx_dish,
                        navigation: TestPage(),
                        title: "Cookify",
                      ),
                      SinglePageItem(
                        iconData: FxBoxIcons.bx_heart,
                        navigation: TestPage(),
                        title: "Dating",
                      ),
                      SinglePageItem(
                        iconData: FxBoxIcons.bx_building_house,
                        navigation: TestPage(),
                        title: "Estate",
                      ),
                      SinglePageItem(
                        iconData: FxBoxIcons.bx_cake,
                        navigation: TestPage(),
                        title: "Homemade",
                      ),
                    ]),
                FxContainer(
                  margin: FxSpacing.top(20),
                  borderRadiusAll: 4,
                  color: theme.colorScheme.primary.withAlpha(24),
                  child: Center(
                    child: FxText.b2("More widgets are coming very soon...",
                        fontWeight: 600, color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
