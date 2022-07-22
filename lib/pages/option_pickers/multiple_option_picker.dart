import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/pages/option_pickers/single_option_picker.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../models/option_picker_model.dart';
import '../../theme/app_notifier.dart';

class MultipleOptionPicker extends StatefulWidget {
  List<OptionPickerModel> original_items;
  String main_title;
  String sub_title;

  MultipleOptionPicker(
    this.main_title,
    this.sub_title,
    this.original_items,
  );

  @override
  State<MultipleOptionPicker> createState() => MultipleOptionPickerState();
}

late CustomTheme customTheme;

class MultipleOptionPickerState extends State<MultipleOptionPicker> {
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

  List<OptionPickerModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    items.clear();

    widget.original_items.forEach((element) {
      if (Utils.int_parse(element.parent_id.toString()) == 0) {
        items.add(element);
      }
    });

    items.sort((a, b) => a.name.compareTo(b.name));
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
            widget.main_title,
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
                    return SingleProduct(items[index]);
                  },
                  childCount: items.length, // 1000 list items
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
      title: FxText.h3(item.name, fontWeight: 400, fontSize: 20),
      onTap: () {
        pick_location(item);
      },
    );
  }

  Future<void> pick_location(OptionPickerModel item) async {
    List<OptionPickerModel> next_items = [];
    widget.original_items.forEach((element) {
      if (item.id.toString() == element.parent_id.toString()) {
        next_items.add(element);
      }
    });

    if (next_items.isEmpty) {
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SingleOptionPicker(widget.sub_title, next_items)),
    );

    if (result != null) {
      if ((result['id'] != null) && (result['text'] != null)) {
        Navigator.pop(context, {
          "id": result['id'],
          "text": item.name + ", " + result['text'].toString()
        });
      }
    }
  }
}
