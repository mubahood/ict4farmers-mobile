import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

part 'ProductModel.g.dart';

@HiveType(typeId: 30)
class ProductModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String created_at = "";

  @HiveField(2)
  String name = "";

  @HiveField(3)
  String category_id = "";

  @HiveField(4)
  String user_id = "";

  @HiveField(5)
  String country_id = "";

  @HiveField(6)
  String city_id = "";

  @HiveField(7)
  String price = "";

  @HiveField(8)
  String slug = "";

  @HiveField(9)
  String status = "";

  @HiveField(10)
  String description = "";

  @HiveField(11)
  String quantity = "";

  @HiveField(12)
  String images = "";

  @HiveField(13)
  String thumbnail = "";

  @HiveField(14)
  String attributes = "";

  @HiveField(15)
  String sub_category_id = "";

  @HiveField(16)
  String fixed_price = "";

  String get_thumbnail() {
    String thumbnail_link = "no_image.jpg";
    bool found = false;

    if (this.thumbnail != null) {
      if (this.thumbnail.length > 3) {
        try {
          dynamic raw_thumb = jsonDecode(this.thumbnail);
          if (raw_thumb['thumbnail'] != null) {
            if (raw_thumb['thumbnail'].toString().length > 2) {
              thumbnail_link =
                  "${AppConfig.BASE_URL}/storage/${raw_thumb['thumbnail'].toString()}";
            }
          }
        } catch (x) {
          String thumbnail_link = "";
        }
      }
    }

    if (thumbnail_link == null || (thumbnail_link.length < 5)) {
      thumbnail_link = AppConfig.BASE_URL + "/" + "no_image.jpg";
    }
    return thumbnail_link;
  }

  static Future<List<ProductModel>> get_user_products(int user_id) async {
    List<ProductModel> items = [];
    get_online_items({'per_page': 200, 'user_id': user_id});

    (await get_local_products()).forEach((element) {
      if (element.user_id.toString().trim() == user_id.toString().trim()) {
        items.add(element);
      }
    });

    if (items.isEmpty) {
      await ProductModel.save_to_local_db(
          (await get_online_items({'per_page': 200, 'user_id': user_id})),
          false);

      (await get_local_products()).forEach((element) {
        if (element.user_id.toString() == user_id.toString()) {
          items.add(element);
        }
      });
    }
    return items;
  }

  static Future<List<ProductModel>> get_trending() async {
    List<ProductModel> items = [];
    get_trending_items_in_background();

    items = await ProductModel.get_local_products();

    if (items == null || items.isEmpty) {
      items = await get_trending_items_in_background();
    } else {
      return items;
    }

    items.sort((a, b) => a.id.compareTo(b.id));

    return items;
  }

  static Future<List<ProductModel>> get_local_products() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<ProductModel>("ProductModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<ProductModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<ProductModel>> get_trending_items_in_background() async {
    List<ProductModel> items = [];
    items = await get_online_items({'per_page': 100, 'user_id': 0});

    if (await Utils.is_connected()) {
      await ProductModel.save_to_local_db(items, true);
    }
    return items;
  }

  static Future<void> save_to_local_db(
      List<ProductModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("ProductModel")) {
      box = await Hive.openBox<ProductModel>("ProductModel");
    }
    if (box == null) {
      box = await Hive.openBox<ProductModel>("ProductModel");
    }
    if (box == null) {
      return;
    }

    if (clear_db) {
      await box.clear();
    }

    List<int> new_data = [];
    data.forEach((element) {
      new_data.add(element.id);
    });

    List existinng = await get_local_products();
    for (int xx = 0; xx < existinng.length; xx++) {
      ProductModel pro = existinng[xx];
      await pro.delete();
    }

    await box.addAll(data);
    return;
  }

  static Future<List<ProductModel>> get_online_items(
      Map<String, dynamic> data) async {
    List<ProductModel> items = [];

    String resp = await Utils.http_get('api/products', data);

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        ProductModel item = new ProductModel();
        item = ProductModel.fromJson(element);
        items.add(item);
      }).toList();
    }

    return items;
  }

  static Future<ProductModel> get_single_item(String id) async {
    List<ProductModel> items = await ProductModel.get_local_products();
    ProductModel item = new ProductModel();
    items.forEach((el) {
      if (el.id.toString() == id.toString()) {
        item = el;
      }
    });

    if (item.id.toString() == id.toString()) {
      return item;
    }

    String resp = await Utils.http_get('api/products/$id', {});

    if (resp != null && !resp.isEmpty) {
      item = ProductModel.fromJson(jsonDecode(resp));
    }

    return item;
  }

  static ProductModel fromJson(data) {
    ProductModel item = new ProductModel();
    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.created_at = data['created_at'].toString();
    item.fixed_price = data['fixed_price'].toString();
    item.name = data['name'].toString();
    item.category_id = data['category_id'].toString();
    item.user_id = data['user_id'].toString();
    item.country_id = data['country_id'].toString();
    item.city_id = data['city_id'].toString();
    item.price = data['price'].toString();
    item.slug = data['slug'].toString();
    item.status = data['status'].toString();
    item.description = data['description'].toString();
    item.quantity = data['quantity'].toString();
    item.images = data['images'].toString();
    item.thumbnail = data['thumbnail'].toString();
    item.attributes = data['attributes'].toString();
    item.sub_category_id = data['sub_category_id'].toString();

    return item;
  }
}
