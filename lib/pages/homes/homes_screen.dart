import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/pages/account/account_splash.dart';
import 'package:ict4farmers/pages/homes/homes_screen_segment.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:ict4farmers/theme/theme_type.dart';
import 'package:provider/provider.dart';

import '../account/my_products_screen.dart';
import '../chat/chat_home_screen.dart';
import '../search/categories_main_screen.dart';

class HomesScreen extends StatefulWidget {

  dynamic params;
  HomesScreen(this.params);

  @override
  _HomesScreenState createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  late ThemeData theme;
  late CustomTheme customTheme;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late TabController tabController;
  late List<NavItem> navItems;

  bool isDark = false;
  TextDirection textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    AppTheme.init();

    tabController = TabController(
      //       animationDuration: Duration.zero,
        length: 5,
        vsync: this,
        initialIndex: 0);

    navItems = [
      NavItem('Home', CupertinoIcons.home, HomesScreenSegment(widget.params)),
      NavItem('Categories', CupertinoIcons.search, CategoriesMainScreen()),
      NavItem('Sell Now', CupertinoIcons.plus_circle, MyProductsScreen()),
      NavItem('Chats', CupertinoIcons.envelope_badge, ChatHomeScreen()),
      NavItem('Account', CupertinoIcons.person, AccountSplash()),
    ];

    tabController.addListener(() {
      currentIndex = tabController.index;

      setState(() {});
    });

    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;

      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
      }

      setState(() {});
    });
  }

  void changeDirection() {
    if (AppTheme.textDirection == TextDirection.ltr) {
      Provider.of<AppNotifier>(context, listen: false)
          .changeDirectionality(TextDirection.rtl);
    } else {
      Provider.of<AppNotifier>(context, listen: false)
          .changeDirectionality(TextDirection.ltr);
    }
    setState(() {});
  }

  void launchCodecanyonURL() async {
    String url = "https://codecanyon.net/user/coderthemes/portfolio";
    //await launch(url);
  }

  void launchDocumentation() async {
    String url = "https://onekit.coderthemes.com/index.html";
    //await launch(url);
  }

  void launchChangeLog() async {
    String url = "https://onekit.coderthemes.com/changlog.html";
    //await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {

        textDirection = AppTheme.textDirection;
        theme = AppTheme.theme;
        customTheme = AppTheme.customTheme;
        return Scaffold(
          key: _drawerKey,
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children:
                        navItems.map((navItem) => navItem.screen).toList()),
              ),
              FxContainer.none(
                padding: FxSpacing.xy(0, 2),
                color: theme.scaffoldBackgroundColor,
                bordered: true,
                enableBorderRadius: false,
                borderRadiusAll: 0,
                border: Border(
                  top: BorderSide(width: 2, color: customTheme.border),
                ),
                child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  controller: tabController,
                  indicator: FxTabIndicator(
                      indicatorColor: CustomTheme.primary,
                      indicatorStyle: FxTabIndicatorStyle.rectangle,
                      indicatorHeight: 2,
                      radius: 4,
                      yOffset: -4,
                      width: 35),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: CustomTheme.primary,
                  tabs: buildTab(),
                ),
              ),
            ],
          ),
/*          drawer: _buildDrawer(),*/
        );
      },
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < navItems.length; i++) {
      tabs.add(Container(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 4,
              top: 4,
            ),
            child: Icon(navItems[i].icon,
                size: 18,
                color: (currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground.withAlpha(220)),
          ),
          FxText.b1(
            navItems[i].title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: (currentIndex == i)
                  ? CustomTheme.primary
                  : theme.colorScheme.onBackground.withAlpha(220),
            ),
          )
        ],
      )));
    }
    return tabs;
  }
}

class NavItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final double size;

  NavItem(this.title, this.icon, this.screen, [this.size = 28]);
}