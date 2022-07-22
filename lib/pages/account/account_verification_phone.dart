import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/models/LoggedInUserModel.dart';
import 'package:ict4farmers/models/RespondModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';

class account_verification_phone extends StatefulWidget {
  @override
  _account_verification_phone createState() => _account_verification_phone();
}

class _account_verification_phone extends State<account_verification_phone> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> check_verification() async {

    await LoggedInUserModel.update_local_user();

    _formKey.currentState!.patchValue({
      'phone_number': "${u.phone_number}",
    });

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

  String phone_number = "";

  @override
  Widget build(BuildContext context) {
    //setState(() { onLoading = false;});

    Future<void> submit_form() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      phone_number = _formKey.currentState?.fields['phone_number']?.value;
      error_message = "";
      setState(() {});

      if (!Utils.phone_number_is_valid(phone_number)) {
        setState(() {
          error_message =
              "Please enter a valid uganda phone number. eg. 0779 777 777 OR +256 779 777 777";
        });
        return;
      }

      phone_number = "+256" + phone_number;

      _showDialog();
      return;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      child: Image.asset(
                        'assets/project/on-phone.png',
                        height:
                            ((MediaQuery.of(context).size.height / 2) - 100),
                      ),
                    ),
                  ),
                  FxSpacing.height(32),
                  FxText.h3(
                    "STEP 1 of 2",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.start,
                  ),
                  FxSpacing.height(10),
                  FxText.h3(
                    "Enter your valid phone number where we should send you an a secret code in SMS.",
                    color: Colors.black,
                    fontWeight: 600,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(32),
                  FormBuilderTextField(
                      name: "phone_number",
                      initialValue: u.phone_number,
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Phone number required.",
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          8,
                          errorText: "Phone number too short.",
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          8,
                          errorText: "Phone number too short.",
                        ),
                        FormBuilderValidators.maxLength(
                          context,
                          15,
                          errorText: "Phone number too short.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Phone number", icon: Icons.phone)),
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
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                        )
                      : FxButton.block(
                          borderRadiusAll: 8,
                          onPressed: () {
                            submit_form();
                          },
                          backgroundColor: CustomTheme.primary,
                          child: FxText.l1(
                            "SUBMIT",
                            fontSize: 20,
                            color: customTheme.cookifyOnPrimary,
                          )),
                  FxSpacing.height(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: FxSpacing.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.sh1(
                      "Are you sure ${phone_number} is your active phone number? \n",
                      fontWeight: 500,
                    ),
                    Container(
                        alignment: AlignmentDirectional.center,
                        child: FxButton.block(
                            onPressed: () {
                              do_verification();
                              Navigator.pop(context);
                            },
                            borderRadiusAll: 4,
                            elevation: 0,
                            child: FxText.b2("YES, VERIFY",
                                letterSpacing: 0.3, color: Colors.white))),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  LoggedInUserModel u = new LoggedInUserModel();

  Future<void> do_verification() async {
    u = await LoggedInUserModel.get_logged_in_user();
    if (onLoading) {
      return;
    }
    onLoading = true;
    setState(() {});
    String _resp = await Utils.http_post('api/verify-phone', {
      'id': u.id,
      'phone_number': phone_number,
    });

    RespondModel r = RespondModel(_resp);
    await LoggedInUserModel.update_local_user();
    onLoading = false;
    setState(() {});

    if (r.code != 1) {
      setState(() {
        error_message = r.message;
      });
      return;
    }
    Utils.showSnackBar(r.message, context, Colors.white,
        background_color: CustomTheme.primary);
    Utils.navigate_to(AppConfig.account_verification_code, context);
  }
}
