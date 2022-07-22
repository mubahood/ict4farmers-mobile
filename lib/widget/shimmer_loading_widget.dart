import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget ShimmerLoadingWidget(
    {double width: double.infinity,
    double height: 200,
    bool is_circle: false,
    double padding: 0.0}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                  Radius.circular(is_circle ? (width / 2) : 10))),
        ),
      ),
    ),
  );
}
