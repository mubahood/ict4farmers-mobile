import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/pages/TestPage1.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';

import '../../utils/AppConfig.dart';

class HomesScreenSegment extends StatefulWidget {

  dynamic params;
  HomesScreenSegment(this.params);

  @override
  _HomesScreenSegmentState createState() => _HomesScreenSegmentState();
}

class _HomesScreenSegmentState extends State<HomesScreenSegment>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;



  TextDirection textDirection = TextDirection.ltr;

  bool store_is_ready = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Utils.ini_theme();


  }




  List<ProductModel> items = [];


  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        textDirection = AppTheme.textDirection;
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: CustomTheme.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: FxContainer.rounded(
                    bordered: true,
                    border: Border.all(color: CustomTheme.primary),
                    paddingAll: 5,
                    splashColor: CustomTheme.primary,
                    color: CustomTheme.primary_bg,
                    child: Icon(
                      Icons.arrow_back,
                      size: 35,
                      color: CustomTheme.primaryDark,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                    child: Image(
                      image: AssetImage(Images.logo_1),
                      width: 60,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () =>
                      {
                        Utils.navigate_to(AppConfig.ProductDetails, context)
                        //Utils.navigate_to(AppConfig.SearchScreen, context)
                      },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 10, top: 7, bottom: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: (MediaQuery.of(context).size.width-160),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Search...",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*InkWell(
                  onTap: () {
                    Navigator.push(context, SlideLeftRoute(AppSettingScreen()));
                  },
                  child: Container(
                    padding: FxSpacing.x(0),
                    child: Image(
                      image: AssetImage(Images.settingIcon),
                      color: theme.colorScheme.onBackground,
                      width: 26,
                      height: 26,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          body: TestPage1(widget.params),
/*          drawer: _buildDrawer(),*/
        );
      },
    );
  }


}

class NavItem {
  final String title;
  final String icon;
  final Widget screen;
  final double size;

  NavItem(this.title, this.icon, this.screen, [this.size = 28]);
}
