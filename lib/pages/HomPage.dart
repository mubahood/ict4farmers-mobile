import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:ict4farmers/widgets/single_grid_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
                        iconData: Icons.cake_outlined,
                        navigation: Text("Homemade"),
                        title: "Shopping",
                      ),
                      SinglePageItem(
                        iconData: Icons.cake_outlined,
                        navigation: Text("Homemade"),
                        title: "Homemade",
                      ),
                      SinglePageItem(
                        iconData: Icons.outdoor_grill_outlined,
                        navigation: Text("Homemade"),
                        title: "Cookify",
                      ),
                      SinglePageItem(
                        iconData: Icons.health_and_safety_outlined,
                        navigation: Text("Homemade"),
                        title: "Medi Care",
                      ),
                      SinglePageItem(
                        iconData: Icons.home_work_outlined,
                        navigation: Text("Homemade"),
                        title: "Estate",
                      ),
                      SinglePageItem(
                        iconData: Icons.home_work_outlined,
                        title: "Grocery",
                        navigation: Text("Homemade"),
                      ),
                      SinglePageItem(
                        iconData: Icons.favorite_outline_rounded,
                        navigation: Text("Homemade"),
                        title: "Dating",
                      ),
                      SinglePageItem(
                        iconData: Icons.live_tv,
                        title: "Grocery",
                        navigation: Text("Homemade"),
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
                    children: <Widget>[Text("List of other stagg")]),
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
