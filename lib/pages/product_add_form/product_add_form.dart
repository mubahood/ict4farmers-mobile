import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/CategoryModel.dart';
import '../../models/FormItemModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/ProductModel.dart';
import '../../models/option_picker_model.dart';
import '../../theme/app_notifier.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../location_picker/location_main.dart';
import '../option_pickers/multiple_option_picker.dart';
import 'item_picker_screen.dart';

class ProductAddForm extends StatefulWidget {
  @override
  State<ProductAddForm> createState() => ProductAddFormState();
}

late CustomTheme customTheme;

class ProductAddFormState extends State<ProductAddForm> {
  String nature_of_off = "";

  bool main_loading = true;

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
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: CustomTheme.primary,
              automaticallyImplyLeading: false,
              // remove back button in appbar.
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: CustomTheme.primary,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 1,
              title: Row(
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
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText(
                          'Sell an item',
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: 500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: FormBuilder(
              key: _formKey,
          child: main_loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: CustomTheme.primary,
                    strokeWidth: 2,
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                    right: 15,
                                  ),
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                          name: "name",
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.name,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                              context,
                                              errorText: "Name is required.",
                                            ),
                                            FormBuilderValidators.minLength(
                                              context,
                                              2,
                                              errorText: "Title too short.",
                                            ),
                                            FormBuilderValidators.maxLength(
                                              context,
                                              45,
                                              errorText: "Title too long.",
                                            ),
                                          ]),
                                          decoration:
                                              customTheme.input_decoration_2(
                                                  labelText: "Title",
                                                  hintText:
                                                      "What is the name of this item?")),
                                      FxDashedDivider(
                                        color: Colors.grey.shade300,
                                      ),
                                      FormBuilderTextField(
                                          name: "price",
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                              context,
                                              errorText: "Price is required",
                                            ),
                                          ]),
                                          decoration:
                                              customTheme.input_decoration_2(
                                                  labelText: "Price",
                                                  hintText:
                                                      "How much is this item?")),
                                      FxDashedDivider(
                                        color: Colors.grey.shade300,
                                      ),
                                      FormBuilderTextField(
                                          name: "description",
                                          minLines: 2,
                                          maxLines: 4,
                                          textInputAction:
                                              TextInputAction.newline,
                                          keyboardType: TextInputType.multiline,
                                          validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                            context,
                                            errorText: "Description is required.",
                                          ),
                                          FormBuilderValidators.minLength(
                                            context,
                                            5,
                                            errorText: "Description too short.",
                                          ),
                                        ]),
                                        decoration: customTheme.input_decoration_2(
                                            labelText: "Describe your item",
                                            hintText:
                                            "More explanation  = more buyers")),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade100,
                                height: 25,
                              ),
                              Container(
                                padding: FxSpacing.all(20),
                                child: InkWell(
                                  onTap: () {
                                    pick_category();
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FxSpacing.width(16),
                                      Expanded(
                                        child: FxText.b1(
                                          'Category',
                                          fontSize: 18,
                                          fontWeight: 500,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            FxText(
                                              category_text,
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
                                color: Colors.grey.shade200,
                                height: 1,
                              ),
                              Container(
                                padding: FxSpacing.all(20),
                                child: InkWell(
                                  onTap: () {
                                    pick_location();
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FxSpacing.width(16),
                                      Expanded(
                                        child: FxText.b1(
                                          'Location',
                                          fontSize: 18,
                                          fontWeight: 500,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            FxText(
                                              location_sub_name,
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
                                color: Colors.grey.shade200,
                                height: 1,
                              ),
                              Container(
                                padding: FxSpacing.all(20),
                                child: InkWell(
                                  onTap: () {
                                    pick_offer();
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FxSpacing.width(16),
                                      Expanded(
                                        child: FxText.b1(
                                          'Nature of offer',
                                          fontSize: 18,
                                          fontWeight: 500,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            FxText(
                                              nature_of_off,
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
                                color: Colors.grey.shade200,
                                height: 1,
                              ),
                              Container(
                                color: Colors.grey.shade100,
                                height: 25,
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 10,bottom: 10),
                                color: Colors.white,
                                child: Text(
                                    "Add item's photos. Not more than 15."
                                ),
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
                                  top: 10,
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
                                      "UPLOAD",
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
                      onTap: ()  {do_pick_image('camera');},
                      dense: false,
                      leading: Icon(Icons.camera_alt,
                          color: CustomTheme.primary),
                      title: FxText.b1("Camera", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () => {do_pick_image("gallery")},
                        leading: Icon(Icons.photo_library_sharp,
                            color: CustomTheme.primary),
                        title: FxText.b1("Gallery", fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget single_image_picker(int index, String _item, BuildContext context) {
    return (_item == AppConfig.form_field_image_picker)
        ? InkWell(
        onTap: ()  {
        _show_bottom_sheet_photo(context);
          //do_pick_image()

        },
        child: Container(
            margin: EdgeInsets.all(5),
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
                ])) )
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

  String category_id = "";
  String category_text = "";
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

  Future<void> pick_category() async {
    if (categories.isEmpty) {
      categories = await CategoryModel.get_all();
    }
    if (categories.isEmpty) {
      Utils.showSnackBar(
          "Please connect to internet and try again.", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    List<OptionPickerModel> local_items = [];

    categories.forEach((element) {
      OptionPickerModel item = new OptionPickerModel();
      item.parent_id = element.parent.toString();

      item.id = element.id.toString();
      item.name = element.name.toString();
      local_items.add(item);
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MultipleOptionPicker(
              "Select main category", "Select sub crop", local_items)),
    );

    if (result != null) {
      if ((result['id'] != null) && (result['text'] != null)) {
        category_id = result['id'];
        category_text = result['text'].toString();

        setState(() {});
      }
    }
  }

  LoggedInUserModel userModel = new LoggedInUserModel();

  void do_upload_process() async {
    if (photos_picked.length > 16) {
      Utils.showSnackBar("Too many photos.", context, Colors.white,
          background_color: Colors.red);
      return;
    }

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

    userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      Utils.showSnackBar(
          "Login before  you proceed.", context, CustomTheme.onPrimary);
      return;
    }

    bool first_found = false;
    form_data_map['user_id'] = userModel.id;

    form_data_map["Advert's_title"] =
        _formKey.currentState?.fields['name']?.value;
    form_data_map['Product_price'] =
        _formKey.currentState?.fields['price']?.value;
    form_data_map['Product_description'] =
        _formKey.currentState?.fields['description']?.value;

    if (category_id.isEmpty) {
      Utils.showSnackBar("Please pick item category", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    if (location_id.isEmpty) {
      Utils.showSnackBar("Please pick item location", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    if (photos_picked.length < 2) {
      Utils.showSnackBar("Please add at least one photo", context, Colors.white,
          background_color: Colors.red);
      return;
    }

    form_data_map['Category'] = category_id;
    form_data_map['Sub_Category'] = category_id;
    form_data_map['District'] = location_id;
    form_data_map['Sub_county'] = location_id;

    if (!photos_picked.isEmpty) {
      for (int __counter = 0; __counter < photos_picked.length; __counter++) {
        if (first_found) {
          try {
            var img = await MultipartFile.fromFile(photos_picked[__counter],
                filename: 'image_${__counter}' );
            if (img != null) {
              form_data_map['image_${__counter}'] =
              await MultipartFile.fromFile(photos_picked[__counter],
                  filename: photos_picked[__counter].toString());
            } else {}
          } catch (e) {}
        }
        first_found = true;
      }
    }

    var formData = FormData.fromMap(form_data_map);
    var dio = Dio();
    setState(() {
      is_uploading = true;
    });

    var response =
    await dio.post('${AppConfig.BASE_URL}/api/products', data: formData);

    await ProductModel.get_user_products(userModel.id);
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
          response.data['status'].toString(), context, Colors.red.shade700);
      return;
    }
    await ProductModel.get_user_products(userModel.id);
    //await FormItemModel.delete_all();
    Utils.showSnackBar(
        response.data['message'].toString(), context, CustomTheme.onPrimary);

    Navigator.pop(context, {"task": 'success'});
  }

  do_pick_image(String source) async {
    Navigator.pop(context);

    if (source == "camera") {
      do_pick_image_from_camera();
    } else {
      do_pick_image_from_gallary();
    }

    setState(() {});
  }

  do_pick_image_from_camera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pic =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pic != null) {
      if (photos_picked.length < 16) {
        photos_picked.add(pic.path);
      }
    }
    setState(() {});
  }

  do_pick_image_from_gallary() async {
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

  Future<void> pick_offer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ItemPickerScreen(
            ['For sale', 'For hire', 'Service'],
            nature_of_off,
            'Nature of the offer',
              )),
    );

    if (result != null) {
      if ((result['value'] != null) && (result['value'] != null)) {
        nature_of_off = result['value'].toString();
        setState(() {});
      }
    }
  }

  List<CategoryModel> categories = [];

  Future<void> my_init() async {
    main_loading = true;
    setState(() {});
    userModel = await Utils.get_logged_in();
    if (!userModel.profile_is_complete()) {
      Utils.showSnackBar("Complete your profile first", context, Colors.white,
          background_color: Colors.red);

      Navigator.pop(context);
      Utils.navigate_to(AppConfig.AccountEdit, context);

      main_loading = false;
      setState(() {});
      return;
    }
    categories = await CategoryModel.get_all();

    main_loading = false;
    setState(() {});
  }
}
