import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';

import '../../models/FinancialRecordModel.dart';
import '../../models/GardenModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';

class FinancialRecordsScreen extends StatefulWidget {
  dynamic params;

  FinancialRecordsScreen(this.params);

  @override
  FinancialRecordsScreenState createState() => FinancialRecordsScreenState();
}

class FinancialRecordsScreenState extends State<FinancialRecordsScreen> {
  late ThemeData theme;
  int id = 0;
  int profit_loss = 0;
  GardenModel gardenModel = new GardenModel();

  FinancialRecordsScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  List<FinancialRecordModel> activities = [];

  Future<void> my_init() async {
    setState(() {});

    loggedUser = await Utils.get_logged_in();
    if (loggedUser.id < 1) {
      Utils.showSnackBar("Not logged in.", context, Colors.white);
      Navigator.pop(context);
      return;
    }

    if (widget.params != null) {
      if (widget.params['id'] != null) {
        id = Utils.int_parse(widget.params['id'].toString());
      }
    }

    List<GardenModel> temp_gardens = await GardenModel.get_items();
    temp_gardens.forEach((e) {
      gardenModel = e;
    });

    List<FinancialRecordModel> temp_finances =
        await FinancialRecordModel.get_items();

    activities.clear();
    profit_loss = 0;
    temp_finances.forEach((element) {
      if (element.garden_id.toString() == id.toString()) {
        activities.add(element);
        profit_loss += element.amount;
      }
    });

    setState(() {});
  }

  LoggedInUserModel loggedUser = new LoggedInUserModel();

  Future<Null> _onRefresh() async {
    my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.navigate_to(AppConfig.FinancialRecordsCreateScreen, context,
              data: {'garden_id': id});
        },
        backgroundColor: CustomTheme.primary,
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
                    'Financial records',
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
                    return Container(
                      height: 20,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: CustomTheme.primary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _widget_garden_activity_ui(activities[index]);
                  },
                  childCount: activities.length, // 1000 list items
                ),
              ),
            ],
          )),
    );
  }

  void _show_details_bottom_sheet(context, FinancialRecordModel m) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext buildContext) {
          return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: _details_bottom_sheet_content(context, m),
                  ),
                );
              });
        });
  }

  Widget _details_bottom_sheet_content(
      BuildContext context, FinancialRecordModel m) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _widget_single_item('Description', m.description),
          Container(
            padding: EdgeInsets.only(left: 16, right: 18, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.b1(
                  "Amount:",
                  fontWeight: 600,
                  fontSize: 20,
                  color: Colors.black,
                ),
                activity_status_widget(m),
              ],
            ),
          ),
          _widget_single_item('Enterprise', gardenModel.name),
          _widget_single_item('Created by', m.created_by_name.toString()),
          _widget_single_item(
              'DATE', '${Utils.to_date_1(m.created_at.toString())}'),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(left: 30, top: 10, right: 30),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Expanded(
                      child: FxButton(
                    elevation: 0,
                    padding: FxSpacing.y(12),
                    borderRadiusAll: 4,
                    onPressed: () {
                      /*Navigator.pop(context);
                      Utils.navigate_to(
                          AppConfig.GardenProductionRecordScreen, context,
                          data: {
                            'id': m.amount.toString(),
                          });*/
                    },
                    child: FxText.b1(
                      "DELETE TRANSACTION",
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      fontWeight: 700,
                    ),
                    backgroundColor: Colors.red.shade700,
                  )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widget_garden_activity_ui(FinancialRecordModel m) {
    return InkWell(
      onTap: () => {_show_details_bottom_sheet(context, m)},
      child: FxContainer(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: (Utils.screen_width(context) / 1.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText(
                            m.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontWeight: 800,
                          ),
                          FxText(
                            "${m.created_at.toString()}",
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

  activity_status_widget(FinancialRecordModel m) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FxText(
          '${m.amount}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          color: (m.amount < 0) ? Colors.red.shade800 : Colors.green.shade800,
          fontWeight: 800,
        ),
        FxText(
          'UGX',
          maxLines: 1,
          fontSize: 14,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
          color: Colors.grey.shade400,
          fontWeight: 600,
        ),
      ],
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
                  gardenModel.name,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: 400,
                )),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FxText(
                    'UGX ${profit_loss}',
                    fontWeight: 800,
                    fontSize: 40,
                    height: .8,
                    textAlign: TextAlign.end,
                    color: Colors.white,
                  ),
                  FxText(
                    'Profit/Loss',
                    height: .8,
                    fontWeight: 400,
                    fontSize: 16.5,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  Widget _widget_single_item(String title, String value) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 18, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FxText.b1(
            "${title}:",
            fontWeight: 600,
            fontSize: 20,
            color: Colors.black,
          ),
          FxText.b1(
            "${value}",
            maxLines: 1,
            fontWeight: 600,
            fontSize: 20,
            color: Colors.grey.shade700,
          ),
        ],
      ),
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
}
