import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

import '../../models/LoggedInUserModel.dart';

class account_verification_splash extends StatefulWidget {
  @override
  _account_verification_splash createState() => _account_verification_splash();
}

class _account_verification_splash extends State<account_verification_splash> {
  final _formKey = GlobalKey<FormBuilderState>();

  late CustomTheme customTheme;
  late ThemeData theme;
  String error_message = "";
  bool onLoading = false;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    check_verification();
  }

  @override
  Widget build(BuildContext context) {
    //setState(() { onLoading = false;});

    Future<void> submit_form() async {
      error_message = "";
      setState(() {});
      if (!_formKey.currentState!.validate()) {
        return;
      }

      onLoading = true;
      setState(() {});
      String _resp = await Utils.http_post('api/users-login', {
        'password': _formKey.currentState?.fields['password_1']?.value,
        'email': _formKey.currentState?.fields['email']?.value,
      });

      onLoading = false;
      setState(() {});

      if (_resp == null || _resp.isEmpty) {
        setState(() {
          error_message =
              "Failed to connect to internet. Please check your network and try again.";
        });
        return;
      }
      dynamic resp_obg = jsonDecode(_resp);
      if (resp_obg['status'].toString() != "1") {
        error_message = resp_obg['message'];
        setState(() {});
        return;
      }

      if (await Utils.login_user(_resp)) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/HomesScreen", (r) => false);
      } else {
        error_message = "Account failed to login. Please try again.";
        setState(() {});
      }
    }

    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
      child: Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 80, 24, 0),
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/project/verifify-1.png',
                      height: ((MediaQuery.of(context).size.height / 2) - 100),
                    ),
                  ),
                  FxSpacing.height(16),
                  FxText.h3(
                    "Account Verification",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.start,
                  ),
                  FxSpacing.height(24),
                  FxText.h3(
                    "First things first!, Let's get your account verified for you to proceed.",
                    color: Colors.black,
                    fontWeight: 600,
                    fontSize: 16,
                    textAlign: TextAlign.start,
                  ),
                  FxSpacing.height(24),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red.shade50,
                    ),
                    child: error_message.isEmpty
                        ? SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              error_message,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                  ),
                  FxSpacing.height(0),
                  onLoading
                      ? Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : FxButton.block(
                          borderRadiusAll: 8,
                          onPressed: () {
                            Utils.navigate_to(
                                AppConfig.account_verification_phone, context);
                          },
                          backgroundColor: CustomTheme.primary,
                          child: FxText.l1(
                            "Verify Account",
                            fontSize: 20,
                            color: customTheme.cookifyOnPrimary,
                          )),
                  FxSpacing.height(26),
                  FxButton.text(
                      onPressed: () {
                        _showDialog();
                      },
                      splashColor: CustomTheme.primary.withAlpha(40),
                      child: FxText.l2("Not today, Logout.",
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          color: CustomTheme.accent)),
                  FxSpacing.height(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context, builder: (BuildContext context) => _SimpleDialog());
  }

  Future<void> check_verification() async {
    await LoggedInUserModel.update_local_user();
    LoggedInUserModel _u = await LoggedInUserModel.get_logged_in_user();
    if (_u.phone_number_verified.toString() == "1") {
      Utils.showSnackBar(
          'Account verified successfully!', context, Colors.white,
          background_color: CustomTheme.primary);
      setState(() {
        onLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(context, "/HomesScreen", (r) => false);
    }
  }
}

class _SimpleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(16),
        decoration: BoxDecoration(
          color: themeData.backgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FxText.sh1(
              "Are you sure you want to logout?",
              fontWeight: 500,
            ),
            Container(
                alignment: AlignmentDirectional.centerEnd,
                child: FxButton(
                    onPressed: () {
                      Utils.logged_out();
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/HomesScreen", (r) => false);
                    },
                    backgroundColor: Colors.red,
                    borderRadiusAll: 4,
                    elevation: 0,
                    child: FxText.b2("LOGOUT",
                        letterSpacing: 0.3, color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
