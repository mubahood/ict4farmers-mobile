import 'dart:convert';

import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';

class FarmersGroup {
  static String end_point = "farmers-goups";
  int id = 0;
  String name = "";
  String details = "";

  static Future<List<FarmersGroup>> get_items() async {
    List<DynamicTable> items = [];
    List<FarmersGroup> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          FarmersGroup item = new FarmersGroup();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.details = map['details'].toString();
            item.name = map['name'].toString();
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
      'details': this.details,
    };
  }
}
