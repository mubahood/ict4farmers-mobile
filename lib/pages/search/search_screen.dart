import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/pages/search/search_results_items_screen.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../models/CategoryModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/my_widgets.dart';
import 'categories_sub_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => SearchScreenState();
}

late CustomTheme customTheme;
bool is_loading = false;
var _textController = TextEditingController();

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    AppTheme.resetFont();
    theme = AppTheme.theme;
    AppTheme.resetFont();
    init_tabs();
  }

  late TabController tabController;
  late List<NavItem> navItems;

  void init_tabs() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    navItems = [
      NavItem('Items', SearchResultsItemsScreen(_textController)),
      NavItem('Members', SearchResultsItemsScreen(_textController)),
    ];

    tabController.addListener(() {
      currentIndex = tabController.index;

      if (this.mounted) {
        setState(() {});
      }
    });

    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
      }

      if (this.mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dipose() {
    pageController.dispose();
    _textController.dispose();
  }

  List<CategoryModel> items = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: FormBuilderTextField(
                name: "name",
                controller: _textController,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.name,
                cursorColor: CustomTheme.primary,
                autofocus: true,
                enableSuggestions: false,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(CupertinoIcons.search,
                      color: CustomTheme.primary, size: 24),
                  contentPadding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                  focusColor: theme.colorScheme.onBackground.withAlpha(10),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'Search for items and members...',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                  fillColor: theme.colorScheme.onBackground.withAlpha(20),
                )),
          ),
        ),
        body: Column(
          children: [
            FxContainer.none(
              padding: EdgeInsets.only(top: 15, bottom: 20),
              color: theme.scaffoldBackgroundColor,
              enableBorderRadius: false,
              borderRadiusAll: 0,
              child: TabBar(
                labelPadding: EdgeInsets.all(0),
                controller: tabController,
                indicator: FxTabIndicator(
                    indicatorColor: CustomTheme.primary,
                    indicatorStyle: FxTabIndicatorStyle.rectangle,
                    indicatorHeight: 3,
                    radius: 0,
                    yOffset: 37,
                    width: (MediaQuery.of(context).size.width / 2)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: theme.colorScheme.primary,
                tabs: buildTab(),
              ),
            ),
            Divider(height: 0, thickness: 1, color: Colors.grey.shade200),
            Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: navItems.map((navItem) => navItem.screen).toList()),
            ),
          ],
        ),
      );
    });
  }

  SingleProduct(CategoryModel item) {
    return Column(
      children: [
        ListTile(
          leading: FxContainer(
            child: myNetworkImage(item.image, 45, 45, 10),
            width: 45,
            height: 45,
            paddingAll: 0,
            marginAll: 0,
            borderRadiusAll: 20,
          ),
          trailing: Icon(
            CupertinoIcons.right_chevron,
            size: 18,
          ),
          dense: false,
          title: FxText.h3(
            item.name,
            fontWeight: 600,
            fontSize: 16,
            color: Colors.black,
          ),
          onTap: () {

            Utils.navigate_to(AppConfig.ProductListting, context,data: {
              'title' : item.name,
              'id' : item.category_id,
              'task' : 'Category',
            });
            //pick_location(item);
          },
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  Future<void> pick_location(CategoryModel item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SategoriesSubScreen({
                'parent_id': item.id.toString(),
              })),
    );

    if (result != null) {
      if ((result['location_sub_id'] != null) &&
          (result['location_sub_name'] != null)) {
        Navigator.pop(context, {
          "location_sub_id": result['location_sub_id'],
          "location_sub_name":
              item.name + ", " + result['location_sub_name'].toString()
        });
      }
    }
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < navItems.length; i++) {
      tabs.add(Container(
          child: Text(
        navItems[i].title,
        style: TextStyle(
          fontSize: 15,
          color: (currentIndex == i)
              ? CustomTheme.primary
              : theme.colorScheme.onBackground.withAlpha(220),
        ),
      )));
    }
    return tabs;
  }
}

class NavItem {
  final String title;
  final Widget screen;
  final double size;

  NavItem(this.title, this.screen, [this.size = 28]);
}
