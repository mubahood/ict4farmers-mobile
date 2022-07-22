import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/icons/box_icon/box_icon_data.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/models/CategoryModel.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widget/loading_widget.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/BannerModel.dart';
import '../../models/LocationModel.dart';
import '../../models/ProductModel.dart';
import '../../models/FormItemModel.dart';
import '../../theme/app_notifier.dart';
import '../../theme/material_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_list_loading_widget.dart';
import '../../widget/shimmer_loading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductCategoryPicker extends StatefulWidget {
  @override
  State<ProductCategoryPicker> createState() => PproducCcategorPpicker();
}

late CustomTheme customTheme;
String title = "Pick category";
bool is_loading = false;

class PproducCcategorPpicker extends State<ProductCategoryPicker> {
  PproducCcategorPpicker();

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _do_refresh();
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
          iconTheme: IconThemeData(
            color: Colors.white, // <= You can change your color here.
          ),
          backgroundColor: CustomTheme.primary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: .5,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
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
    return ListTile(
      dense: true,
      title: FxText.h3(item.name, fontWeight: 400, fontSize: 20),
      onTap: () {

        Navigator.pop(context,
            {"category_id": item.id.toString(), "category_text": item.name});
      },
    );
  }
}