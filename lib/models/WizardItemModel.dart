import 'dart:convert';

import '../utils/Utils.dart';
import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';

class WizardItemModel {
  static String end_point = "api/wizard-items";

  int id = 0;
  String title = "";
  String sub_title = "";
  String description = "";
  String screen = "";
  String action_text = "";
  bool is_done = false;

  static Future<bool> open_setup_wizard() async {
    List<WizardItemModel> _items = [];
    _items = await WizardItemModel.get_items();

    bool decision = false;
    _items.forEach((e) {
      if ((e.id == 2)) {
        if (!e.is_done) {
          decision = true;
        }
      }
    });
    return decision;
  }

  static Future<List<WizardItemModel>> get_items() async {
    List<DynamicTable> items = [];
    List<WizardItemModel> _items = [];

    LoggedInUserModel u = await Utils.get_logged_in();
    if (u.id < 1) {
      return [];
    }

    items = await DynamicTable.get_items(
        end_point: end_point,
        clear_previous: true,
        params: {'user_id': u.id.toString()});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          WizardItemModel item = new WizardItemModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.title = map['title'].toString();
            item.action_text = map['action_text'].toString();
            item.sub_title = map['sub_title'].toString();
            item.description = map['description'].toString();
            item.screen = map['screen'].toString();
            item.is_done = Utils.bool_parse(map['is_done']);
            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.id.compareTo(b.id));
    return _items;
  }
}
