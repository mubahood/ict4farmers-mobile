import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:shimmer/shimmer.dart';

Widget ShimmerListLoadingWidget(
    {double width: double.infinity,
    double height: 70,
    bool is_circle: false,
    double padding: 15.0}) {
  return Text("Loading...");
  return Container(
    height: double.infinity - 200,
    child: ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                FxContainer(
                  width: height,
                  color: Colors.grey.shade700,
                  height: height,
                  borderRadiusAll: height / 2,
                  child: SizedBox(
                    width: height,
                    height: height,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: FxContainer(
                    color: Colors.grey.shade700,
                    height: height,
                    width: width,
                    borderRadiusAll: 0,
                    child: SizedBox(
                      height: height,
                    ),
                  ),
                ),

                /*  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: FxContainer(
                      width: width,
                      height: height,
                      borderRadiusAll: 0,
                      child: SizedBox(),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                FxContainer(
                  width: height,
                  color: Colors.grey.shade700,
                  height: height,
                  borderRadiusAll: height / 2,
                  child: SizedBox(
                    width: height,
                    height: height,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: FxContainer(
                    color: Colors.grey.shade700,
                    height: height,
                    width: width,
                    borderRadiusAll: 0,
                    child: SizedBox(
                      height: height,
                    ),
                  ),
                ),

                /*  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: FxContainer(
                      width: width,
                      height: height,
                      borderRadiusAll: 0,
                      child: SizedBox(),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                FxContainer(
                  width: height,
                  color: Colors.grey.shade700,
                  height: height,
                  borderRadiusAll: height / 2,
                  child: SizedBox(
                    width: height,
                    height: height,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: FxContainer(
                    color: Colors.grey.shade700,
                    height: height,
                    width: width,
                    borderRadiusAll: 0,
                    child: SizedBox(
                      height: height,
                    ),
                  ),
                ),

                /*  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: FxContainer(
                      width: width,
                      height: height,
                      borderRadiusAll: 0,
                      child: SizedBox(),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                FxContainer(
                  width: height,
                  color: Colors.grey.shade700,
                  height: height,
                  borderRadiusAll: height / 2,
                  child: SizedBox(
                    width: height,
                    height: height,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: FxContainer(
                    color: Colors.grey.shade700,
                    height: height,
                    width: width,
                    borderRadiusAll: 0,
                    child: SizedBox(
                      height: height,
                    ),
                  ),
                ),

                /*  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: FxContainer(
                      width: width,
                      height: height,
                      borderRadiusAll: 0,
                      child: SizedBox(),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                FxContainer(
                  width: height,
                  color: Colors.grey.shade700,
                  height: height,
                  borderRadiusAll: height / 2,
                  child: SizedBox(
                    width: height,
                    height: height,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: FxContainer(
                    color: Colors.grey.shade700,
                    height: height,
                    width: width,
                    borderRadiusAll: 0,
                    child: SizedBox(
                      height: height,
                    ),
                  ),
                ),

                /*  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: FxContainer(
                      width: width,
                      height: height,
                      borderRadiusAll: 0,
                      child: SizedBox(),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
