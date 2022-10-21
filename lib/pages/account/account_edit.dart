import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ict4farmers/pages/location_picker/location_main.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/FarmersGroup.dart';
import '../../models/LocationModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../widget/shimmer_loading_widget.dart';
import '../location_picker/product_category_picker.dart';
import '../location_picker/single_item_picker.dart';

class AccountEdit extends StatefulWidget {
  @override
  _AccountEditState createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  final _formKey = GlobalKey<FormBuilderState>();

  late CustomTheme customTheme;
  late ThemeData theme;
  String error_message = "";

  bool onLoading = false;

  LoggedInUserModel item = new LoggedInUserModel();

  Future<void> get_location() async {
    Position p = await Utils.get_device_location();
    if (p != null) {
      if (p.latitude != null && p.longitude != null) {
        item.longitude = p.latitude.toString();
        item.longitude = p.longitude.toString();
        _formKey.currentState!.patchValue({
          'gps': "${item.longitude},${item.longitude}",
        });
      }
    }
  }

  List<LocationModel> locations = [];

  Future<void> my_init() async {
    item = await Utils.get_logged_in();

    locations = await LocationModel.get_items();

    if (item.date_of_birth != null) {
      if (item.date_of_birth.length > 3) {
        try {
          DateTime dob = DateTime.parse(item.date_of_birth);
          _formKey.currentState!.patchValue({
            'date_of_birth': dob,
          });
        } catch (e) {}
      }
    }

    locations.forEach((loc_1) {
      if (loc_1.id.toString() == item.sub_county) {
        locations.forEach((loc_2) {
          if (loc_2.id.toString() == loc_1.parent.toString()) {
            _formKey.currentState!.patchValue({
              'district': "${loc_2.name}, ${loc_1.name}",
            });
          }
        });
      }
    });

    //item.district = result['location_sub_name'];
    //item.sub_county = result['location_sub_id'];

    if (item.id < 1) {
      Utils.showSnackBar("Login before you proceed.", context, Colors.red);
      Navigator.pop(context);
      return;
    }

    if (item.latitude == "null" ||
        item.longitude == "null" ||
        item.latitude.isEmpty ||
        item.longitude.isEmpty) {
      //get_location();
    }

    if ((item.gender != "Male") && (item.gender != "Female")) {
      item.gender = "";
    }

    if ((item.marital_status == "Single") ||
        (item.marital_status == "Married")) {
      _formKey.currentState!.patchValue({
        'marital_status': item.marital_status,
      });
    }

    _formKey.currentState!.patchValue({
      'name': item.name,
      'email': item.email,
      'gender': item.gender,
      'experience': item.experience,
    });

    if ([
      'Basic user',
      'Farmer',
      'Service provider',
    ].contains(item.user_role)) {
      _formKey.currentState!.patchValue({
        'user_role': item.user_role,
      });
    }

    if ([
      'No any access',
      'SACCO',
      'Bank',
      'VSLA',
      'Family',
    ].contains(item.access_to_credit)) {
      _formKey.currentState!.patchValue({
        'access_to_credit': item.access_to_credit,
      });
    }

    if ([
      'Subsistence production',
      'Small Commercial Production',
      'Large Commercial Production',
    ].contains(item.production_scale)) {
      _formKey.currentState!.patchValue({
        'production_scale': item.production_scale,
      });
    }

    if ([
      'Crop farming',
      'Livestock farming',
      'Fisheries',
    ].contains(item.sector)) {
      _formKey.currentState!.patchValue({
        'sector': item.sector,
      });
    }

    farmers_groups = await FarmersGroup.get_items();
    farmers_groups.forEach((element) {
      if (element.id.toString() == item.region.toString()) {
        _formKey.currentState!.patchValue({
          'farm_group_text': element.name.toString(),
        });
      }
    });

    _formKey.currentState!.patchValue({
      'sectors': Utils.json_to_list(item.sector),
    });

    print("============MY INIT==========");

    setState(() {});
  }

  List<FarmersGroup> farmers_groups = [];
  List<String> sectors = [];

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    // setState(() { onLoading = false;});

    Future<void> submit_form() async {
      error_message = "";
      setState(() {});
      if (!_formKey.currentState!.validate()) {
        Utils.showSnackBar(
            "Please Check errors in the form and fix them first.",
            context,
            Colors.white,
            background_color: Colors.red);

        return;
      }

      Map<String, dynamic> form_data_map = {};

      form_data_map = {
        'name': _formKey.currentState?.fields['name']?.value,
        'email': _formKey.currentState?.fields['email']?.value,
        'user_id': item.id.toString(),
        'gender': _formKey.currentState?.fields['gender']?.value,
        'marital_status':
            _formKey.currentState?.fields['marital_status']?.value,
        'date_of_birth': _formKey.currentState?.fields['date_of_birth']?.value,
        'user_role': _formKey.currentState?.fields['user_role']?.value,
        'experience': _formKey.currentState?.fields['experience']?.value,
        'production_scale':
            _formKey.currentState?.fields['production_scale']?.value,
        'access_to_credit':
            _formKey.currentState?.fields['access_to_credit']?.value,
        'sub_county': item.sub_county,
        'sector': jsonEncode(_formKey.currentState?.fields['sectors']?.value),
      };

      if ((new_dp != null) && new_dp.length > 4) {
        try {
          var img =
              await MultipartFile.fromFile(new_dp, filename: 'profile_pic');
          if (img != null) {
            form_data_map['profile_pic'] = img;
          }
        } catch (e) {}
      }

      onLoading = true;
      setState(() {});
      String _resp = await Utils.http_post('api/users-update', form_data_map);
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

        Utils.showSnackBar(error_message, context, Colors.white,
            background_color: CustomTheme.primary);

        setState(() {});
        return;
      }
      await LoggedInUserModel.update_local_user();

      onLoading = false;
      setState(() {});
      Navigator.pop(context);
      Utils.showSnackBar(
          "Profile updated successfully!.", context, Colors.white,
          background_color: CustomTheme.primary);
      return;

      Utils.showSnackBar(
          "Profile updated successfully!.", context, Colors.white,
          background_color: CustomTheme.primary);

      //await Utils.login_user(u);
      if (await Utils.login_user(_resp)) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/HomesScreen", (r) => false);
      } else {
        error_message =
            "Account created but failed to login. Please try again.";
        setState(() {});
      }
    }

    /*

    facebook
    twitter
    whatsapp
    instagram

----
cover_photo
avatar
username
password

     */
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
      child: Scaffold(
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
                  "My Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  submit_form();
                },
                child: Container(
                    padding: FxSpacing.x(0),
                    child: onLoading
                        ? Text("Loading...")
                        : Icon(
                            Icons.done,
                            color: Colors.white,
                          )),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: FxSpacing.fromLTRB(20, 10, 20, 0),
          children: [
            FutureBuilder(
                future: my_init(),
                builder: (context, snapshot) => FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: <Widget>[
                                FxContainer.rounded(
                                  paddingAll: 0,
                                  width: 100,
                                  height: 100,
                                  child: (new_dp.length > 3)
                                      ? Image.file(
                                          File(new_dp),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : CachedNetworkImage(
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: item.avatar,
                                          placeholder: (context, url) =>
                                              ShimmerLoadingWidget(
                                            height: 100,
                                            width: 100,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image(
                                            image: AssetImage(
                                                './assets/project/no_image.jpg'),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                FxSpacing.height(8),
                                FxButton.text(
                                    onPressed: () {
                                      _show_bottom_sheet_photo(context);
                                    },
                                    splashColor:
                                        CustomTheme.primary.withAlpha(40),
                                    child: FxText.l2("Change Photo",
                                        fontSize: 14,
                                        textAlign: TextAlign.center,
                                        color: CustomTheme.accent)),
                              ],
                            ),
                          ),
                          FxSpacing.height(15),
                          FormBuilderTextField(
                              name: "name",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
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
                              decoration: customTheme.input_decoration_2(
                                  labelText: "Full name",
                                  hintText: "What is your name?")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderTextField(
                              name: "email",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Email address is required.",
                                ),
                                FormBuilderValidators.minLength(
                                  context,
                                  5,
                                  errorText: "Email address too short.",
                                ),
                                FormBuilderValidators.maxLength(
                                  context,
                                  30,
                                  errorText: "Email address too long.",
                                ),
                              ]),
                              decoration: customTheme.input_decoration_2(
                                  labelText: "Email address",
                                  hintText: "You will use this to login")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderDropdown(
                            dropdownColor: Colors.white,
                            name: 'gender',
                            decoration: customTheme.input_decoration_2(
                              labelText: "Gender",
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: "Gender is required.",
                              )
                            ]),
                            items: [
                              '',
                              'Male',
                              'Female',
                            ]
                                .map((tyepe) => DropdownMenuItem(
                                      value: tyepe,
                                      child: Text('$tyepe'),
                                    ))
                                .toList(),
                          ),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderDropdown(
                            dropdownColor: Colors.white,
                            name: 'marital_status',
                            decoration: customTheme.input_decoration_2(
                              labelText: "Marital status",
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: "Marital status is required.",
                              )
                            ]),
                            items: [
                              'Single',
                              'Married',
                            ]
                                .map((tyepe) => DropdownMenuItem(
                                      value: tyepe,
                                      child: Text('$tyepe'),
                                    ))
                                .toList(),
                          ),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderDateTimePicker(
                              name: "date_of_birth",
                              textInputAction: TextInputAction.next,
                              inputType: InputType.date,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Date of birth is required.",
                                ),
                              ]),
                              decoration: customTheme.input_decoration_2(
                                  labelText: "Date of birth",
                                  hintText: "When were you born?")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderTextField(
                              name: "district",
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              onTap: () => {pick_location()},
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Location is required.",
                                ),
                              ]),
                              decoration: customTheme.input_decoration_2(
                                  labelText: "Location",
                                  hintText: "Where do you mainly live?")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderDropdown(
                            dropdownColor: Colors.white,
                            name: 'user_role',
                            decoration: customTheme.input_decoration_2(
                              labelText: "User role",
                            ),
                            onChanged: (c) => {OnUserTypeChange(c.toString())},
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: "User type is required.",
                              )
                            ]),
                            items: [
                              'Basic user',
                              'Farmer',
                              'Service provider',
                            ]
                                .map((tyepe) => DropdownMenuItem(
                                      value: tyepe,
                                      child: Text('$tyepe'),
                                    ))
                                .toList(),
                          ),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          (user_role == "Farmer")
                              ? InkWell(
                                  onTap: () => {prick_farmer_group()},
                                  child: Container(
                                    padding: FxSpacing.only(
                                        top: 20,
                                        bottom: 20,
                                        right: 15,
                                        left: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        FxSpacing.width(0),
                                        Expanded(
                                          child: FxText.b1(
                                            'Select farmer organization',
                                            fontSize: 18,
                                            fontWeight: 500,
                                            color: Colors.grey.shade900,
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              FxText(
                                                group_text,
                                                maxLines: 2,
                                                color: Colors.grey.shade500,
                                              ),
                                              Icon(CupertinoIcons.right_chevron,
                                                  size: 22,
                                                  color: Colors.grey.shade600),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          (user_role == "Farmer")
                              ? FormBuilderCheckboxGroup<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: customTheme.input_decoration_2(
                                    labelText:
                                        "Select your sectors of specialization",
                                  ),
                                  name: 'sectors',
                                  options: const [
                                    FormBuilderFieldOption(
                                        value: 'Crop farming'),
                                    FormBuilderFieldOption(
                                        value: 'Livestock farming'),
                                    FormBuilderFieldOption(value: 'Fisheries'),
                                  ],
                                  separator: const VerticalDivider(
                                    width: 10,
                                    thickness: 5,
                                    color: Colors.red,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                      errorText: "Sectors are required.",
                                    )
                                  ]),
                                )
                              : SizedBox(),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          (user_role == "Farmer")
                              ? FormBuilderTextField(
                                  name: "experience",
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                      errorText: "Experience is required.",
                                    ),
                                  ]),
                                  decoration: customTheme.input_decoration_2(
                                      labelText: "Years of Experience",
                                      hintText:
                                          "How long have you spent the selector"))
                              : SizedBox(),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          (user_role == "Farmer")
                              ? FormBuilderDropdown(
                                  dropdownColor: Colors.white,
                                  name: 'production_scale',
                                  decoration: customTheme.input_decoration_2(
                                    labelText: "Production scale",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                      errorText:
                                          "Production scale is required.",
                                    )
                                  ]),
                                  items: [
                                    'Subsistence production',
                                    'Small Commercial Production',
                                    'Large Commercial Production',
                                  ]
                                      .map((tyepe) => DropdownMenuItem(
                                            value: tyepe,
                                            child: Text('$tyepe'),
                                          ))
                                      .toList(),
                                )
                              : SizedBox(),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          (user_role == "Farmer")
                              ? FormBuilderDropdown(
                                  dropdownColor: Colors.white,
                                  name: 'access_to_credit',
                                  decoration: customTheme.input_decoration_2(
                                    labelText: "Do you have access to credit?",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                      errorText: "This field is required.",
                                    )
                                  ]),
                                  items: [
                                    'No any access',
                                    'SACCO',
                                    'Bank',
                                    'VSLA',
                                    'Family',
                                  ]
                                      .map((tyepe) => DropdownMenuItem(
                                            value: tyepe,
                                            child: Text('$tyepe'),
                                          ))
                                      .toList(),
                                )
                              : SizedBox(),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                      style:
                                          TextStyle(color: Colors.red.shade800),
                                    ),
                                  ),
                          ),
                          FxSpacing.height(10),
                          onLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                )
                              : FxButton.block(
                                  borderRadiusAll: 8,
                                  onPressed: () {
                                    submit_form();
                                  },
                                  backgroundColor: CustomTheme.primary,
                                  child: FxText.l1(
                                    "UPDATE PROFILE",
                                    color: customTheme.cookifyOnPrimary,
                                  )),
                          /* FxSpacing.height(16),
                      FxButton.text(
                          onPressed: () {
                            logout();
                          },
                          splashColor: CustomTheme.primary.withAlpha(40),
                          child: FxText.l2(
                              "I will do this later. Log out.",
                              fontSize: 14,
                              textAlign: TextAlign.center,
                              color: CustomTheme.accent)),*/
                          FxSpacing.height(16),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  Future<void> pick_category() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductCategoryPicker()),
    );

    if (result != null) {
      if ((result['category_id'] != null) &&
          (result['category_text'] != null)) {
        item.category_id = result['category_id'];
        item.division = result['category_text'];
        _formKey.currentState!.patchValue({
          'division': item.division,
        });
      }
    }
  }

  Future<void> pick_location() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationMain()),
    );

    if (result != null) {
      if ((result['location_sub_id'] != null) &&
          (result['location_sub_name'] != null)) {
        item.district = result['location_sub_name'];
        item.sub_county = result['location_sub_id'];
        _formKey.currentState!.patchValue({
          'district': item.district,
        });
      }
    }
  }

  void _show_bottom_sheet_photo(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () => {do_pick_image("camera")},
                      dense: false,
                      leading: Icon(Icons.camera_alt,
                          color: theme.colorScheme.onBackground),
                      title: FxText.b1("Camera", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () => {do_pick_image("gallery")},
                        leading: Icon(Icons.photo_library_sharp,
                            color: theme.colorScheme.onBackground),
                        title: FxText.b1("Gallery", fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<XFile>? temp_images = [];

  String new_dp = "";

  do_pick_image(String source) async {
    Navigator.pop(context);

    new_dp = "";

    final ImagePicker _picker = ImagePicker();
    temp_images = [];
    if (source == "camera") {
      final XFile? pic = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      if (pic != null) {
        temp_images?.add(pic);
      }
    } else {
      final XFile? pic = await _picker.pickImage(source: ImageSource.gallery);
      if (pic != null) {
        temp_images?.add(pic);
      }
    }

    temp_images?.forEach((element) {
      if (element.path == null) {
        return;
      }
      new_dp = element.path;
    });

    setState(() {});
  }

  String group_text = "";
  String group_id = "";

  prick_farmer_group() async {
    farmers_groups = await FarmersGroup.get_items();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleItemPicker(
          "Pick farmer organization",
          jsonEncode(farmers_groups),
          "0",
        ),
      ),
    );

    if (result != null) {
      if (result['id'] != null && result['name'] != null) {
        group_id = result['id'].toString();
        group_text = result['name'].toString();
        setState(() {});
      }
    }
  }

  String user_role = "";

  OnUserTypeChange(String c) {
    user_role = c.toString();
    setState(() {});
  }

  Future<void> logout() async {
    await Utils.logged_out();
    Navigator.pushNamedAndRemoveUntil(context, "/HomesScreen", (r) => false);
  }
}
