import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

class MoreMenuScreen1 extends StatefulWidget {
  MoreMenuScreen1();

  @override
  MoreMenuScreen1State createState() => MoreMenuScreen1State();
}

class MoreMenuScreen1State extends State<MoreMenuScreen1> {
  late ThemeData theme;
  String title = "More";

  MoreMenuScreen1State();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme = AppTheme.theme;
    my_init();
  }

  Future<void> my_init() async {
    Utils.ini_theme();

    is_logged_in = true;
    setState(() {});

    loggedUser = await Utils.get_logged_in();
    if (loggedUser.id < 1) {
      Navigator.pop(context);
      return;
    }

    is_logged_in = false;
    setState(() {});
  }

  bool is_logged_in = false;
  LoggedInUserModel loggedUser = new LoggedInUserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            MdiIcons.close,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: CustomTheme.primary,
        title: Text("More",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              margin: Spacing.fromLTRB(10, 10, 10, 10),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                childAspectRatio: 1.3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Create new garden",
                      screen: AppConfig.GardenCreateScreen),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Schedule farm activity",
                      screen: AppConfig.ComingSoon),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Create production record",
                      screen: AppConfig.ComingSoon),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Create financial record",
                      screen: AppConfig.ComingSoon), 
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Report pest case",
                      screen: AppConfig.PestCaseCreateScreen),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Suggest pest solution",
                      screen: AppConfig.ComingSoon),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Sell something",
                      screen: AppConfig.ProductAddForm),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Share a resource",
                      screen: AppConfig.ProductAddForm),
                  singleService(
                      serviceIcon: Icons.add,
                      service: "Add new worker",
                      screen: AppConfig.ComingSoon),
                  singleService(
                      serviceIcon: Icons.web, service: "Web Dashboard"),
                  singleService(serviceIcon: Icons.info, service: "About us"),
                  singleService(serviceIcon: Icons.info, service: "About us"),
                  singleService(
                      serviceIcon: Icons.contact_support,
                      service: "Contact us"),
                  singleService(serviceIcon: Icons.logout, service: "Logout"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget singleService(
      {IconData? serviceIcon, required String service, String screen: ""}) {
    return InkWell(
      onTap: () {
        if (screen == AppConfig.ComingSoon) {
          Utils.showSnackBar("Coming soon...", context, Colors.white);
          return;
        } else if (service == "Logout") {
          Utils.logged_out();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        } else if (service == "About us") {
          Utils.launchURL('https://www.mak.ac.ug/marcci');
        } else if (service == "Web Dashboard") {
          Utils.launchURL('http://' + AppConfig.BASE_URL);
        } else if (service == "Contact us") {
          Utils.launchPhone(AppConfig.OUR_PHONE_NUMBER);
        } else {
          Utils.navigate_to(
            screen,
            context,
          );
        }
        /*Navigator.push(context,
            MaterialPageRoute(builder: (context) => SingleServiceScreen()));*/
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 12,
          top: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: (service == "Logout") ? Colors.red : CustomTheme.primary,
              width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              serviceIcon,
              color: (service == "Logout") ? Colors.red : CustomTheme.primary,
              size: 40,
            ),
            Container(
              margin: Spacing.top(8),
              child: FxText(
                service,
                fontSize: 18,
                height: 1.2,
                maxLines: 2,
                color: Colors.black,
                textAlign: TextAlign.center,
                fontWeight: 700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
