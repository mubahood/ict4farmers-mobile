import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/pages/homes/on_map/search_controller.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/map_item.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/material_theme.dart';
import '../../../widget/loading_effect.dart';
import '../../../widget/shimmer_loading_widget.dart';
import '../../../widgets/images.dart';
import '../../location_picker/location_main.dart';
import '../../location_picker/product_category_picker.dart';

class OnMapScreen extends StatefulWidget {
  const OnMapScreen({Key? key}) : super(key: key);

  @override
  _OnMapScreenState createState() => _OnMapScreenState();
}

class _OnMapScreenState extends State<OnMapScreen> {
  late ThemeData theme;
  late MaterialThemeData mTheme;
  late SearchController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    mTheme = MaterialTheme.estateTheme;
    controller = FxControllerStore.putOrFind(SearchController());
    _init_state();
  }

  List<MapItem> map_items = [];

  List<Widget> _buildMapItems() {
    List<Widget> list = [];

    for (MapItem item in map_items) {
      list.add(_SinglePosition(item));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SearchController>(
        controller: controller,
        builder: (controller) {
          return Theme(
            data: theme.copyWith(
                colorScheme: theme.colorScheme
                    .copyWith(secondary: mTheme.primaryContainer)),
            child: Scaffold(
              body: Container(
                padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      child: controller.showLoading
                          ? LinearProgressIndicator(
                              color: mTheme.primary,
                              minHeight: 2,
                            )
                          : Container(
                              height: 0,
                            ),
                    ),
                    Expanded(
                      child: _buildBody(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    if (controller.uiLoading) {
      return Container(
          margin: FxSpacing.top(FxSpacing.safeAreaTop(context)),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
            theme,
            mTheme,
          ));
    } else {
      /*  FxButton.outlined(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext buildContext) {
                return FilterBottomSheet();
              });
        },
        backgroundColor: CustomTheme.primary,
        child: Icon(Icons.add),
        elevation: 5,
      ),*/
      return Stack(
        children: [
          GoogleMap(
            markers: controller.marker,
            onMapCreated: controller.onMapCreated,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            initialCameraPosition: CameraPosition(
              target: controller.center,
              zoom: 7.0,
            ),
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: FxButton(
              borderRadiusAll: 100,
              padding: EdgeInsets.all(16),
              splashColor: CustomTheme.accent.withAlpha(40),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return FilterBottomSheet(do_filter);
                    });
              },
              backgroundColor: CustomTheme.accent,
              child: Icon(
                Icons.filter_alt,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 100,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                pageSnapping: true,
                physics: ClampingScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) => {onPageChange(index)},
                children: _buildMapItems(),
              ),
            ),
          ),
        ],
      );
    }
  }

  onPageChange(int position) {
    controller.mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: map_items[position].get_lat_log(), zoom: 15.5)));
  }

  void _init_state() {
    show_products();
  }

  bool is_loading = false;
  List<UserModel> users = [];
  List<ProductModel> products = [];

  Future<void> show_products() async {
    controller.showLoading = true;
    controller.uiLoading = true;
    controller.update();

    map_items.clear();
    products = await ProductModel.get_local_products();
    products.forEach((element) {
      MapItem item = new MapItem();
      item.id = "${element.id}";
      item.type = "product";
      item.title = element.name;

      item.sub_title = "UGX " + element.price.toString();

      item.photo = element.get_thumbnail();
      item.user = new UserModel();
      item.product = element;
      item.lati = "";
      item.longi = "";
      if ((item.lati.length < 6) || (item.longi.length < 6)) {
        dummy_map_positions.shuffle();
        item.lati = dummy_map_positions[0].lati;
        item.longi = dummy_map_positions[0].longi;
      }
      if (!_mapFilterItem.category_id.isEmpty) {
        if (_mapFilterItem.category_id == element.category_id.toString()) {
          map_items.add(item);
        }
      }
      /*if (!_mapFilterItem.location_id.isEmpty) {
        if (_mapFilterItem.location_id == element.l .toString()) {
          map_items.add(item);
        }
      } */
      else {
        map_items.add(item);
      }
    });

    map_items.sort((a, b) => a.lati.compareTo(b.lati));

    controller.addMarkers(map_items);
    _buildMapItems();
    await Future.delayed(Duration(seconds: 1));

    controller.showLoading = false;
    controller.uiLoading = false;
    controller.update();

    onPageChange(0);
  }

  Future<void> show_farmers() async {
    controller.showLoading = true;
    controller.uiLoading = true;
    controller.update();

    map_items.clear();
    users = await UserModel.get_local_items();
    users.forEach((element) {
      MapItem item = new MapItem();
      item.id = "${element.id}";
      item.type = "user";
      item.title = element.company_name;
      if (item.title.isEmpty || item.title == 'null') {
        item.title = element.name;
      }

      item.sub_title = element.address;
      if (item.sub_title.isEmpty || item.sub_title == 'null') {
        item.sub_title = element.username;
      }
      item.photo = element.avatar;
      item.user = element;
      item.product = new ProductModel();
      item.lati = element.latitude.toString();
      item.longi = element.latitude.toString();
      if ((item.lati.length < 6) || (item.longi.length < 6)) {
        dummy_map_positions.shuffle();
        dummy_map_positions.shuffle();
        item.lati = dummy_map_positions[0].lati;
        item.longi = dummy_map_positions[0].longi;
      }
      if (!_mapFilterItem.category_id.isEmpty) {
        if (_mapFilterItem.category_id == element.category_id.toString()) {
          map_items.add(item);
        }
      }
      if (!_mapFilterItem.location_id.isEmpty) {
        if (_mapFilterItem.location_id == element.region.toString()) {
          map_items.add(item);
        }
      } else {
        map_items.add(item);
      }
    });

    map_items.sort((a, b) => a.lati.compareTo(b.lati));

    controller.addMarkers(map_items);
    _buildMapItems();
    await Future.delayed(Duration(seconds: 1));

    controller.showLoading = false;
    controller.uiLoading = false;
    controller.update();

    onPageChange(0);
  }

  MapFilterItem _mapFilterItem = new MapFilterItem();

  void do_filter(MapFilterItem mapFilterItem) {
    _mapFilterItem = mapFilterItem;
    if (mapFilterItem.type == 'Products') {
      show_products();
    } else {
      show_farmers();
    }
  }
}

class _SinglePosition extends StatelessWidget {
  final MapItem item;
  List<String> _images = [];

  _SinglePosition(this.item);

  @override
  Widget build(BuildContext context) {
    _images = Images.network_links;
    _images.shuffle();
    _images.shuffle();
    MaterialThemeData mTheme = MaterialTheme.estateTheme;
    return InkWell(
      onTap: () => {
        if (item.type == 'product')
          {
            Utils.navigate_to(AppConfig.ProductDetails, context,
                data: item.product)
          }
        else
          {
            Utils.navigate_to(AppConfig.AccountDetails, context,
                data: item.user)
          }
      },
      child: FxCard(
        shadow: FxShadow(elevation: 5),
        color: Colors.white,
        borderRadiusAll: mTheme.containerRadius.medium,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        margin: EdgeInsets.only(bottom: 8, left: 5, right: 3),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(mTheme.containerRadius.medium),
              child: CachedNetworkImage(
                height: 72,
                width: 72,
                fit: BoxFit.cover,
                imageUrl: item.photo,
                placeholder: (context, url) => ShimmerLoadingWidget(
                    height: 72, width: 72, is_circle: false, padding: 0),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage('./assets/project/no_image.jpg'),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.b1(
                      item.title,
                      fontWeight: 600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey.shade900,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_pin,
                            color: CustomTheme.primary,
                            size: 14,
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(left: 2),
                                child: FxText.b3(
                                  item.sub_title,
                                  fontWeight: 400,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: Colors.grey.shade800,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  int _radioValue = 0;
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: FxSpacing.xy(24, 16),
        decoration: BoxDecoration(
            color: customTheme.card,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FxSpacing.height(8),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _radioValue = 0;
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        onChanged: (dynamic value) {
                          setState(() {
                            _radioValue = 0;
                          });
                        },
                        groupValue: _radioValue,
                        value: 0,
                        visualDensity: VisualDensity.compact,
                        activeColor: theme.colorScheme.primary,
                      ),
                      FxText.sh2("Price - ", fontWeight: 60),
                      FxText.sh2("Cheapest"),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    setState(() {
                      _radioValue = 2;
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        onChanged: (dynamic value) {
                          setState(() {
                            _radioValue = 2;
                          });
                        },
                        groupValue: _radioValue,
                        value: 2,
                        visualDensity: VisualDensity.compact,
                        activeColor: theme.colorScheme.primary,
                      ),
                      FxText.sh2("Distance - ", fontWeight: 600),
                      FxText.sh2("Nearest"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _radioValue = 3;
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        onChanged: (dynamic value) {
                          setState(() {
                            _radioValue = 3;
                          });
                        },
                        groupValue: _radioValue,
                        value: 3,
                        visualDensity: VisualDensity.compact,
                        activeColor: theme.colorScheme.primary,
                      ),
                      FxText.sh2("Name - ", fontWeight: 600),
                      FxText.sh2("A to Z"),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class FilterBottomSheet extends StatefulWidget {
  final Function do_filter;

  const FilterBottomSheet(this.do_filter);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState(do_filter);
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final Function do_filter;

  bool colorBlack = false,
      colorRed = true,
      colorOrange = false,
      colorTeal = true,
      colorPurple = false;

  bool sizeXS = false,
      sizeS = true,
      sizeM = false,
      sizeL = true,
      sizeXL = false;

  late ThemeData theme;
  late CustomTheme customTheme;

  _FilterBottomSheetState(this.do_filter);

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: customTheme.card,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0))),
      padding: FxSpacing.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: FxSpacing.fromLTRB(16, 5, 16, 5),
            child: FxText.sh2(
              "What do you want to see?",
              fontWeight: 600,
              color: Colors.black,
            ),
          ),
          Container(
            child: _TypeChipWidget(my_on_change),
          ),
          Container(
            padding: FxSpacing.fromLTRB(16, 5, 16, 5),
            child: FxText.sh2(
              "Specify Category",
              fontWeight: 600,
              color: Colors.black,
            ),
          ),
          Container(
            padding: FxSpacing.x(16),
            child: CupertinoTextField(
              readOnly: true,
              decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  border: Border.all(color: CustomTheme.primary)),
              cursorColor: theme.colorScheme.primary,
              placeholder: "Pick a category",
              controller: category_controller,
              onTap: () => {pick_category()},
              prefix: Padding(
                padding: FxSpacing.x(16),
                child: Icon(
                  Icons.category,
                  color: CustomTheme.primary,
                ),
              ),
              suffix: Padding(
                padding: FxSpacing.x(16),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(color: theme.colorScheme.onBackground),
              padding: FxSpacing.xy(8, 16),
              placeholderStyle: TextStyle(
                  color: theme.colorScheme.onBackground.withAlpha(160)),
            ),
          ),
          Container(
            padding: FxSpacing.fromLTRB(16, 16, 16, 5),
            child: FxText.sh2(
              "Specify Location",
              fontWeight: 600,
              color: Colors.black,
            ),
          ),
          Container(
            padding: FxSpacing.x(16),
            child: CupertinoTextField(
              controller: location_controller,
              decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  border: Border.all(color: CustomTheme.primary)),
              cursorColor: theme.colorScheme.primary,
              placeholder: "Pick a region",
              onTap: () => {pick_location()},
              readOnly: true,
              prefix: Padding(
                padding: FxSpacing.x(16),
                child: Icon(
                  Icons.room,
                  color: CustomTheme.primary,
                ),
              ),
              suffix: Padding(
                padding: FxSpacing.x(16),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(color: theme.colorScheme.onBackground),
              padding: FxSpacing.xy(8, 16),
              placeholderStyle: TextStyle(
                  color: theme.colorScheme.onBackground.withAlpha(160)),
            ),
          ),
          Container(
            padding: FxSpacing.fromLTRB(16, 16, 16, 0),
            child: FxButton.block(
              onPressed: () => {_do_filter()},
              shadowColor: Colors.white,
              child: FxText.b1(
                "APPLY FILTER",
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorWidget({Color? color, bool checked = true}) {
    return FxContainer.none(
      width: 36,
      height: 36,
      color: color,
      borderRadiusAll: 18,
      child: checked
          ? Center(
              child: Icon(
                MdiIcons.check,
                color: Colors.white,
                size: 20,
              ),
            )
          : Container(),
    );
  }

  MapFilterItem mapFilterItem = new MapFilterItem();
  final TextEditingController location_controller = TextEditingController();
  final TextEditingController category_controller = TextEditingController();

  Future<void> pick_location() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationMain()),
    );

    if (result != null) {
      if ((result['location_sub_id'] != null) &&
          (result['location_sub_name'] != null)) {
        mapFilterItem.location_name = result['location_sub_name'];
        mapFilterItem.location_id = result['location_sub_id'];
        setState(() {
          location_controller.text = mapFilterItem.location_name;
        });
      }
    }
  }

  Future<void> pick_category() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductCategoryPicker()),
    );

    if (result != null) {
      if ((result['category_id'] != null) &&
          (result['category_text'] != null)) {
        mapFilterItem.category_name = result['category_text'];
        mapFilterItem.category_id = result['category_id'];
        setState(() {
          category_controller.text = mapFilterItem.category_name;
        });
      }
    }
  }

  my_on_change(String selected) {
    mapFilterItem.type = selected;
  }

  _do_filter() {

    Navigator.pop(context);
    do_filter(mapFilterItem);
  }
}

class _TypeChipWidget extends StatefulWidget {
  final List<String> typeList = ["Products", "Farmers"];
  final Function my_on_change;

  _TypeChipWidget(this.my_on_change);

  @override
  _TypeChipWidgetState createState() => _TypeChipWidgetState(my_on_change);
}

class _TypeChipWidgetState extends State<_TypeChipWidget> {
  final Function my_on_change;

  _TypeChipWidgetState(this.my_on_change);

  List<String> selectedChoices = [];
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.typeList.forEach((item) {
      choices.add(Container(
        padding: FxSpacing.only(left: 10),
        child: ChoiceChip(
          backgroundColor: customTheme.card,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          selectedColor: CustomTheme.primary,
          label: FxText.b2(item,
              fontSize: 20,
              color: selectedChoices.contains(item)
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onBackground,
              fontWeight: selectedChoices.contains(item) ? 700 : 600),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              my_on_change(item);
              if (selectedChoices.contains(item)) {
                selectedChoices.clear();
              } else {
                selectedChoices.clear();
                selectedChoices.add(item);
              }
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

