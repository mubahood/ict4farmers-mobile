import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widgets/images.dart';

Widget not_logged_screen(context) {
  return Container(
    margin: FxSpacing.fromLTRB(24, 30, 24, 20),
    child: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Image.asset(
            Images.logo_1,
            height: 80,
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 8),
          child: FxText.sh1(
              "Sell your farm products, Chat with experts, Compare farm products prices, Manage your farms and much more...",
              textAlign: TextAlign.center,
              fontWeight: 600,
              letterSpacing: 0),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: FxButton.outlined(
              borderColor: CustomTheme.accent,
              borderRadiusAll: 11,
              splashColor: CustomTheme.primary.withAlpha(40),
              padding: FxSpacing.y(10),
              onPressed: () {
                Utils.navigate_to(AppConfig.AccountRegister, context);
              },
              child: FxText.l1(
                "Register",
                fontSize: 20,
                color: CustomTheme.accent,
                letterSpacing: 0.5,
              ),
            )),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: FxButton(
              elevation: 0,
              padding: FxSpacing.y(12),
              borderRadiusAll: 4,
              onPressed: () {
                Utils.navigate_to(AppConfig.AccountLogin, context);
              },
              child: FxText.l1(
                "LOG IN",
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              backgroundColor: CustomTheme.primary,
            )),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              singleOption(context, AppTheme.theme,
                  iconData: Icons.security,
                  option: "Privacy policy",
                  navigation: AppConfig.PrivacyPolicy),
              Divider(),
              singleOption(context, AppTheme.theme,
                  iconData: Icons.info,
                  option: "About this App",
                  navigation: AppConfig.PrivacyPolicy),
              Divider(),
              singleOption(context, AppTheme.theme,
                  iconData: Icons.call,
                  option: "Toll free",
                  navigation: AppConfig.PrivacyPolicy),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.facebook,
                        size: 30,
                        color: Colors.blue.shade800,
                      ),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade500, width: 1),
                          color: AppTheme.lightTheme.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        MdiIcons.twitter,
                        size: 30,
                        color: Colors.blue.shade500,
                      ),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade500, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        MdiIcons.instagram,
                        size: 30,
                        color: Colors.purple.shade300,
                      ),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade500, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        MdiIcons.youtube,
                        size: 30,
                        color: Colors.red.shade500,
                      ),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade500, width: 1),
                          color: AppTheme.lightTheme.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: double.infinity,
                child: Text(
                  "(C) ${AppConfig.AppName} 2022",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget singleOption(_context, theme,
    {IconData? iconData,
    required String option,
    String navigation: "",
    String badge: ""}) {
  return Container(
    padding: FxSpacing.y(10),
    child: InkWell(
      onTap: () {
        /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );

          return;*/
        if (navigation == AppConfig.ProductAddForm) {
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
              size: 30,
              color: CustomTheme.primary,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: FxText.b1(
              option,
              fontWeight: 600,
              fontSize: 18,
            ),
          ),
          Container(
            child: Row(
              children: [
                badge.toString().isEmpty
                    ? SizedBox()
                    : FxContainer(
                        paddingAll: 5,
                        borderRadiusAll: 30,
                        color: Colors.red.shade500,
                        child: Text(
                          "12",
                          style: TextStyle(color: Colors.white),
                        )),
                Icon(MdiIcons.chevronRight,
                    size: 30, color: CustomTheme.primary),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
