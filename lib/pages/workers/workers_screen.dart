import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/WorkerModel.dart';

import '../../models/WorkerModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/my_widgets.dart';

class WorkersScreen extends StatefulWidget {
  @override
  WorkersScreenState createState() => WorkersScreenState();
}

class WorkersScreenState extends State<WorkersScreen> {
  late ThemeData theme;

  WorkersScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  List<WorkerModel> items = [];
  List<int> loaded = [];

  Future<void> my_init() async {
    WorkerModel.get_items();

    setState(() {});

    items.clear();
    loaded.clear();
    List<WorkerModel> temp_items = await WorkerModel.get_items();

    temp_items.forEach((element) {
      if (!loaded.contains(element.id)) {
        loaded.add(element.id);
        items.add(element);
      }
    });

    setState(() {});
  }

  Future<Null> _onRefresh() async {
    my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: extended_floating_button(context,
          title: 'Add new worker', screen: AppConfig.WorkerCreateScreen),

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
                    'My Workers',
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
                    return _widget_garden_activity_ui(items[index]);
                  },
                  childCount: items.length, // 1000 list items
                ),
              ),
            ],
          )),
    );
  }

  Widget _widget_garden_activity_ui(WorkerModel m) {
    return InkWell(
      onTap: () => {
        Utils.showSnackBar(
            "Go to web dashboard to manage your workers.", context, Colors.white)
      },
      child: FxCard(
          color: Colors.white,
          padding: EdgeInsets.only(top: 15, left: 10, bottom: 10, right: 15),
          margin: EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image(
                      image: AssetImage('./assets/project/user.png'),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),*/
                  Container(
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
                        '${m.phone_number}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
                ],
              ),
            ],
          )),
    );
  }
}
