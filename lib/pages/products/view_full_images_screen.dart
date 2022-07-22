import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../theme/app_notifier.dart';
import '../../theme/material_theme.dart';
import '../../widget/shimmer_loading_widget.dart';

class ViewFullImagesScreen extends StatefulWidget {
  List<String> photos;

  ViewFullImagesScreen(this.photos);

  @override
  State<ViewFullImagesScreen> createState() =>
      ViewFullImagesScreenState(this.photos);
}

class ViewFullImagesScreenState extends State<ViewFullImagesScreen> {
  List<String> photos;

  ViewFullImagesScreenState(this.photos);

  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {}

  @override
  void dipose() {}

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return Scaffold(
            body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView(
              pageSnapping: true,
              controller: pageController,
              physics: ClampingScrollPhysics(),
              onPageChanged: (index) => {},
              children: _buildHouseList(photos),
            ),
          ),
        ));
      },
    );
  }
}

List<Widget> _buildHouseList(List<String> photos) {
  List<Widget> list = [];

  photos.forEach((element) {
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
      color: Colors.black,
      paddingAll: 0,
      borderRadiusAll: 0,
      margin: EdgeInsets.all(0),
      child: CachedNetworkImage(
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.contain,
        imageUrl: this.image_url,
        placeholder: (context, url) => ShimmerLoadingWidget(
          height: double.infinity,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
