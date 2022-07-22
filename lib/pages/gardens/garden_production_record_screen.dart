import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';

import '../../models/GardenActivityModel.dart';
import '../../models/GardenProductionModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_loading_widget.dart';

class GardenProductionRecordScreen extends StatefulWidget {
  GardenProductionRecordScreen(this.params);

  dynamic params;

  @override
  GardenProductionRecordScreenState createState() =>
      GardenProductionRecordScreenState();
}

class GardenProductionRecordScreenState
    extends State<GardenProductionRecordScreen> {
  late ThemeData theme;

  GardenProductionRecordScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  String id = "";
  GardenProductionModel gardenProductionModel = new GardenProductionModel();
  List<String> thumbnails = [];
  List<String> photos = [];

  Future<void> my_init() async {
    is_logged_in = true;
    setState(() {});

    if (widget.params != null) {
      if (widget.params['id'] != null) {
        id = widget.params['id'].toString();
      }
    }

    List<GardenProductionModel> items = await GardenProductionModel.get_items();
    items.forEach((element) {
      if (element.id.toString() == id.toString()) {
        gardenProductionModel = element;
      }
    });
    thumbnails = gardenProductionModel.get_images(true);
    photos = gardenProductionModel.get_images(false);

    loggedUser = await Utils.get_logged_in();
    if (loggedUser.id < 1) {
      Navigator.pop(context);
      return;
    }

    is_logged_in = false;
    setState(() {});
  }

  bool is_logged_in = false;
  LoggedInUserModel loggedUser = new LoggedInUserModel();

  Future<Null> _onRefresh() async {
    my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          color: CustomTheme.primary,
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Colors.white, // <= You can change your color here.
                  ),
                  titleSpacing: 0,
                  elevation: 0,
                  title: FxText(
                    'Production record',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: 500,
                  ),
                  floating: false,
                  pinned: true,
                  backgroundColor: CustomTheme.primary),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _widget_garden_activity_ui(gardenProductionModel);
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return FxContainer(
                      borderRadiusAll: 0,
                      color: Colors.white,
                      child: FxText.h2(
                        "Photos",
                        color: Colors.black,
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 2,
                    mainAxisExtent: (170)),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      onTap: () => {
                        Utils.navigate_to(
                            AppConfig.ViewFullImagesScreen, context,
                            data: photos)
                      },
                      child: FxContainer(
                          bordered: true,
                          border: Border.all(color: CustomTheme.primary),
                          margin: index.isEven
                              ? EdgeInsets.only(left: 20, right: 5, bottom: 10)
                              : EdgeInsets.only(left: 5, right: 10, bottom: 10),
                          paddingAll: 0,
                          color: Colors.white,
                          borderRadiusAll: 0,
                          child: CachedNetworkImage(
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            imageUrl: thumbnails[index].toString(),
                            placeholder: (context, url) => ShimmerLoadingWidget(
                              height: 100,
                              width: 100,
                            ),
                            errorWidget: (context, url, error) => Image(
                              image:
                                  AssetImage('./assets/project/no_image.jpg'),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )),
                    );
                  },
                  childCount: thumbnails.length,
                ),
              ),
            ],
          )),
    );
  }



  Widget _widget_garden_activity_ui(GardenProductionModel m) {
    return InkWell(
      onTap: () => {
        Utils.navigate_to(AppConfig.GardenProductionRecordScreen, context,
            data: {
              'id': m.id.toString(),
            })
      },
      child: FxCard(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FxText(
                    "${Utils.to_date_1(m.created_at.toString())}",
                    maxLines: 1,
                    fontSize: 14,
                    fontWeight: 700,
                    color: Colors.black,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              FxText(
                m.description,
                height: 1.2,
                maxLines: 50,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 2,
              ),
              Divider(),
              SizedBox(
                height: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 18,
                        ),
                        FxText(
                          "${m.garden_name.toString()}",
                          maxLines: 1,
                          fontSize: 14,
                          fontWeight: 700,
                          color: Colors.grey.shade700,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 18,
                        ),
                        FxText(
                          "${m.garden_name.toString()}",
                          maxLines: 1,
                          fontSize: 14,
                          fontWeight: 700,
                          color: Colors.grey.shade700,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget my_rich_text(String t, String s, Color c) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: '${t}: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: c)),
            TextSpan(
                text: '${s}',
                style: TextStyle(fontWeight: FontWeight.normal, color: c)),
          ],
        ),
      ),
    );
  }

  activity_status_widget(GardenActivityModel m) {
    int status = m.get_status();

    return (status == 5)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FxText(
                'Done',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: Colors.green.shade600,
                fontWeight: 800,
              ),
              Icon(
                Icons.close,
                color: Colors.green.shade600,
              ),
            ],
          )
        : (status == 4)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FxText(
                    'Missed',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red.shade600,
                    fontWeight: 800,
                  ),
                  Icon(
                    Icons.close,
                    color: Colors.red.shade600,
                  ),
                ],
              )
            : (status == 2)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FxText(
                        'Missing',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.red.shade600,
                        fontWeight: 800,
                      ),
                      Icon(
                        Icons.warning,
                        color: Colors.red.shade600,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FxText(
                        'Pending',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey.shade600,
                        fontWeight: 800,
                      ),
                      Icon(
                        Icons.alarm_outlined,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  );
  }
}

class GridItemWidget {
  String title = "Title";

  String all = "Title";
  String all_text = "Title";

  String done = "Title";
  String done_text = "Title";

  String complete = "Title";
  String complete_text = "Title";

  String screen = '';
}
