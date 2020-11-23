import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui';

class ColorStyles {
  static const backgroundColor = const Color(0xFF252F2E);
  static const buttonColor = const Color(0xFF38EFB4);
  static const white = const Color(0xFFFFFFFF);
  static const cardTextColor = const Color(0xFF050000);
  static const containerColor = const Color(0xFF787878);
  static const sliderColor = const Color(0xFFC7C7C7);
  static const containerButtonColor = const Color(0xFF363E3D);
  static const borderColor = const Color(0xFF1FC593);
  static const numberApproveColor = const Color(0xFFDEDEDE);
  static const smsApproveColor = const Color(0xFFBBBBBB);
  static const hintTextColor = const Color(0xFF989898);
  static const inviteFieldColor = const Color(0xFF605E5E);
  static const endPageGreenTextColor = const Color(0xFFA0FFE3);
  static const saveLineColor = const Color(0xFF6A6B6B);
  static const mainPageTitleColor = const Color(0xFF757777);
  static const redColor = const Color(0xFFFF4B4B);
  static const greyTextColor = const Color(0xFFB1B8BF);
  static const mainPageCapitalColor = const Color(0xFFF5F5F5);
  static const graphTooltipColor = const Color(0xFF767D7B);
  static const graphGridColor = const Color(0xFFC4C4C4);
  static const graphDotGreyColor = const Color(0xFFDBDBDB);
}

class TestGraph extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestGraphState();
}

class TestGraphState extends State<TestGraph> {
  bool isShowingMainData;

  double minSum = 0;
  double maxSum = 150000;
  int dayNum = 12;
  double gridNum = 0;
  Random random = new Random();

  List<FlSpot> spotsBarFirst = [];
  List<FlSpot> spotsBarSecond = [];
  DateTime firstDate;

  @override
  void initState() {
    firstDate = DateTime.utc(2020, DateTime.november, 1);
    gridNum = (maxSum - minSum) / 5;
    double sum = 0;
    double sum2 = 0;
    for (int i = 0; i < dayNum; i++) {
      spotsBarFirst.add(FlSpot(i.toDouble(), sum));
      sum += random.nextInt((maxSum / dayNum).round());
      sum += random.nextInt(100) / 100;
      spotsBarSecond.add(FlSpot(i.toDouble(), sum2));
      sum2 += random.nextInt((maxSum / dayNum / 2).round());
      sum2 += random.nextInt(100) / 100;
    }
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: ColorStyles.backgroundColor,
        automaticallyImplyLeading: false,
        border: Border.all(width: 0, color: Colors.transparent),
      ),
      backgroundColor: ColorStyles.backgroundColor,
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(18)),
              color: ColorStyles.containerColor.withOpacity(0.2),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                        child: LineChart(sampleData1()),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator: (barData, spotIndexes) => List.filled(
            spotIndexes.length,
            TouchedSpotIndicatorData(
                FlLine(
                  color: Color.fromARGB(51, 255, 148, 167),
                  strokeWidth: 1.0,
                ),
                FlDotData(
                    getDotPainter: (flSpot, double, lineChartBarData, int) =>
                        FlDotCirclePainter(
                            radius: 7.0,
//                            color: lineChartBarData.colors.first,
                            color: lineChartBarData.colors.first ==
                                    ColorStyles.buttonColor
                                ? ColorStyles.endPageGreenTextColor
                                : ColorStyles.graphDotGreyColor,
                            strokeWidth: 0.0,
                            shadow: [
                              Shadow(
                                  color: Color.fromARGB(128, 255, 250, 250),
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 20.0),
                              Shadow(
                                  color: Color.fromARGB(64, 0, 0, 0),
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 4.0),
                              Shadow(
                                  color: Color.fromARGB(64, 0, 0, 0),
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 4.0)
                            ]
                        )))),
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: ColorStyles.graphTooltipColor,
          getTooltipItems: (touchedSpots) => touchedSpots.map((element) {
            return LineTooltipItem('${element.y.toStringAsFixed(2)} ₽',
                TextStyle(color: Colors.white, fontSize: 15, height: 1.28));
          }).toList(),
          tooltipRoundedRadius: 10.0,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          newStyleTooltip: true,
          firstDate: firstDate,
          tooltipPadding:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: gridNum + 1,
        getDrawingHorizontalLine: (val) => FlLine(
//            strokeWidth: 0.0,
            dashArray: [2, 5],
            color: ColorStyles.backgroundColor.withOpacity(0.5)),
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: ColorStyles.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          margin: 25,
          interval: 1,
          getTitles: (value) {
            final List<String> monthList = [
              'Янв',
              'Фев',
              'Мар',
              'Апр',
              'Май',
              'Июнь',
              'Июль',
              'Авг',
              'Сен',
              'Окт',
              'Ноя',
              'Дек',
            ];
            if (value.toInt() == 0) {
              return '${firstDate.year}';
            } else if (value.toInt() == (dayNum ~/ 3).toInt()) {
              return '${monthList[firstDate.add(Duration(days: value.toInt())).month - 1]}';
            } else if (value.toInt() == (dayNum ~/ 3 * 2).toInt()) {
              return '${monthList[firstDate.add(Duration(days: value.toInt())).month - 1]}';
            } else if (value.toInt() == dayNum) {
              return '${monthList[firstDate.add(Duration(days: value.toInt())).month - 1]}';
            } else {
              return '';
            }
//            switch (value.toInt()) {
//
//              case 0:
//                return '${firstDate.year}';
//              case 10:
//                return 'SEPT';
//              case 40:
//                return 'OCT';
//              case 100:
//                return 'DEC';
//            }
//            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: ColorStyles.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value.toInt() == minSum) {
              return '0';
            } else if (value.toInt() == gridNum) {
              return '${(value.toInt() / 1000).round()} тыс ₽';
            } else if (value.toInt() == gridNum * 2) {
              return '${(value.toInt() / 1000).round()} тыс ₽';
            } else if (value.toInt() == gridNum * 3) {
              return '${(value.toInt() / 1000).round()} тыс ₽';
            } else if (value.toInt() == gridNum * 4) {
              return '${(value.toInt() / 1000).round()} тыс ₽';
//            } else if (value.toInt() == gridNum * 5) {
//              return '${(value.toInt() / 1000).round()} тыс ₽';
            } else {
              return '';
            }
          },
          margin: 8,
          reservedSize: 70,
        ),
        rightTitles: SideTitles(
          reservedSize: 10,
              showTitles: true,
          getTitles: (value) {
            return '';
          }
        )
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.transparent,
//            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: dayNum.toDouble(),
      maxY: maxSum,
      minY: minSum,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spotsBarFirst,
//      spots: [
//        FlSpot(1, 5234),
//        FlSpot(3, 9124),
//        FlSpot(5, 14250),
//        FlSpot(7, 25215),
//        FlSpot(10, 30510),
//        FlSpot(12, 34500),
//        FlSpot(13, 45001),
//      ],
//      shadow: Shadow(color: Colors.white, blurRadius: 10.0),

      isCurved: true,
      colors: [ColorStyles.buttonColor],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: spotsBarSecond,
//      spots: [
//        FlSpot(1, 2340),
//        FlSpot(3, 5600),
//        FlSpot(5, 12300),
//        FlSpot(7, 20152),
//        FlSpot(10, 24051),
//        FlSpot(12, 34000),
//        FlSpot(13, 41241),
//      ],
      isCurved: true,
      colors: [
        ColorStyles.saveLineColor,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );

    return [
      lineChartBarData2,
      lineChartBarData1,
    ];
  }
}
