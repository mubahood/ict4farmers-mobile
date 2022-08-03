import 'dart:convert';

import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';

class GardenActivityModel {
  static String end_point = "api/garden-activities";
  int id = 0;
  int position = 0;
  int person_responsible = 0;
  int done_by = 0;
  bool is_done = false;
  bool is_generated = false;
  bool done_status = false;
  String name = "";
  String created_at = "";
  String due_date = "";
  String details = "";
  String administrator_id = "";
  String administrator_name = "";
  String person_responsible_name = "";
  String done_by_name = "";
  String done_details = "";
  String done_images = "";
  int garden_id = 0;
  int garden_production_record_id = 0;

  static Future<List<GardenActivityModel>> get_items() async {
    LoggedInUserModel u = await Utils.get_logged_in();
    if (u.id < 1) {
      return [];
    }
    List<DynamicTable> items = [];
    List<GardenActivityModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {'user_id': u.id});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          GardenActivityModel item = new GardenActivityModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.garden_production_record_id = Utils.int_parse(map['garden_production_record_id']);
            item.position = Utils.int_parse(map['position']);
            item.person_responsible =
                Utils.int_parse(map['person_responsible']);
            item.done_by = Utils.int_parse(map['done_by']);
            item.garden_id = Utils.int_parse(map['garden_id']);
            item.is_done = Utils.bool_parse(map['is_done']);
            item.is_generated = Utils.bool_parse(map['is_generated']);
            item.done_status = Utils.bool_parse(map['done_status']);
            item.name = map['name'].toString();
            item.created_at = map['created_at'].toString();
            item.due_date = map['due_date'].toString();
            item.details = map['details'].toString();
            item.administrator_id = map['administrator_id'].toString();
            item.administrator_name = map['administrator_name'].toString();
            item.person_responsible_name =
                map['person_responsible_name'].toString();
            item.done_by_name = map['done_by_name'].toString();
            item.done_details = map['done_details'].toString();
            item.done_images = map['done_images'].toString();

            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.position.compareTo(b.position));
    return _items;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'details': this.details,
    };
  }

  bool is_missing() {
    bool is_missing = false;
    try {
      final old = DateTime.parse(this.due_date);
      if (old != null) {
        final date2 = DateTime.now();
        final difference = date2.difference(old).inDays;
        if (difference > 1) {
          is_missing = true;
        } else {
          is_missing = false;
        }
      }
    } catch (e) {}
    return is_missing;
  }

  int get_status() {
    int status = 0;
    if (this.is_done) {
      if (this.done_status) {
        status = 5;
      } else {
        status = 4;
      }
    } else {
      if (this.is_missing()) {
        status = 2;
      } else {
        status = 3;
      }
    }
    return status;
  }
}
