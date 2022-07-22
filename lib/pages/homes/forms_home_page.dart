/*
* File : Forms Home Page
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';

import '../TestPage.dart';
import 'single_grid_item.dart';

class FormsHomePage extends StatefulWidget {
  @override
  _FormsHomePageState createState() => _FormsHomePageState();
}

class _FormsHomePageState extends State<FormsHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            FeatherIcons.chevronLeft,
            size: 20,
          ),
        ),
        title: FxText.sh1("Forms", fontWeight: 600),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: FxSpacing.x(20),
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          FxText.sh2("Inputs", fontWeight: 700),
          GridView.count(
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: FxSpacing.top(20),
            mainAxisSpacing: 20,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            children: <Widget>[
              SinglePageItem(
                title: "Text Fields",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Checkbox",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Radio Button",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                icon: './assets/icons/reader-outline.png',
                title: "Switch",
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Date Picker",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                icon: './assets/icons/reader-outline.png',
                title: "Time Picker",
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Range Slider",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Form",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
            ],
          ),
          FxSpacing.height(20),
          FxText.sh2("Customs", fontWeight: 700),
          GridView.count(
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: FxSpacing.y(20),
            mainAxisSpacing: 16.0,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 16.0,
            children: <Widget>[
              SinglePageItem(
                title: "Personal",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Address",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
              SinglePageItem(
                title: "Feedback",
                icon: './assets/icons/reader-outline.png',
                navigation: TestPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
