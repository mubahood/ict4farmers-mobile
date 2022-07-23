import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/BannerModel.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../theme/material_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/my_widgets.dart';
import '../../widget/product_item_ui.dart';
import '../../widget/shimmer_loading_widget.dart';

class AccountDetails extends StatefulWidget {
  UserModel userModel;

  AccountDetails(this.userModel);

  @override
  State<AccountDetails> createState() => AccountDetailsState(this.userModel);
}

List<BannerModel> banners = [];
List<String> images = [];
List<String> thumbnails = [];
bool initilized = false;
bool store_initilized = false;


class AccountDetailsState extends State<AccountDetails> {
  UserModel userModel;

  AccountDetailsState(this.userModel);

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  void initState() {
    _onRefresh();
  }

  @override
  void dipose() {}

  List<ProductModel> _products = [];
  int i = 0;

  LoggedInUserModel logged_in_user = new LoggedInUserModel();

  Future<Null> _onRefresh() async {
    logged_in_user = await Utils.get_logged_in();

    _products.clear();
    _products = await ProductModel.get_local_products();
    _products.shuffle();

    if (_products.length > 10) {
      _products = _products.sublist(0, 8);
    }

    setState(() {});
    initilized = false;
    return null;
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: FxText.h1(
                            'Farmer profile',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          ),
                          width: MediaQuery.of(context).size.width - 120,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      get_shop_products();
                    },
                    child: Container(
                        padding: FxSpacing.x(0),
                        child: Icon(Icons.favorite_border)),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        fit: BoxFit.cover,
                                        imageUrl: userModel.avatar,
                                        placeholder: (context, url) =>
                                            ShimmerLoadingWidget(
                                                height: 72,
                                                width: 72,
                                                is_circle: false,
                                                padding: 0),
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
                                    ListTile(
                                      contentPadding: EdgeInsets.only(
                                          top: 16, left: 20, right: 20),
                                      dense: true,
                                      title: Text(userModel.company_name,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(userModel.about),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.map_outlined,
                                        color: CustomTheme.primary,
                                        size: 40,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 20, right: 20),
                                      dense: true,
                                      title: Text('Address',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          )),
                                      subtitle: FxText.b1(userModel.address),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.call,
                                        color: CustomTheme.primary,
                                        size: 40,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 20, right: 20),
                                      dense: true,
                                      title: Text('Telephone',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          )),
                                      subtitle:
                                          FxText.b1(userModel.phone_number),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.alternate_email,
                                        color: CustomTheme.primary,
                                        size: 40,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 20, right: 20),
                                      dense: true,
                                      title: Text('Email',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          )),
                                      subtitle: FxText.b1(userModel.email),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.calendar_month,
                                        color: CustomTheme.primary,
                                        size: 40,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 20, right: 20),
                                      dense: true,
                                      title: Text('Joined',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          )),
                                      subtitle: FxText.b1(userModel.created_at),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade100,
                                      thickness: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      child: Text(
                                        "Products",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 10),
                                    ),
                                  ],
                                );
                              },
                              childCount: 1, // 1000 list items
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1,
                                    mainAxisExtent: 280),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductItemUi(
                                    index, _products[index], context);
                              },
                              childCount: _products.length,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ));
      },
    );
  }

  void get_shop_products() {
    print("Romin");
  }
}

List<Widget> _buildHouseList() {
  List<Widget> list = [];

  images.forEach((element) {
    list.add(_SinglePosition(element.toString()));
  });

  return list;
}

class _SinglePosition extends StatelessWidget {
  final String image_url;
  List<String> _images = [];

  _SinglePosition(this.image_url);

  @override
  Widget build(BuildContext context) {
    MaterialThemeData mTheme = MaterialTheme.estateTheme;
    return FxContainer(
      color: Colors.white,
      paddingAll: 0,
      margin: EdgeInsets.only(bottom: 8, left: 0, right: 8),
      child: CachedNetworkImage(
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        imageUrl: this.image_url,
        placeholder: (context, url) => ShimmerLoadingWidget(
          height: double.infinity,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
