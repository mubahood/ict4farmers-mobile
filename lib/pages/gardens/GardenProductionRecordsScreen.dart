import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/widget/loading_widget.dart';

import '../../models/GardenModel.dart';
import '../../models/GardenProductionModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../models/option_picker_model.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../option_pickers/single_option_picker.dart';

class GardenProductionRecordsScreen extends StatefulWidget {
  dynamic params;

  GardenProductionRecordsScreen(this.params);

  @override
  GardenProductionRecordsScreenState createState() =>
      GardenProductionRecordsScreenState();
}

class GardenProductionRecordsScreenState
    extends State<GardenProductionRecordsScreen> {
  late ThemeData theme;
  int id = 0;
  bool is_filtered = false;
  bool is_loading = true;
  GardenModel gardenModel = new GardenModel();

  GardenProductionRecordsScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  List<GardenProductionModel> activities = [];
  List<int> loaded_items = [];

  Future<void> my_init() async {
    is_logged_in = false;
    is_loading = true;
    activities.clear();
    loaded_items.clear();
    activities = [];
    loaded_items = [];
    setState(() {});

    loggedUser = await Utils.get_logged_in();
    if (loggedUser.id < 1) {
      Utils.showSnackBar("Not logged in.", context, Colors.white);
      Navigator.pop(context);
      return;
    }

    if (id < 1) {
      if (widget.params != null) {
        if (widget.params['id'] != null) {
          id = Utils.int_parse(widget.params['id'].toString());
        }
      }
    }

    if (id < 1) {
      is_filtered = false;
      setState(() {});
    }else{
      is_filtered = true;
      setState(() {});
    }

    List<GardenModel> temp_gardens = await GardenModel.get_items();
    temp_gardens.forEach((e) {
      gardenModel = e;
    });

    List<GardenProductionModel> temp_acts =
        await GardenProductionModel.get_items();

    temp_acts.forEach((element) {
      if (!loaded_items.contains(element.id)) {
        if (is_filtered) {
          if (element.garden_id.toString() == id.toString()) {
            activities.add(element);
            loaded_items.add(element.id);
          }
        } else {
          loaded_items.add(element.id);
          activities.add(element);
        }
      }
    });

    is_loading = false;
    is_logged_in = true;
    gardens = await GardenModel.get_items();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Utils.navigate_to(AppConfig.GardenProductionRecordCreateScreen, context,
              data: {'id': id});
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
                    'Production records',
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
                    return is_loading
                        ? LoadingWidget()
                        : _widget_garden_activity_ui(activities[index]);
                  },
                  childCount:
                      is_loading ? 1 : activities.length, // 1000 list items
                ),
              ),
            ],
          )),
    );
  }

  void _show_details_bottom_sheet(context, GardenProductionModel m) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext buildContext) {
          return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  color: Colors.transparent,
                  child: FxCard(
                    child: _details_bottom_sheet_content(context, m),
                  ),
                );
              });
        });
  }

  Widget _details_bottom_sheet_content(
      BuildContext context, GardenProductionModel m) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FxText(
            "TASK",
            fontWeight: 800,
            color: Colors.black,
          ),
          FxText(
            "${m.description}",
            maxLines: 5,
            textAlign: TextAlign.start,
          ),
          Divider(),
          _widget_single_item('Enterprise', gardenModel.name),
          _widget_single_item('Assigned to', m.description),
          _widget_single_item(
              'Due date', '${Utils.to_date_1(m.created_at.toString())}'),
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.b1(
                  "Submission STATUS:",
                  fontWeight: 600,
                  fontSize: 20,
                  color: Colors.black,
                ),
                activity_status_widget(m),
              ],
            ),
          ),
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
                (false)
                    ? Container(
                        width: double.infinity,
                        child: Expanded(
                            child: FxButton(
                          elevation: 0,
                          padding: FxSpacing.y(12),
                          borderRadiusAll: 4,
                          onPressed: () {
                            Navigator.pop(context);
                            Utils.navigate_to(
                                AppConfig.GardenProductionRecordScreen, context,
                                data: {
                                  'id': m.id,
                                });
                          },
                          child: FxText.b1(
                            "VIEW ACTIVITY REPORT",
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            fontWeight: 700,
                          ),
                          backgroundColor: CustomTheme.primary,
                        )),
                      )
                    : Container(
                        width: double.infinity,
                        child: Expanded(
                            child: FxButton(
                          elevation: 0,
                          padding: FxSpacing.y(12),
                          borderRadiusAll: 4,
                          onPressed: () {
                            Navigator.pop(context);
                            Utils.navigate_to(
                                AppConfig.SubmitActivityScreen, context,
                                data: {
                                  'activity_id': m.id.toString(),
                                  'garden_id': m.garden_id.toString(),
                                  'activity_text': m.id,
                                  'enterprise_text': '${gardenModel.name}',
                                });
                          },
                          child: FxText.b1(
                            "SUBMIT ACTIVITY REPORT",
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            fontWeight: 700,
                          ),
                          backgroundColor: CustomTheme.primary,
                        )),
                      ),
                (false)
                    ? Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        child: (false)
                            ? Expanded(
                                child: FxButton.outlined(
                                borderRadiusAll: 5,
                                borderColor: CustomTheme.accent,
                                splashColor: CustomTheme.primary.withAlpha(40),
                                padding: FxSpacing.y(12),
                                onPressed: () {
                                  Navigator.pop(context);
                                  do_delete(m);
                                },
                                child: FxText.b1(
                                  "DELETE ACTIVITY",
                                  color: Colors.red.shade700,
                                  letterSpacing: 0.5,
                                  fontWeight: 700,
                                ),
                              ))
                            : SizedBox(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
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
                maxLines: 3,
                height: 1.2,
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

  activity_status_widget(GardenProductionModel m) {
    int status = 1;

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
                Icons.check,
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

  Widget _widget_overview() {
    return FxContainer(
        borderRadiusAll: 0,
        color: CustomTheme.primary,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: FxText(
                          (is_filtered) ? gardenModel.name : "All records",
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: 400,
                        )),

                  ],
                ),
                (is_filtered)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FxText(
                            '${gardenModel.get_percebtage_done()}%',
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
                      )
                    : SizedBox(),
              ],
            ),

            InkWell(
              onTap: () => {pick_a_garden()},
              child: FxCard(
                  width: 120,
                  padding: EdgeInsets.only(
                      left: 15, top: 10, bottom: 10, right: 15),
                  color: Colors.white,
                  splashColor: CustomTheme.primary.withAlpha(40),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_alt,
                        size: 20,
                        color: CustomTheme.accent,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      FxText("Filter",
                          fontSize: 16,
                          fontWeight: 800,
                          textAlign: TextAlign.center,
                          color: CustomTheme.primaryDark),
                    ],
                  )),
            ),

          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  Widget _widget_single_item(String title, String value) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FxText(
            "${title}:",
            fontWeight: 600,
            fontSize: 16,
            color: Colors.black,
          ),
          FxText(
            "${value}",
            maxLines: 1,
            fontWeight: 600,
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  void do_delete(GardenProductionModel m) async {
    if (true) {
      Utils.showSnackBar(
          "You cannot delete a generated activity.", context, Colors.white);
      return;
    }
    Utils.showSnackBar("Deleting...", context, Colors.white,
        background_color: Colors.red.shade800);
    String data = await Utils.http_delete(
        'api/garden-activities', {'id': m.id.toString()});

    await GardenProductionModel.get_items();
    Utils.showSnackBar("Deleted", context, Colors.white);
    my_init();
  }

  List<GardenModel> gardens = [];

  Future<void> pick_a_garden() async {
    if (gardens.isEmpty) {
      gardens = await GardenModel.get_items();
    }
    if (gardens.isEmpty) {
      Utils.showSnackBar(
          "Please connect to internet and try again.", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    List<OptionPickerModel> local_items = [];

    gardens.forEach((element) {
      OptionPickerModel item = new OptionPickerModel();
      item.parent_id = "1";
      item.id = element.id.toString();
      item.name = element.name.toString();
      local_items.add(item);
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SingleOptionPicker("Select an enterprise", local_items)),
    );

    if (result != null) {
      if ((result['id'] != null) && (result['text'] != null)) {
        id = Utils.int_parse(result['id']);
        widget.params = {id: id.toString()};
        setState(() {});
      }
    }
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
