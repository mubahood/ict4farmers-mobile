import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widgets/images.dart';

import '../../utils/AppConfig.dart';

class AccountLogin extends StatefulWidget {
  @override
  _AccountLogin createState() => _AccountLogin();
}

class _AccountLogin extends State<AccountLogin> {
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
  }

  String phone_number = "";

  @override
  Widget build(BuildContext context) {
    //setState(() { onLoading = false;});

    Future<void> submit_form() async {
      error_message = "";
      setState(() {});
      if (!_formKey.currentState!.validate()) {
        return;
      }

      phone_number = _formKey.currentState?.fields['email']?.value;
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

      onLoading = true;
      setState(() {});
      String _resp = await Utils.http_post('api/users-login', {
        'password': _formKey.currentState?.fields['password_1']?.value,
        'email': phone_number,
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
                      Images.logo_1,
                      height: 100,
                    ),
                  ),
                  FxSpacing.height(16),
                  FxText.h3(
                    "Sign In",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(32),
                  FormBuilderTextField(
                      name: "email",
                      textInputAction: TextInputAction.next,
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
                  FormBuilderTextField(
                    name: "password_1",
                    keyboardType: TextInputType.visiblePassword,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "Password is required.",
                      ),
                      FormBuilderValidators.minLength(
                        context,
                        2,
                        errorText: "Password too short.",
                      ),
                      FormBuilderValidators.maxLength(
                        context,
                        45,
                        errorText: "Password too long.",
                      ),
                    ]),
                    decoration: customTheme.input_decoration(
                        labelText: "Password", icon: Icons.lock_outline),
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
                        submit_form();
                      },
                      backgroundColor: CustomTheme.primary,
                      child: FxText.l1(
                        "Sign in",
                        fontSize: 20,
                        color: customTheme.cookifyOnPrimary,
                      )),
                  FxSpacing.height(16),
                  FxButton.text(
                      onPressed: () {
                        Utils.navigate_to(AppConfig.AccountRegister, context);

                      },
                      splashColor: CustomTheme.primary.withAlpha(40),
                      child: FxText.l2("I don't have account, create account",
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
}
