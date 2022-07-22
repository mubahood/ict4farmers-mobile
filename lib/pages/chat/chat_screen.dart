import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/ChatModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_chat_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_loading_widget.dart';

class ChatScreen extends StatefulWidget {
  ChatModel chatThread;

  ChatScreen(this.chatThread);

  @override
  _ChatScreenState createState() => _ChatScreenState(this.chatThread);
}

class MyChatModel {
  String message, from, timestamp, seenType;
  static final String myId = "myId";
  static final String otherId = "otherId";

  MyChatModel(this.message, this.from, this.timestamp, this.seenType);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.chatThread);

  ChatModel chatThread;
  late CustomTheme customTheme;
  late ThemeData theme;
  bool isExpanded = false,
      is_loading = false,
      showMenu = false,
      show_receiver = false;

  ScrollController? _scrollController;
  TextEditingController? _chatTextController;

  List<String> _simpleChoice = ["Report this user", "Clear chat"];

  List<ChatModel> chats = [];
  List<Timer> _timers = [];

  bool isChatTextEmpty = true;
  LoggedInUserModel logged_in_user = new LoggedInUserModel();

  Future<void> my_init_state() async {
    is_loading = true;
    setState(() {});
    logged_in_user = await Utils.get_logged_in();
    if (logged_in_user.id < 1) {
      Utils.showSnackBar("Login before you proceed.", context, Colors.red);
      Navigator.pop(context);
      return;
    }
    if (logged_in_user.id == chatThread.receiver_pic) {
      show_receiver = false;
    } else {
      show_receiver = true;
    }

    chats =
        await ChatModel.get_local_chats(chatThread.thread, logged_in_user.id);
    if (chats.isEmpty) {
      chats =
          await ChatModel.get_local_chats(chatThread.thread, logged_in_user.id);
    }
    is_loading = false;
    setState(() {});
    scrollToBottom(isDelayed: false);

    List<int> done_chats = [];
    List<ChatModel> online_chats = [];

    chats.forEach((element) {
      done_chats.add(element.id);
    });
    await ChatModel.get_online_chats(chatThread.thread, logged_in_user.id);
    online_chats =
        await ChatModel.get_local_chats(chatThread.thread, logged_in_user.id);
    online_chats.forEach((element) {
      if (!done_chats.contains(element.id)) {
        if (element.thread == chatThread.thread) {
          chats.add(element);
        }
      }
    });
    setState(() {});
    scrollToBottom(isDelayed: false);
    start_live_check();
  }

  @override
  void initState() {
    super.initState();
    my_init_state();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    _chatTextController = TextEditingController();
    _scrollController = ScrollController();
    _chatTextController!.addListener(() {
      setState(() {
        isChatTextEmpty = _chatTextController!.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stop_live_check();
    _scrollController!.dispose();
    for (Timer timer in _timers) {
      timer.cancel();
    }
  }

  void stop_live_check() {
    live_check_is_active = false;

  }

  bool live_check_is_active = true;
  bool live_check_is_loading = false;
  List<ChatModel> live_chats = [];
  List<int> loaded_chats = [];

  Future<void> start_live_check() async {
    if (!live_check_is_loading) {
      live_check_is_loading = true;
      loaded_chats = [];
      chats.forEach((element) {
        loaded_chats.add(element.id);
      });
      live_chats = await ChatModel.get_online_chats(
          chatThread.thread, logged_in_user.id,
          unread: "1");

      live_chats.forEach((element) {
        if (!loaded_chats.contains(element.id)) {
          if (element.thread == chatThread.thread) {
            if (element.sender.toString() != logged_in_user.id.toString()) {
              chats.add(element);
              loaded_chats.add(element.id);
            }
          }
        }
      });
      setState(() {});
      scrollToBottom(isDelayed: false);
      live_check_is_loading = false;
    }

    Future.delayed(Duration(seconds: 1), () {

      if (!live_check_is_active) {
        return;
      }
      if (live_check_is_active) {
        start_live_check();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: my_init_state,
            color: CustomTheme.primary,
            backgroundColor: Colors.white,
            child: Container(
              padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
              child: Column(
                children: [
                  Container(
                    child: appBarWidget(),
                  ),
                  Expanded(
                      child: Container(
                    margin: FxSpacing.horizontal(16),
                    child: is_loading
                        ? Text("Loading...")
                        : ListView.builder(
                            controller: _scrollController,
                            padding: FxSpacing.zero,
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: index == 0
                                    ? EdgeInsets.only(top: 8, bottom: 3).add(
                                        (chats[index].sender.toString() != logged_in_user.id.toString())
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context).size.width *
                                                    0.2)
                                            : EdgeInsets.only(
                                                right:
                                                    MediaQuery.of(context).size.width *
                                                        0.2))
                                    : EdgeInsets.only(top: 3, bottom: 3).add(
                                        (chats[index].sender.toString() !=
                                                logged_in_user.id.toString())
                                            ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2)
                                            : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2)),
                                alignment: (chats[index].sender.toString() !=
                                        logged_in_user.id.toString())
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: singleChat(index),
                              );
                            },
                          ),
                  )),
                  Container(
                    child: bottomBarWidget(),
                  )
                ],
              ),
            )));
  }

  Widget appBarWidget() {
    return Column(
      children: [
        FxContainer(
          padding: FxSpacing.fromLTRB(16, 0, 0, 0),
          color: theme.scaffoldBackgroundColor,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  MdiIcons.chevronLeft,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: CachedNetworkImage(
                    height: 52,
                    width: 52,
                    fit: BoxFit.cover,
                    imageUrl: show_receiver
                        ? chatThread.sender_pic
                        : chatThread.receiver_pic,
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
              Container(
                margin: FxSpacing.left(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 200),
                      child: FxText.b1(
                        show_receiver
                            ? (chatThread.receiver_name.isEmpty)
                                ? chatThread.product_name
                                : chatThread.receiver_name
                            : chatThread.sender_name,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 200),
                      child: FxText.caption(chatThread.product_name,
                          color: CustomTheme.primary,
                          muted: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: 600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          start_live_check();
                        },
                        child: Container(
                          padding: FxSpacing.all(4),
                          child: Icon(
                            MdiIcons.phoneOutline,
                            color: theme.colorScheme.onBackground,
                            size: 18,
                          ),
                        ),
                      ),
                      Container(
                        margin: FxSpacing.left(4),
                        child: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return _simpleChoice.map((String choice) {
                              return PopupMenuItem(
                                value: choice,
                                child: FxText.b2(choice,
                                    letterSpacing: 0.15,
                                    color: theme.colorScheme.onBackground),
                              );
                            }).toList();
                          },
                          color: customTheme.card,
                          icon: Icon(
                            MdiIcons.dotsVertical,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget bottomBarWidget() {
    return FxContainer(
      borderRadiusAll: 0,
      color: Colors.grey.shade200,
      padding: FxSpacing.fromLTRB(24, 12, 24, 12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        onEnd: () {
          setState(() {
            showMenu = isExpanded;
          });
        },
        height: isExpanded ? 124 : 42,
        child: ListView(
          padding: FxSpacing.zero,
          children: [
            Row(
              children: [
                FxContainer.rounded(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      if (!showMenu) showMenu = true;
                    });
                  },
                  padding: FxSpacing.all(8),
                  color: CustomTheme.primary.withAlpha(28),
                  child: Icon(
                    MdiIcons.plus,
                    color: CustomTheme.primary,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: FxSpacing.left(16),
                    child: TextFormField(
                      style: FxTextStyle.b2(
                          letterSpacing: 0.1,
                          color: Colors.grey.shade700,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        hintText: "Type here",
                        hintStyle: FxTextStyle.b2(
                            letterSpacing: 0.1,
                            color: theme.colorScheme.onBackground,
                            muted: true,
                            fontWeight: 500),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            borderSide: BorderSide(
                                color: customTheme.border, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            borderSide: BorderSide(
                                color: customTheme.border, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            borderSide: BorderSide(
                                color: customTheme.border, width: 1)),
                        isDense: true,
                        contentPadding: FxSpacing.fromLTRB(16, 12, 16, 12),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      textInputAction: TextInputAction.newline,
                      /*onFieldSubmitted: (message) {
                        //sendMessage(message);
                      },*/
                      controller: _chatTextController,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                FxContainer.rounded(
                  margin: FxSpacing.left(16),
                  width: 38,
                  onTap: () {
                    sendMessage(_chatTextController!.text);
                  },
                  height: 38,
                  padding: FxSpacing.left(isChatTextEmpty ? 0 : 4),
                  color: CustomTheme.primary.withAlpha(28),
                  child: Icon(
                    isChatTextEmpty
                        ? MdiIcons.microphoneOutline
                        : MdiIcons.sendOutline,
                    color: CustomTheme.primary,
                    size: isChatTextEmpty ? 20 : 18,
                  ),
                )
              ],
            ),
            showMenu
                ? Container(
                    margin: FxSpacing.top(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        optionWidget(
                            color: Colors.blue,
                            iconData: MdiIcons.imageOutline,
                            title: "Image"),
                        optionWidget(
                            color: Colors.pink,
                            iconData: MdiIcons.mapMarkerOutline,
                            title: "Location"),
                        optionWidget(
                            color: Colors.orange,
                            iconData: MdiIcons.accountOutline,
                            title: "Contact"),
                        optionWidget(
                            color: Colors.purple,
                            iconData: MdiIcons.fileDocumentOutline,
                            title: "File"),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget optionWidget(
      {IconData? iconData, required Color color, String title = ""}) {
    return Column(
      children: [
        Container(
          padding: FxSpacing.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(40),
          ),
          child: Icon(
            iconData,
            color: color,
            size: 22,
          ),
        ),
        Container(
          margin: FxSpacing.top(4),
          child: FxText.caption(title,
              fontSize: 12,
              color: theme.colorScheme.onBackground,
              fontWeight: 600),
        )
      ],
    );
  }

  CustomChatTheme customChatTheme = CustomChatTheme.getWhatsAppTheme();

  Widget singleChat(int index) {
    bool is_mine = false;
    if (chats[index].sender.toString() == logged_in_user.id.toString()) {
      is_mine = true;
    } else {
      is_mine = false;
    }
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: 4,
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: is_mine ? CustomTheme.primary : Colors.grey.shade300,
          borderRadius: makeChatBubble(index),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  child: FxText.sh1(
                    chats[index].body,
                    color: is_mine ? customChatTheme.onMyChat : Colors.black,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: FxText.overline(chats[index].created_at,
                    letterSpacing: -0.1,
                    color: is_mine
                        ? customChatTheme.onMyChat
                        : Colors.grey.shade700),
              ),
              !is_mine
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(left: 2),
                      child: Icon(
                          chats[index].received
                              ? MdiIcons.checkAll
                              : MdiIcons.check,
                          size: 14,
                          color: is_mine
                              ? (chats[index].seen
                                  ? customChatTheme.tickColor
                                  : customChatTheme.onMyChat)
                              : customChatTheme.onChat))
            ],
          ),
        ));
  }

  BorderRadius makeChatBubble(int index) {
    if (chats[index].id.toString().compareTo(logged_in_user.id.toString()) ==
        0) {
      if (index != 0) {
        if (chats[index - 1].sender.compareTo(logged_in_user.id.toString()) ==
            0) {
          return BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4));
        } else {
          return BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(0));
        }
      } else {
        return BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            topRight: Radius.circular(0));
      }
    } else {
      if (index != 0) {
        if (chats[index - 1]
                .sender
                .toString()
                .compareTo(logged_in_user.id.toString()) !=
            0) {
          return BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4));
        } else {
          return BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4));
        }
      } else {
        return BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            topRight: Radius.circular(4));
      }
    }
  }

  void sendMessage(String message) {
    ChatModel new_message = new ChatModel();
    new_message.sender = logged_in_user.id.toString();
    if (logged_in_user.id.toString() == chatThread.receiver.toString()) {
      new_message.receiver = chatThread.sender.toString();
    } else {
      new_message.receiver = chatThread.receiver.toString();
    }
    new_message.product_id = chatThread.product_id.toString();
    new_message.body = message;
    new_message.created_at = 'just now';

    new_message.send_this_message(context);

    if (message.isNotEmpty) {
      setState(() {
        _chatTextController!.clear();
        chats.add(new_message);
        //startTimer(chats.length - 1, message);
      });
      scrollToBottom(isDelayed: true);
    }
  }

  void startTimer(int index, String message) {

    const twoSec = Duration(seconds: 2);
    const threeSec = Duration(seconds: 3);

    Timer timerSeen = Timer.periodic(
        twoSec,
        (Timer timer) => {
              timer.cancel(),
              setState(() {
/*                chats[index].seenType = "seen";*/
              })
            });
    _timers.add(timerSeen);
    Timer timer = Timer.periodic(
        threeSec, (Timer timer) => {timer.cancel(), sentFromOther(message)});
    _timers.add(timer);
  }

  void sentFromOther(String message) {
    setState(() {
      /*  chats.add(MyChatModel(message, MyChatModel.otherId,
          DateTime.now().millisecondsSinceEpoch.toString(), "sent"));
      scrollToBottom(isDelayed: true);*/
    });
  }

  scrollToBottom({bool isDelayed = false}) {
    final int delay = isDelayed ? 400 : 0;
    Future.delayed(Duration(milliseconds: delay), () {
      _scrollController!.animateTo(_scrollController!.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
