import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'line_chart_data.dart';
import 'line_chart_renderer.dart';

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  ///Determines the behavior of touch indicator
  final bool resetTouchIndicatorOnTapUp;

  ///Determines the curve for line drawing animation when it enable
  final Curve lineAnimationCurve;

  ///Enable staggered animation for chart swap(draw line after graph swap-animation)
  final bool useLineAnimation;

  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const LineChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
    this.resetTouchIndicatorOnTapUp = false,
    this.useLineAnimation = false,
    this.lineAnimationCurve = Curves.easeInOut,
  }) : super(duration: swapAnimationDuration, curve: swapAnimationCurve);

  /// Creates a [_LineChartState]
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [LineChartData] to the new one.
  LineChartDataTween? _lineChartDataTween;
  FlSpotsTweenList? _spotsTweenList;
  // FlSpotsTween? _spotsTween;

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  bool needClear = false;

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();
    // print('build');
    // print(_lineChartDataTween!.evaluate(animation).lineBarsData.first.spots.length);
    // print(animation);
    if (needClear) {
      needClear = false;

      _showingTouchedTooltips.clear();
      _showingTouchedIndicators.clear();
      _showingTouchedTooltips.add(ShowingTooltipIndicators(showingData.lineBarsData
          .map((barData) =>
              LineBarSpot(barData, showingData.lineBarsData.indexOf(barData), barData.spots.last))
          .toList()));
    }

    /// Wr wrapped our chart with [GestureDetector], and onLongPressStart callback.
    /// because we wanted to lock the widget from being scrolled when user long presses on it.
    /// If we found a solution for solve this issue, then we can remove this undoubtedly.
    late final LineChartData chart;
    if (widget.useLineAnimation) {
      final temp = _lineChartDataTween!.evaluate(
          CurvedAnimation(parent: controller, curve: Interval(0, 0.45, curve: widget.curve)));
      final barData = <LineChartBarData>[];
      // print('len ${temp.lineBarsData.length}');
      for (var i = 0; i < temp.lineBarsData.length; i++) {
        List<FlSpot>? spotsTemp;
        try {
          spotsTemp = _spotsTweenList!
              .evaluate(CurvedAnimation(
                  parent: controller, curve: Interval(0.50, 1, curve: widget.lineAnimationCurve)))
              .toList()[i];
        } catch (e) {}
        if (spotsTemp != null) {
          final tempData = temp.lineBarsData[i].copyWith(spots: spotsTemp);
          barData.add(tempData);
        }
      }
      chart = temp.copyWith(lineBarsData: barData);
    } else {
      chart = _lineChartDataTween!.evaluate(animation);
    }
    // print('chart data ${chart.lineBarsData.length}');

    return GestureDetector(
      onLongPressStart: (details) {},
      child: LineChartLeaf(
        data: _withTouchedIndicators(chart),
        targetData: _withTouchedIndicators(showingData),
        touchCallback: _handleBuiltInTouch,
      ),
    );
  }

  LineChartData _withTouchedIndicators(LineChartData lineChartData) {
    if (!lineChartData.lineTouchData.enabled || !lineChartData.lineTouchData.handleBuiltInTouches) {
      return lineChartData;
    }

    if (_showingTouchedTooltips.isEmpty && widget.data.alwaysShowTouchIndicator) {
      _showingTouchedTooltips.add(ShowingTooltipIndicators(lineChartData.lineBarsData
          .map((barData) =>
              LineBarSpot(barData, lineChartData.lineBarsData.indexOf(barData), barData.spots.last))
          .toList()));
    }

    return lineChartData.copyWith(
      showingTooltipIndicators: _showingTouchedTooltips,
      lineBarsData: lineChartData.lineBarsData.map((barData) {
        final index = lineChartData.lineBarsData.indexOf(barData);
        late final List<int> defaultIndicators;
        if (_getData().alwaysShowTouchIndicator) {
          defaultIndicators = [lineChartData.lineBarsData[index].spots.length - 1];
        } else {
          defaultIndicators = <int>[];
        }
        return barData.copyWith(
          showingIndicators: _showingTouchedIndicators[index] ?? defaultIndicators,
        );
      }).toList(),
    );
  }

  LineChartData _getData() {
    // print('getData');
    final lineTouchData = widget.data.lineTouchData;
    if (lineTouchData.enabled && lineTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        lineTouchData: widget.data.lineTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(LineTouchResponse touchResponse) {
    widget.data.lineTouchData.touchCallback?.call(touchResponse);

    final desiredTouch = touchResponse.touchInput is PointerDownEvent ||
        touchResponse.touchInput is PointerMoveEvent ||
        touchResponse.touchInput is PointerHoverEvent;
    if (desiredTouch && touchResponse.lineBarSpots != null) {
      setState(() {
        final sortedLineSpots = List.of(touchResponse.lineBarSpots!);

        if (widget.data.showMaxValueAtTheTop) {
          sortedLineSpots.sort((spot1, spot2) => spot1.y.compareTo(spot2.y));
        } else {
          sortedLineSpots.sort((spot1, spot2) => spot2.y.compareTo(spot1.y));
        }

        if (!widget.data.alwaysShowTouchIndicator) {
          _showingTouchedIndicators.clear();
        }

        for (var i = 0; i < touchResponse.lineBarSpots!.length; i++) {
          final touchedBarSpot = touchResponse.lineBarSpots![i];
          final barPos = touchedBarSpot.barIndex;
          _showingTouchedIndicators[barPos] = [touchedBarSpot.spotIndex];
        }

        if (sortedLineSpots.isNotEmpty && widget.data.alwaysShowTouchIndicator) {
          _showingTouchedTooltips.clear();
          _showingTouchedTooltips.add(ShowingTooltipIndicators(sortedLineSpots));
        }
        // _showingTouchedTooltips.clear();
        // _showingTouchedTooltips.add(ShowingTooltipIndicators(0, sortedLineSpots));
      });
    } else {
      if (!widget.data.alwaysShowTouchIndicator) {
        setState(() {
          _showingTouchedTooltips.clear();
          _showingTouchedIndicators.clear();
        });
      } else {
        if (widget.resetTouchIndicatorOnTapUp == true) {
          needClear = true;
          Future.delayed(Duration(milliseconds: 50), () => setState(() {}));
        }
      }
    }
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    // print('forEachTween');
    var barData = _lineChartDataTween?.end?.lineBarsData.first;
    var spots = barData?.spots;
    if (spots != null && spots.isNotEmpty) {
      final showingData = _getData();

      if (spots.first != showingData.lineBarsData.first.spots.first) {
        needClear = true;
      } else {
        var needUpdate =
            spots.every((element) => !showingData.lineBarsData.first.spots.contains(element));
        if (needUpdate == false) {
          if (_showingTouchedIndicators.isEmpty ||
              _showingTouchedIndicators.isNotEmpty &&
                  _showingTouchedIndicators[0]!.first == spots.length - 1) {
            needUpdate = true;
          }
        }
        if (needUpdate) {
          needClear = true;
        }
      }
    }
    // print('kekWait');
    // print(_lineChartDataTween?.begin?.lineBarsData.first.spots.length);
    // print(_lineChartDataTween?.end?.lineBarsData.first.spots.length);
    // print('kekWait hmm');
    _lineChartDataTween = visitor(
      _lineChartDataTween,
      _getData(),
      (dynamic value) {
        // print('hello at visitor');
        // print((value as LineChartData).lineBarsData.first.spots.length);
        // print('end of visitor');
        return LineChartDataTween(begin: value, end: widget.data);
      },
    ) as LineChartDataTween;

    // _spotsTween = visitor(
    //   _spotsTween,
    //   _getData().lineBarsData.first.spots,
    //   (dynamic value) {
    //     return FlSpotsTween(begin: value, end: widget.data.lineBarsData.first.spots);
    //   },
    // ) as FlSpotsTween;

    _spotsTweenList = visitor(
      _spotsTweenList,
      _getData().lineBarsData.map((e) => e.spots).toList(),
      (dynamic value) {
        return FlSpotsTweenList(
            begin: value, end: widget.data.lineBarsData.map((e) => e.spots).toList());
      },
    ) as FlSpotsTweenList;
    // print(_lineChartDataTween?.begin?.lineBarsData.first.spots.length);
    // print(_lineChartDataTween?.end?.lineBarsData.first.spots.length);
    // print('kekWait ok');
  }
}
