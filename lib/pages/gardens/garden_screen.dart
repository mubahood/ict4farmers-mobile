import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/FinancialRecordModel.dart';
import 'package:ict4farmers/models/GardenModel.dart';
import 'package:ict4farmers/models/GardenProductionModel.dart';
import 'package:ict4farmers/utils/AppConfig.dart';

import '../../models/GardenActivityModel.dart';
import '../../models/UserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';
import '../../models/LoggedInUserModel.dart';

class GardenScreen extends StatefulWidget {
  GardenScreen(this.params);

  dynamic params;

  @override
  GardenScreenState createState() => GardenScreenState();
}

class GardenScreenState extends State<GardenScreen> {
  late ThemeData theme;


  GardenScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  GardenModel item = new GardenModel();
  String id = "";
  int count_activities_all = 0;
  int finainancial_expence = 0;
  int finainancial_income = 0;
  int profit_loss = 0;
  int count_activities_remaining = 0;
  int count_activities_submitted = 0;
  List<int> done_finacnces = [];
  List<int> done_productions = [];
  List<GardenProductionModel> garden_records = [];

  Future<void> my_init() async {
    is_logged_in = true;
    setState(() {});

    if (widget.params != null) {
      if (widget.params['id'] != null) {
        id = widget.params['id'].toString();
      }
    }
    List<GardenModel> gardens = [];
    gardens = await GardenModel.get_items();
    gardens.forEach((element) {
      if (element.id.toString() == id) {
        item = element;
      }
    });
    if (item.id < 1) {
      Utils.showSnackBar("Garden not found.", context, Colors.white);
      Navigator.pop(context);
      return;
    }

    loggedUser = await Utils.get_logged_in();
    if (loggedUser.id < 1) {
      Utils.showSnackBar("Not logged in.", context, Colors.white);
      Navigator.pop(context);
      return;
    }

    List<GardenActivityModel> all_activities =
        await GardenActivityModel.get_items();

    garden_records =
        await GardenProductionModel.get_items();

    List<FinancialRecordModel> all_fines =
        await FinancialRecordModel.get_items();

    finainancial_expence = 0;
    finainancial_income = 0;
    profit_loss = 0;
    done_finacnces.clear();
    done_finacnces = [];
    all_fines.forEach((xx) {
      if (!done_finacnces.contains(xx.id)) {
        profit_loss += xx.amount;
        done_finacnces.add(xx.id);
        if (xx.garden_id.toString() == item.id.toString()) {
          if (xx.amount.isNegative) {
            finainancial_expence += ((-1) * (xx.amount));
          } else {
            finainancial_income += ((xx.amount));
          }
        }
      }
    });



    count_activities_all = 0;
    count_activities_remaining = 0;
    count_activities_submitted = 0;

    done_productions.clear();
    done_productions = [];

    all_activities.forEach((e) {
      if (!done_productions.contains(e.id)) {
        done_productions.add(e.id);
        if (e.garden_id.toString() == item.id.toString()) {
          count_activities_all++;
          if (e.is_done) {
            count_activities_submitted++;
          } else {
            count_activities_remaining++;
          }
        }
      }
    });

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
                    'Enterprise overview',
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
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 2,
                    mainAxisExtent: (190)),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _widget_grid_item(index, item);
                  },
                  childCount: [2, 3, 4, 6].length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: CustomTheme.primary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
            ],
          )),
    );
  }

  Widget _widget_garden_activity_ui(GardenActivityModel m) {
    return FxContainer(
        color: Colors.white,
        padding: EdgeInsets.only(top: 0, left: 15, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: (Utils.screen_width(context) / 1.5),
                    child: Column(
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
                          m.due_date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                Container(child: activity_status_widget(m)),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
          ],
        ));
  }

  Widget _widget_grid_item(int index, GardenModel g) {
    GridItemWidget item = new GridItemWidget();
    if (index == 0) {
      item.title = "Garden activities";
      item.all = "ALL";
      item.all_text = "${count_activities_all}";
      item.done = "SUBMITTED";
      item.done_text = '${count_activities_submitted}';
      item.complete = "REMAINING";
      item.complete_text = count_activities_remaining.toString();
      item.screen = AppConfig.GardenActivitiesScreen;
    } else if (index == 1) {
      item.title = "Financial records";
      item.all = "EXPENSE";
      item.all_text = "UGX ${Utils.number_short(finainancial_expence)}";
      item.done = "INCOME";
      item.done_text = "UGX ${Utils.number_short(finainancial_income)}";
      item.screen = AppConfig.FinancialRecordsScreen;
      item.complete = "PROFIT/LOSS";
      item.complete_text =
          " ${Utils.number_short(profit_loss)}";
    } else if (index == 2) {
      item.title = "Enterprise's records";
      item.all = "All records";
      item.all_text = "${garden_records.length.toString()}";
      item.done = "INCOME";
      item.done_text = "10";
      item.complete = "PROFIT/LOSS";
      item.complete_text = " 11";
      item.screen = AppConfig.GardenProductionRecordsScreen;
    } else if (index == 3) {
      item.title = "Enterprise's gallery";
      item.all = "Albums";
      item.all_text = "${garden_records.length.toString()}";
      item.done = "INCOME";
      item.done_text = "10";
      item.complete = "PROFIT/LOSS";
      item.complete_text = " 11";
      item.screen = AppConfig.GardenProductionRecordsScreen;
    }

    return InkWell(
      onTap: () =>
      {
        Utils.navigate_to(item.screen, context, data: {'id': id.toString()})
      },
      child: Container(
        color: CustomTheme.primary,
        child: FxCard(
          paddingAll: 10,
          marginAll: 10,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FxText(
                item.title,
                color: CustomTheme.primary,
                fontWeight: 800,
                height: 1.0,
                fontSize: 20,
              ),
              Spacer(),
              my_rich_text(
                  item.all, item.all_text.toString(), Colors.grey.shade800),
              (index > 1)
                  ? SizedBox()
                  : my_rich_text(item.done, item.done_text.toString(),
                      Colors.grey.shade800),
              (index > 1)
                  ? SizedBox()
                  : my_rich_text(item.complete, item.complete_text.toString(),
                      Colors.grey.shade800),
              Spacer(),
              FxContainer(
                child: FxText(
                  "See All",
                  fontSize: 18,
                  fontWeight: 700,
                  color: CustomTheme.primary,
                ),
                paddingAll: 0,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                color: CustomTheme.primary.withAlpha(20),
                alignment: Alignment.center,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widget_overview() {
    return FxContainer(
        borderRadiusAll: 0,
        color: CustomTheme.primary,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: FxText(
                  item.name,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: 400,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: (Utils.screen_width(context) / 1.6),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            height: 1.2,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ENTERPRISE CATEGORY: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${item.crop_category_name}, ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                                text: '\nSTARTED: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${Utils.to_date_1(item.plant_date)}, ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                                text: '\nLAND SIZE: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${item.size} acres, ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                                text: '\nLOCATION: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${item.location_name}.',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText(
                      '${item.get_percebtage_done()}%',
                      fontWeight: 800,
                      fontSize: 40,
                      height: .8,
                      color: Colors.white,
                    ),
                    FxText(
                      'Completed',
                      height: .8,
                      fontWeight: 400,
                      fontSize: 16.5,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
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
