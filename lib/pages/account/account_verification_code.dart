import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/models/LoggedInUserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:sms_autofill/sms_autofill.dart';

class account_verification_code extends StatefulWidget {
  @override
  _account_verification_code createState() => _account_verification_code();
}

class _account_verification_code extends State<account_verification_code> {
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
    LoggedInUserModel.update_local_user();
  }

  String code = "";

  @override
  Widget build(BuildContext context) {
    //setState(() { onLoading = false;});

    Future<void> submit_form() async {
      check_verification();
      if (!_formKey.currentState!.validate()) {
        return;
      }


      setState(() {
        onLoading = true;
        error_message = "";
      });

      check_verification();
      await LoggedInUserModel.update_local_user();
      LoggedInUserModel u = await LoggedInUserModel.get_logged_in_user();

      code = _formKey.currentState?.fields['code']?.value;

      if (u.verification_code.trim() != code.trim()) {
        await LoggedInUserModel.update_local_user();
        u = await LoggedInUserModel.get_logged_in_user();
      }

      if (u.verification_code.trim() != code.trim()) {
        setState(() {
          onLoading = false;
          error_message = "Code did not match. Enter correct code.";
        });
        return;
      }

      String _resp = await Utils.http_post('api/verify-phone', {
        'id': u.id,
        'status': 'verified',
      });

      await LoggedInUserModel.update_local_user();
      u = await LoggedInUserModel.get_logged_in_user();

      Utils.showSnackBar(
          'Account verified successfully!', context, Colors.white,
          background_color: CustomTheme.primary);
      setState(() {
        onLoading = false;
      });

      Navigator.pushNamedAndRemoveUntil(context, "/HomesScreen", (r) => false);
    }

    //256758589326
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
                        'assets/project/on-phone-2.png',
                        height:
                            ((MediaQuery.of(context).size.height / 2) - 100),
                      ),
                    ),
                  ),
                  FxSpacing.height(32),
                  FxText.h3(
                    "STEP 2 of 2",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.start,
                  ),
                  FxSpacing.height(10),
                  FxText.h3(
                    "Enter your the secret code that we have just sent to you through SMS.",
                    color: Colors.black,
                    fontWeight: 600,
                    fontSize: 16,
                    textAlign: TextAlign.start,
                  ),
                  FxSpacing.height(32),
                  FormBuilderTextField(
                      name: "code",
                      keyboardType: TextInputType.text,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "CODE required.",
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          3,
                          errorText: "CODE too short.",
                        ),
                        FormBuilderValidators.maxLength(
                          context,
                          5,
                          errorText: "CODE too long.",
                        ),
                      ]),
                      initialValue: "",
                      decoration: customTheme.input_decoration(
                          labelText: "CODE", icon: Icons.code)),
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
                            "VERIFY",
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

  Future<void> check_verification() async {
    await SmsAutoFill().listenForCode;

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
