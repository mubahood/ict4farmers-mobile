import 'dart:convert';

import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';

class FinancialRecordModel {
  static String end_point = "financial-records";
  int id = 0;
  int garden_id = 0;
  String garden_name = "";
  int administrator_id = 0;
  int created_by = 0;
  String created_by_name = "";
  int amount = 0;
  String created_at = "";
  String description = "";

  static Future<List<FinancialRecordModel>> get_items() async {
    LoggedInUserModel u = await Utils.get_logged_in();
    if (u.id < 1) {
      return [];
    }
    List<DynamicTable> items = [];
    List<FinancialRecordModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {'user_id': u.id});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          FinancialRecordModel item = new FinancialRecordModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.garden_id = Utils.int_parse(map['garden_id']);
            item.created_by = Utils.int_parse(map['created_by']);
            item.amount = Utils.int_parse(map['amount']);
            item.administrator_id = Utils.int_parse(map['administrator_id']);
            item.garden_name = map['garden_name'].toString();
            item.created_by_name = map['created_by_name'].toString();
            item.created_at = map['created_at'].toString();
            item.description = map['description'].toString();


            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => b.id.compareTo(a.id));
    return _items;
  }
}
