import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/LoggedInUserModel.dart';
import 'package:ict4farmers/models/WizardItemModel.dart';
import 'package:ict4farmers/pages/location_picker/single_item_picker.dart';
import 'package:ict4farmers/pages/product_add_form/product_add_form.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../models/FarmersGroup.dart';
import '../models/MenuItemModel.dart';
import '../widget/my_widgets.dart';
import '../widget/shimmer_loading_widget.dart';

class Dashboard extends StatefulWidget {
  BuildContext _context;

  Dashboard(this._context);

  @override
  DashboardState createState() => DashboardState(_context);
}

class DashboardState extends State<Dashboard> {
  late ThemeData theme;
  BuildContext _context;

  List<MenuItemModel> main_menu_items = [
//    new MenuItemModel('HRM', "1.png", AppConfig.WorkersScreen, true),
    new MenuItemModel(
        'Enterprise Management', "1.png", AppConfig.GardensScreen, true, null),
    new MenuItemModel(
        'Pests & Diseases', "4.png", AppConfig.PestsScreen, true, null),
    new MenuItemModel(
        'Market Place', "3.png", AppConfig.MarketPlace1, false, null),
    new MenuItemModel('Resource Sharing', "2.png", AppConfig.MarketPlace1, true,
        {'task': 'resource'}),
    new MenuItemModel(
        'Extension Services', "6.png", AppConfig.ComingSoon, true, null),
    new MenuItemModel(
        'Ask the Expert', "5.png", AppConfig.QuestionsScreen, true, null),
  ];

  DashboardState(this._context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  bool open_setup_wizard = false;

  Future<void> my_init() async {
    bool open_setup_wizard = false;
    loggedUser = await LoggedInUserModel.get_logged_in_user();
    if (loggedUser.id < 1) {
      is_logged_in = false;
    } else {
      is_logged_in = true;

      open_setup_wizard = await WizardItemModel.open_setup_wizard();
      if (loggedUser.phone_number_verified != "1") {
        Utils.navigate_to(AppConfig.account_verification_splash, context);
      }
    }

    setState(() {});
    Utils.ini_theme();

    if (open_setup_wizard) {
      Utils.navigate_to(AppConfig.WizardHomeScreen, context);
    }
    return;
    LoggedInUserModel.get_logged_in_user();

    Utils.init_one_signal();
  }

  bool is_logged_in = false;
  LoggedInUserModel loggedUser = new LoggedInUserModel();

  Future<Null> _onRefresh() async {
    await my_init();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItemModel> sub_menu_items = [];
    MenuItemModel i1 = new MenuItemModel(
        'My Acivities', "1.png", AppConfig.GardenActivitiesScreen, true,null);
    i1.icon = Icons.agriculture;
    sub_menu_items.add(i1);

    MenuItemModel i2 = new MenuItemModel(
        'My Records', "1.png", AppConfig.GardenProductionRecordsScreen, true,null);
    i2.icon = Icons.assignment;
    sub_menu_items.add(i2);

    MenuItemModel i3 = new MenuItemModel(
        'My Products', "1.png", AppConfig.MyProductsScreen, true,null);
    i3.icon = Icons.inventory;
    sub_menu_items.add(i3);

    MenuItemModel i4 =
        new MenuItemModel('My Chats', "1.png", AppConfig.ChatHomeScreen, true,null);
    i4.icon = Icons.forum;
    sub_menu_items.add(i4);

    /*

      new MenuItemModel('My orders', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel(
          'Production guides', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel('Resources', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel('Browse farmers', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel(
          'Extension services', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel(
          'Products pricing', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel('Ask an expert', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel('About this App', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel(
          'Our privacy policy', "1.png", AppConfig.PrivacyPolicy, true),
      new MenuItemModel('Help & Support', "1.png", AppConfig.ComingSoon, true),
      new MenuItemModel('Toll free', "1.png", AppConfig.ComingSoon, true),
     */

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.primary_bg,
        floatingActionButton:
            (is_logged_in && (!loggedUser.profile_is_complete()))
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.red.shade800,
                    elevation: 20,
                    onPressed: () {
                      //

                      if (open_setup_wizard) {
                        Utils.navigate_to(AppConfig.WizardHomeScreen, context);
                        return;
                      }

                      /*   if(mounted){
                        OneSignalModel.set_player_id(context);
                      }

                      return;
*/

                      if (is_logged_in) {
                        Utils.navigate_to(AppConfig.AccountEdit, context);
                      } else {
                        show_not_account_bottom_sheet(context);
                      }
                    },
                    label: Row(
                      children: [
                        Icon(
                          open_setup_wizard ? Icons.settings : Icons.edit,
                          size: 18,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: FxText(
                            open_setup_wizard
                                ? 'System Setup Wizard'
                                : "Complete Profile",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
                : FloatingActionButton.extended(
                    backgroundColor: CustomTheme.primary,
                    elevation: 20,
                    onPressed: () {

                      if (open_setup_wizard) {
                        Utils.navigate_to(AppConfig.WizardHomeScreen, context);
                        return;
                      }

                      if (is_logged_in) {
                        Utils.navigate_to(AppConfig.MyAccountScreen, context);
                      } else {
                        show_not_account_bottom_sheet(context);
                      }
                    },
                    label: Row(
                      children: [
                        Icon(
                          open_setup_wizard ? Icons.settings : Icons.person,
                          size: 18,
                        ),
                        Container(
                          child: Text(
                            open_setup_wizard
                                ? 'System Setup Wizard'
                                :  is_logged_in ? "My Account" : " Register | Login ",
                          ),
                        ),
                      ],
                    )),
        body: RefreshIndicator(
            color: CustomTheme.primary,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                    titleSpacing: 0,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: CustomTheme.primary,
                      statusBarIconBrightness: Brightness.light,
                      // For Android (dark icons)
                      statusBarBrightness:
                          Brightness.light, // For iOS (dark icons)
                    ),
                    elevation: 0,
                    pinned: true,
                    toolbarHeight: (Utils.screen_height(context) / 3.0),
                    title: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          child: Image(
                            width: double.infinity,
                            height: (Utils.screen_height(context) / 3.0),
                            fit: BoxFit.cover,
                            image: AssetImage("assets/project/farm_doodle.jpg"),
                          ),
                        ),
                        InkWell(
                          onTap: () => {
                            if (!is_logged_in)
                              {show_not_account_bottom_sheet(context)}
                            else
                              {
                                Utils.navigate_to(
                                    AppConfig.AccountEdit, context)
                              }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 0,
                              right: 0,
                              top: (MediaQuery.of(context).size.height / 6.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                sub_menu_widget(sub_menu_items[0]),
                                sub_menu_widget(sub_menu_items[1]),
                                sub_menu_widget(sub_menu_items[2]),
                                sub_menu_widget(sub_menu_items[3]),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => {
                                  Utils.launchPhone(
                                      AppConfig.TOLL_FREE_PHONE_NUMBER)
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      FxContainer.rounded(
                                        bordered: true,
                                        width: 60,
                                        height: 60,
                                        border: Border.all(
                                            color: CustomTheme.primary),
                                        paddingAll: 10,
                                        splashColor: CustomTheme.primary,
                                        color: CustomTheme.primary,
                                        child: Icon(
                                          CupertinoIcons.phone,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                      FxContainer(
                                        padding: EdgeInsets.only(
                                            top: 3,
                                            bottom: 3,
                                            left: 10,
                                            right: 10),
                                        splashColor: CustomTheme.primary,
                                        color: Colors.white,
                                        child: FxText(
                                          "Toll Free: ${AppConfig.TOLL_FREE_PHONE_NUMBER}",
                                          fontWeight: 800,
                                          fontSize: 15,
                                          color: CustomTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              FxContainer.rounded(
                                paddingAll: 0,
                                child: is_logged_in
                                    ? InkWell(
                                        onTap: () => {
                                          if (loggedUser.profile_is_complete())
                                            {
                                              Utils.navigate_to(
                                                  AppConfig.MyAccountScreen,
                                                  context)
                                            }
                                          else
                                            {
                                              Utils.navigate_to(
                                                  AppConfig.AccountEdit,
                                                  context)
                                            }
                                        },
                                        child: CachedNetworkImage(
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          imageUrl: loggedUser.avatar,
                                          placeholder: (context, url) =>
                                              ShimmerLoadingWidget(
                                            height: 60,
                                            width: 60,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image(
                                            image: AssetImage(
                                                './assets/project/user.png'),
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () => {
                                          show_not_account_bottom_sheet(context)
                                        },
                                        child: Image(
                                          width: 60,
                                          height: 60,
                                          image: AssetImage(
                                              "./assets/project/user.png"),
                                        ),
                                      ),
                              ),
                              /* Container(
                          child:
                          FxText.h2("Bob Tusiime"),
                        )*/
                            ],
                          ),
                        ),
                      ],
                    ),
                    floating: false,
                    backgroundColor: CustomTheme.primary_bg),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                    childCount: 1,
                  ),
                ),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1,
                      mainAxisExtent: (140)),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _single_item(main_menu_items[index]);
                    },
                    childCount: main_menu_items.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return FxCard(
                        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                        padding: EdgeInsets.only(top: 15),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: FxText.caption("FOLLOW US"),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 15, right: 10),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchOuLink(AppConfig.OurWhatsApp)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 0),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.whatsapp,
                                        size: 30,
                                        color: Colors.green.shade600,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          color: AppTheme
                                              .lightTheme.backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchOuLink(
                                          AppConfig.OUR_FACEBOOK_LINK)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.facebook,
                                        size: 30,
                                        color: Colors.blue.shade800,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          color: AppTheme
                                              .lightTheme.backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchOuLink(
                                          AppConfig.OUR_TWITTER_LINK)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        MdiIcons.twitter,
                                        size: 30,
                                        color: Colors.blue.shade500,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchOuLink(
                                          AppConfig.OUR_INSTAGRAM_LINK)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        MdiIcons.instagram,
                                        size: 30,
                                        color: Colors.red.shade700,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchOuLink(
                                          AppConfig.OUR_YOUTUBE_LINK)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        MdiIcons.youtube,
                                        size: 30,
                                        color: Colors.red.shade500,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchOuLink(
                                          AppConfig.OUR_WEBSITE_LINK)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        MdiIcons.web,
                                        size: 30,
                                        color: Colors.grey.shade900,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      Utils.launchPhone(
                                          AppConfig.OUR_PHONE_NUMBER)
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 16),
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        MdiIcons.phone,
                                        size: 30,
                                        color: CustomTheme.primary,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FxSpacing.height(22),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _list_item(MenuItemModel menu_item) {
    String badge = "1";
    return InkWell(
      onTap: () => {Utils.navigate_to(menu_item.screen, context)},
      child: Container(
        child: FxContainer(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 0, right: 10),
          padding: FxSpacing.all(20),
          bordered: true,
          border: Border.all(color: CustomTheme.primary, width: 1),
          child: InkWell(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.access_alarms,
                    size: 22,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                FxSpacing.width(16),
                Expanded(
                  child: FxText.b1(
                    menu_item.title,
                    fontWeight: 800,
                    color: Colors.black,
                    fontSize: (menu_item.title.length > 20) ? 16 : 18,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      badge.toString().isEmpty
                          ? SizedBox()
                          : FxContainer(
                              color: Colors.red.shade500,
                              width: 28,
                              paddingAll: 0,
                              marginAll: 0,
                              alignment: Alignment.center,
                              borderRadiusAll: 15,
                              height: 28,
                              child: FxText(
                                badge.toString(),
                                color: Colors.white,
                              )),
                      Icon(MdiIcons.chevronRight,
                          size: 22, color: theme.colorScheme.onBackground),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _single_item(MenuItemModel item) {
    return InkWell(
      onTap: () => {
        item.is_protected
            ? (loggedUser.id > 0)
                ? Utils.navigate_to(item.screen, context,data: item.data)
                : show_not_account_bottom_sheet(context)
            : Utils.navigate_to(item.screen, context,data: item.data)
      },
      child: FxCard(
        paddingAll: 5,
        color: Colors.white,
        borderRadiusAll: 10,
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Column(
          children: [
            Container(
              height: 80,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/project/${item.photo}"),
              ),
            ),
            Spacer(),
            FxText(
              "${item.title}",
              textAlign: TextAlign.center,
              color: CustomTheme.primaryDark,
              fontWeight: 800,
              height: 1,
              maxLines: 2,
              fontSize: 14,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  /*
  Container(
        padding: EdgeInsets.only(left: 10, top: 20, right: 10),
        child: FxContainer(
          paddingAll: 0,
          bordered: true,
          width: MediaQuery.of(context).size.width / 2.3,
          border: Border.all(color: CustomTheme.primary, width: 1),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                  child: FxText(
                    item.title,
                    maxLines: 3,
                    fontSize: (item.title.length > 16) ? 18 : 22,
                    height: .8,
                    fontWeight: 700,
                    color: Colors.grey.shade900,
                  ),
                ),
                Spacer(),
                Container(
                  height: 90,
                  child: Image(
                    fit: BoxFit.fill,
                    width: (Utils.screen_width(context) / 2),
                    image: AssetImage("assets/project/${item.photo}"),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      )
   */

  Widget singleOption(_context, theme,
      {IconData? iconData,
      required String option,
      String navigation: "",
      String badge: ""}) {
    return FxContainer(
      margin: EdgeInsets.only(left: 20, top: 0, bottom: 20, right: 20),
      padding: FxSpacing.all(20),
      bordered: true,
      border: Border.all(color: CustomTheme.primary, width: 1),
      child: InkWell(
        onTap: () {
          if (navigation == AppConfig.CallUs) {
            Utils.launchOuLink(navigation);
          } else if (navigation == AppConfig.ProductAddForm) {
            Utils.navigate_to(navigation, _context);
            //_show_bottom_sheet_sell_or_buy(_context);
          } else {
            Utils.navigate_to(navigation, _context);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                iconData,
                size: 22,
                color: theme.colorScheme.onBackground,
              ),
            ),
            FxSpacing.width(16),
            Expanded(
              child: FxText.b1(
                option,
                fontWeight: 800,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Container(
              child: Row(
                children: [
                  badge.toString().isEmpty
                      ? SizedBox()
                      : FxContainer(
                      color: Colors.red.shade500,
                      width: 28,
                      paddingAll: 0,
                      marginAll: 0,
                      alignment: Alignment.center,
                      borderRadiusAll: 15,
                      height: 28,
                      child: FxText(
                        badge.toString(),
                        color: Colors.white,
                      )),
                  Icon(MdiIcons.chevronRight,
                      size: 22, color: theme.colorScheme.onBackground),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> do_logout() async {
    await Utils.logged_out();
    Utils.showSnackBar("Logged out successfully.", _context, Colors.white);
    my_init();
  }

  open_add_product(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductAddForm()),
    );

    if (result != null) {
      if (result['task'] != null) {
        if (result['task'] == 'success') {
          Utils.navigate_to(AppConfig.MyProductsScreen, context);
        }
      }
    }
  }

  List<FarmersGroup> farmers_groups = [];

  test_function() async {
    farmers_groups = await FarmersGroup.get_items();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleItemPicker(
              "Pick farmer group", jsonEncode(farmers_groups), "0")),
    );
    if (result != null) {
      if (result['id'] != null && result['name'] != null) {

      }
    }
  }

  Widget sub_menu_widget(MenuItemModel sub_menu_item) {
    return InkWell(
      onTap: () => {
        if (sub_menu_item.is_protected)
          {
            if (!is_logged_in)
              {show_not_account_bottom_sheet(context)}
            else
              {Utils.navigate_to(sub_menu_item.screen, context)}
          }
      },
      child: Column(
        children: [
          FxContainer.rounded(
            bordered: true,
            border: Border.all(color: CustomTheme.primary),
            paddingAll: 10,
            splashColor: CustomTheme.primary,
            color: CustomTheme.primary_bg,
            child: Icon(
              sub_menu_item.icon,
              size: 35,
              color: CustomTheme.primaryDark,
            ),
          ),
          FxCard(
            padding: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
            marginAll: 0,
            child: FxText(
              "${sub_menu_item.title}",
              color: CustomTheme.primaryDark,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 13,
              fontWeight: 800,
            ),
          )
        ],
      ),
    );
  }
}
