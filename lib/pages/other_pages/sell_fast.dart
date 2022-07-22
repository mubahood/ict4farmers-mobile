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

class SellFast extends StatefulWidget {
  @override
  State<SellFast> createState() => SellFastState();
}

late CustomTheme customTheme;
String title = "Sell fast";
bool is_loading = false;

class SellFastState extends State<SellFast> {
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
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
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
              "Sell fast on ${AppConfig.AppName}",
              "Below are some tips on how to post ads that attract a lot of buyer interest.",
              'sell_fast_1.png',
              false,
            ),
            SingleWidget(
              "Add as much detail as you can",
              "Ads with clear details get more views! Include keywords and information that buyers will be interested in. Remember to be honest while providing these details.",
              'sell_fast_3.png',
              false,
            ),
            SingleWidget(
              "Add great photos",
              "Use clear photos of the item you're selling. Ads with real photos get up to 10 times more views than ads with catalogue/stock photos. Make sure the lighting is good and take photos from different angles.",
              'sell_fast_2.png',
              false,
            ),
            SingleWidget(
              "Pick the right price",
              "Everything sells if the price is right! Browse similar ads on Bikroy and choose a competitive price. In general, the lower the price, the higher is the demand. If you are willing to negotiate, be sure to select the Negotiable option while posting the ad.",
              'sell_fast_2.png',
              true,
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
        children: [
          FxSpacing.height(20),
          FxText.h5(
            title,
            textAlign: TextAlign.center,
            color: Colors.black,
          ),
          FxSpacing.height(10),
          Image(
            image: AssetImage('./assets/project/${image}'),
            width: (MediaQuery.of(context).size.width - 200),
            fit: BoxFit.cover,
          ),
          FxSpacing.height(5),
          FxText.b1(
            body,
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
