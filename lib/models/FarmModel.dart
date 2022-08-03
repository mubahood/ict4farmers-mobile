import 'dart:convert';

import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';
import 'UserModel.dart';

class FarmModel {
  static String end_point = "api/farms";
  int id = 0;
  String name = "";
  String details = "";

  static Future<List<FarmModel>> get_items() async {
    LoggedInUserModel u = await Utils.get_logged_in();
    if (u.id < 1) {
      return [];
    }

    List<DynamicTable> items = [];
    List<FarmModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {
      'user_id': u.id.toString()
    });

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          FarmModel item = new FarmModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.details = map['details'].toString();
            item.name = map['name'].toString();
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
    return 'https://images.unsplash.com/photo-1570042707108-66761758315a?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770';
    //return '${AppConfig.BASE_URL}/${image}';
  }
}
