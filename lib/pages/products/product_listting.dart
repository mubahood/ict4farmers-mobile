import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/BannerModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/empty_list.dart';
import '../../widget/loading_widget.dart';
import '../../widget/product_item_ui.dart';
import '../location_picker/product_category_picker.dart';

class ProductListting extends StatefulWidget {
  dynamic params;

  ProductListting(this.params);

  @override
  State<ProductListting> createState() => _ProductListtingState(this.params);
}

List<BannerModel> banners = [];
bool initilized = false;
bool store_initilized = false;

String title = "Products";
String id = "";

class _ProductListtingState extends State<ProductListting> {
  dynamic params;

  _ProductListtingState(this.params);

  @override
  void initState() {
    _onRefresh();
  }

  @override
  void dipose() {}

  List<ProductModel> _products = [];
  int i = 0;

  Future<Null> _onRefresh() async {
    setState(() {
      is_loading = true;
    });

    if (params != null) {
      if (params['title'] != null &&
          params['id'] != null) {
        title = params['title'].toString().trim();
        id = params['id'].toString().trim();
      }
    }



    if (!id.isEmpty) {
      _products = await ProductModel.get_online_items({'cat_id': id});
    }

    setState(() {
      is_loading = false;
    });
    initilized = false;
    return null;
  }

  bool isDark = false;
  bool is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: CustomTheme.primary,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 1,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pick_category();
                    },
                    child: Container(
                        padding: FxSpacing.x(0), child: Icon(
                      CupertinoIcons.arrow_up_arrow_down
                    )),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: is_loading
                  ? LoadingWidget()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: _products.isEmpty
                          ? EmptyList(
                              body: "No items were found under ${title}",
                              action_text: "Change the filter and try again.")
                          : CustomScrollView(
                              slivers: [
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 1,
                                          mainAxisExtent: 280),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return ProductItemUi(
                                          index, _products[index], context);
                                    },
                                    childCount: _products.length,
                                  ),
                                ),
                              ],
                            )),
            ));
      },
    );
  }

  Future<void> pick_category() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductCategoryPicker()),
    );

    if (result != null) {
      if ((result['category_id'] != null) &&
          (result['category_text'] != null)) {

        id = result['category_id'].toString();
        title = result['category_text'];


        setState(() {

        });
        _onRefresh();
      }
    }
  }

}
