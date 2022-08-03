import 'dart:convert';

import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';

class PestModel {
  static String end_point = "api/pests";
  int id = 0;
  String name = "";
  String description = "";
  String cause = "";
  String cure = "";
  String image = "";
  String video = "";


  static Future<List<PestModel>> get_items() async {
    List<DynamicTable> items = [];
    List<PestModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          PestModel item = new PestModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.description = map['description'].toString();
            item.name = map['name'].toString();
            item.cause = map['cause'].toString();
            item.cure = map['cure'].toString();
            item.image = map['image'].toString();
            item.video = map['video'].toString();

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
      'name': this.name,
    };
  }

  String get_image() {
    //return 'https://images.unsplash.com/photo-1570042707108-66761758315a?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770';
    return '${AppConfig.BASE_URL}/${image}';
  }
}
