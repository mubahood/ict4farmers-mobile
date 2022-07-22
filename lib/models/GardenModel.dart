import 'dart:convert';

import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';

class GardenModel {
  static String end_point = "gardens";
  int id = 0;
  int administrator_id = 0;
  int crop_category_id = 0;
  int location_id = 0;
  int size = 0;
  int production_activities_all = 0;
  int production_activities_done = 0;
  int production_activities_remaining = 0;

  String name = "";
  String crop_category_name = "";
  String location_name = "";
  String created_at = "";
  String details = "";
  String image = "";
  String plant_date = "";
  String harvest_date = "";
  String latitude = "";
  String longitude = "";
  String images = "";
  String color = "#542889";

  static Future<List<GardenModel>> get_items() async {
    LoggedInUserModel u = await Utils.get_logged_in();
    if (u.id < 1) {
      return [];
    }
    List<DynamicTable> items = [];
    List<GardenModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {'user_id': u.id});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          GardenModel item = new GardenModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {

            item.details = map['details'].toString();
            item.name = map['name'].toString();
            item.crop_category_name = map['crop_category_name'].toString();
            item.administrator_id = Utils.int_parse(map['parent']);
            item.location_id = Utils.int_parse(map['location_id']);

            item.size = Utils.int_parse(map['location_id']);
            item.production_activities_all = Utils.int_parse(map['production_activities_all']);
            item.production_activities_done = Utils.int_parse(map['production_activities_done']);
            item.production_activities_remaining = Utils.int_parse(map['production_activities_remaining']);


            item.location_name = map['location_name'].toString();
            item.created_at = map['created_at'].toString();
            item.details = map['details'].toString();
            item.image = map['image'].toString();
            item.plant_date = map['plant_date'].toString();
            item.harvest_date = map['harvest_date'].toString();
            item.latitude = map['latitude'].toString();
            item.longitude = map['longitude'].toString();
            item.images = map['images'].toString();
            item.color = map['color'].toString();

            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.name.compareTo(b.name));
    return _items;
  }

  int get_percebtage_done(){
    if(this.production_activities_all <1){
      return 0;
    }
    double percentage = ((this.production_activities_done/this.production_activities_all)*100);

    return percentage.ceil() ;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'details': this.details,
    };
  }


}
