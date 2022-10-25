import 'dart:convert';

import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';

class LoggedInUserModel {
  static String end_point = "api/logged_in_user";
  int id = 0;
  String name = "";
  String token = "";
  String phone_number = "";
  String remember_token = "";
  String created_at = "";
  String first_name = "";
  String last_name = "";
  String email = "";
  String avatar = "";
  String status = "";
  String message = "";
  String data = "";
  String username = "";
  String company_name = "";
  String address = "";
  String about = "";
  String services = "";
  String longitude = "";
  String latitude = "";
  String division = "";
  String opening_hours = "";
  String cover_photo = "";
  String facebook = "";
  String whatsapp = "";
  String youtube = "";
  String instagram = "";
  String last_seen = "";
  String linkedin = "";
  String status_comment = "";
  String category_id = "";
  String country_id = "";
  String region = "";
  String district = "";
  String sub_county = "";
  String user_type = "";
  String location_id = "";
  String owner_id = "";
  String date_of_birth = "";
  String marital_status = "";
  String gender = "";
  String group_id = "";
  String group_text = "";
  String sector = "";
  List<String> sectors = [];
  String production_scale = "";
  String number_of_dependants = "";
  String user_role = "";
  String access_to_credit = "";
  String experience = "";
  String phone_number_2 = "";
  String district_text = "";
  String county_text = "";
  String sub_county_text = "";
  String education = "";
  String phone_number_verified = "";
  String verification_code = "";
  DateTime dob = DateTime(1990);

  static Future<void> update_local_user() async {
    LoggedInUserModel u = await LoggedInUserModel.get_logged_in_user();
    String _resp = await Utils.http_get('api/users-profile', {
      'id': u.id,
    });
    await LoggedInUserModel.login_user(_resp);
  }

  static delete_all_items() async {
    List<DynamicTable> items =
        await DynamicTable.get_local_items(endpoint: end_point);
    int y = 0;
    for (y = 0; y < items.length; y++) {
      await items[y].delete();
    }
    List<DynamicTable> token_items =
        await DynamicTable.get_local_items(endpoint: 'token');

    for (y = 0; y < token_items.length; y++) {
      await token_items[y].delete();
    }

    return;
  }

  static Future<LoggedInUserModel> get_logged_in_user() async {
    LoggedInUserModel item = new LoggedInUserModel();
    DynamicTable _item = new DynamicTable();
    List<DynamicTable> items =
        await DynamicTable.get_local_items(endpoint: end_point);
    if (items.isEmpty) {
      return item;
    }

    _item = items[0];
    if (_item.data != null) {
      if (_item.data.length > 5) {
        Map<dynamic, dynamic> d = jsonDecode(_item.data);

        if (d['data'] != null) {
          if (d['data']['id'] != null) {
            item.id = Utils.int_parse(d['data']['id']);
            item.name = Utils.string_parse(d['data']['name'], "");
            item.token = Utils.string_parse(d['data']['token'], "");
            item.remember_token =
                Utils.string_parse(d['data']['remember_token'], "");
            item.created_at = Utils.string_parse(d['data']['created_at'], "");
            item.first_name = Utils.string_parse(d['data']['first_name'], "");
            item.last_name = Utils.string_parse(d['data']['last_name'], "");
            item.email = Utils.string_parse(d['data']['email'], "");
            item.phone_number =
                Utils.string_parse(d['data']['phone_number'], "");
            item.avatar = Utils.string_parse(d['data']['avatar'], "");
            item.status = Utils.string_parse(d['data']['status'], "");
            item.message = Utils.string_parse(d['data']['message'], "");
            item.data = Utils.string_parse(d['data']['data'], "");
            item.username = Utils.string_parse(d['data']['username'], "");
            item.company_name =
                Utils.string_parse(d['data']['company_name'], "");
            item.address = Utils.string_parse(d['data']['address'], "");
            item.about = Utils.string_parse(d['data']['about'], "");
            item.services = Utils.string_parse(d['data']['services'], "");
            item.longitude = Utils.string_parse(d['data']['longitude'], "");
            item.latitude = Utils.string_parse(d['data']['latitude'], "");
            item.division = Utils.string_parse(d['data']['division'], "");
            item.opening_hours =
                Utils.string_parse(d['data']['opening_hours'], "");
            item.cover_photo = Utils.string_parse(d['data']['cover_photo'], "");
            item.facebook = Utils.string_parse(d['data']['facebook'], "");
            item.whatsapp = Utils.string_parse(d['data']['whatsapp'], "");
            item.youtube = Utils.string_parse(d['data']['youtube'], "");
            item.instagram = Utils.string_parse(d['data']['instagram'], "");
            item.last_seen = Utils.string_parse(d['data']['last_seen'], "");
            item.linkedin = Utils.string_parse(d['data']['linkedin'], "");
            item.status_comment =
                Utils.string_parse(d['data']['status_comment'], "");
            item.category_id = Utils.string_parse(d['data']['category_id'], "");
            item.country_id = Utils.string_parse(d['data']['country_id'], "");
            item.region = Utils.string_parse(d['data']['region'], "");
            item.district = Utils.string_parse(d['data']['district'], "");
            item.sub_county = Utils.string_parse(d['data']['sub_county'], "");
            item.user_type = Utils.string_parse(d['data']['user_type'], "");
            item.location_id = Utils.string_parse(d['data']['location_id'], "");
            item.owner_id = Utils.string_parse(d['data']['owner_id'], "");
            item.date_of_birth =
                Utils.string_parse(d['data']['date_of_birth'], "");
            item.marital_status =
                Utils.string_parse(d['data']['marital_status'], "");
            item.gender = Utils.string_parse(d['data']['gender'], "");
            item.group_id = Utils.string_parse(d['data']['group_id'], "");
            item.group_text = Utils.string_parse(d['data']['group_text'], "");
            item.sector = Utils.string_parse(d['data']['sector'], "");
            item.production_scale =
                Utils.string_parse(d['data']['production_scale'], "");
            item.number_of_dependants =
                Utils.string_parse(d['data']['number_of_dependants'], "");
            item.user_role = Utils.string_parse(d['data']['user_role'], "");
            item.access_to_credit =
                Utils.string_parse(d['data']['access_to_credit'], "");
            item.phone_number =
                Utils.string_parse(d['data']['phone_number'], "");
            item.experience = Utils.string_parse(d['data']['experience'], "");
            item.phone_number_2 =
                Utils.string_parse(d['data']['phone_number_2'], "");
            item.district_text =
                Utils.string_parse(d['data']['district_text'], "");
            item.county_text = Utils.string_parse(d['data']['county_text'], "");
            item.sub_county_text =
                Utils.string_parse(d['data']['sub_county_text'], "");
            item.education = Utils.string_parse(d['data']['education'], "");
            item.phone_number_verified =
                Utils.string_parse(d['data']['phone_number_verified'], "");
            item.verification_code =
                Utils.string_parse(d['data']['verification_code'], "");

            if (item.date_of_birth.length > 4) {
              try {
                item.dob = DateTime.parse(item.date_of_birth);
              } catch (e) {}
            }

            if (item.sector.length > 4) {
              try {
                item.sectors.clear();
                (jsonDecode(item.sector) as List<dynamic>).forEach((e) {
                  if (['Crop farming', 'Livestock farming', 'Fisheries']
                      .contains(e.toString())) {
                    item.sectors.add(e.toString());
                  }
                });
              } catch (e) {}
            }
          }
        }
      }
    }

    return item;
  }

  static login_user(
    dynamic raw,
  ) async {
    if (raw == null) {
      return;
    }
    DynamicTable d = new DynamicTable();
    d.id = 1;
    d.own_id = 1;
    d.data_type = end_point;

    d.data = raw;

    await DynamicTable.save_to_local_db(
        end_point: end_point, clear_previous: true, new_ids: [1], items: [d]);
  }

  static Future<String> get_token() async {
    List<DynamicTable> token_items =
        await DynamicTable.get_local_items(endpoint: 'token');
    if (token_items.isEmpty) {
      return '';
    }

    return token_items[0].data;
  }

  static save_token(String token) async {
    DynamicTable _token = new DynamicTable();
    _token.id = 1;
    _token.own_id = 1;
    _token.data_type = 'token';
    _token.data = token;

    await DynamicTable.save_to_local_db(
        end_point: 'token',
        clear_previous: true,
        new_ids: [1],
        items: [_token]);
  }

  bool profile_is_complete() {
    if (this.user_role == null) {
      return false;
    }

    if (this.user_role.length < 5) {
      return false;
    }

    if (this.user_role == 'null') {
      return false;
    } else {
      return true;
    }
  }
}
