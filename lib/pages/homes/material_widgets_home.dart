import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';

import '../TestPage.dart';
import 'single_grid_item.dart';

class MaterialWidgetsHome extends StatefulWidget {
  @override
  _MaterialWidgetsHomeState createState() => _MaterialWidgetsHomeState();
}

class _MaterialWidgetsHomeState extends State<MaterialWidgetsHome> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      theme = AppTheme.theme;
      return Container(
        child: ListView(
          padding: FxSpacing.x(20),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            FxText.t3(
              "BASIC",
              fontWeight: 700,
              muted: true,
            ),
            FxSpacing.height(20),
            GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: FxSpacing.zero,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1.5,
                crossAxisSpacing: 20.0,
                children: <Widget>[
                  SinglePageItem(
                    title: "Basic",
                    icon: Images.basicIcon,
                    navigation: TestPage(),
                  ),
                  SingleGridItem(
                    title: "App Bar",
                    icon: Images.topAppBarIcon,
                    items: <SinglePageItem>[
                      SinglePageItem(
                        title: "App Bars",
                        icon: Images.topAppBarIcon,
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        title: "Search Bars",
                        icon: Images.topAppBarIcon,
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        title: "Sliver Appbar",
                        icon: Images.topAppBarIcon,
                        navigation: TestPage(),
                      ),
                    ],
                  ),
                  SinglePageItem(
                    title: "Bottom Sheet",
                    icon: Images.bottomSheetIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Buttons",
                    icon: Images.buttonIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Card",
                    icon: Images.cardIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Dialogs",
                    icon: Images.dialogIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "List",
                    icon: Images.listBulletsIcon,
                    navigation: TestPage(),
                  ),
                  SingleGridItem(
                    title: "Navigation",
                    icon: Images.navigationIcon,
                    items: <SinglePageItem>[
                      SinglePageItem(
                        title: "FX Navigation",
                        icon: Images.navigationIcon,
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        title: "Top",
                        icon: Images.navigationIcon,
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        icon: Images.navigationIcon,
                        title: "Scrollable",
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        icon: Images.navigationIcon,
                        title: "Rail",
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        icon: Images.navigationIcon,
                        title: "Bottom",
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        icon: Images.navigationIcon,
                        title: "Drawer",
                        navigation: TestPage(),
                      ),
                      SinglePageItem(
                        icon: Images.navigationIcon,
                        title: "Custom Bottom",
                        navigation: TestPage(),
                      ),
                    ],
                  ),
                ]),
            FxSpacing.height(20),
            FxText.t3(
              "ADVANCED",
              fontWeight: 700,
              muted: true,
            ),
            FxSpacing.height(20),
            GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: FxSpacing.zero,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1.5,
                crossAxisSpacing: 20.0,
                children: <Widget>[
                  SinglePageItem(
                    title: "Advanced",
                    icon: Images.advancedIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Carousel",
                    icon: Images.carouselIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Expansions",
                    icon: Images.expansionIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Forms",
                    icon: Images.formIcon,
                    navigation: TestPage(),
                  ),
                  SinglePageItem(
                    title: "Progress",
                    icon: Images.progressIcon,
                    navigation: TestPage(),
                  ),
                ]),
            FxContainer(
              margin: FxSpacing.y(20),
              borderRadiusAll: 4,
              color: theme.colorScheme.primary.withAlpha(24),
              child: Center(
                child: FxText.b2("More widgets are coming very soon...",
                    fontWeight: 600, color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      );
    });
  }
}
