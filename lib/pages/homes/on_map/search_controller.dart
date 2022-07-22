import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/map_item.dart';
import '../../../theme/app_theme.dart';

class SearchController extends FxController {
  final LatLng center = const LatLng(45.521563, -122.677433);
  bool showLoading = false, uiLoading = false;
  late GoogleMapController mapController;
  List<MapItem> map_items = [];
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  int currentPage = 0;

  final Set<Marker> marker = {};

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMapTheme();
  }

  @override
  void initState() {
    super.save = false;
    super.initState();
  }

  Future<void> setMapTheme() async {
    if (AppTheme.theme == AppTheme.darkTheme) {
      String mapStyle = await rootBundle
          .loadString('assets/images/apps/estate/map-dark-style.txt');
      mapController.setMapStyle(mapStyle);
    }
  }

  @override
  String getTag() {
    return "search_controller";
  }

  onMarkerTap(MapItem item) {
    if (map_items.isEmpty) {
      return;
    }
    int position = 0;
    int x = 0;
    map_items.forEach((element) {
      if (element.id.toString() == item.id.toString()) {
        position = x;
      }
      x++;
    });

    pageController.animateToPage(
      position,
      duration: Duration(milliseconds: 800),
      curve: Curves.ease,
    );
    update();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  add_marker(MapItem item) async {
    double lati = 0.364607;
    double long = 32.604781;

    try {
      lati = double.parse(item.lati.toString());
      long = double.parse(item.longi.toString());
    } catch (e) {
      lati = 0.364607;
      long = 32.604781;
    }
    LatLng point = new LatLng(lati, long);

    marker.add(
      Marker(
          icon: BitmapDescriptor.fromBytes(
              await getBytesFromAsset('assets/project/marker.png', 70)),
          markerId: MarkerId("${item.type}-${item.id}"),
          position: point,
          onTap: () {
            onMarkerTap(item);
          }),
    );
  }

  addMarkers(List<MapItem> items) async {
    if (items.isEmpty) {
      return;
    }
    marker.clear();
    map_items.clear();
    for (int x = 0; x < items.length; x++) {
      map_items.add(items[x]);
      await add_marker(items[x]);
    }
    update();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
