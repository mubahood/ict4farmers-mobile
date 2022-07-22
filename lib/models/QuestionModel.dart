import 'dart:convert';

import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

import 'DynamicTable.dart';

class QuestionModel {
  static String end_point = "questions";
  int id = 0;
  int administrator_id = 0;
  int answered_by = 0;
  bool is_answered = false;
  String created_at = "";
  String question = "";
  String answer = "";
  String question_images = "";
  String answer_images = "";
  String category_id = "";


  List<String> get_images(bool get_thumbs){
    if(this.question_images.toString().length<10){
      return [];
    }
    List<String> items = [];
    List<dynamic> map = jsonDecode(this.question_images.toString());
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

  static Future<List<QuestionModel>> get_items() async {
    List<DynamicTable> items = [];
    List<QuestionModel> _items = [];
    items = await DynamicTable.get_items(
        end_point: end_point, clear_previous: true, params: {});

    items.forEach((element) {
      Map<dynamic, dynamic> map = jsonDecode(element.data);
      if (map != null) {
        if (map['id'] != null) {
          QuestionModel item = new QuestionModel();
          item.id = Utils.int_parse(map['id']);
          if (item.id > 1) {
            item.administrator_id = Utils.int_parse(map['administrator_id'].toString());
            item.answered_by = Utils.int_parse(map['answered_by'].toString());
            item.is_answered = Utils.bool_parse(map['is_answered'].toString());
            item.created_at = map['created_at'].toString();
            item.question = map['question'].toString();
            item.answer = map['answer'].toString();
            item.question_images = map['question_images'].toString();
            item.category_id = map['category_id'].toString();

            _items.add(item);
          }
        }
      }
    });
    _items.sort((a, b) => a.id.compareTo(b.id));
    return _items;
  }


  String get_image() {
    return 'https://images.unsplash.com/photo-1570042707108-66761758315a?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770';
  }
}
