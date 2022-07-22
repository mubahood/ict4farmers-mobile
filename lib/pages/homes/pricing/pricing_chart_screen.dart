import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/custom_theme.dart';
import '../../../widgets/images.dart';

class EstateSplashScreen extends StatefulWidget {
  const EstateSplashScreen({Key? key}) : super(key: key);

  @override
  _EstateSplashScreenState createState() => _EstateSplashScreenState();
}

class _EstateSplashScreenState extends State<EstateSplashScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late SplashController controller;

  late TooltipBehavior _tooltipBehavior;

  @override
  initState() {
    super.initState();

    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);

    FxControllerStore.resetStore();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    controller = FxControllerStore.putOrFind(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.estatePrimary.withAlpha(80))),
      debugShowCheckedModeBanner: false,
      home: FxBuilder<SplashController>(
          controller: controller,
          builder: (controller) {
            return Scaffold(
              body: Stack(
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/project/estate16.jpg"),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: FxText.h3(
                      'Let\'s Help you set a right price for your farm products',
                      color: customTheme.estateOnPrimary,
                      textAlign: TextAlign.center,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: FxText.d3(
                      'Cocoa Price',
                      color: customTheme.estateOnPrimary,
                      textAlign: TextAlign.center,
                      fontWeight: 800,
                    ),
                  ),
                  Positioned(
                    top: 130,
                    child: FxCard(
                        paddingAll: 0,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 60),
                        child: Container(
                            width: double.infinity,
                            height: 320,
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.all(0),
                            child: _buildDefaultRangeColumnChart())),
                  ),
                  Positioned(
                    top: 468,
                    child: FxCard(
                      onTap: () {
                        controller.goToLogin();
                      },
                      paddingAll: 24,
                      color: customTheme.estatePrimary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      width: MediaQuery.of(context).size.width - 30,
                      margin: EdgeInsets.only(top: 32, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FxText.b2(
                            'Modify Filter',
                            fontWeight: 700,
                            fontSize: 25,
                            color: customTheme.estateOnPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  SfCartesianChart _buildDefaultRangeColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(textStyle: FxTextStyle.caption()),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          interval: 5,
          labelFormat: '{value}',
          majorTickLines: MajorTickLines(size: 8, color: Colors.transparent)),
      series: _getDefaultRangeColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<RangeColumnSeries<ChartSampleData, String>>
      _getDefaultRangeColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jinja', y: 1000, yValue: 1300),
      ChartSampleData(x: 'Busia', y: 1200, yValue: 1500),
      ChartSampleData(x: 'Kasese', y: 800, yValue: 1300),
      ChartSampleData(x: 'Mbale', y: 700, yValue: 1000),
      ChartSampleData(x: 'Gulu', y: 900, yValue: 1500),
      ChartSampleData(x: 'Arua', y: 600, yValue: 1200),
    ];
    return <RangeColumnSeries<ChartSampleData, String>>[
      RangeColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }
}

class SplashController extends FxController {
  @override
  String getTag() {
    return "splash_controller";
  }

  void goToSearchScreen() {
    /* Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (context) => EstateSearchScreen()),
    );*/
  }

  void goToLogin() {
    /* Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (context) => EstateLoginScreen()),
    );*/
  }
}
