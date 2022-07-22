import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/Utils.dart';

part 'PostModel.g.dart';

@HiveType(typeId: 53)
class PostModel extends HiveObject {
  static Future<void> save_to_local_db(
      List<PostModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("PostModel")) {
      box = await Hive.openBox<PostModel>("PostModel");
    }
    if (box == null) {
      box = await Hive.openBox<PostModel>("PostModel");
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

  static Future<List<PostModel>> get_items() async {
    List<PostModel> items = [];
    get_online_items();

    (await get_local_items()).forEach((element) {
      items.add(element);
    });


    return items;
  }

  static Future<List<PostModel>> get_local_items() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<PostModel>("PostModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<PostModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<PostModel>> get_online_items() async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<PostModel> items = [];

    String resp = await Utils.http_get('api/posts', {});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        PostModel item = new PostModel();
        item = PostModel.fromJson(element);
        items.add(item);
      }).toList();
    }

    await PostModel.save_to_local_db(items, true);

    return items;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String created_at = "";

  @HiveField(2)
  String administrator_id = "";

  @HiveField(3)
  String views = "";

  @HiveField(4)
  String comments = "";

  @HiveField(5)
  String text = "";

  @HiveField(6)
  String thumnnail = "";

  @HiveField(7)
  String images = "";

  @HiveField(8)
  String audio = "";

  @HiveField(9)
  String posted_by = "";

  @HiveField(10)
  String post_category_id = "";

  String get_title() {
    bool is_audio = false;

    if (this.audio.length > 10) {
      is_audio = true;
    } else if (this.thumnnail.length > 10) {
      is_audio = false;
    }

    if(is_audio){
      return "Audio by "+this.posted_by;
    }else{
      return this.text;
    }

  }

  String get_post_type() {
    String type = "";

    if (this.audio.length > 10) {
      type = "audio";
    } else if (this.thumnnail.length > 10) {
      type = "image";
    }

    return type;
  }

  static PostModel fromJson(data) {
    PostModel u = new PostModel();
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

    u.thumnnail = data['thumnnail'].toString();
    u.created_at = data['created_at'].toString();
    u.administrator_id = data['administrator_id'].toString();
    u.views = data['views'].toString();
    u.comments = data['comments'].toString();
    u.text = data['text'].toString();
    u.audio = data['audio'].toString();
    u.images = data['images'].toString();
    u.posted_by = data['posted_by'].toString();

    return u;
  }
}
