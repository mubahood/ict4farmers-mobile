import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/models/UserModel.dart';

class MapItem {
  String id = "";
  String type = "";
  String title = "";
  String sub_title = "";
  String photo = "";
  String lati = "0.00";
  String longi = "0.00";
  UserModel user = new UserModel();
  ProductModel product = new ProductModel();

  LatLng get_lat_log() {
    double lati = 0.364607;
    double long = 32.604781;

    try {
      lati = double.parse(this.lati.toString());
      long = double.parse(this.longi.toString());
    } catch (e) {
      lati = 0.364607;
      long = 32.604781;
    }
    LatLng point = new LatLng(lati, long);

    return point;


  }
}

class MyLatiLong{
  String lati;
  String longi;

  MyLatiLong(this.lati, this.longi);
}
List<MyLatiLong> dummy_map_positions = [
  new MyLatiLong('0.335865','32.553319'),
  new MyLatiLong('0.335704','32.551592'),
  new MyLatiLong('0.3226804','32.5673273'),
  new MyLatiLong('0.3107424','32.5934333'),
  new MyLatiLong('0.314072','32.559779'),
  new MyLatiLong('0.311590','32.573717'),
  new MyLatiLong('0.306912','32.573481'),
  new MyLatiLong('0.277828','32.579623'),
  new MyLatiLong('0.265904','32.593281'),
  new MyLatiLong('0.310908','32.565318'),
  new MyLatiLong('-0.602938','30.638680'),
  new MyLatiLong('-0.638238','30.644286'),
  new MyLatiLong('-0.651246','30.636781'),
  new MyLatiLong('-0.602216','30.623272'),
  new MyLatiLong('-0.574199','30.681311'),
  new MyLatiLong('-0.633977','30.732904'),
  new MyLatiLong('0.162778','30.068803'),
  new MyLatiLong('0.185780','30.088201'),
  new MyLatiLong('0.176854','30.065198'),
  new MyLatiLong('0.456625','33.209174'),
  new MyLatiLong('0.452505','33.227542'),
  new MyLatiLong('0.459715','33.190635'),
];


class MapFilterItem{
String location_id = "";
String location_name = "";
String type = "";
String category_id = "";
String category_name = "";
}