import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/loading_widget.dart';
import '../../widget/my_widgets.dart';
import '../homes/homes_screen.dart';
import 'categories_sub_screen.dart';

class SearchResultsItemsScreen extends StatefulWidget {
  TextEditingController _textController;

  SearchResultsItemsScreen(this._textController);

  @override
  State<SearchResultsItemsScreen> createState() =>
      SearchResultsItemsScreenState(this._textController);
}

late CustomTheme customTheme;
bool is_loading = false;

class SearchResultsItemsScreenState extends State<SearchResultsItemsScreen>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;
  String search_text = "";
  TextEditingController _textController;

  void listen_text_change() {
    _textController.addListener(() {
      search_text = _textController.text;
      if (search_text.length > 1) {
        _onRefresh(context);
      }
    });
  }

  SearchResultsItemsScreenState(this._textController);

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    AppTheme.resetFont();
    theme = AppTheme.theme;
    AppTheme.resetFont();
    listen_text_change();
    //_do_refresh();
  }

  late TabController tabController;
  late List<NavItem> navItems;

  @override
  void dipose() {
    pageController.dispose();
    //_textController.dispose();
  }

  List<ProductModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    if (is_loading) {
      return;
    }

    if (this.mounted) {
      is_loading = true;
      setState(() {});
    }

    List<ProductModel> _items =
        await ProductModel.get_online_items({"s": search_text});
    items.clear();
    _items.forEach((element) {
      items.add(element);
    });

    items.sort((a, b) => a.name.compareTo(b.name));
    if (this.mounted) {
      is_loading = false;
      setState(() {});
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
        body: SafeArea(
          child: is_loading
              ? LoadingWidget()
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

  SingleProduct(ProductModel item) {
    return Column(
      children: [
        ListTile(
          leading: FxContainer(
            child: myNetworkImage(item.get_thumbnail(), 50, 50, 5),
            width: 50,
            height: 50,
            paddingAll: 0,
            marginAll: 0,
            borderRadiusAll: 20,
          ),
          dense: false,
          title: FxText.h3(
            item.name,
            fontWeight: 600,
            maxLines: 1,
            fontSize: 18,
            color: Colors.grey.shade700,
          ),
          onTap: () {
            ProductModel.save_to_local_db([item], false);

            Utils.navigate_to(AppConfig.ProductDetails, context, data: item);
            //pick_location(item);
          },
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  Future<void> pick_location(ProductModel item) async {
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
