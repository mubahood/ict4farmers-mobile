import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../theme/app_notifier.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class ItemPickerScreen extends StatefulWidget {
  List<String> items;
  String selected;
  String title;

  ItemPickerScreen(this.items, this.selected, this.title);

  @override
  State<ItemPickerScreen> createState() =>
      _ItemPickerScreen(this.items, this.selected, this.title);
}

late CustomTheme customTheme;
String title = "Pick an area";
bool is_loading = false;

class _ItemPickerScreen extends State<ItemPickerScreen> {
  List<String> items;
  String selected;
  String title;

  _ItemPickerScreen(this.items, this.selected, this.title);

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _do_refresh();
  }

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});

    items.sort((a, b) => a.compareTo(b));
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
          backgroundColor: CustomTheme.primary,
          iconTheme: IconThemeData(
            color: Colors.white, // <= You can change your color here.
          ),
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

  SingleProduct(String item) {
    return ListTile(
      dense: true,
      title: FxText.h3(item, fontWeight: 400, fontSize: 20),
      onTap: () {
        Navigator.pop(context, {"value": item.toString()});
      },
    );
  }
}
