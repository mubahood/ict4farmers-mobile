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
import 'package:ict4farmers/models/LoggedInUserModel.dart';
import 'package:ict4farmers/models/PestModel.dart';
import 'package:ict4farmers/pages/option_pickers/single_option_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/FormItemModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/option_picker_model.dart';
import '../../theme/app_notifier.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../location_picker/location_main.dart';

class WorkerCreateScreen extends StatefulWidget {
  @override
  State<WorkerCreateScreen> createState() => WorkerCreateScreenState();
}

late CustomTheme customTheme;

class WorkerCreateScreenState extends State<WorkerCreateScreen> {
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

    String _title = "Adding new worker";
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
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
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
                                  hintText:
                                      "What is the name of this employee?")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderTextField(
                              name: "phone",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Phone number is required.",
                                ),
                              ]),
                              decoration: customTheme.input_decoration_2(
                                  labelText: "Phone number",
                                  hintText:
                                      "What is the Phone number of this employee?")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          FormBuilderTextField(
                              name: "password",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Password is required.",
                                ),
                              ]),
                              decoration: customTheme.input_decoration_2(
                                  labelText: "Password",
                                  hintText:
                                      "Password the employee will use to login ")),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 0,
                              top: 5,
                              right: 0,
                            ),
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                    name: "description",
                                    minLines: 5,
                                    maxLines: 6,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        context,
                                        errorText:
                                            "about the employee is required.",
                                      ),
                                      FormBuilderValidators.minLength(
                                        context,
                                        5,
                                        errorText: "About too short.",
                                      ),
                                    ]),
                                    decoration: customTheme.input_decoration_2(
                                        labelText: "Worker's details",
                                        hintText:
                                            "Write something about this worker")),
                              ],
                            ),
                          ),
                          FxDashedDivider(
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            color: Colors.white,
                            child: Text("Add photo of this worker."),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return single_image_picker(
                        index, photos_picked[index].toString(), context);
                  },
                  childCount: photos_picked.length,
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

  Widget single_image_picker(int index, String _item, BuildContext context) {
    return (_item == AppConfig.form_field_image_picker)
        ? InkWell(
            onTap: () => {_show_bottom_sheet_photo(context)},
            child: Container(
                margin: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomTheme.primary,
                      width: 1,
                      style: BorderStyle.solid),
                  color: CustomTheme.primary.withAlpha(25),
                ),
                padding: EdgeInsets.all(0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 35, color: CustomTheme.primary),
                      Center(child: Text("add photo")),
                    ])))
        : Stack(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomTheme.primary,
                      width: 1,
                      style: BorderStyle.solid),
                  color: CustomTheme.primary.withAlpha(25),
                ),
                padding: EdgeInsets.all(0),
                child: Image.file(
                  File(_item),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                  child: InkWell(
                    onTap: () => {romove_image_at(index)},
                    child: Container(
                      child: FxContainer(
                        width: 35,
                        alignment: Alignment.center,
                        borderRadiusAll: 17,
                        height: 35,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        color: Colors.red.shade700,
                        paddingAll: 0,
                      ),
                    ),
                  ),
                  right: 0),
            ],
          );
  }

  List<FormItemModel> form_data_to_upload = [];

  String garden_id = "";
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

  String pest_id = "";
  String pest_text = "";

  List<PestModel> pests = [];

  Future<void> pick_a_pest() async {
    if (pests.isEmpty) {
      pests = await PestModel.get_items();
    }
    if (pests.isEmpty) {
      Utils.showSnackBar(
          "Please connect to internet and try again.", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    List<OptionPickerModel> local_items = [];

    pests.forEach((element) {
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
              SingleOptionPicker("Select a pest", local_items)),
    );

    if (result != null) {
      if ((result['id'] != null) && (result['text'] != null)) {
        pest_id = result['id'];
        pest_text = result['text'];
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
              SingleOptionPicker("Select a farm", local_items)),
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
    form_data_to_upload = await FormItemModel.get_all();

    LoggedInUserModel userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      Utils.showSnackBar(
          "Login before  you proceed.", context, CustomTheme.onPrimary);
      return;
    }

    form_data_map['owner_id'] = userModel.id;

    form_data_map["about"] =
        _formKey.currentState?.fields['description']?.value;

    form_data_map["phone_number"] =
        _formKey.currentState?.fields['phone']?.value;

    form_data_map["password"] =
        _formKey.currentState?.fields['password']?.value;

    form_data_map["name"] =
        _formKey.currentState?.fields['name']?.value;



    setState(() {
      is_uploading = true;
    });
    var formData = FormData.fromMap(form_data_map);
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };


    var response =
        await dio.post('${AppConfig.BASE_URL}/api/workers', data: formData);

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
          response.data['message'].toString(), context, Colors.white,
          background_color: Colors.red.shade700);
      return;
    } else {
      Utils.showSnackBar(
          response.data['message'].toString(), context, Colors.white,
          background_color: Colors.green.shade700);
    }
    Navigator.pop(context, {"task": 'success'});
  }

  void _show_bottom_sheet_photo(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () => {do_pick_image_from_camera()},
                      dense: false,
                      leading: Icon(
                        Icons.camera_alt,
                      ),
                      title: FxText.b1("Camera", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () => {do_pick_image()},
                        leading: Icon(
                          Icons.photo_library_sharp,
                        ),
                        title: FxText.b1("Gallery", fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  do_pick_image_from_camera() async {
    Navigator.pop(context);
    if (photos_picked.length > 2) {
      Utils.showSnackBar('Too many photos.', context, Colors.red.shade700);
      return;
    }

    final ImagePicker _picker = ImagePicker();
    final XFile? pic =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pic != null) {
      if (photos_picked.length < 2) {
        photos_picked.add(pic.path);
      }
    }
    setState(() {});
  }

  do_pick_image() async {
    Navigator.pop(context);
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    images?.forEach((element) {
      if (element.path == null) {
        return;
      }
      if (photos_picked.length < 2) {
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

  void my_init() async {
    gardens = await GardenModel.get_items();
    pests = await PestModel.get_items();
  }
}
