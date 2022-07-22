import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../theme/app_notifier.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class SingleItemPicker extends StatefulWidget {
  String title, selected;
  dynamic items;

  SingleItemPicker(
    this.title,
    this.items,
    this.selected,
  );

  @override
  State<SingleItemPicker> createState() => SingleItemePickerState();
}

late CustomTheme customTheme;

class SingleItemePickerState extends State<SingleItemPicker> {
  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _do_refresh();
  }

  List<dynamic> _items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    if (widget.items != null) {
      try {
        _items = jsonDecode(widget.items);

      } catch (e) {
        _items = [];
      }
    }

    setState(() {});

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
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: false
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
                            return SingleItemUI(_items[index]);
                          },
                          childCount: _items.length, // 1000 list items
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

  SingleItemUI(dynamic item) {

    return ListTile(
      dense: true,
      title: FxText.h3(item['name'], fontWeight: 400, fontSize: 20),
      onTap: () {
        Navigator.pop(
            context, {"id": item['id'].toString(), "name": item['name']});
      },
    );
  }
}
