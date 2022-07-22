import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/Utils.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 40)
class UserModel extends HiveObject {
  static Future<void> save_to_local_db(List<UserModel> data) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("UserModel")) {
      box = await Hive.openBox<UserModel>("UserModel");
    }
    if (box == null) {
      box = await Hive.openBox<UserModel>("UserModel");
    }
    if (box == null) {
      return;
    }

    List<UserModel> _local_items = [];
    int logged_id = 0;
    box.values.forEach((item) {
      if (item.status != 'logged_in') {
        _local_items.add(item);
      } else {
        logged_id = item.id;
      }
    });

    if (await Utils.is_connected()) {
      for (int x = 0; x < _local_items.length; x++) {
        await _local_items[x].delete();
      }

      for (int x = 0; x < data.length; x++) {
        if (data[x].id != logged_id) {
          await box.add(data[x]);
        }
      }
    }

    return;
  }

  static Future<List<UserModel>> get_local_items() async {
    get_online_users({});
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<UserModel>("UserModel");
    if (box.values.isEmpty) {
      await get_online_users({});
      box = await Hive.openBox<UserModel>("UserModel");
    }
    List<UserModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<UserModel>> get_online_users(
      Map<String, String> params) async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<UserModel> items = [];

    String resp = await Utils.http_get('api/users', params);

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        UserModel item = new UserModel();
        item = UserModel.fromMap(element);
        item.status = '';
        items.add(item);
      }).toList();
    }

    if (await Utils.is_connected()) {
      await UserModel.save_to_local_db(items);
    }

    return items;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String username = "";

  @HiveField(2)
  String password = "";

  @HiveField(3)
  String name = "";

  @HiveField(4)
  String avatar = "";

  @HiveField(5)
  String remember_token = "";

  @HiveField(6)
  String created_at = "";

  @HiveField(7)
  String updated_at = "";

  @HiveField(8)
  String last_name = "";

  @HiveField(9)
  String company_name = "";

  @HiveField(10)
  String email = "";

  @HiveField(11)
  String phone_number = "";

  @HiveField(12)
  String address = "";

  @HiveField(13)
  String about = "";

  @HiveField(14)
  String services = "";

  @HiveField(15)
  String longitude = "";

  @HiveField(16)
  String latitude = "";

  @HiveField(17)
  String division = "";

  @HiveField(18)
  String opening_hours = "";

  @HiveField(19)
  String cover_photo = "";

  @HiveField(20)
  String facebook = "";

  @HiveField(21)
  String twitter = "";

  @HiveField(22)
  String whatsapp = "";

  @HiveField(23)
  String youtube = "";

  @HiveField(24)
  String instagram = "";

  @HiveField(25)
  String last_seen = "";

  @HiveField(26)
  String status = "";

  @HiveField(27)
  String linkedin = "";

  @HiveField(28)
  String category_id = "";

  @HiveField(29)
  String status_comment = "";

  @HiveField(30)
  String country_id = "";

  @HiveField(31)
  String region = "";

  @HiveField(32)
  String district = "";

  @HiveField(33)
  String sub_county = "";

  @HiveField(34)
  String logged_in_user = "0";

  bool is_a_worker() {
    if (this.linkedin == "worker") {
      return true;
    } else {
      return false;
    }
  }

  static UserModel fromMap(data) {
    UserModel u = new UserModel();
    u.id = 0;
    if (data['id'] != null) {
      if (!data['id'].toString().toString().isEmpty) {
        try {
          u.id = int.parse(data['id'].toString());
        } catch (e) {
          u.id = 0;
        }
      }
    }

    u.username = data['username'].toString();
    u.password = data['password'].toString();
    u.name = data['name'].toString();
    u.avatar = data['avatar'].toString();
    u.remember_token = data['remember_token'].toString();
    u.created_at = data['created_at'].toString();
    u.updated_at = data['updated_at'].toString();
    u.last_name = data['last_name'].toString();
    u.company_name = data['company_name'].toString();
    u.email = data['email'].toString();
    u.phone_number = data['phone_number'].toString();
    u.address = data['address'].toString();
    u.about = data['about'].toString();
    u.services = data['services'].toString();
    u.longitude = data['longitude'].toString();
    u.latitude = data['latitude'].toString();
    u.division = data['division'].toString();
    u.opening_hours = data['opening_hours'].toString();
    u.cover_photo = data['cover_photo'].toString();
    u.facebook = data['facebook'].toString();
    u.twitter = data['twitter'].toString();
    u.whatsapp = data['whatsapp'].toString();
    u.youtube = data['youtube'].toString();
    u.instagram = data['instagram'].toString();
    u.last_seen = data['last_seen'].toString();
    u.status = data['status'].toString();
    u.linkedin = data['linkedin'].toString();
    u.category_id = data['category_id'].toString();
    u.status_comment = data['status_comment'].toString();
    u.country_id = data['country_id'].toString();
    u.region = data['region'].toString();
    u.district = data['district'].toString();
    u.sub_county = data['sub_county'].toString();
    u.logged_in_user = data['logged_in_user'].toString();
    return u;
  }

  String date_of_birth = "";
  String marital_status = "";
  String gender = "";
  String group_id = "";
  String group_text = "";
  String sector = "";
  String production_scale = "";
  String number_of_dependants = "";
  String initial_toal_capitial = "";
  String experience = "";
  String access_to_credit = "";
  String user_role = "";
  String phone_number_verified = "";

  void init() {
    if (!this.facebook.isEmpty) {
      if (this.facebook.length > 15) {
        Map<dynamic, dynamic> map = json.decode(this.facebook);
        if (map != null) {
          if (map['id'] != null) {
            int id = Utils.int_parse(map['id']);
            if (id > 0) {
              this.date_of_birth = map['date_of_birth'].toString();
              this.marital_status = map['marital_status'].toString();
              this.gender = map['gender'].toString();
              this.group_id = map['group_id'].toString();
              this.group_text = map['group_text'].toString();
              this.sector = map['sector'].toString();
              this.production_scale = map['production_scale'].toString();
              this.number_of_dependants = map['number_of_dependants'].toString();
              this.initial_toal_capitial = map['initial_toal_capitial'].toString();
              this.access_to_credit = map['access_to_credit'].toString();
              this.user_role = map['user_role'].toString();
              this.experience = map['experience'].toString();
              this.phone_number_verified = map['phone_number_verified'].toString();
            }
          }
        }
      }
    }
  }
}
