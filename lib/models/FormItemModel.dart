import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/Utils.dart';

part 'FormItemModel.g.dart';

@HiveType(typeId: 50)
class FormItemModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  int category_id = 0;

  @HiveField(2)
  String name = "";

  @HiveField(3)
  String type = "";

  @HiveField(4)
  String description = "";

  @HiveField(5)
  String units = "";

  @HiveField(6)
  String value = "";

  @HiveField(7)
  List<String> options = [];

  @HiveField(8)
  bool is_required = false;

  @HiveField(9)
  String active_form = "";

  static Future<void> delete_all() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("FormItemModel")) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      return;
    }
    await box.clear();
    return;
  }


  static Future<void> save_to_local_db(
      List<FormItemModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("FormItemModel")) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      return;
    }

    if (clear_db) {
      await box.clear();
    }
    box.addAll(data);
    return;
  }

  static Future<void> save_iteem_to_local_db(FormItemModel data) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("FormItemModel")) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      return;
    }

    int i = 0;

    List<FormItemModel> _items = [];
    _items = await get_all();


    for (i = 0; i < _items.length; i++) {
      if (data.id == _items[i].id) {
        await _items[i].delete();
        break;
      }
    }

    await box.add(data);





    return;
  }

  static Future<FormItemModel> get_item(int id) async {


    FormItemModel item = new FormItemModel();
    List<FormItemModel> items = await get_all();

    for(int k=0;k<items.length;k++) {
      if (items[k].id == id) {
        item = items[k];
        break;
      }
    };


    return item;
  }

  static Future<List<FormItemModel>> get_all() async {
    Utils.init_databse();
    await Hive.initFlutter();

    var box = null;
    if (!Hive.isBoxOpen("FormItemModel")) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box == null) {
      box = await Hive.openBox<FormItemModel>("FormItemModel");
    }
    if (box.values.isEmpty) {
      return [];
    }

    List<FormItemModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }
}
