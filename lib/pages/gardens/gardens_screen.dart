import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ict4farmers/models/FarmModel.dart';
import 'package:ict4farmers/models/GardenModel.dart';
import 'package:ict4farmers/widget/loading_widget.dart';

import '../../models/LoggedInUserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/my_widgets.dart';

class GardensScreen extends StatefulWidget {
  GardensScreen();

  @override
  GardensScreenState createState() => GardensScreenState();
}

class GardensScreenState extends State<GardensScreen> {
  late ThemeData theme;
  String title = "My enterprises";

  GardensScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  List<FarmModel> farms = [];

  Future<void> my_init() async {
    Utils.ini_theme();

    is_logged_in = true;
    setState(() {});

    loggedUser = await Utils.get_logged_in();
    if (loggedUser.id < 1) {
      Navigator.pop(context);
      return;
    }

    farms = await FarmModel.get_items();
    gardens = await GardenModel.get_items();
    if (farms.isEmpty) {
      farms = await FarmModel.get_items();
    }
    if (farms.isEmpty) {
      Utils.showSnackBar(
          "You need to create at least one farm.", context, Colors.white,
          background_color: Colors.red);
      Utils.navigate_to(AppConfig.FarmCreateScreen, context);
    }

    is_logged_in = false;
    setState(() {});
  }

  bool is_logged_in = false;
  LoggedInUserModel loggedUser = new LoggedInUserModel();
  List<GardenModel> gardens = [];

  Future<Null> _onRefresh() async {
    my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: extended_floating_button(context,
          title: 'Create new enterprise', screen: AppConfig.GardenCreateScreen),

      body: RefreshIndicator(
          color: CustomTheme.primary,
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          child: (is_logged_in)
              ? LoadingWidget()
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                        iconTheme: IconThemeData(
                          color: Colors
                              .white, // <= You can change your color here.
                        ),
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: CustomTheme.primary,
                          statusBarIconBrightness: Brightness.light,
                          // For Android (dark icons)
                          statusBarBrightness:
                              Brightness.light, // For iOS (dark icons)
                        ),
                        titleSpacing: 0,
                        elevation: 0,
                        title: Text(title),
                        floating: false,
                        pinned: true,
                        backgroundColor: CustomTheme.primary),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 2,
                    mainAxisExtent: (160)),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    my_colors.shuffle();
                    return widget_grid_item(context,
                        title: gardens[index].name,
                        id: gardens[index].id.toString(),
                        screen: AppConfig.GardenScreen,
                        caption: gardens[index].created_at,
                        bg_color: gardens[index].color);
                  },
                  childCount: gardens.length,
                ),
              ),
            ],
          )),
    );
  }
}
