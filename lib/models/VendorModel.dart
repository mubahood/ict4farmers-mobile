import 'dart:convert';

import '../utils/Utils.dart';
import 'DynamicTable.dart';

class VendorModel {
  static String end_point = "vendors";
  int id = 0;
  String created_at	= "";
  String username	= "";
  String name	= "";
  String avatar	= "";
  String last_name	= "";
  String company_name	= "";
  String email	= "";
  String phone_number	= "";
  String address	= "";
  String about	= "";
  String services	= "";
  String longitude	= "";
  String latitude	= "";
  String division	= "";
  String opening_hours	= "";
  String cover_photo	= "";
  String facebook	= "";
  String twitter	= "";
  String whatsapp	= "";
  String youtube	= "";
  String instagram	= "";
  String last_seen	= "";
  String status	= "";
  String linkedin	= "";
  String category_id	= "";
  String country_id	= "";
  String region	= "";
  String district	= "";
  String sub_county	= "";
  String user_type	= "";
  String location_id	= "";
  String owner_id	= "";
  String date_of_birth	= "";
  String marital_status	= "";
  String gender	= "";



  static Future<List<VendorModel>> get_items() async {
    List<DynamicTable> items = [];
    List<VendorModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          VendorModel item = new VendorModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {


            item.created_at = map['created_at'].toString();
            item.username = map['username'].toString();
            item.name = map['name'].toString();
            item.avatar = map['avatar'].toString();
            item.last_name = map['last_name'].toString();
            item.company_name = map['company_name'].toString();
            item.email = map['email'].toString();
            item.phone_number = map['phone_number'].toString();
            item.about = map['about'].toString();
            item.address = map['address'].toString();
            item.services = map['services'].toString();
            item.longitude = map['longitude'].toString();
            item.latitude = map['latitude'].toString();
            item.division = map['division'].toString();
            item.opening_hours = map['opening_hours'].toString();
            item.cover_photo = map['cover_photo'].toString();
            item.facebook = map['facebook'].toString();
            item.twitter = map['twitter'].toString();
            item.whatsapp = map['whatsapp'].toString();
            item.youtube = map['youtube'].toString();
            item.instagram = map['instagram'].toString();
            item.last_seen = map['last_seen'].toString();
            item.status = map['status'].toString();
            item.linkedin = map['linkedin'].toString();
            item.category_id = map['category_id'].toString();
            item.country_id = map['country_id'].toString();
            item.region = map['region'].toString();
            item.district = map['district'].toString();
            item.sub_county = map['sub_county'].toString();
            item.user_type = map['user_type'].toString();
            item.location_id = map['location_id'].toString();
            item.owner_id = map['owner_id'].toString();
            item.date_of_birth = map['date_of_birth'].toString();
            item.marital_status = map['marital_status'].toString();
            item.gender = map['gender'].toString();
    
            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.id.compareTo(b.id));
    return _items;
  }

  static delete_all_items() async {
    List<DynamicTable> items =
    await DynamicTable.get_local_items(endpoint: end_point);
    int y = 0;
    for (y = 0; y < items.length; y++) {
      await items[y].delete();
    }
    return;
  }
}
