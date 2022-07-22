import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/widget/shimmer_list_loading_widget.dart';
import 'package:provider/provider.dart';

import '../../models/ChatModel.dart';
import '../../models/ChatThreadModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../theme/app_notifier.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/empty_list.dart';
import '../../widget/shimmer_loading_widget.dart';
import 'chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  bool is_logged_in = false;
  bool is_loading = true;
  LoggedInUserModel logged_in_user = new LoggedInUserModel();
  List<ChatThreadModel> chat_threads = [];

  @override
  void initState() {
    my_init();
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  Future<void> my_init() async {
    is_loading = true;
    setState(() {});
    logged_in_user = await Utils.get_logged_in();
    is_loading = false;

    if (logged_in_user.id < 1) {
      is_logged_in = false;

      return;
    } else {

      is_logged_in = true;
    }
    chat_threads = await ChatThreadModel.get_threads(logged_in_user.id);

    setState(() {
      is_loading = false;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white, // <= You can change your color here.
              ),
              backgroundColor: CustomTheme.primary,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: CustomTheme.primary,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: .5,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "My Chats",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      my_init();
                    },
                    child: Container(
                        padding: FxSpacing.x(0), child: Icon(Icons.add)),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: (!is_logged_in)
                  ? EmptyList(
                      empty_image: "assets/project/on_board_toll_free.png",
                      body: "You are not logged in yet.",
                      action_text:
                          "Press the account tab to create your create account today and access all features of ${AppConfig.AppName}")
                  : is_loading
                      ? ShimmerListLoadingWidget()
                      : RefreshIndicator(
                          onRefresh: my_init,
                          color: CustomTheme.primary,
                          backgroundColor: Colors.white,
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      child: singleChat(chat_threads[index]),
                                    );
                                  },
                                  childCount:
                                      chat_threads.length, // 1000 list items
                                ),
                              )
                            ],
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }

  void _showFullImage(String imagePath, String imageTag) {}

  Widget singleChat(ChatThreadModel item) {
    bool isActive = true;
    bool show_sender = false;

    if (item.sender.toString() == logged_in_user.id.toString()) {
      show_sender = false;
    } else {
      show_sender = true;
    }

    bool isNew = true;
    bool hasBadge = true;
    if (item.unread_count > 0) {
      isActive = true;
      hasBadge = true;
      isNew = true;
    } else {
      isActive = false;
      isNew = false;
      hasBadge = false;
    }

    Widget badgeWidget = (!hasBadge)
        ? Container()
        : Container(
            padding: FxSpacing.all(6),
            decoration: BoxDecoration(
                color: CustomTheme.accent, shape: BoxShape.circle),
            child: FxText.caption(item.unread_count.toString(),
                fontSize: 12, color: theme.colorScheme.onPrimary),
          );

    return InkWell(
      onTap: () {
        ChatModel _test = new ChatModel();
        _test.id = item.id;
        _test.created_at = item.created_at;
        _test.body = item.body;
        _test.sender = item.sender;
        _test.product_id = item.product_id;
        _test.receiver = item.receiver;
        _test.thread = item.thread;
        _test.received = item.received;
        _test.seen = item.seen;
        _test.type = item.type;
        _test.receiver_pic = item.receiver_pic;
        _test.contact = item.contact;
        _test.gps = item.gps;
        _test.file = item.file;
        _test.image = item.image;
        _test.audio = item.audio;
        _test.receiver_name = item.receiver_name;
        _test.sender_name = item.sender_name;
        _test.product_name = item.product_name;
        _test.product_pic = item.product_pic;
        _test.unread_count = item.unread_count;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(_test)));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                  child: InkWell(
                    onTap: () {
                      //_showFullImage('./assets/project/no_image.jpg', "anjane");
                    },
                    child: Hero(
                      tag: "romina",
                      transitionOnUserGestures: true,
                      child: CachedNetworkImage(
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                        imageUrl:
                            show_sender ? item.sender_pic : item.receiver_pic,
                        placeholder: (context, url) => ShimmerLoadingWidget(
                          height: 52,
                          width: 52,
                        ),
                        errorWidget: (context, url, error) => Image(
                          image: AssetImage('./assets/project/no_image.jpg'),
                          height: 52,
                          width: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                isActive
                    ? Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: customTheme.card, width: 2),
                              shape: BoxShape.circle),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: customTheme.colorSuccess,
                                shape: BoxShape.circle),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Expanded(
              child: Container(
                margin: FxSpacing.left(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.b1(
                        show_sender ? item.sender_name : item.receiver_name,
                        maxLines: 1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 700),
                    FxText.b2(item.body,
                        color:
                            isNew ? Colors.grey.shade600 : Colors.grey.shade500,
                        fontWeight: isNew ? 600 : 500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Container(
              margin: FxSpacing.left(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FxText.caption(item.created_at,
                      color:
                          isNew ? Colors.grey.shade600 : Colors.grey.shade700,
                      letterSpacing: -0.2,
                      fontWeight: isNew ? 600 : 500),
                  badgeWidget
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget singleOption(
      {IconData? icon, required String title, Widget? navigation}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigation!));
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withAlpha(90),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: FxSpacing.fromLTRB(16, 16, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: theme.colorScheme.onPrimary),
              padding: FxSpacing.all(2),
              child: Icon(
                icon,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
            Container(
              margin: FxSpacing.top(8),
              child: FxText.sh2(title, color: theme.colorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }
}
