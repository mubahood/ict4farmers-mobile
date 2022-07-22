import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

part 'CategoryModel.g.dart';

@HiveType(typeId: 51)
class CategoryModel extends HiveObject {
  static Future<List<CategoryModel>> get_all() async {
    List<CategoryModel> items = [];

    get_all_items_in_background();

    items = await CategoryModel.get_local_items();

    if (items == null || items.isEmpty) {
      items = await get_all_items_in_background();
    } else {
      return items;
    }
    return items;
  }

  static Future<List<CategoryModel>> get_local_items() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<CategoryModel>("CategoryModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<CategoryModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<CategoryModel>> get_all_items_in_background() async {
    List<CategoryModel> items = [];
    items = await get_online_items({'per_page': 10000});

    if (await Utils.is_connected()) {
      await CategoryModel.save_to_local_db(items, true);
    }
    return items;
  }

  static Future<List<CategoryModel>> get_online_items(
      Map<String, dynamic> data) async {
    List<CategoryModel> items = [];


    String resp = await Utils.http_get('api/categories', data);

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        CategoryModel item = new CategoryModel();
        item = CategoryModel.fromJson(element);
        items.add(item);
      }).toList();
    }

    return items;
  }

  static CategoryModel fromJson(data) {
    CategoryModel item = new CategoryModel();
    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.parent = Utils.int_parse(data['parent']);
    item.name = data['name'].toString();
    item.description = data['description'].toString();
    item.slug = data['slug'].toString();
    item.image = data['image'].toString();
    item.has_parent = data['has_parent'].toString();

    if (data['attributes'] != null) {
      List<dynamic> attrs = data['attributes'];
      attrs.forEach((element) {
        item.attributes.add(element);
      });
    }

    return item;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  int category_id = 0;

  @HiveField(2)
  int parent = 0;

  @HiveField(3)
  String name = "";

  @HiveField(4)
  String description = "";

  @HiveField(5)
  String slug = "";

  @HiveField(7)
  String image = "";

  @HiveField(8)
  String has_parent = "";

  @HiveField(9)
  List<String> attributes = [];

  static Future<void> save_to_local_db(
      List<CategoryModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("CategoryModel")) {
      box = await Hive.openBox<CategoryModel>("CategoryModel");
    }
    if (box == null) {
      box = await Hive.openBox<CategoryModel>("CategoryModel");
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

  static Future<CategoryModel> get_item(int id) async {
    CategoryModel item = new CategoryModel();

    (await get_all()).forEach((element) {
      if (element.id == id) {
        item = element;
      }
    });

    return item;
  }
}
