import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/LoggedInUserModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SubmitActivityScreen.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit> {
  bool is_loading =  false;
  late Future<String> formInit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formInit = init_form();

  }


  final _fKey = GlobalKey<FormBuilderState>();
  bool mainLoading =  false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
        actions: [
          is_loading
              ? Padding(
            padding:
            const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor:
                AlwaysStoppedAnimation<Color>(CustomTheme.primary),
              ),
            ),
          )
              : FxButton.text(
              onPressed: () {
                init_form();
              },
              child: FxText.b1(
                "SAVE",
                color: CustomTheme.primary,
                fontWeight: 800,
              ))
        ],
        title: FxText.h2('My Profile'),
      ),
      body: FutureBuilder(
        future: formInit,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print(snapshot.data);
            print("==============DONE===========");
            return FormBuilder(
              key: _fKey,
              child: Stack(
                children: [
                  mainLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                      : CustomScrollView  (
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Container(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        top: 10,
                                        right: 15,
                                      ),
                                      child: Column(
                                        children:[
                                          const SizedBox(height: 10),
                                          FormBuilderTextField(
                                              name: "name",
                                              initialValue: item.name,
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
                                              decoration: CustomTheme.input_decoration_3(
                                                  labelText: "Full name",
                                                  hintText: "What is your name?")),


                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          childCount: 1, // 1000 list items
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }else{
            return const Center(child: const CircularProgressIndicator());
          }


        },
      ),
    );
  }
  LoggedInUserModel item = new LoggedInUserModel();
  Future<String> init_form() async {
    print("==============INTINIGNG===========");
    await Future.delayed(Duration(seconds: 2));

    return "Romina";
  }
}
