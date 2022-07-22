import 'dart:convert';

import 'package:ict4farmers/utils/Utils.dart';

class RespondModel {
  String raw;
  int code = 0;
  String message = "";
  dynamic data;

  RespondModel(this.raw) {
    if (raw != null && !raw.isEmpty) {

      dynamic resp = json.decode(raw);
      if (resp != null) {

        if (resp['status'] != null) {
          this.code = Utils.int_parse(resp['status']);
          this.message = resp['message'].toString();
          this.data = resp['data'];
        }
      }
    }
  }
}
