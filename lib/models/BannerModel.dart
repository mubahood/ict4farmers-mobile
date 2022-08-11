import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

part 'BannerModel.g.dart';
//test
@HiveType(typeId: 20)
class BannerModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String created_at = "";

  @HiveField(2)
  String section = "";

  @HiveField(3)
  String position = "";

  @HiveField(4)
  String name = "";

  @HiveField(5)
  String sub_title = "";

  @HiveField(6)
  String type = "";

  @HiveField(7)
  String category_id = "";

  @HiveField(8)
  String product_id = "";

  @HiveField(9)
  String clicks = "";

  @HiveField(10)
  String image = "";

  String get_image()   {
    String img = "${AppConfig.BASE_URL}/${image.toString().trim()}";
    ;

    return img;
  }
  static Future<List<BannerModel>> get() async {
    List<BannerModel> items = [];
    get_online_items();

    items = await BannerModel.get_local_banners();

    if (items == null || items.isEmpty) {
      items = await get_online_items();
    } else {
      return items;
    }
    if (items.isEmpty) {
      items = await BannerModel.get_local_banners();
    }
    items = await get_online_items();
    if (items == null) {
      return [];
    }

    return items;
  }

  static Future<List<BannerModel>> get_online_items() async {
    List<BannerModel> items = [];

    String resp = await Utils.http_get('api/banners', {});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        BannerModel item = new BannerModel();
        item = BannerModel.fromJson(element);
        items.add(item);
      }).toList();
    }

    if (await Utils.is_connected()) {
      await BannerModel.save_to_local_db(items, true);
    }

    return items;
  }

  static Future<void> save_to_local_db(
      List<BannerModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<BannerModel>("BannerModel");

    if (clear_db) {
      await box.clear();
    }
    box.addAll(data);
    return;
  }

  static BannerModel fromJson(data) {
    BannerModel item = new BannerModel();
    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.created_at = data['created_at'].toString();
    item.section = data['section'].toString();
    item.position = data['position'].toString();
    item.name = data['name'].toString();
    item.sub_title = data['sub_title'].toString();
    item.type = data['type'].toString();
    item.category_id = data['category_id'].toString();
    item.product_id = data['product_id'].toString();
    item.clicks = data['clicks'].toString();
    item.image = data['image'].toString();

    return item;
  }

  static Future<List<BannerModel>> get_local_banners() async {

    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<BannerModel>("BannerModel");
    if(box.values.isEmpty){
      return [];
    }

    List<BannerModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }
}

/*

class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final typeId = 21;

  @override
  BannerModel read(BinaryReader reader) {
    return BannerModel()..name = reader.read();
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer.write(obj.name);
  }
}*/
