import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';

import '../TestPage.dart';
import 'single_grid_item.dart';

class OthersHome extends StatefulWidget {
  @override
  State<OthersHome> createState() => _OthersHomeState();
}

class _OthersHomeState extends State<OthersHome> {
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
      return ListView(
        padding: FxSpacing.x(20),
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          FxText.t3(
            "SYNCFUSION",
            fontWeight: 700,
            muted: true,
          ),
          FxSpacing.height(20),
          GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: FxSpacing.zero,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
              crossAxisSpacing: 20,
              children: <Widget>[
                SinglePageItem(
                  title: "Cartesian Chart",
                  icon: Images.cartesianBarIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Circular Chart",
                  icon: Images.pieChartIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Other Chart",
                  icon: Images.cartesianBarSyncIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Date Range",
                  icon: Images.calendarIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Gauges",
                  icon: Images.gaugeIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Sliders",
                  icon: Images.sliderHorizontalIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Range Sliders",
                  icon: Images.rangeSliderHorizontalIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Range Selector",
                  icon: Images.rangeSelectorIcon,
                  navigation: TestPage(),
                ),
              ]),
          FxSpacing.height(20),
          FxText.t3(
            "CUPERTINO",
            fontWeight: 700,
            muted: true,
          ),
          FxSpacing.height(20),
          GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: FxSpacing.zero,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
              crossAxisSpacing: 20,
              children: <Widget>[
                SinglePageItem(
                  title: "Dialogs",
                  icon: Images.dialogIcon,
                  navigation: TestPage(),
                ),
                SinglePageItem(
                  title: "Inputs",
                  icon: Images.formIcon,
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
          )
        ],
      );
    });
  }
}
