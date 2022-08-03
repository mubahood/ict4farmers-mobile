import 'dart:convert';

import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';

class CropCategory {
  static String end_point = "crop-categories";
  int id = 0;
  int parent = 0;
  String name = "";
  String details = "";

  static Future<List<CropCategory>> get_items() async {
    List<DynamicTable> items = [];
    List<CropCategory> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          CropCategory item = new CropCategory();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.details = map['details'].toString();
            item.name = map['name'].toString();
            item.parent = Utils.int_parse(map['parent']);
            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.name.compareTo(b.name));
    return _items;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'parent': this.parent,
      'name': this.name,
      'details': this.details,
    };
  }
}
