import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/QuestionModel.dart';

import '../../models/QuestionModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/my_widgets.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  QuestionsScreenState createState() => QuestionsScreenState();
}

class QuestionsScreenState extends State<QuestionsScreen> {
  late ThemeData theme;

  QuestionsScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  List<QuestionModel> items = [];

  Future<void> my_init() async {
    setState(() {});

    items = await QuestionModel.get_items();

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
          title: 'Ask a new question', screen: AppConfig.QuestionsCreateScreen),
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
                    'Browse Questions & Answers',
                    color: Colors.white,
                    maxLines: 1,
                    fontSize: 20,
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

  Widget _widget_garden_activity_ui(QuestionModel m) {
    return InkWell(
      onTap: () => {
        Utils.navigate_to(AppConfig.QuestionScreen, context,
            data: {'id': m.id.toString()})
      },
      child: FxCard(
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
                maxLines: 4,
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
          )),
    );
  }
}
