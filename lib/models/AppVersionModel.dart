import 'dart:convert';

import 'package:ict4farmers/utils/AppConfig.dart';

import '../utils/Utils.dart';
import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';

class AppVersionModel {
  static String end_point = "api/app-version";

  int id = 0;
  String version = "";

  static Future<bool> is_latest_varsion() async {
    List<AppVersionModel> _items = [];
    _items = await AppVersionModel.get_items();

    bool decision = true;
    _items.forEach((e) {
      if(e.id == 1){
        if(e.version.toString() != AppConfig.APP_VERSION.toString()){
          decision = false;
        }
      }
    });
    return decision;
  }

  static Future<List<AppVersionModel>> get_items() async {
    List<DynamicTable> items = [];
    List<AppVersionModel> _items = [];


    items = await DynamicTable.get_items(
        end_point: end_point,
        clear_previous: true, params: {}, );

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          AppVersionModel item = new AppVersionModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.id = 1;
            item.version = map['version'].toString();

            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.id.compareTo(b.id));
    return _items;
  }
}
