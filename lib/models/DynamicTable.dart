import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ict4farmers/utils/Utils.dart';

part 'DynamicTable.g.dart';

@HiveType(typeId: 60)
class DynamicTable extends HiveObject {
  static save_to_local_db({
    required String end_point,
    required bool clear_previous,
    required List<int> new_ids,
    required List<DynamicTable> items,
  }) async {
    List<DynamicTable> current_items = [];
    current_items = await DynamicTable.get_local_items(endpoint: end_point);
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<DynamicTable>("DynamicTable");

    for (int count = 0; count < current_items.length; count++) {
      if (clear_previous) {
        try {
          await current_items[count].delete();
        } catch (e) {}
      } else {
        if (new_ids.contains(current_items[count].own_id)) {
          await current_items[count].delete();
        }
      }
    }
    for (int x = 0; x < items.length; x++) {
      await box.add(items[x]);
    }
  }

  static Future<List<DynamicTable>> get_items({
    required String end_point,
    required bool clear_previous,
    required Map<String, dynamic> params,
  }) async {
    List<DynamicTable> items = [];
    List<DynamicTable> ready_items = [];
    List<int> done_ids = [];

    DynamicTable.get_online_items(
        end_point: end_point, clear_previous: clear_previous, params: params);
    items = await DynamicTable.get_local_items(endpoint: end_point);
    if (items.isEmpty) {
      await DynamicTable.get_online_items(
          end_point: end_point, clear_previous: clear_previous, params: params);
      items = await DynamicTable.get_local_items(endpoint: end_point);
    }
    done_ids.clear();
    ready_items.clear();
    done_ids = [];
    ready_items = [];

    items.forEach((element) {
      if (!done_ids.contains(Utils.int_parse(element.own_id))) {
        done_ids.add(Utils.int_parse(element.own_id));
        ready_items.add(element);
      }
    });

    return ready_items;
  }

  static Future<List<DynamicTable>> get_online_items({
    required String end_point,
    required bool clear_previous,
    required Map<String, dynamic> params,
  }) async {
    List<DynamicTable> items = [];
    List<DynamicTable> current_items = [];
    current_items = await DynamicTable.get_local_items(endpoint: end_point);

    if (await Utils.is_connected()) {
      Utils.init_databse();
      await Hive.initFlutter();
      var box = await Hive.openBox<DynamicTable>("DynamicTable");

      String resp = await Utils.http_get('api/${end_point}', params);
      List<int> new_ids = [];

      if (resp != null && !resp.isEmpty) {
        json.decode(resp).map((element) {
          DynamicTable item = new DynamicTable();
          item = DynamicTable.fromJson(element);
          item.data_type = end_point;
          items.add(item);
          new_ids.add(item.own_id);
        }).toList();
      }

      for (int count = 0; count < current_items.length; count++) {
        if (clear_previous) {
          try {
            await current_items[count].delete();
          } catch (e) {}
        } else {
          if (new_ids.contains(current_items[count].own_id)) {
            await current_items[count].delete();
          }
        }
      }

      for (int x = 0; x < items.length; x++) {
        await box.add(items[x]);
      }

      current_items = await DynamicTable.get_local_items(endpoint: end_point);
    }

    return items;
  }

  static DynamicTable fromJson(data) {
    DynamicTable item = new DynamicTable();
    item.own_id = 0;
    if (data['id'] != null) {
      try {
        item.own_id = int.parse(data['id'].toString());
      } catch (e) {
        item.own_id = 0;
      }
    }

    item.data = json.encode(data).toString();

    return item;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  int own_id = 0;

  @HiveField(3)
  String data_type = "";

  @HiveField(4)
  String data = "";

  static Future<List<DynamicTable>> get_local_items({required String endpoint}) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<DynamicTable>("DynamicTable");
    if (box.values.isEmpty) {
      return [];
    }
    List<int> done_ids = [];
    List<DynamicTable> items = [];
    box.values.forEach((element) {
      if (element.data_type == endpoint) {
        if (!done_ids.contains(Utils.int_parse(element.own_id))) {
          done_ids.add(Utils.int_parse(element.own_id));
          items.add(element);
        }
      }
    });

    return items;
  }
}
