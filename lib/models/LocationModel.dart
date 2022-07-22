import 'dart:convert';

import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';

class LocationModel {
  static String end_point = "locations";
  int id = 0;
  int parent = 0;
  String name = "";

  static Future<List<LocationModel>> get_items() async {
    List<DynamicTable> items = [];
    List<LocationModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          LocationModel item = new LocationModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.name = map['name'].toString();
            item.parent = Utils.int_parse(map['parent'].toString());
            _items.add(item);
          }
        }
      }
    });
    return _items;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'parent': this.parent,
    };
  }
}
