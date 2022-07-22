import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widgets/images.dart';

import '../../utils/AppConfig.dart';

class AccountRegister extends StatefulWidget {
  @override
  _AccountRegisterState createState() => _AccountRegisterState();
}

class _AccountRegisterState extends State<AccountRegister> {
  final _formKey = GlobalKey<FormBuilderState>();

  late CustomTheme customTheme;
  late ThemeData theme;
  String error_message = "";
  String phone_number = "";
  bool onLoading = false;

  @override
  void initState() {
    super.initState();
    Utils.ini_theme();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
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

      error_message = "";
      setState(() {});

      phone_number = _formKey.currentState?.fields['email']?.value;
      if (!Utils.phone_number_is_valid(phone_number)) {
        setState(() {
          error_message =
              "Please enter a valid uganda phone number. eg. 0779 777 777 OR +256 779 777 777";
        });
        return;
      }
      phone_number = "+256" + phone_number;

      if (_formKey.currentState?.fields['password_2']?.value !=
          _formKey.currentState?.fields['password_1']?.value) {
        error_message = "Passwords don't match.";
        setState(() {});
        return;
      }

      onLoading = true;
      setState(() {});
      String _resp = await Utils.http_post('api/users', {
        'password': _formKey.currentState?.fields['password_1']?.value,
        'name': _formKey.currentState?.fields['name']?.value,
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

      Utils.showSnackBar("Account created successfully!. Logging you in...",
          context, Colors.white);
      await login_user();
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
                      height: 70,
                    ),
                  ),
                  FxSpacing.height(16),
                  FxText.h3(
                    "Create an Account",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(32),
                  FormBuilderTextField(
                      name: "name",
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Name is required.",
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          2,
                          errorText: "Name too short.",
                        ),
                        FormBuilderValidators.maxLength(
                          context,
                          45,
                          errorText: "Name too long.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Your Full Name", icon: Icons.person)),
                  FxSpacing.height(24),
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
                    textInputAction: TextInputAction.next,
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
                  FormBuilderTextField(
                      name: "password_2",
                      textInputAction: TextInputAction.done,
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
                          labelText: "Re-enter Password",
                          icon: Icons.lock_outline)),
                  FxSpacing.height(16),

                  FxButton.text(
                      onPressed: () {
                        Utils.navigate_to(AppConfig.PrivacyPolicy, context);
                      },
                      splashColor: CustomTheme.primary.withAlpha(40),
                      child: FxText.l2("I have read and agreed with Privacy Policy  of ${AppConfig.AppName}.",
                          textAlign: TextAlign.center,
                          decoration: TextDecoration.underline,
                          color: CustomTheme.primary)),

                  Container(
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
                  FxSpacing.height(16),
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
                            "Create an Account",
                            color: customTheme.cookifyOnPrimary,
                          )),
                  FxSpacing.height(16),
                  FxButton.text(
                      onPressed: () {
                        Utils.navigate_to(AppConfig.AccountLogin, context);
                      },
                      splashColor: CustomTheme.primary.withAlpha(40),
                      child: FxText.l2("I already have an account",
                          fontSize: 14, color: CustomTheme.accent)),
                  FxSpacing.height(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login_user() async {
    error_message = "";
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
      Utils.showSnackBar("Logged in successfully!", context, Colors.white);
      Navigator.pushNamedAndRemoveUntil(context, "/HomesScreen", (r) => false);
    } else {
      Utils.showSnackBar("Log in now.", context, Colors.white,
          background_color: Colors.red);
      error_message = "Account failed to login. Please try again.";
      Utils.navigate_to(AppConfig.AccountLogin, context);
      setState(() {});
    }
  }
}
