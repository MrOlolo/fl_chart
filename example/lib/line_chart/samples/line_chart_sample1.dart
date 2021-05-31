import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class LineChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  bool isShowingMainData;
  List<FlSpot> spots;
  int lines = 0;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    spots = [
      FlSpot(1, 1),
      FlSpot(3, 4),
      FlSpot(5, 1.8),
      FlSpot(7, 5),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const Text(
                  'Unfold Shop 2018',
                  style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Monthly Sales',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                      child: CustomPaint(
                        painter: MyPainter(
                            bottomTitleSize: 32,
                            leftTitleSize: 38,
                            text: 'если не инвестировать',
                            anotherLine: spots,
                            lineForText: [
                              FlSpot(1, 1),
                              // FlSpot(3, 4),
                              // FlSpot(5, 1.8),
                              // FlSpot(7, 5),
                              // FlSpot(10, 2),
                              FlSpot(12, 2.2),
                              // FlSpot(13, 1.8),
                            ]),
                        child: LineChart(
                          isShowingMainData ? sampleData1(spots) : sampleData2(),
                          swapAnimationDuration: const Duration(milliseconds: 3000),
                          resetTouchIndicatorOnTapUp: true,
                          useLineAnimation: true,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      if (lines < 1) {
                        spots = List.of(spots.sublist(0, spots.length - 5));
                      } else {
                        lines--;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      isShowingMainData = !isShowingMainData;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      if (lines > 2) {
                        final last = spots.last;
                        spots = List.of([
                          FlSpot(1, 1),
                          FlSpot(3, 4),
                          FlSpot(5, 1.8),
                          // FlSpot(7, 5),
                          // FlSpot(10, 2),

                          FlSpot(last.x + 0.1, last.y + 0.1),
                          FlSpot(last.x + 0.21, last.y + 0.21),
                          FlSpot(last.x + 0.30, spots.first.y),
                          FlSpot(last.x + 0.31, last.y + 0.1),
                          FlSpot(last.x + 0.41, last.y + 0.21),
                          FlSpot(last.x + 0.61, spots.first.y),
                          FlSpot(last.x + 1.61, last.y + 0.21)
                        ]);
                      } else {
                        lines++;
                      }
                    });
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1(List<FlSpot> spots) {
    print(spots.map((e) => e.x).reduce(min));
    print(spots.map((e) => e.x).reduce(max));

    print(spots.map((e) => e.y).reduce(min));
    print(spots.map((e) => e.y).reduce(max));
    return LineChartData(
      alwaysShowTouchIndicator: true,
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
                        FlDotCirclePainterWithArrows(
                            showHints: true,
                            disableRightHint: int == (lineChartBarData.spots.length - 1),
                            disableLeftHint: int == 0,
                            radius: 9.0,
                            color: Colors.blue,
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
                            ])))),
        touchTooltipData: LineTouchTooltipData(
          maxContentWidth: 150,
          tooltipBgColor: Colors.transparent,
          getTooltipItems: (touchedSpots) => touchedSpots.map((element) {
            return LineTooltipItem('1', TextStyle(fontSize: 20), textAxisX: 'x', textAxisY: 'y');
          }).toList(),
          tooltipRoundedRadius: 10.0,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          customTooltipLabels: true,
          tooltipPadding: EdgeInsets.only(left: 17.0, right: 10.0, top: 2.0, bottom: 2.0),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            if (value.toInt() % 5 == 0 && value.toInt() > 10) {
              return 'Kek';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
            }
            if (value.toInt() % 1 == 0 && value.toInt() > 4) {
              return 'Kekm';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
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
      // minX: 0,
      // maxX: 14,
      // maxY: 4,
      // minY: 0,
      lineBarsData: linesBarData1(spots),
    );
  }

  List<LineChartBarData> linesBarData1(List<FlSpot> spots) {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final dataBars = [
      lineChartBarData1,
      if (lines > 0) lineChartBarData2,
      if (lines > 1) lineChartBarData3
    ];
    return dataBars;
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
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
          )),
      minX: 0,
      maxX: 14,
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x444af699),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}

class MyPainter extends CustomPainter {
  final TextStyle textStyle;
  final String text;
  final List<FlSpot> lineForText;
  final List<FlSpot> anotherLine;
  final double leftTitleSize;
  final double bottomTitleSize;
  final double maxX, maxY, minX, minY;

  MyPainter({
    this.textStyle,
    this.text = 'text',
    @required this.lineForText,
    this.anotherLine,
    this.leftTitleSize = 0,
    this.bottomTitleSize = 0,
    this.maxX,
    this.maxY,
    this.minX,
    this.minY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    final Size newSize = (size - Offset(leftTitleSize, bottomTitleSize));

    double _maxX = 0, _maxY = 0;
    double _minX = double.maxFinite, _minY = double.maxFinite;
    final len = max(lineForText.length, anotherLine?.length ?? 0);
    for (var i = 0; i < len; i++) {
      if ((lineForText?.length ?? 0) > i) {
        _maxX = max(_maxX, lineForText[i].x);
        _maxY = max(_maxY, lineForText[i].y);
        _minX = min(_minX, lineForText[i].x);
        _minY = min(_minY, lineForText[i].y);
      }
      if ((anotherLine?.length ?? 0) > i) {
        _maxX = max(_maxX, anotherLine[i].x);
        _maxY = max(_maxY, anotherLine[i].y);
        _minX = min(_minX, anotherLine[i].x);
        _minY = min(_minY, anotherLine[i].y);
      }
    }

    if (minX != null) _minX = min(_minX, minX);
    if (minY != null) _minY = min(_minY, minY);
    if (maxX != null) _maxX = max(_maxX, maxX);
    if (maxY != null) _maxY = max(_maxY, maxY);

    final xAxisLen = _maxX - _minX;
    final yAxisLen = _maxY - _minY;
    print(yAxisLen);
    print(xAxisLen);

    final wh = (newSize.width / 12) / (newSize.height / 4);

    // canvas.rotate(-atan2(newSize.height * 0.8 / 4, (newSize.width)));
    print(wh);
    print(atan2((4 - 1) * wh, (13 - 1)) * 180 / pi);
    print(atan2(newSize.height * 0.8 / 4, (newSize.width)) * 180 / pi);
    print('width ${newSize.width}');
    print('height ${newSize.height * 0.8 / 4}');

    Paint line = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    Paint complete = new Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    // canvas.drawRect(Offset(38, 0) & newSize, line);

    TextSpan span = new TextSpan(style: textStyle, text: '——   ' + text);
    TextPainter tp = new TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    canvas.save();
    canvas.translate(tp.height + leftTitleSize, newSize.height);
    canvas.rotate(-atan2((lineForText.last.y - lineForText.first.y) / yAxisLen * newSize.height,
        (lineForText.last.x - lineForText.first.x) / xAxisLen * newSize.width));
    tp.paint(canvas, new Offset(newSize.width - tp.width, 0));
    // optional, if you saved earlier
    canvas.restore();
    canvas.drawPoints(
        PointMode.lines,
        [
          Offset(newSize.width * 9 / 12 + 38, newSize.height * (4 - 1) / 4),
          Offset(newSize.width * 0 / 12 + 38, newSize.height * (4 - 0) / 4)
        ],
        complete);

    tp.paint(canvas, new Offset(newSize.width - tp.width + leftTitleSize, newSize.height));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FlDotCirclePainterWithArrows extends FlDotPainter {
  /// Flag for show hint arrows
  bool showHints;

  /// Flag to disable left arrow
  bool disableLeftHint;

  /// Flag to disable right arrow
  bool disableRightHint;

  /// The fill color to use for the circle
  Color color;

  /// Customizes the radius of the circle
  double radius;

  /// The stroke color to use for the circle
  Color strokeColor;

  /// The stroke width to use for the circle
  double strokeWidth;

  /// Shadow
  List<Shadow> shadow;

  /// The color of the circle is determined determined by [color],
  /// [radius] determines the radius of the circle.
  /// You can have a stroke line around the circle,
  /// by setting the thickness with [strokeWidth],
  /// and you can change the color of of the stroke with [strokeColor].
  FlDotCirclePainterWithArrows({
    Color color,
    double radius,
    Color strokeColor,
    double strokeWidth,
    List<Shadow> shadow,
    bool showHints,
    bool disableRightHint,
    bool disableLeftHint,
  })  : color = color ?? Colors.green,
        radius = radius ?? 4.0,
        strokeColor = strokeColor ?? Colors.green,
        strokeWidth = strokeWidth ?? 1.0,
        shadow = shadow ?? [],
        showHints = showHints ?? true,
        disableLeftHint = disableLeftHint ?? false,
        disableRightHint = disableRightHint ?? false;

  /// Implementation of the parent class to draw the circle
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    ///draw shadows
    for (var item in shadow) {
      canvas.drawCircle(
          offsetInCanvas.translate(item.offset.dx, item.offset.dy),
          radius,
          Paint()
            ..color = item.color
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, item.blurSigma));
    }

    if (strokeWidth != 0.0 && strokeColor.opacity != 0.0) {
      canvas.drawCircle(
          offsetInCanvas,
          radius + (strokeWidth / 2),
          Paint()
            ..color = strokeColor
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke);
    }
    canvas.drawCircle(
        offsetInCanvas,
        radius,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);

    // canvas.drawRect(
    //     offsetInCanvas.translate(radius + 5, -radius) & Size(10, 20),
    //     Paint()
    //       ..color = color
    //       ..style = PaintingStyle.fill);
    // canvas.drawRect(
    //     offsetInCanvas.translate(-(radius + 5), -radius) & Size(-10, 20),
    //     Paint()
    //       ..color = color
    //       ..style = PaintingStyle.fill);
    if (!showHints) return;

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    if (!disableLeftHint) {
      final leftChevron = Icons.chevron_left_rounded;
      textPainter.text = TextSpan(
        text: String.fromCharCode(leftChevron.codePoint),
        style: TextStyle(
          color: Colors.white.withOpacity(0.1),
          // shadows: shadow,
          fontSize: radius * 4,
          fontFamily: leftChevron.fontFamily,
          package: leftChevron.fontPackage, // This line is mandatory for external icon packs
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, offsetInCanvas.translate(-radius * 4, -2 * radius));
    }

    if (!disableRightHint) {
      final rightChevron = Icons.chevron_right_rounded;
      textPainter.text = TextSpan(
        text: String.fromCharCode(rightChevron.codePoint),
        style: TextStyle(
          color: Colors.white.withOpacity(0.1),
          // shadows: shadow,
          fontSize: radius * 4,
          fontFamily: rightChevron.fontFamily,
          package: rightChevron.fontPackage, // This line is mandatory for external icon packs
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, offsetInCanvas.translate(0, -2 * radius));
    }
  }

  /// Implementation of the parent class to get the size of the circle
  @override
  Size getSize(FlSpot spot) {
    return Size(radius * 2, radius * 2);
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        color,
        radius,
        strokeColor,
        strokeWidth,
      ];
}
