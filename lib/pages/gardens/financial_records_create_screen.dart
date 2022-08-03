import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ict4farmers/models/GardenModel.dart';
import 'package:ict4farmers/models/WorkerModel.dart';
import 'package:ict4farmers/pages/option_pickers/single_option_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/FormItemModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../models/option_picker_model.dart';
import '../../theme/app_notifier.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../location_picker/location_main.dart';

class FinancialRecordsCreateScreen extends StatefulWidget {
  dynamic params;

  FinancialRecordsCreateScreen(this.params);

  @override
  State<FinancialRecordsCreateScreen> createState() =>
      FinancialRecordsCreateScreenState();
}

late CustomTheme customTheme;

class FinancialRecordsCreateScreenState
    extends State<FinancialRecordsCreateScreen> {
  String nature_of_off = "";
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    my_init();
  }

  @override
  void dipose() {}

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    String _title = "Creating financial record";
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // remove back button in appbar.
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: 1,
          titleSpacing: 0,
          title: FxContainer(
            borderRadiusAll: 0,
            color: CustomTheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: FxSpacing.x(0),
                      child: Icon(
                        CupertinoIcons.clear,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText(
                        _title,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: 500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FormBuilder(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => {pick_a_garden()},
                            child: Container(
                              padding: FxSpacing.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FxSpacing.width(16),
                                  Expanded(
                                    child: FxText.b1(
                                      'Select an enterprise',
                                      fontSize: 18,
                                      fontWeight: 500,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        FxText(
                                          garden_text,
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
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              top: 5,
                              right: 15,
                            ),
                            child: Column(
                              children: [
                                FxDashedDivider(
                                  color: Colors.grey.shade300,
                                ),
                                FormBuilderDropdown(
                                  dropdownColor: Colors.white,
                                  name: 'type',
                                  decoration: customTheme.input_decoration_2(
                                    labelText: "Transaction type",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context)
                                  ]),
                                  items: [
                                    'Income',
                                    'Expenditure',
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
                                FormBuilderTextField(
                                    name: "amount",
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        context,
                                        errorText: "Amount is required.",
                                      ),
                                    ]),
                                    decoration: customTheme.input_decoration_2(
                                        labelText: "Amount",
                                        hintText:
                                            "How much was involved in this transaction?")),
                                FxDashedDivider(
                                  color: Colors.grey.shade300,
                                ),
                                FormBuilderTextField(
                                    name: "details",
                                    minLines: 3,
                                    maxLines: 4,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        context,
                                        errorText: "Description is required.",
                                      ),
                                      FormBuilderValidators.minLength(
                                        context,
                                        3,
                                        errorText: "Transaction too short.",
                                      ),
                                    ]),
                                    decoration: customTheme.input_decoration_2(
                                        labelText: "Transaction description",
                                        hintText:
                                            "Write something about this activity")),
                              ],
                            ),
                          ),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 20,
                              right: 20,
                            ),
                            child: (is_uploading)
                                ? CircularProgressIndicator(
                                    color: CustomTheme.primary,
                                    strokeWidth: 2,
                                  )
                                : FxButton.block(
                                    borderRadiusAll: 8,
                                    onPressed: () {
                                      do_upload_process();
                                    },
                                    backgroundColor: CustomTheme.primary,
                                    child: FxText.l1(
                                      "SUBMIT",
                                      fontSize: 20,
                                      color: customTheme.cookifyOnPrimary,
                                    )),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  final _formKey = GlobalKey<FormBuilderState>();
  String error_message = "";
  List<String> photos_picked = [AppConfig.form_field_image_picker];

  List<FormItemModel> form_data_to_upload = [];

  String garden_id = "";
  String worker_text = "";
  String worker_id = "";
  String garden_text = "";
  String location_sub_name = "";
  String location_id = "";
  bool is_uploading = false;

  Future<void> pick_location() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationMain()),
    );

    if (result != null) {
      if ((result['location_sub_id'] != null) &&
          (result['location_sub_name'] != null)) {
        location_sub_name = result['location_sub_name'];
        location_id = result['location_sub_id'];
        setState(() {});
      }
    }
  }

  Future<void> pick_a_worker() async {
    if (workers.isEmpty) {
      workers = await WorkerModel.get_items();
    }

    List<OptionPickerModel> local_items = [];

    OptionPickerModel item = new OptionPickerModel();
    item.parent_id = "1";
    item.id = logged_in_user.id.toString();
    item.name = "Me";
    local_items.add(item);

    workers.forEach((element) {
      OptionPickerModel item = new OptionPickerModel();
      item.parent_id = "1";
      item.id = element.id.toString();
      item.name = element.name.toString();
      local_items.add(item);
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SingleOptionPicker("Select a worker", local_items)),
    );

    if (result != null) {
      if ((result['id'] != null) && (result['text'] != null)) {
        worker_id = result['id'].toString();
        worker_text = result['text'];
        setState(() {});
      }
    }
  }

  Future<void> pick_a_garden() async {
    if (gardens.isEmpty) {
      gardens = await GardenModel.get_items();
    }
    if (gardens.isEmpty) {
      Utils.showSnackBar(
          "Please connect to internet and try again.", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    List<OptionPickerModel> local_items = [];

    gardens.forEach((element) {
      OptionPickerModel item = new OptionPickerModel();
      item.parent_id = "1";
      item.id = element.id.toString();
      item.name = element.name.toString();
      local_items.add(item);
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SingleOptionPicker("Select an enterprise", local_items)),
    );

    if (result != null) {
      if ((result['id'] != null) && (result['text'] != null)) {
        garden_id = result['id'];
        garden_text = result['text'];
        setState(() {});
      }
    }
  }

  void do_upload_process() async {
    error_message = "";
    setState(() {});
    if (!_formKey.currentState!.validate()) {
      Utils.showSnackBar("Please Check errors in the form and fix them first.",
          context, Colors.white,
          background_color: Colors.red);
      return;
    }

    Map<String, dynamic> form_data_map = {};
    form_data_to_upload.clear();
    if (garden_id.isEmpty) {
      Utils.showSnackBar(
          "Please select an enterprise.", context, CustomTheme.onPrimary);
      return;
    }

    LoggedInUserModel userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      Utils.showSnackBar(
          "Login before  you proceed.", context, CustomTheme.onPrimary);
      return;
    }

    form_data_map['created_by'] = userModel.id.toString();
    form_data_map['garden_id'] = garden_id.toString();
    String type = _formKey.currentState?.fields['type']?.value;
    int amount =
        Utils.int_parse(_formKey.currentState?.fields['amount']?.value);

    form_data_map["description"] =
        _formKey.currentState?.fields['details']?.value;

    if (amount < 1) {
      amount = (-1) * (amount);
    }

    if (type == 'Expenditure') {
      amount = (-1) * amount;
    }
    form_data_map['amount'] = amount;

    var formData = FormData.fromMap(form_data_map);
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    setState(() {
      is_uploading = true;
    });

    var response = await dio.post('${AppConfig.BASE_URL}/api/financial-records',
        data: formData);

    setState(() {
      is_uploading = false;
    });

    if (response == null) {
      Utils.showSnackBar("Failed to upload product. Please try again.", context,
          Colors.red.shade700);
      return;
    }

    if (response.data['status'] == null) {
      Utils.showSnackBar("Failed to upload product. Please try again.", context,
          Colors.red.shade700);
      return;
    }

    if (response.data['status'].toString() != '1') {
      Utils.showSnackBar(
          response.data['message'].toString(), context, Colors.red.shade700);
      return;
    }

    Navigator.pop(context, {"task": 'success'});

    Utils.showSnackBar(
        response.data['message'].toString(), context, Colors.white);
  }

  do_pick_image() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    images?.forEach((element) {
      if (element.path == null) {
        return;
      }
      if (photos_picked.length < 16) {
        photos_picked.add(element.path);
      }
      // /data/user/0/jotrace.com/cache/image_picker3734385312125071389.jpg
    });
    setState(() {});
  }

  void romove_image_at(int image_position) {
    photos_picked.removeAt((image_position));
    setState(() {});
  }

  Future<void> pick_gps() async {
    Position p = await Utils.get_device_location();
    if (p != null) {
      latitude = p.latitude;
      longitude = p.longitude;
      setState(() {});
    }
  }

  List<GardenModel> gardens = [];
  List<WorkerModel> workers = [];
  LoggedInUserModel logged_in_user = new LoggedInUserModel();

  void my_init() async {
    logged_in_user = await Utils.get_logged_in();

    if (widget.params != null) {
      if (widget.params['garden_id'] != null) {
        garden_id = widget.params['garden_id'].toString();
      }
    }

    gardens = await GardenModel.get_items();
    workers = await WorkerModel.get_items();

    if (!garden_id.isEmpty) {
      gardens.forEach((element) {
        if (element.id.toString() == garden_id.toString()) ;
        garden_text = element.name;
      });
    }

    setState(() {});
  }
}
