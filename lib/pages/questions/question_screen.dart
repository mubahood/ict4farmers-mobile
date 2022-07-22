import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/QuestionModel.dart';

import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_loading_widget.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen(this.params);

  dynamic params;

  @override
  QuestionScreenState createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen> {
  late ThemeData theme;

  QuestionScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  List<String> thumbnails = [];
  List<String> photos = [];

  int id = 0;
  List<QuestionModel> items = [];
  QuestionModel item = new QuestionModel();

  Future<void> my_init() async {
    setState(() {});

    if (widget.params != null) {
      id = Utils.int_parse(widget.params['id']);
    }

    items = await QuestionModel.get_items();
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

    thumbnails = item.get_images(true);
    photos = item.get_images(false);

    setState(() {});
  }

  Future<Null> _onRefresh() async {
    my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.navigate_to(AppConfig.PestCaseCreateScreen, context);
        },
        backgroundColor: CustomTheme.primary,
        tooltip: 'Report a case',
        child: Icon(Icons.add),
        elevation: 5,
      ),
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
                    'Question',
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
                    return _widget_overview(item);
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
                    mainAxisExtent: (160)),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      onTap: () => {
                        Utils.navigate_to(
                            AppConfig.ViewFullImagesScreen, context,
                            data: photos)
                      },
                      child: FxContainer(
                          marginAll: 20,
                          margin: index.isEven
                              ? EdgeInsets.only(
                                  left: 20, right: 5, bottom: 10, top: 20)
                              : EdgeInsets.only(
                                  left: 5, right: 10, bottom: 10, top: 20),
                          paddingAll: 0,
                          color: Colors.white,
                          borderRadiusAll: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: thumbnails[index].toString(),
                              placeholder: (context, url) =>
                                  ShimmerLoadingWidget(
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
                            ),
                          )),
                    );
                  },
                  childCount: thumbnails.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        ItemTile('Expert\'s Answer', item.answer),
                        ItemTile('Community Replies', 'Coming soon...'),
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

  Widget _widget_overview(QuestionModel m) {
    return FxCard(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.b1(
                    'Muhindo Mubaraka',
                    color: Colors.black,
                    maxLines: 1,
                    fontWeight: 700,
                  ),
                  FxText.b1(
                    'Open',
                    color: Colors.green.shade800,
                    fontWeight: 700,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            FxText(
              AppConfig.Lorem1,
              overflow: TextOverflow.ellipsis,
              maxLines: 100,
              height: 1.2,
              color: Colors.grey.shade600,
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Category\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: 'Computers',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Replies\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: '13',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Posted\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: '13 Minutes ago',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
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
