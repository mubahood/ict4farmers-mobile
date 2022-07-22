import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/PestModel.dart';

import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/my_widgets.dart';
import '../../widget/shimmer_loading_widget.dart';

class PestScreen extends StatefulWidget {
  PestScreen(this.params);

  dynamic params;

  @override
  PestScreenState createState() => PestScreenState();
}

class PestScreenState extends State<PestScreen> {
  late ThemeData theme;

  PestScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  int id = 0;
  List<PestModel> items = [];
  PestModel item = new PestModel();

  Future<void> my_init() async {
    setState(() {});

    if (widget.params != null) {
      id = Utils.int_parse(widget.params['id']);
    }

    items = await PestModel.get_items();
    items.forEach((element) {
      if (element.id.toString() == id.toString()) {
        item = element;
      }
    });

    if (item.id == 0) {
      Utils.showSnackBar("Not found.", context, Colors.white);
      Navigator.pop(context);
      return;
    }

    setState(() {});
  }

  Future<Null> _onRefresh() async {
    my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: extended_floating_button(context,title: 'Report a pest case',screen: AppConfig.PestCaseCreateScreen ),
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
                    'Pest overview',
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
                    return _widget_overview();
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: (Utils.screen_height(context) / 3.5),
                            fit: BoxFit.cover,
                            imageUrl: item.get_image(),
                            placeholder: (context, url) => ShimmerLoadingWidget(
                              height: (Utils.screen_width(context) / 3.8),
                            ),
                            errorWidget: (context, url, error) => Image(
                                image: AssetImage(
                                  './assets/project/no_image.jpg',
                                ),
                                fit: BoxFit.cover,
                                height: (Utils.screen_width(context) / 3.8),
                                width: (Utils.screen_width(context) / 2.8)),
                          )),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        ItemTile('Video', 'Coming soon...'),
                        ItemTile('About this pest', item.description),
                        ItemTile('Causes of this pest', item.cause),
                        ItemTile('Prevention & Cure', item.cure),
                        ItemTile('Community solutions', 'Coming soon...'),
                      ],
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
            ],
          )),
    );
  }

  Widget _widget_garden_activity_ui(PestModel m) {
    return FxContainer(
        color: Colors.white,
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: (Utils.screen_width(context) / 1.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText(
                          m.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontWeight: 800,
                        ),
                        FxText(
                          'NEW CASES: 10',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FxText(
                          'SOLUTIONS: 15',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FxText(
                          'TOO MUCH IN: Lira',
                          maxLines: 1,
                          fontSize: ('TOO MUCH IN: Lira'.length > 21) ? 12 : 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: (Utils.screen_width(context) / 3.8),
                      width: (Utils.screen_width(context) / 2.8),
                      fit: BoxFit.cover,
                      imageUrl: m.get_image(),
                      placeholder: (context, url) => ShimmerLoadingWidget(
                        height: (Utils.screen_width(context) / 3.8),
                      ),
                      errorWidget: (context, url, error) => Image(
                          image: AssetImage(
                            './assets/project/no_image.jpg',
                          ),
                          fit: BoxFit.cover,
                          height: (Utils.screen_width(context) / 3.8),
                          width: (Utils.screen_width(context) / 2.8)),
                    )),
              ],
            ),
          ],
        ));
  }

  Widget _widget_overview() {
    return FxContainer(
      borderRadiusAll: 0,
      color: CustomTheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText(
            '${item.name}',
            color: Colors.white,
            fontSize: 35,
            height: 1,
            fontWeight: 700,
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'NEW CASES: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '13 ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'SOLUTIONS: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '25 ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'TOO MUCH IN: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: 'KASESE',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  String title;
  String details;

  ItemTile(this.title, this.details);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          key: PageStorageKey<int>(1),
          title: FxText(
            '${this.title}',
            color: Colors.black,
            fontSize: 25,
            fontWeight: 700,
            maxLines: 1,
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 0),
              child: FxText(
                '${this.details}',
              ),
            )
          ],
        ),
        Divider(height: 0)
      ],
    );
  }
}
