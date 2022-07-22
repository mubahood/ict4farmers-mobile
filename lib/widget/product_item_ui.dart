import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widget/shimmer_loading_widget.dart';

import '../models/ProductModel.dart';
import '../pages/products/product_details.dart';
import '../theme/custom_theme.dart';

Widget ProductItemUi(int index, ProductModel productModel, context) {
  return InkWell(
    onTap: () {
      Utils.navigate_to(AppConfig.ProductDetails, context,
          data: {'id': productModel.id});
      return;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              ProductDetails(productModel),
          transitionDuration: Duration.zero,
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.only(
        top: 10,
        left: (index.isOdd) ? 0 : 10,
        right: (index.isOdd) ? 10 : 0,
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            height: 230,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: productModel.get_thumbnail(),
            placeholder: (context, url) => ShimmerLoadingWidget(
              height: 240,
            ),
            errorWidget: (context, url, error) => Image(
                image: AssetImage(
                  './assets/project/no_image.jpg',
                ),
                fit: BoxFit.cover,
                height: 40,
                width: 40),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'UGX '+productModel.price,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Icon(
                  Icons.more_outlined,
                  color: CustomTheme.primary,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
