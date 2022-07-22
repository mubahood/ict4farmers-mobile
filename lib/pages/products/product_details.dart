import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/pages/account/my_products_screen.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widget/loading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/BannerModel.dart';
import '../../models/ChatModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../theme/material_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/my_widgets.dart';
import '../../widget/product_item_ui.dart';
import '../../widget/shimmer_loading_widget.dart';
import '../chat/chat_screen.dart';

class ProductDetails extends StatefulWidget {
  ProductModel productModel = new ProductModel();
  dynamic raw;
  int id = 0;

  ProductDetails(this.raw);

  @override
  State<ProductDetails> createState() => ProductDetailsState();
}

List<BannerModel> banners = [];

List<String> thumbnails = [];
bool initilized = false;
bool store_initilized = false;

class ProductDetailsState extends State<ProductDetails> {
  ProductDetailsState();

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  void initState() {
    _onRefresh();
  }

  @override
  void dipose() {}

  List<ProductModel> _products = [];
  int i = 0;
  int id = 0;

  LoggedInUserModel logged_in_user = new LoggedInUserModel();
  UserModel productOwner = new UserModel();
  ProductModel productModel = new ProductModel();

  Future<Null> _onRefresh() async {
    is_loading = true;
    setState(() {});
    if (widget.raw != null) {
      if (widget.raw is Map) {
        if (widget.raw['id'] != null) {
          id = Utils.int_parse(widget.raw['id']);
          if (id > 0) {
            productModel = await ProductModel.get_single_item("$id");
          }
        }
      } else if (widget.raw is ProductModel) {
        productModel = widget.raw;
      }
    }

    logged_in_user = await Utils.get_logged_in();

    get_owner(productModel.user_id, false);

    thumbnails.clear();
    images.clear();
    List<dynamic> raw_list = jsonDecode(this.productModel.images);
    if (raw_list != null) {
      raw_list.forEach((element) {
        if (element != null) {
          if (element['thumbnail'] != null) {
            thumbnails.add(
                "${AppConfig.BASE_URL}/storage/${element['thumbnail'].toString()}");
            images.add("${AppConfig.BASE_URL}/storage/${element['src'].toString()}");
          }
        }
      });
    }

    if (thumbnails.isEmpty) {
      thumbnails.clear();
      images.clear();
      thumbnails.add(AppConfig.BASE_URL + "/" + "no_image.jpg");
      images.add(AppConfig.BASE_URL + "/" + "no_image.jpg");
    }

    _products.clear();
    _products = await ProductModel.get_local_products();
    _products.shuffle();
    if (_products.length > 10) {
      _products = _products.sublist(0, 8);
    }

    is_loading = false;
    setState(() {});
    initilized = false;
    return null;
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: CustomTheme.primary,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 1,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: FxText.h1(
                            productModel.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          width: MediaQuery.of(context).size.width - 120,
                        ),
                        Text(
                          'UGX ' + productModel.price,
                          style: TextStyle(
                              color: CustomTheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: is_loading
                      ? LoadingWidget()
                      : Stack(
                          children: [
                            CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 420,
                                            child: PageView(
                                              pageSnapping: true,
                                              controller: pageController,
                                              physics: ClampingScrollPhysics(),
                                              onPageChanged: (index) => {},
                                              children: _buildHouseList(),
                                            ),
                                          ),
                                          Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "UGX ${productModel.price}",
                                                  style: TextStyle(
                                                      color:
                                                          CustomTheme.primary,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                /*Text(
                                                  "Negotiable",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12),
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "${productModel.name} ",
                                        style: TextStyle(
                                            color: Colors.grey.shade900,
                                            fontSize: 16),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade100,
                                      thickness: 10,
                                    ),
                                    InkWell(
                                      onTap: () => {
                                        my_bottom_sheet(
                                            context,
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                  productModel.description),
                                            ))
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Description",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "See all details",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Container(
                                                      padding: FxSpacing.x(0),
                                                      child: Icon(
                                                        Icons.chevron_right,
                                                        size: 30,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade100,
                                      thickness: 3,
                                    ),
                                    InkWell(
                                      onTap: () => {
                                        get_owner(productModel.user_id, true)
                                        /*  Utils.navigate_to(
                                            AppConfig.AccountDetails, context,
                                            data: productModel.user_id)*/
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                productOwner.name,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Visit shop",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Container(
                                                      padding: FxSpacing.x(0),
                                                      child: Icon(
                                                        Icons.chevron_right,
                                                        size: 30,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade100,
                                      thickness: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              "You may also like",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(top: 6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              childCount: 1, // 1000 list items
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1,
                                    mainAxisExtent: 300),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductItemUi(
                                    index, _products[index], context);
                              },
                              childCount: _products.length,
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return SizedBox(
                                height: 80,
                              );
                            },
                            childCount: 1,
                          ))
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.grey.shade200,
                              height: 3,
                              margin: EdgeInsets.all(0),
                            ),
                            Container(
                              margin: EdgeInsets.all(0),
                              color: Colors.white,
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: FxContainer(
                                      color: CustomTheme.accent,
                                            borderRadiusAll: 4,
                                            onTap: () {
                                              Utils.launchPhone(
                                                  productOwner.phone_number);
                                            },
                                            margin: FxSpacing.x(4),
                                            padding: FxSpacing.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.phone,
                                                  color: Colors.grey.shade100,
                                                  size: 20,
                                                ),
                                                FxSpacing.width(8),
                                                FxText.sh2("Call",
                                                    color: Colors.grey.shade100,
                                                    fontWeight: 600,
                                                    letterSpacing: 0)
                                              ],
                                            ),
                                          ),
                                  ),
                                  FxSpacing.width(12),
                                  Expanded(
                                    child: FxContainer(
                                      color: CustomTheme.primary,
                                      borderRadiusAll: 4,
                                      onTap: () {
                                        if (logged_in_user.id < 1) {
                                          show_not_account_bottom_sheet(
                                              context);
                                        } else {
                                          /*Utils.navigate_to(
                                              AppConfig.PaymentPage, context);*/
                                          start_chat();
                                        }
                                      },
                                      padding: FxSpacing.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.forum,
                                            color: Colors.grey.shade100,
                                            size: 22,
                                          ),
                                          FxSpacing.width(8),
                                          FxText.sh2("Chat",
                                              color: Colors.white,
                                              fontWeight: 600,
                                              letterSpacing: 0)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ));
      },
    );
  }

  start_chat() {
    ChatModel chatThread = new ChatModel();
    chatThread.id = 0;
    chatThread.created_at = 'Just now';
    chatThread.body = '';
    chatThread.receiver_pic = '';
    chatThread.sender = logged_in_user.id.toString();
    chatThread.receiver = productModel.user_id.toString();
    chatThread.product_id = productModel.id.toString();
    chatThread.thread =
        '${chatThread.sender}-${chatThread.receiver}-${chatThread.product_id}';
    chatThread.received = false;
    chatThread.seen = false;
    chatThread.type = '';
    chatThread.contact = '';
    chatThread.gps = '';
    chatThread.file = '';
    chatThread.image = '';
    chatThread.audio = '';
    chatThread.receiver_name = '';
    chatThread.sender_name = logged_in_user.name;
    chatThread.product_name = productModel.name;
    chatThread.product_pic = '';
    chatThread.sender_pic = logged_in_user.avatar;
    chatThread.unread_count = 0;

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatScreen(chatThread)));
  }

  Future<void> get_owner(String user_id, bool open_profile) async {
    if (productOwner.id < 1) {
      productOwner.name = "Loading owner...";

      setState(() {});
    }
    if (open_profile) {
      if (productOwner.id > 0) {
        Utils.navigate_to(AppConfig.AccountDetails, context,
            data: productOwner);
        return;
      }
    }
    List<UserModel> users =
        await UserModel.get_online_users({'user_id': user_id});
    if (users != null) {
      if (users[0] != null) {
        productOwner = users[0];
        setState(() {});
        if (open_profile) {
          if (productOwner.id > 0) {
            Utils.navigate_to(AppConfig.AccountDetails, context,
                data: productOwner);
            return;
          }
        }
      }
    }
  }
}

List<Widget> _buildHouseList() {
  List<Widget> list = [];

  thumbnails.forEach((element) {
    list.add(_SinglePosition(element.toString()));
  });

  return list;
}

List<String> images = [];

class _SinglePosition extends StatelessWidget {
  final String image_url;

  _SinglePosition(this.image_url);

  @override
  Widget build(BuildContext context) {
    MaterialThemeData mTheme = MaterialTheme.estateTheme;
    return FxContainer(
      color: Colors.white,
      paddingAll: 0,
      margin: EdgeInsets.only(bottom: 8, left: 0, right: 8),
      child: InkWell(
        onTap: () => {
          Utils.navigate_to(AppConfig.ViewFullImagesScreen, context,
              data: images)
        },
        child: CachedNetworkImage(
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl: this.image_url,
          placeholder: (context, url) => ShimmerLoadingWidget(
            height: double.infinity,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
