import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/option_picker_model.dart';
import '../../theme/app_notifier.dart';
import '../location_picker/location_sub.dart';

class SingleOptionPicker extends StatefulWidget {
  List<OptionPickerModel> items;
  String title;

  SingleOptionPicker(this.title, this.items);

  @override
  State<SingleOptionPicker> createState() => SingleOptionPickerState();
}

late CustomTheme customTheme;

class SingleOptionPickerState extends State<SingleOptionPicker> {
  final PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    _do_refresh();
  }

  @override
  void dipose() {
    pageController.dispose();
  }

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});

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
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: _do_refresh,
          color: CustomTheme.primary,
          backgroundColor: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SingleProduct(widget.items[index]);
                  },
                  childCount: widget.items.length, // 1000 list items
                ),
              )
            ],
          ),
        )),
      );
    });
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  SingleProduct(OptionPickerModel item) {
    return ListTile(
      dense: true,
      title: FxText.h3(item.name, fontWeight: 600, fontSize: 18),
      onTap: () {
        pick_location(item);
      },
    );
  }

  Future<void> pick_location(OptionPickerModel item) async {
    Navigator.pop(
        context, {"id": item.id.toString().trim(), "text": item.name.trim()});
  }
}
