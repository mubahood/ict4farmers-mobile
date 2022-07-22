import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:provider/provider.dart';

import '../../theme/app_notifier.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<AboutUsScreen> createState() => About_us_sUeSState();
}

late CustomTheme customTheme;
String title = "About ${AppConfig.AppName}";
bool is_loading = false;

class About_us_sUeSState extends State<AboutUsScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  void dipose() {}

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: .5,
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
            child: ListView(
          children: [
            SingleWidget(
              "Background",
              "The UNFFE ICT4Farmers Initiative is one of the pillar programmes for UNFFE 2030 vision, which focused on transforming smallholder agriculture into sustainable and profitable enterprises."
                  "\n\nThe UNFFE ICT4farmer initiative is implemented in partnership with Eight Tech Consults (www.8technologies.net) one of the leading ICT4Agric firms in the region, with kind support from RCDF, Uganda Communication Commission (www.ucc.co.ug)."
                  "\n\nThe overall objective of UNFFE ICT4Farmer programme is to contribute to accelerated uptake of ICT4Agric innovations by various actors especially smallholder farmers in a number of value chains covering crops, animals and fisheries.",
              'logo_1.png',
              false,
            ),
            SingleWidget(
              "The specific objectives include;-",
              "- Establish ICT baseline indicators within the UNFFE farming community and eco-system"
                  "\n\n- Establish a sustainable integrated decision enhancement service platform for various actors including; farmers, policy makers, extension workers, logistics providers, academia, processors among others"
                  "\n\n - Establish a mechanism of content development, validation, certification and distribution"
                  "\n\n- Promoting the uptake of ICT Innovation and services by various actors through skilling and awareness creation"
                  "\n\n -Document the impact of the digital skilling initiative on farmer; productivity, information seeking behaviour, consumption of ICT services among others.",
              '',
              false,
            ),
            SingleWidget(
              "Therefore, the programme has 7 thematic output areas, of which 4 are core and 3 are supportive areas. These are;-",
              "- An integrated decision enhancement integrate platform"
                  "\n\n- Digital skilling of farmers and other value chain actors"
                  "\n\n- Content development and delivery framework"
                  "\n\n- Farmer mobilization, awareness and promotion"
                  "\n\n- Programme sustainability and resource mobilization"
                  "\n\n- Knowledge management and stakeholder accountability"
                  "\n\n- Partner capacity building and UNFFE network strengthening"
                  "",
              "",
              false,
            ),
          ],
        )),
      );
    });
  }

  SingleWidget(String title, String body, String image, bool is_last) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxSpacing.height(20),
          (title.isEmpty)
              ? SizedBox()
              : FxText.h5(
                  title,
                  textAlign: TextAlign.start,
                  color: Colors.black,
                ),
          FxSpacing.height(10),
          (image.isEmpty)
              ? SizedBox()
              : Center(
                  child: Image(
                    image: AssetImage('./assets/project/${image}'),
                    width: (MediaQuery.of(context).size.width - 200),
                    fit: BoxFit.cover,
                  ),
                ),
          FxSpacing.height(5),
          FxText.b1(
            body,
            textAlign: TextAlign.justify,
          ),
          FxSpacing.height(20),
          is_last
              ? Container()
              : Container(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Divider(
                      height: 10, color: CustomTheme.primary.withAlpha(40)),
                )),
          FxSpacing.height(20),
        ],
      ),
    );
  }
}
