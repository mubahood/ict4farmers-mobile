import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/pages/posts/posts_category_screen.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/LoggedInUserModel.dart';
import '../../models/UserModel.dart';
import '../../utils/AppConfig.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  CcreatPposSscreenState createState() => CcreatPposSscreenState();
}

class CcreatPposSscreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  late CustomTheme customTheme;
  late ThemeData theme;
  String error_message = "";
  bool onLoading = false;
  bool recording_is_ready = false;
  bool audio_is_playing = false;

  bool is_uploading = false;

  @override
  void initState() {
    super.initState();
    check_login();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  void dipose() {
    //stopRecording();
    stopPlayFunc();
  }

  bool has_audio = false;
  bool has_photos = false;
  bool has_text = false;
  String post_content = "";
  List<String> photos = [];
  List<XFile>? temp_images = [];

  do_pick_image(String source) async {
    Navigator.pop(context);

    final ImagePicker _picker = ImagePicker();
    temp_images = [];
    if (source == "camera") {
      final XFile? pic = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      if (pic != null) {
        temp_images?.add(pic);
      }
    } else {
      temp_images = await _picker.pickMultiImage();
    }

    temp_images?.forEach((element) {
      if (element.path == null) {
        return;
      }
      if (!photos.contains(element.path)) {
        if (photos.length < 10) {
          photos.add(element.path);
        }
      }
    });

    setState(() {});
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

  Future<void> check_login() async {
    LoggedInUserModel userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      Utils.showSnackBar(
          "Login before  you proceed.", context, CustomTheme.onPrimary,
          background_color: Colors.red.shade700);
      Utils.navigate_to(AppConfig.AccountRegister, context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<void> submit_form() async {
      await check_login();
      LoggedInUserModel userModel = await Utils.get_logged_in();
      if (userModel.id < 1) {
        Utils.showSnackBar(
            "Login before  you proceed.", context, CustomTheme.onPrimary,
            background_color: Colors.red.shade700);
        return;
      }

      if (category_name.isEmpty || category_id.isEmpty) {
        if ((!has_text) || (!has_photos)) {
          Utils.showSnackBar("Select post category.", context, Colors.white,
              background_color: Colors.red.shade700);
          return;
        }
      }

      has_audio = false;
      has_photos = false;
      has_text = false;

      if (_formKey.currentState?.fields['post_content'] != null) {
        if (_formKey.currentState?.fields['post_content']?.value != null) {
          post_content = _formKey.currentState?.fields['post_content']?.value;
        }
      }

      post_content = post_content.toString().trim();
      has_text = false;
      if (!post_content.isEmpty) {
        has_text = true;
      }

      final file = await File(pathToAudio);
      if ((await file.exists())) {
        has_audio = true;
      }

      if (!photos.isEmpty) {
        has_photos = true;
      }

      if (!has_audio) {
        if ((!has_text) || (!has_photos)) {
          Utils.showSnackBar(
              "You should at least write some text and attach a photo.",
              context,
              Colors.white,
              background_color: Colors.red);
          return;
        }
      }

      Map<String, dynamic> form_data_map = {};

      form_data_map['user_id'] = userModel.id.toString();
      form_data_map['posted_by'] = userModel.id.toString();
      form_data_map['text'] = post_content.toString();
      form_data_map['post_category_id'] = category_id.toString();

      if (!photos.isEmpty) {
        if (photos != null) {
          for (int _counter = 0; _counter < photos.length; _counter++) {
            try {
              var img = await MultipartFile.fromFile(photos[_counter],
                  filename: 'image_${_counter}');
              if (img != null) {
                form_data_map['image_${_counter}'] =
                    await MultipartFile.fromFile(photos[_counter],
                        filename: 'image_${_counter}');
              }
            } catch (e) {}
          }
        }
      }

      if (pathToAudio != null) {
        if (!pathToAudio.trim().isEmpty) {
          var audio =
              await MultipartFile.fromFile(pathToAudio, filename: 'Audio');
          if (audio != null) {
            form_data_map['audio'] = audio;
          }
        }
      }

      var formData = FormData.fromMap(form_data_map);
      var dio = Dio();

      setState(() {
        is_uploading = true;
      });

      var response = await dio.post(
        '${AppConfig.BASE_URL}/api/posts',
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      setState(() {
        is_uploading = false;
      });

      if (response == null) {
        Utils.showSnackBar("Failed to  submit  post. Please try again.",
            context, Colors.red.shade700);
        return;
      }

      if (response.data['status'] == null) {
        Utils.showSnackBar("Failed to submit  post. Please try again.", context,
            Colors.red.shade700);
        return;
      }

      if (response.data['status'].toString() != '1') {
        Utils.showSnackBar(
            response.data['status'].toString(), context, Colors.red.shade700);
        return;
      }
      Utils.showSnackBar(
          response.data['message'].toString(), context, CustomTheme.onPrimary);

      Navigator.pop(context, {"task": 'success'});
    }

    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
      child: Scaffold(
        appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 1,
            /*actions: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: is_uploading
                    ? FxText("Posting...")
                    : FxButton.rounded(
                        onPressed: () => {submit_form()},
                        child: FxText(
                          "SUBMIT",
                          color: Colors.white,
                        )),
              )
            ],*/
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Creating new post",
                    style: TextStyle(
                        color: CustomTheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: is_uploading
              ? Center(
                  child: FxText("Submiting post..."),
                )
              : FormBuilder(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height - 370),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: FormBuilderTextField(
                          name: "post_content",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              context,
                              errorText: "Password is required.",
                            ),
                          ]),
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "Write your post here...",
                            isDense: false,
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          minLines: 10,
                          maxLines: 10,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  singleOption(context, theme,
                                      option: category_name.isEmpty
                                          ? "Select post category"
                                          : "Change post category",
                                      navigation: AppConfig.MyProductsScreen),
                                  category_name.isEmpty
                                      ? SizedBox()
                                      : Container(
                                          child: FxText(
                                            category_name,
                                            color: CustomTheme.primary,
                                            fontWeight: 700,
                                            fontSize: 18,
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 25, bottom: 5),
                                        ),
                                  Divider(),
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            audio_recorder_expanded
                                ? Container(
                                    height: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(_voice_recording_counter),
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15, left: 15),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 15,
                                              bottom: 15,
                                              left: 15,
                                              right: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: ClipOval(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .red)),
                                                    child: InkWell(
                                                      splashColor: Colors.red,
                                                      child: SizedBox(
                                                          width: 56,
                                                          height: 56,
                                                          child: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.red)),
                                                      onTap: () {
                                                        delete_recording();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              (!recording_is_ready)
                                                  ? SizedBox()
                                                  : audio_is_playing
                                                      ? ClipOval(
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            28),
                                                                side: BorderSide(
                                                                    color: CustomTheme
                                                                        .primary)),
                                                            child: InkWell(
                                                              splashColor:
                                                                  CustomTheme
                                                                      .primary,
                                                              child: SizedBox(
                                                                  width: 56,
                                                                  height: 56,
                                                                  child: Icon(
                                                                      Icons
                                                                          .stop,
                                                                      color: CustomTheme
                                                                          .primary)),
                                                              onTap: () {
                                                                stopPlayFunc();
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      : ClipOval(
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            28),
                                                                side: BorderSide(
                                                                    color: CustomTheme
                                                                        .primary)),
                                                            child: InkWell(
                                                              splashColor:
                                                                  CustomTheme
                                                                      .primary,
                                                              child: SizedBox(
                                                                  width: 56,
                                                                  height: 56,
                                                                  child: Icon(
                                                                      Icons
                                                                          .play_circle,
                                                                      color: CustomTheme
                                                                          .primary)),
                                                              onTap: () {
                                                                playFunc();
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                              Container(
                                                child: is_recording
                                                    ? ClipOval(
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          28),
                                                              side: BorderSide(
                                                                  color: CustomTheme
                                                                      .primary)),
                                                          child: InkWell(
                                                            splashColor:
                                                                CustomTheme
                                                                    .primary,
                                                            child: SizedBox(
                                                                width: 56,
                                                                height: 56,
                                                                child: Icon(
                                                                    Icons
                                                                        .stop_circle,
                                                                    color: CustomTheme
                                                                        .primary)),
                                                            onTap: () {
                                                              Utils.showSnackBar(
                                                                  "Coming soon",
                                                                  context,
                                                                  Colors.black);
                                                              //stopRecording();
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: Material(
                                                          color: CustomTheme
                                                              .primary,
                                                          child: InkWell(
                                                            splashColor:
                                                                Colors.white,
                                                            // inkwell color
                                                            child: SizedBox(
                                                                width: 56,
                                                                height: 56,
                                                                child: Icon(
                                                                  Icons.done,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            onTap: () {
                                                              collapse_recorder();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: (photos.length < 1)
                                              ? InkWell(
                                                  onTap: () => {
                                                    _show_bottom_sheet_photo(
                                                        context)
                                                  },
                                                  child: optionWidget(
                                                      color:
                                                          CustomTheme.primary,
                                                      iconData: MdiIcons.camera,
                                                      title: "Add Photo"),
                                                )
                                              : CustomScrollView(
                                                  slivers: [
                                                    SliverGrid(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 0,
                                                        crossAxisSpacing: 0,
                                                        childAspectRatio: 1,
                                                      ),
                                                      delegate:
                                                          SliverChildBuilderDelegate(
                                                        (context, index) {
                                                          return single_image_picker(
                                                              index,
                                                              photos[index]
                                                                  .toString(),
                                                              context);
                                                        },
                                                        childCount:
                                                            photos.length,
                                                      ),
                                                    ),
                                                    SliverList(
                                                      delegate:
                                                          SliverChildBuilderDelegate(
                                                        (BuildContext context,
                                                            int index) {
                                                          return InkWell(
                                                            onTap: () => {
                                                              _show_bottom_sheet_photo(
                                                                  context)
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          35.0),
                                                              child: optionWidget(
                                                                  color: CustomTheme
                                                                      .primary,
                                                                  iconData:
                                                                      MdiIcons
                                                                          .plus,
                                                                  title:
                                                                      "Add More Photos"),
                                                            ),
                                                          );
                                                        },
                                                        childCount:
                                                            1, // 1000 list items
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          width: ((MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              50),
                                        ),
                                        Container(
                                          width: 2,
                                          height: 120,
                                          color: Colors.grey.shade200,
                                        ),
                                        Container(
                                          width: ((MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              40),
                                          child: InkWell(
                                            onTap: () => {
                                              has_audio
                                                  ? delete_recording()
                                                  : expand_recorder()
                                            },
                                            child: optionWidget(
                                                color: has_audio
                                                    ? Colors.red
                                                    : CustomTheme.primary,
                                                iconData: has_audio
                                                    ? MdiIcons.delete
                                                    : MdiIcons.microphone,
                                                title: has_audio
                                                    ? "Delete Audio"
                                                    : "Record Audio"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Container(
                              child: FxButton.rounded(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  onPressed: () => {submit_form()},
                                  child: FxText.h5(
                                    "SUBMIT POST",
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  //final recordingPlayer = AssetsAudioPlayer();

  Future<void> playFunc() async {
    if (pathToAudio == null || pathToAudio.isEmpty) {
      return;
    }
    final file = await File(pathToAudio);
    if (!(await file.exists())) {
      return;
    }

    setState(() {
      audio_is_playing = true;
    });

    /*recordingPlayer.open(
      Audio.file(pathToAudio),
      autoStart: true,
      showNotification: true,
    );*/
  }

  Future<void> stopPlayFunc() async {
    //recordingPlayer.stop();
    setState(() {
      audio_is_playing = false;
    });
  }

  Widget optionWidget(
      {IconData? iconData, required Color color, String title = ""}) {
    return Container(
      margin: FxSpacing.only(top: 30),
      child: Column(
        children: [
          Container(
            padding: FxSpacing.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(45),
            ),
            child: Icon(
              iconData,
              color: color,
              size: 40,
            ),
          ),
          Container(
            margin: FxSpacing.top(4),
            child: FxText.caption(title,
                fontSize: 14,
                color: theme.colorScheme.onBackground,
                fontWeight: 600),
          )
        ],
      ),
    );
  }

  bool voice_initialized = false;
  bool is_recording = false;
  bool audio_recorder_expanded = false;
  String pathToAudio = "";
  String _voice_recording_counter = "00:00:00";

  //late FlutterSoundRecorder _recordingSession;

  Future<void> initialize_voice_recorder() async {
    //await Permission.microphone.request();
    final directory = await getApplicationDocumentsDirectory();
    //await Permission.microphone.request();
    final file = await File('${directory.path}/test.wav');
    recording_is_ready = false;
    pathToAudio = file.path;
    //_recordingSession = FlutterSoundRecorder();
    voice_initialized = true;
  }

/*

  Future<void> startRecording() async {
    if (!voice_initialized) {
      await initialize_voice_recorder();
    }

    if (!voice_initialized) {
      await initialize_voice_recorder();
    }

    if (!voice_initialized) {
      await initialize_voice_recorder();
      return;
    }

    await _recordingSession.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);

    await _recordingSession.setSubscriptionDuration(Duration(seconds: 1));
    await initializeDateFormatting();

    if (!_recordingSession.isRecording) {
      await _recordingSession.startRecorder(
        toFile: pathToAudio,
        codec: Codec.pcm16WAV,
      );
    }

    if (_recordingSession.isRecording) {
      is_recording = true;

      StreamSubscription _recorderSubscription =
          _recordingSession.onProgress!.listen((e) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds,
            isUtc: true);
        var timeText = DateFormat('mm:ss:SS', 'en_GB').format(date);
        setState(() {
          _voice_recording_counter = timeText.substring(0, 8);
        });
      });
      //_recorderSubscription.cancel();


    } else {

    }

    setState(() {
      recording_is_ready = false;
    });
  }

  Future<String?> stopRecording() async {
    _recordingSession.stopRecorder();
    _recordingSession.closeAudioSession();

    setState(() {
      recording_is_ready = true;
      is_recording = false;
    });

    return "";
  }
*/

  String category_id = "";
  String category_name = "";

  open_add_product() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostsCategoryScreen()),
    );
    if (result != null) {
      if ((result['id'] != null) && result['name'] != null) {
        category_id = result['id'].toString();
        category_name = result['name'].toString();
        setState(() {});
      }
    }
  }

  Widget singleOption(_context, theme,
      {required String option, String navigation: "", String badge: ""}) {
    return Container(
      padding: FxSpacing.fromLTRB(20, 10, 20, 5),
      child: InkWell(
        onTap: () {
          open_add_product();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FxSpacing.width(5),
            Expanded(
              child: FxText.b1(option, fontWeight: 600),
            ),
            Container(
              child: Row(
                children: [
                  badge.toString().isEmpty
                      ? SizedBox()
                      : FxContainer(
                          color: Colors.red.shade500,
                          width: 28,
                          paddingAll: 0,
                          marginAll: 0,
                          alignment: Alignment.center,
                          borderRadiusAll: 15,
                          height: 28,
                          child: FxText(
                            badge.toString(),
                            color: Colors.white,
                          )),
                  Icon(MdiIcons.chevronRight,
                      size: 22, color: theme.colorScheme.onBackground),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> collapse_recorder() async {
    audio_recorder_expanded = false;

    if (!pathToAudio.isEmpty) {
      final file = await File(pathToAudio);
      if (await file.exists()) {
        has_audio = true;
      } else {
        has_audio = false;
      }
    }
    setState(() {});
  }

  void expand_recorder() {
    audio_recorder_expanded = true;
    //startRecording();

    setState(() {});
  }

  Future<void> delete_recording() async {
    if (pathToAudio == null || pathToAudio.isEmpty) {
      return;
    }

    //await stopRecording();
    await stopPlayFunc();
    collapse_recorder();
    final file = await File(pathToAudio);
    if (await file.exists()) {
      await file.delete();
    }
    has_audio = false;
    setState(() {});
  }

  Widget single_image_picker(int index, String _item, BuildContext context) {
    return (_item == AppConfig.form_field_image_picker)
        ? InkWell(
            onTap: () => {_show_bottom_sheet_photo(context)},
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

  void romove_image_at(int image_position) {
    photos.removeAt((image_position));
    setState(() {});
  }
}
