import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/utils/Utils.dart';

import '../../../models/PostModel.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/AppConfig.dart';
import '../../../widget/loading_effect.dart';
import '../../../widget/shimmer_list_loading_widget.dart';
import '../../../widget/shimmer_loading_widget.dart';
import 'home_controller.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  ForumScreenState createState() => ForumScreenState();
}

class ForumScreenState extends State<ForumScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController =
        FxControllerStore.putOrFind<HomeController>(HomeController());
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;

    _do_refresh();
  }

  Widget _endDrawer() {
    return SafeArea(
      child: Container(
        margin: FxSpacing.fromLTRB(16, 16, 16, 80),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: customTheme.card,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            color: customTheme.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: FxSpacing.xy(16, 12),
                  color: CustomTheme.primary,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FxText(
                            "Filter",
                            fontWeight: 700,
                            color: customTheme.homemadeOnPrimary,
                          ),
                        ),
                      ),
                      FxContainer.rounded(
                          onTap: () {
                            homeController.closeEndDrawer();
                          },
                          paddingAll: 6,
                          color: customTheme.homemadeOnPrimary.withAlpha(80),
                          child: Icon(
                            FeatherIcons.x,
                            size: 12,
                            color: customTheme.homemadeOnPrimary,
                          ))
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(
                  padding: FxSpacing.all(16),
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.b2(
                            "Select Districts",
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600,
                          ),
                          FxText.b3(
                            homeController.selectedChoices.length.toString() +
                                " selected",
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600,
                            xMuted: true,
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(16),
                    Container(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _buildType(),
                      ),
                    ),
                    FxSpacing.height(24),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.b2(
                            "Specify Crop",
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600,
                          ),
                          FxText.b3(
                            'Cocoa'.toString(),
                            color: CustomTheme.primary,
                            fontWeight: 600,
                            letterSpacing: 0.35,
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(16),
                    Container(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _buildType(),
                      ),
                    )
                  ],
                )),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: FxContainer(
                        onTap: () {
                          homeController.closeEndDrawer();
                        },
                        padding: FxSpacing.y(12),
                        child: Center(
                          child: FxText(
                            "Clear",
                            color: CustomTheme.primary,
                            fontWeight: 600,
                          ),
                        ),
                      )),
                      Expanded(
                          child: FxContainer.none(
                        onTap: () {
                          homeController.closeEndDrawer();
                        },
                        padding: FxSpacing.y(12),
                        child: Center(
                          child: FxText(
                            "Apply",
                            color: customTheme.homemadeOnPrimary,
                            fontWeight: 600,
                          ),
                        ),
                        color: customTheme.homemadePrimary,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildType() {
    List<String> categoryList = [
      "Kasese",
      "Mbarara",
      "Jinja",
      "Kasese",
      "Mbale",
      "Soroti",
      "Arua",
      "Kumi",
      "Wakiso",
    ];

    List<Widget> choices = [];
    categoryList.forEach((item) {
      bool selected = homeController.selectedChoices.contains(item);
      if (selected) {
        choices.add(FxContainer.none(
            color: customTheme.homemadePrimary.withAlpha(28),
            bordered: true,
            borderRadiusAll: 12,
            paddingAll: 8,
            border: Border.all(color: customTheme.homemadePrimary),
            onTap: () {
              homeController.removeChoice(item);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  size: 14,
                  color: customTheme.homemadePrimary,
                ),
                FxSpacing.width(6),
                FxText.b3(
                  item,
                  fontSize: 11,
                  color: customTheme.homemadePrimary,
                )
              ],
            )));
      } else {
        choices.add(FxContainer.none(
          color: customTheme.border,
          borderRadiusAll: 12,
          padding: FxSpacing.xy(12, 8),
          onTap: () {
            homeController.addChoice(item);
          },
          child: FxText.l3(
            item,
            color: theme.colorScheme.onBackground,
            fontSize: 11,
          ),
        ));
      }
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HomeController>(
        controller: homeController,
        builder: (homeController) {
          return _buildBody();
        });
  }

  Widget _buildBody() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Utils.navigate_to(AppConfig.CreatePostScreen, context);
        },
        elevation: 4,
        backgroundColor: CustomTheme.primary,
        label: FxText(
          "CREATE POST",
          letterSpacing: 0.1,
          color: theme.colorScheme.onPrimary,
        ),
        icon: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimary,
        ),
      ),

      appBar: AppBar(
        title: header(),

        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        elevation: 1,
      ),
      key: homeController.scaffoldKey,
      // endDrawer: _endDrawer(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: is_loading
            ? ShimmerListLoadingWidget()
            : RefreshIndicator(
                onRefresh: _do_refresh,
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return SingleItem(items[index]);
                        },
                        childCount: items.length, // 1000 list items
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  List<PostModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});

    items = await PostModel.get_items();
    setState(() {
      is_loading = false;
    });

    return null;
  }

  bool is_loading = false;

  Widget SingleItem(PostModel item) {
    String thumbnail = AppConfig.BASE_URL + "/" + "no_image.jpg";


    if (item.thumnnail != "null" && (item.thumnnail.length > 5)) {
      if (item.thumnnail != null &&
          (!item.thumnnail.toString().trim().isEmpty)) {
        Map<String, dynamic> thumbnail_map = jsonDecode(item.thumnnail);
        if (thumbnail_map != null) {
          if (thumbnail_map['thumbnail'] != null) {
            if (thumbnail_map['thumbnail'].toString().length > 3) {
              thumbnail = AppConfig.BASE_URL +
                  "/storage/" +
                  thumbnail_map['thumbnail'].toString();
            }
          }
        }
      }
    }

    if(item.get_post_type() == "audio"){
      thumbnail = AppConfig.BASE_URL + "/" + "mic.png";
    }


    double height = (MediaQuery.of(context).size.width / 3.5);
    double width = (MediaQuery.of(context).size.width / 3);

    return InkWell(
      onTap: () =>
          {Utils.navigate_to(AppConfig.PostDetailsScreen, context, data: item)},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
            child: Row(
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: CachedNetworkImage(
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                    imageUrl: thumbnail,
                    placeholder: (context, url) => ShimmerLoadingWidget(
                        height: height,
                        width: width,
                        is_circle: false,
                        padding: 0),
                    errorWidget: (context, url, error) => Image(
                        image: AssetImage(
                          './assets/project/no_image.jpg',
                        ),
                        fit: BoxFit.cover,
                        height: width,
                        width: width),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: FxContainer(
                    height: height,
                    paddingAll: 0,
                    color: Colors.white,
                    width: double.infinity,
                    borderRadiusAll: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText(
                          item.text,
                          maxLines: 2,
                          fontSize: 18,
                          textAlign: TextAlign.start,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FxText(
                          "${item.views} Views",
                          fontSize: 14,
                          maxLines: 1,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FxText(
                          "${item.created_at}",
                          fontSize: 14,
                          maxLines: 1,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FxText(
                          "By ${item.posted_by}",
                          maxLines: 1,
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
/*        Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Divider(
              height: 0,
              color: Colors.grey.shade400,
            ),
          ),*/
        ],
      ),
    );

    return ListTile(
      onTap: () => {
        Navigator.pop(context, {"id": "${item.id}", "name": item.text})
      },
      dense: true,
      leading: CachedNetworkImage(
        height: width,
        width: width,
        fit: BoxFit.cover,
        imageUrl: thumbnail,
        placeholder: (context, url) => ShimmerLoadingWidget(
          height: width,
        ),
        errorWidget: (context, url, error) => Image(
            image: AssetImage(
              './assets/project/no_image.jpg',
            ),
            fit: BoxFit.cover,
            height: width,
            width: width),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: FxText.b1(item.text, fontSize: 20, fontWeight: 600),
      ),
    );
  }

  Widget header() {
    return Row(
      children: [

        Expanded(
            child: Center(
                child: FxText.h5(
          "Farmer's Forum",
          color: Colors.black,
        ))),
        FxSpacing.width(16),
        FxContainer.bordered(
            onTap: () {
              homeController.openEndDrawer();
            },
            color: CustomTheme.primary.withAlpha(28),
            border: Border.all(color: CustomTheme.primary.withAlpha(120)),
            borderRadiusAll: 8,
            paddingAll: 13,
            child: Icon(
              FeatherIcons.sliders,
              color: CustomTheme.primary,
              size: 18,
            )),
      ],
    );
  }
}
/*

Before you know it you take me up to the sky,
You give me sweet love boy you are so tender,
You make me wanna scream and shout your name,
I will never hurt you, never let you down.

 */
