import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../models/CategoryModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/my_widgets.dart';
import '../../widget/shimmer_list_loading_widget.dart';
import 'categories_sub_screen.dart';

class CategoriesMainScreen extends StatefulWidget {
  @override
  State<CategoriesMainScreen> createState() => CategoriesMainScreenState();
}

late CustomTheme customTheme;
bool is_loading = false;

class CategoriesMainScreenState extends State<CategoriesMainScreen> {
  final PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    AppTheme.resetFont();
    theme = AppTheme.theme;
    AppTheme.resetFont();
    _do_refresh();
  }

  @override
  void dipose() {
    pageController.dispose();
  }

  List<CategoryModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    List<CategoryModel> _items = await CategoryModel.get_all();
    items.clear();
    _items.forEach((element) {
      if (element.parent < 1) {
        items.add(element);
      }
    });

    items.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      is_loading = false;
    });

    return null;
  }

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
          elevation: .5,
          title: InkWell(
            onTap: () => {Utils.navigate_to(AppConfig.SearchScreen, context)},
            child: Container(
              padding: EdgeInsets.only(left: 10, top: 7, bottom: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: theme.colorScheme.onBackground.withAlpha(20),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: theme.colorScheme.onBackground.withAlpha(200),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Search for items or members...",
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.colorScheme.onBackground.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: is_loading
              ? ShimmerListLoadingWidget()
              : RefreshIndicator(
                  onRefresh: _do_refresh,
                  color: CustomTheme.primary,
                  backgroundColor: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return SingleProduct(items[index]);
                          },
                          childCount: items.length, // 1000 list items
                        ),
                      )
                    ],
                  ),
                ),
        ),
      );
    });
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  SingleProduct(CategoryModel item) {
    return Column(
      children: [
        ListTile(
          leading: FxContainer(
            child: myNetworkImage(AppConfig.BASE_URL+"/"+item.image, 45, 45, 10),
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
              'id' : item.id,
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
}
