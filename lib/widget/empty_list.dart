import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/theme/app_theme.dart';

Widget EmptyList({
  String body: "No item found.",
  String action_text: "",
  double image_width: 80,
  String empty_image: ""}) {
  String _empty_image = './assets/project/empty_box.png';
  if (!empty_image.isEmpty) {
    _empty_image = empty_image;
  }
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Image(
            width: image_width,
            image: AssetImage(
              _empty_image,
            ),
          ),
          padding: EdgeInsets.only(left: 80, right: 80),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 30,right: 30),
          child: Column(
            children: [
              FxText(
                body,
                textAlign: TextAlign.center,
              ),
              FxSpacing.height(20),
              action_text.isEmpty?Container():FxText.h2(
                action_text,
                fontSize: 18,
                color: CustomTheme.primary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
