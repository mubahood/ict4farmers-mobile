import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/pages/products/product_details.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widget/my_widgets.dart';

import '../../models/BannerModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/product_item_ui.dart';
import '../../widget/shimmer_loading_widget.dart';

class MarketPlace1 extends StatefulWidget {
  //const MarketPlace1({Key? key}) : super(key: key, this.page);

  @override
  State<MarketPlace1> createState() => _MarketPlace1State();
}

List<BannerModel> banners = [];
bool initilized = false;
bool store_initilized = false;
BannerModel horizontal_banner_1 = BannerModel();
BannerModel horizontal_banner_2 = BannerModel();
BannerModel horizontal_banner_3 = BannerModel();
List<ProductModel> _trending_products = [];

class _MarketPlace1State extends State<MarketPlace1> {
  int page_num = 1;

  bool is_logged_in = true;
  bool complete_profile = true;
  LoggedInUserModel logged_in_user = new LoggedInUserModel();

  Future<void> _init_databse() async {
    is_logged_in = await Utils.is_login();
    if (is_logged_in) {
      logged_in_user = await Utils.get_logged_in();
      if (logged_in_user.address == "null" ||
          logged_in_user.address.isEmpty ||
          (logged_in_user.address.length < 3)) {
        complete_profile = false;
      } else {
        complete_profile = true;
      }
    } else {
      complete_profile = true;
    }

    _trending_products.clear();
    List<ProductModel> _trending_get = await ProductModel.get_trending();
    _trending_get.forEach((element) {
      _trending_products.add(element);
    });

    banners = await BannerModel.get();
    int i = 0;
    _gridItems.clear();

    _gridBannersItems.clear();
    _gridBannersItems2.clear();
    banners.forEach((element) {
      i++;

      if (page_num == 1 && i == 1) {
        horizontal_banner_1 = element;
      } else if (page_num == 2 && (i == 18)) {
        horizontal_banner_1 = element;
      } else if (page_num == 3 && (i == 35)) {
        horizontal_banner_1 = element;
      }

/*      if ( (banners.length % (i*page_num)) == 1) {

      }*/

      if (((i > 1) && (i < 10)) && page_num == 1) {
        _gridItems.add(element);
      } else if (((i > 18) && (i < 27)) && page_num == 2) {
        _gridItems.add(element);
      } else if (((i > (18 + 17)) && (i < (27 + 17))) && page_num == 3) {
        _gridItems.add(element);
      }

      if (i == 10 && page_num == 1) {
        horizontal_banner_2 = element;
      } else if ((i) == 27 && page_num == 2) {
        horizontal_banner_2 = element;
      } else if ((i) == (27 + 17) && page_num == 3) {
        horizontal_banner_2 = element;
      }

      if (((i > 10) && (i < 13)) && page_num == 1) {
        _gridBannersItems.add(element);
      } else if ((((i) > 27) && ((i) < 30)) && page_num == 2) {
        _gridBannersItems.add(element);
      } else if ((((i) > (27 + 17)) && ((i) < (30 + 17))) && page_num == 3) {
        _gridBannersItems.add(element);
      }

      if (((i > 12) && (i < 17)) && page_num == 1) {
        _gridBannersItems2.add(element);
      } else if (((i > 29) && (i < 34)) && page_num == 2) {
        _gridBannersItems2.add(element);
      } else if (((i > (29 + 17)) && (i < (34 + 17))) && page_num == 3) {
        _gridBannersItems2.add(element);
      }

      if (i == 17 && page_num == 1) {
        horizontal_banner_3 = element;
      } else if (i == 34 && page_num == 2) {
        horizontal_banner_3 = element;
      } else if (i == (34 + 17) && page_num == 3) {
        horizontal_banner_3 = element;
      }
    });

    initilized = true;
    setState(() {});
    return null;
  }

  @override
  void initState() {
    initilized = false;
    _init_databse();
  }

  @override
  void dipose() {
    store_initilized = false;
  }

  List<String> _items = [];
  List<BannerModel> _gridItems = [];
  List<BannerModel> _gridBannersItems = [];
  List<BannerModel> _gridBannersItems2 = [];
  int i = 0;

  Future<Null> _onRefresh() async {
    initilized = false;
    await _init_databse();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /*_gridBannersItems.clear();
    _gridBannersItems2.clear();


    _gridBannersItems2.add(new ProductModel());
    _gridBannersItems2.add(new ProductModel());*/

    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              (is_logged_in && complete_profile)
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container();
                        },
                        childCount: 0, // 1000 list items
                      ),
                    )
                  : SliverAppBar(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText(
                            complete_profile
                                ? "Want to access everything?"
                                : "Just 1 more step remaining!",
                            color: Colors.yellow.shade700,
                            fontWeight: 600,
                          ),
                          FxButton.text(
                              onPressed: () {
                                if (!is_logged_in) {
                                  show_not_account_bottom_sheet(context);
                                } else if (!complete_profile) {
                                  Utils.navigate_to(
                                      AppConfig.AccountEdit, context);
                                }
                              },
                              splashColor: CustomTheme.primary.withAlpha(40),
                              child: FxText.l2(
                                  complete_profile ? "YES" : "WHAT?",
                                  fontSize: 18,
                                  textAlign: TextAlign.center,
                                  color: Colors.white))
                        ],
                      ),
                      floating: true,
                      backgroundColor: Colors.red.shade700,
                    ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => {open_product_listting(horizontal_banner_1)},
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${AppConfig.BASE_URL}/storage/${horizontal_banner_1.image.toString().trim()}",
                          placeholder: (context, url) => ShimmerLoadingWidget(
                            height: 200,
                          ),
                          errorWidget: (context, url, error) => Text(
                              "${AppConfig.BASE_URL}/storage/${horizontal_banner_1.image.toString().trim()}"),
                        ),
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 2,
                    mainAxisExtent: 100),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return singleGridItem(_gridItems[index]);
                  },
                  childCount: _gridItems.length,
                ),
              ),
              /*SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => {open_product_listting(horizontal_banner_2)},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                          "${AppConfig.BASE_URL}/storage/${horizontal_banner_2.image}",
                          placeholder: (context, url) => ShimmerLoadingWidget(
                              height: 90, width: 90, is_circle: true),
                          errorWidget: (context, url, error) => Image(
                            image: AssetImage('./assets/project/no_image.jpg'),
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 7,
                    childAspectRatio: 2,
                    mainAxisExtent: 240),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return singleGridImageItem(_gridBannersItems[index], index);
                  },
                  childCount: _gridBannersItems.length,
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                    mainAxisExtent: 110),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return singleGridImageIte2(_gridBannersItems2[index], index);
                  },
                  childCount: _gridBannersItems2.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => {open_product_listting(horizontal_banner_3)},
                      child: Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          height: 220,
                          fit: BoxFit.fill,
                          imageUrl:
                          "${AppConfig.BASE_URL}/storage/${horizontal_banner_3.image}",
                          placeholder: (context, url) => ShimmerLoadingWidget(
                            height: 220,
                          ),
                          errorWidget: (context, url, error) =>  Image(
                            image: AssetImage('./assets/project/no_image.jpg'),
                            height: 200,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),*/
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(top: 20, left: 18, bottom: 10),
                      child: FxText.h4("Just In",
                          fontSize: 20, fontWeight: 800, color: Colors.black),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                    mainAxisExtent: 280),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductItemUi(
                        index, _trending_products[index], context);
                  },
                  childCount: _trending_products.length,
                ),
              ),
            ],
          )),
    );
  }

  Widget singleGridImageIte3(ProductModel productModel, int index) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ProductDetails(productModel),
            transitionDuration: Duration.zero,
          ),
        )
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 10,
          left: (index.isOdd) ? 0 : 15,
          right: (index.isOdd) ? 15 : 0,
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/project/no_image.jpg",
              height: 210,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                  child: Text(
                    productModel.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colors.grey.shade800,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singleGridImageIte2(BannerModel productModel, int index) {
    return InkWell(
      onTap: () => {open_product_listting(productModel)},
      child: Container(
        color: (page_num == 1)
            ? Color.fromARGB(255, 188, 223, 204)
            : (page_num == 2)
                ? Color.fromARGB(255, 219, 184, 158)
                : (page_num == 3)
                    ? Color.fromARGB(255, 150, 204, 239)
                    : Color.fromARGB(255, 188, 223, 204),
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(
          top: 10,
          left: (index.isOdd) ? 0 : 15,
          right: (index.isOdd) ? 15 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  productModel.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(productModel.sub_title),
              ],
            ),
            CachedNetworkImage(
              height: 100,
              fit: BoxFit.cover,
              imageUrl: "${AppConfig.BASE_URL}/storage/${productModel.image}",
              placeholder: (context, url) => ShimmerLoadingWidget(
                  height: 100, width: 100, is_circle: true),
              errorWidget: (context, url, error) => Image(
                image: AssetImage('./assets/project/no_image.jpg'),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget singleGridImageItem(BannerModel bannerModel, int index) {
    return InkWell(
      onTap: () => {open_product_listting(bannerModel)},
      child: Container(
        height: 240,
        padding: EdgeInsets.only(
          top: 5,
          left: (index.isOdd) ? 0 : 15,
          right: (index.isOdd) ? 15 : 0,
        ),
        alignment: Alignment.center,
        child: CachedNetworkImage(
          width: ((MediaQuery.of(context).size.width / 2) - 15),
          fit: BoxFit.fill,
          imageUrl: "${AppConfig.BASE_URL}/storage/${bannerModel.image}",
          placeholder: (context, url) => ShimmerLoadingWidget(
            height: 210,
          ),
          errorWidget: (context, url, error) => Image(
            image: AssetImage('./assets/project/no_image.jpg'),
            height: 210,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget singleGridItem(BannerModel data) {
    return InkWell(
      onTap: () => {open_product_listting(data)},
      child: Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: Column(
          children: [
            CachedNetworkImage(
              height: 70,
              imageUrl: "${AppConfig.BASE_URL}/storage/${data.image}",
              placeholder: (context, url) => ShimmerLoadingWidget(
                  height: 100, width: 100, is_circle: true, padding: 0),
              errorWidget: (context, url, error) => Image(
                image: AssetImage('./assets/project/no_image.jpg'),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              data.name,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void open_product_listting(BannerModel item) {
    Utils.navigate_to(AppConfig.ProductListting, context, data: {
      'title': item.name,
      'id': item.category_id,
      'task': 'Banner',
    });
  }
}
