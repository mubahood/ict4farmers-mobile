import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widget/shimmer_loading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../theme/app_theme.dart';
import '../theme/custom_theme.dart';
import '../utils/Utils.dart';

final List<String> my_colors = [
  '#BA0A1E',
  '#EE2908',
  '#542889',
  '#35A9B9',
  '#273A85',
  '#35A9B9',
  '#273988',
  '#219847',
  '#FE9F23',
  '#7C00FF',
  '#FC4E51',
  '#AA2754',
  '#186986',
  '#FFAE00',
  '#44372E',
  '#000000',
  '#3E51A1',
];

extension HexString on String {
  int getHexValue() => int.parse(replaceAll('#', '0xff'));
}

/*Widget widget_video_player() {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

  return YoutubePlayer(
    controller: _controller,
    showVideoProgressIndicator: true,
  );
}*/

FloatingActionButton extended_floating_button( context, {
  required String title,
  required String screen,
  IconData icon: Icons.add,
  dynamic data : null,
}) {
  return FloatingActionButton.extended(
      backgroundColor: CustomTheme.primary,
      elevation: 20,
      onPressed: () {
        Utils.navigate_to(screen,context, data:data);
      },
      label: Row(
        children: [
          Icon(
            icon,
            size: 18,
          ),
          Container(
            child: Text(
              "${title}",
            ),
          ),
        ],
      ));
}


Widget widget_grid_item(context, {
  required String title,
  required String caption,
  String bg_color: "",
  String screen: "",
  String id: "",
}) {
  return InkWell(
    onTap: () => {Utils.navigate_to(screen, context, data: {'id': id})},
    child: FxCard(
      paddingAll: 10,
      marginAll: 10,
      color: (bg_color.isEmpty)
          ? CustomTheme.primary
          : Color(bg_color.getHexValue()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FxText(
            title,
            color: Colors.white,
            fontWeight: 800,
            height: 1.0,
            fontSize: 20,
          ),
          Container(
            height: 10,
          ),
          FxText(
            caption,
            color: Colors.grey.shade100,
            fontWeight: 600,
            fontSize: 14,
          ),
        ],
      ),
    ),
  );
}

Widget widget_dashboard_item(
  context, {
  required String title,
  required String asset_image,
}) {
  return FxContainer(
    paddingAll: 0,
    bordered: true,
    width: MediaQuery.of(context).size.width / 2.3,
    height: MediaQuery.of(context).size.width / 2.5,
    border: Border.all(color: CustomTheme.primary, width: 1),
    child: Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image(
            image: AssetImage("assets/project/${asset_image}"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FxText(
            title,
            fontSize: 22,
            height: 1,
            fontWeight: 700,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    ),
    color: Colors.white,
  );
}

Widget widget_item_counter(context) {
  return FxContainer(
    bordered: true,
    width: MediaQuery.of(context).size.width / 3.9,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText(
          "10%",
          fontWeight: 700,
          fontSize: 24,
          textAlign: TextAlign.start,
          color: Colors.white,
        ),
        FxText(
          'Discount',
          fontSize: 10,
          fontWeight: 200,
          color: Colors.white,
        ),
      ],
    ),
    color: CustomTheme.primary,
  );
}

Widget myNetworkImage(
    String url, double _height, double _width, double radiusAll) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(radiusAll)),
    child: CachedNetworkImage(
      height: _height,
      width: double.infinity,
      fit: BoxFit.fill,
      imageUrl: url,
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: _height,
      ),
      errorWidget: (context, url, error) => Image(
          fit: BoxFit.cover,
          image: AssetImage(
            './assets/project/no_image.jpg',
          ),
          height: _height,
          width: _width),
    ),
  );
}

Widget social_media_links(context) {
  return Row(
    children: <Widget>[
      InkWell(
        onTap: () => {Utils.launchOuLink(AppConfig.OurWhatsApp)},
        child: Container(
          margin: EdgeInsets.only(left: 0),
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.whatsapp,
            size: 30,
            color: Colors.green.shade600,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: CustomTheme.primary, width: 1),
              color: AppTheme.lightTheme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(11))),
        ),
      ),
      InkWell(
        onTap: () =>
        {Utils.launchOuLink(AppConfig.OUR_FACEBOOK_LINK)},
        child: Container(
          margin: EdgeInsets.only(left: 16),
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.facebook,
            size: 30,
            color: Colors.blue.shade800,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade500, width: 1),
              color: AppTheme.lightTheme.backgroundColor,
              borderRadius:
              BorderRadius.all(Radius.circular(11))),
        ),
      ),
      InkWell(
        onTap: () =>
        {Utils.launchOuLink(AppConfig.OUR_TWITTER_LINK)},
        child: Container(
          margin: EdgeInsets.only(left: 16),
          padding: EdgeInsets.all(3),
          child: Icon(
            MdiIcons.twitter,
            size: 30,
            color: Colors.blue.shade500,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade500, width: 1),
              borderRadius:
              BorderRadius.all(Radius.circular(11))),
        ),
      ),
      InkWell(
        onTap: () =>
        {Utils.launchOuLink(AppConfig.OUR_YOUTUBE_LINK)},
        child: Container(
          margin: EdgeInsets.only(left: 16),
          padding: EdgeInsets.all(3),
          child: Icon(
            MdiIcons.youtube,
            size: 30,
            color: Colors.red.shade700,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade500, width: 1),
              borderRadius:
              BorderRadius.all(Radius.circular(11))),
        ),
      ),

    ],
  );
}
void show_not_account_bottom_sheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext buildContext) {
        return DraggableScrollableSheet(
            initialChildSize: 0.75,
            //set this as you want
            maxChildSize: 0.75,
            //set this as you want
            minChildSize: 0.75,
            //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Container(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: NoAccountWidget(context),
                ),
              );
            });
      });
}

Widget NoAccountWidget(BuildContext context,
    {String body: "You are not logged in yet."
        "",
    String action_text: "Login to ${AppConfig.AppName} to proceed ...",
    String empty_image: ""}) {
  String _empty_image = './assets/project/no_account.png';
  if (!empty_image.isEmpty) {
    _empty_image = empty_image;
  }
  return Center(
    child: Column(
      children: <Widget>[
        Container(
          child: Image(
            image: AssetImage(
              _empty_image,
            ),
          ),
          padding: EdgeInsets.only(left: 80, right: 80),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              FxText(
                body,
                textAlign: TextAlign.center,
              ),
              FxSpacing.height(20),
              action_text.isEmpty
                  ? Container()
                  : FxText.h2(
                      action_text,
                      fontSize: 18,
                      color: CustomTheme.primary,
                      textAlign: TextAlign.center,
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(height: 10, color: CustomTheme.primary.withAlpha(40)),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(
            left: 40,
            right: 20,
          ),
          child: Row(
            children: [
              Expanded(
                  child: FxButton.outlined(
                borderRadiusAll: 10,
                borderColor: CustomTheme.accent,
                splashColor: CustomTheme.primary.withAlpha(40),
                padding: FxSpacing.y(12),
                onPressed: () {
                  Utils.navigate_to(AppConfig.AccountRegister, context);
                },
                child: FxText.l1(
                  "SIGN UP",
                  color: CustomTheme.accent,
                  letterSpacing: 0.5,
                ),
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FxButton(
                elevation: 0,
                padding: FxSpacing.y(12),
                borderRadiusAll: 4,
                onPressed: () {
                  Utils.navigate_to(AppConfig.AccountLogin, context);
                },
                child: FxText.l1(
                  "LOG IN",
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                backgroundColor: CustomTheme.primary,
              )),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

void my_bottom_sheet(context, Widget widget) {
  showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext buildContext) {
        return DraggableScrollableSheet(
            initialChildSize: 0.75,
            //set this as you want
            maxChildSize: 0.75,
            //set this as you want
            minChildSize: 0.75,
            //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Container(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: widget,
                ),
              );
            });
      });
}
