import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';

import '../../models/BannerModel.dart';
import '../../models/PostModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../theme/material_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/product_item_ui.dart';
import '../../widget/shimmer_loading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostDetailsScreen extends StatefulWidget {
  PostModel item;

  PostDetailsScreen(this.item);

  @override
  State<PostDetailsScreen> createState() => PostDetailsScreenState(this.item);
}

List<BannerModel> banners = [];
List<String> images = [];
List<String> thumbnails = [];
bool initilized = false;
bool store_initilized = false;

class PostDetailsScreenState extends State<PostDetailsScreen> {
  PostModel item;

  PostDetailsScreenState(this.item);

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

  Future<Null> _onRefresh() async {
    thumbnails.clear();
    images.clear();
    List<dynamic> raw_list = jsonDecode(this.item.images);
    if (raw_list != null) {
      raw_list.forEach((element) {
        if (element != null) {
          if (element['thumbnail'] != null) {
            thumbnails.add(
                "${AppConfig.BASE_URL}/storage/${element['thumbnail'].toString()}");
            images.add(
                "${AppConfig.BASE_URL}/storage/${element['src'].toString()}");
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
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
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
                          width: MediaQuery.of(context).size.width - 120,
                          child: Text(
                            item.get_title(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: CustomTheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: FxText.h1(
                            item.created_at,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          width: MediaQuery.of(context).size.width - 120,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        padding: FxSpacing.x(0),
                        child: Icon(
                          Icons.share,
                          size: 25,
                        )),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    item.get_post_type() == 'audio'
                                        ? Container(
                                            margin: EdgeInsets.all(20),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  ClipOval(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          side: BorderSide(
                                                              color: CustomTheme
                                                                  .primary)),
                                                      child: InkWell(
                                                        splashColor:
                                                            CustomTheme.primary,
                                                        child: SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: Icon(
                                                              audio_is_playing
                                                                  ? Icons
                                                                      .stop_circle
                                                                  : Icons
                                                                      .play_circle,
                                                              color: CustomTheme
                                                                  .primary,
                                                              size: 50,
                                                            )),
                                                        onTap: () {
                                                          audio_is_playing
                                                              ? stopFunc()
                                                              : playFunc();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: FxText.h2(
                                                      audio_is_playing
                                                          ? "Stop"
                                                          : "Play",
                                                      fontSize: 30,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
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
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            width: Utils.screen_width(context) -
                                                30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.created_at,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "${item.views} Views",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "${item.comments} Comments",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (item.text.length < 5)
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "${item.text} ",
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontSize: 16),
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
                                              "Comments",
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
                                      color: CustomTheme.primary,
                                      borderRadiusAll: 4,
                                      onTap: () {
                                        Utils.navigate_to(
                                            AppConfig.ChatScreen, context);
                                      },
                                      padding: FxSpacing.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.chat,
                                            color: Colors.grey.shade100,
                                            size: 22,
                                          ),
                                          FxSpacing.width(8),
                                          FxText.sh2("Comment",
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

  //final recordingPlayer = AssetsAudioPlayer();
  bool audio_is_playing = false;

  Future<void> stopFunc() async {
    Utils.showSnackBar("Coming soon", context, Colors.black);

   /* if (recordingPlayer == null) {
      return;
    }
    await recordingPlayer.stop();
    setState(() {
      audio_is_playing = false;
    });*/
  }

  Future<void> playFunc() async {
    if (item.audio == null || (item.audio.length < 4)) {
      return;
    }

   /* await recordingPlayer.open(
      Audio.network(AppConfig.BASE_URL + "/" + item.audio),
      autoStart: true,
      showNotification: true,
    );*/

    setState(() {
      audio_is_playing = true;
    });
  }
}

List<Widget> _buildHouseList() {
  List<Widget> list = [];

  images.forEach((element) {
    list.add(_SinglePosition(element.toString()));
  });

  return list;
}

class _SinglePosition extends StatelessWidget {
  final String image_url;
  List<String> _images = [];

  _SinglePosition(this.image_url);

  @override
  Widget build(BuildContext context) {
    MaterialThemeData mTheme = MaterialTheme.estateTheme;
    return FxContainer(
      color: Colors.white,
      paddingAll: 0,
      margin: EdgeInsets.only(bottom: 8, left: 0, right: 8),
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
    );
  }
}
