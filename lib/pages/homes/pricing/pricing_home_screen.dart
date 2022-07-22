import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/custom_theme.dart';
import '../../../widgets/images.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class PricingChartScreen extends StatefulWidget {
  PricingChartScreen({Key? key}) : super(key: key);

  @override
  _PricingChartScreenState createState() => _PricingChartScreenState();
}

class _PricingChartScreenState extends State<PricingChartScreen> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(height: 320, child: _buildDefaultRangeColumnChart()),
        ),
        Positioned(
          bottom: 15,
          left: 0,
          right: 15,
          child: Row(
            children: <Widget>[
              FxSpacing.width(12),
              Expanded(
                child: FxContainer(
                  color: CustomTheme.accent,
                  borderRadiusAll: 4,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return SortBottomSheet();
                        });
                  },
                  margin: FxSpacing.x(4),
                  padding: FxSpacing.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        MdiIcons.swapVertical,
                        color: Colors.grey.shade100,
                        size: 20,
                      ),
                      FxSpacing.width(8),
                      FxText.sh2("Sort",                          color: Colors.grey.shade100, fontWeight: 600, letterSpacing: 0)
                    ],
                  ),
                ),
              ),
              FxSpacing.width(12),
              Expanded(
                child: FxContainer(
                  color: CustomTheme.primary,
                  borderRadiusAll: 4,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return FilterBottomSheet();
                        });
                  },
                  padding: FxSpacing.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        MdiIcons.tune,
                        color: Colors.grey.shade100,
                        size: 22,
                      ),
                      FxSpacing.width(8),
                      FxText.sh2("Filter",
                          color: Colors.white,
                          fontWeight: 600, letterSpacing: 0)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SfCartesianChart _buildDefaultRangeColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Price range of Soya Beans in 6 selected districts is averagely 600 - 1500UGX per KG as displayed in graph below.',
          textStyle: FxTextStyle.caption()),
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








class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
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
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      padding: FxSpacing.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Center(child: FxText.b1("Filter", fontWeight: 700))),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: FxSpacing.all(8),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: Icon(
                      MdiIcons.check,
                      size: 20,
                      color: theme.colorScheme.onPrimary,
                    )),
              )
            ],
          ),
          FxSpacing.height(8),
          FxText.sh2("What do you want to see?", fontWeight: 600, letterSpacing: 0),
          Container(
            child: _TypeChipWidget(),
          ),
          FxSpacing.height(8),


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



class _TypeChipWidget extends StatefulWidget {
  final List<String> typeList = ["Products", "Farmers", "Markets"];

  @override
  _TypeChipWidgetState createState() => _TypeChipWidgetState();
}

class _TypeChipWidgetState extends State<_TypeChipWidget> {
  List<String> selectedChoices = ["Man"];
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
        padding: FxSpacing.all(8),
        child: ChoiceChip(
          backgroundColor: customTheme.card,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          selectedColor: theme.colorScheme.primary,
          label: FxText.b2(item,
              color: selectedChoices.contains(item)
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onBackground,
              fontWeight: selectedChoices.contains(item) ? 700 : 600),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
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

