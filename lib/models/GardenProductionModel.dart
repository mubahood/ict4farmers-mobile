import 'dart:convert';

import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/utils/Utils.dart';

import '../utils/AppConfig.dart';
import 'DynamicTable.dart';
import 'LoggedInUserModel.dart';

class GardenProductionModel {
  static String end_point = "api/garden-production-record";
  int id = 0;
  int administrator_id = 0;
  String created_at = "";
  String garden_id = "";
  String garden_name = "";
  String description = "";
  String images = "";

  static Future<List<GardenProductionModel>> get_items() async {
    LoggedInUserModel u = await Utils.get_logged_in();
    if (u.id < 1) {
      return [];
    }
    List<DynamicTable> items = [];
    List<GardenProductionModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {'user_id': u.id});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          GardenProductionModel item = new GardenProductionModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 0) {
            item.administrator_id = Utils.int_parse(map['administrator_id']);
            item.created_at = map['created_at'].toString();
            item.garden_id = map['garden_id'].toString();
            item.garden_name = map['garden_name'].toString();
            item.description = map['description'].toString();
            item.images = map['images'].toString();

            _items.add(item);
          }
        }
      }
    });
    _items.sort((b, a) => a.id.compareTo(b.id));
    return _items;
  }

  List<String> get_images(bool get_thumbs){
    if(this.images.toString().length<10){
      return [];
    }
    List<String> items = [];
    List<dynamic> map = jsonDecode(this.images.toString());
    if(map!=null){
      map.forEach((v) {
        if(v!=null){
          if((v['src'] !=null) && v['thumbnail'] !=null ){
            if(get_thumbs){
              items.add( AppConfig.BASE_URL+"/storage/"+v['thumbnail'].toString() );
            }else{
              items.add( AppConfig.BASE_URL+"/storage/"+v['src'].toString() );
            }
          }
        }
      });
    }

    return items;
  }

}
