/*
* File : Custom Onboarding
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict4farmers/models/WizardItemModel.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

class WizardCheckListScreen extends StatefulWidget {
  @override
  _WizardCheckListScreenState createState() => _WizardCheckListScreenState();
}

class _WizardCheckListScreenState extends State<WizardCheckListScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    _do_refresh();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _do_refresh,
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: is_loading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      child: FxText(
                                        "System Setup Checklist",
                                        fontSize: 25,
                                        color: Colors.black,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 5),
                                      child: FxText(
                                        "Complete actions in the following list for your account to be fully set.",
                                        fontWeight: 500,
                                      ),
                                    )
                                  ],
                                );
                              },
                              childCount: 1,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return singleWidget(items[index]);
                              },
                              childCount: items.length, // 1000 list items
                            ),
                          )
                        ],
                      ),
              ),
            )));
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  bool is_loading = false;

  List<WizardItemModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    items.clear();
    is_loading = true;
    setState(() {});

    items = await WizardItemModel.get_items();

    items.sort((a, b) => a.id.compareTo(b.id));
    setState(() {});

    is_loading = false;
    setState(() {});
    return null;
  }

  Widget singleWidget(WizardItemModel item) {
    return InkWell(
      onTap: () {
        _show_bottom_sheet_photo(context, item);
      },
      child: Container(
        color: Colors.white,
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 10, bottom: 10),
        child: Row(
          children: [
            FxContainer.rounded(
              paddingAll: 5,
              child: Icon(
                item.is_done ? Icons.check_circle : Icons.circle_outlined,
                color:
                    item.is_done ? Colors.green.shade800 : Colors.red.shade800,
                size: 35,
              ),
              color: item.is_done ? Colors.green.shade50 : Colors.red.shade50,
            ),
            FxSpacing.width(10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: RichText(
                      maxLines: 1,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'STEP ${item.id}: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          TextSpan(
                            text: '${item.title}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  FxText.b1(
                    item.sub_title,
                    fontWeight: 400,
                    color: item.is_done
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 35,
            )
          ],
        ),
      ),
    );
  }

  void _show_bottom_sheet_photo(context, WizardItemModel item) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black26, // barrier color
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomTheme.primary),
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxText.b1(
                      "Information",
                      fontSize: 18,
                      fontWeight: 700,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: FxText.caption(
                        item.description,
                        fontSize: 16,
                        maxLines: 6,
                        textAlign: TextAlign.justify,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 35),
                      child: FxButton.block(
                        borderRadiusAll: 10,
                        onPressed: () {
                          Navigator.pop(context);
                          Utils.navigate_to(item.screen, context);
                        },
                        shadowColor: Colors.white,
                        backgroundColor: CustomTheme.primary,
                        child: FxText.b1(
                          "${item.action_text}",
                          textAlign: TextAlign.center,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
