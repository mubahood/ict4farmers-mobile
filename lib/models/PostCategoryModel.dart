import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/Utils.dart';

part 'PostCategoryModel.g.dart';

@HiveType(typeId: 54)
class PostCategoryModel extends HiveObject {
  static Future<void> save_to_local_db(
      List<PostCategoryModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("PostCategoryModel")) {
      box = await Hive.openBox<PostCategoryModel>("PostCategoryModel");
    }
    if (box == null) {
      box = await Hive.openBox<PostCategoryModel>("PostCategoryModel");
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

  static Future<List<PostCategoryModel>> get_items() async {
    List<PostCategoryModel> items = [];
    get_online_items();

    (await get_local_items()).forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<PostCategoryModel>> get_local_items() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<PostCategoryModel>("PostCategoryModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<PostCategoryModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<PostCategoryModel>> get_online_items() async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<PostCategoryModel> items = [];

    String resp = await Utils.http_get('api/post-categories', {});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        PostCategoryModel item = new PostCategoryModel();
        item = PostCategoryModel.fromJson(element);
        items.add(item);
      }).toList();
    }

    await PostCategoryModel.save_to_local_db(items, true);

    return items;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String name = "";

  @HiveField(2)
  String details = "";

  @HiveField(3)
  String thumnnail = "";

  List<String> photos = [];

  static PostCategoryModel fromJson(data) {
    PostCategoryModel u = new PostCategoryModel();
    u.id = 0;
    if (data['id'] != null) {
      if (!data['id'].toString().toString().isEmpty) {
        try {
          u.id = int.parse(data['id'].toString());
        } catch (e) {
          u.id = 0;
        }
      }
    }

    u.name = data['name'].toString();
    u.details = data['details'].toString();
    u.thumnnail = data['thumnnail'].toString();

    return u;
  }
}
