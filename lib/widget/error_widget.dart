import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget MyErrorWidget(
    {double width: 200, double height: 200, bool is_circle: false}) {
  return Image(
    width: width,
    fit: BoxFit.cover,
    image: AssetImage('assets/project/logo_1.png'),
  );
}
