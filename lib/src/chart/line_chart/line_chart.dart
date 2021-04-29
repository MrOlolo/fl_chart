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
  }) : super(duration: swapAnimationDuration, curve: swapAnimationCurve);

  /// Creates a [_LineChartState]
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [LineChartData] to the new one.
  LineChartDataTween? _lineChartDataTween;
  FlSpotsTween? _spotsTween;

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  bool needClear = false;

  @override
  void didUpdateWidget(covariant LineChart oldWidget) {
    // print('didUpdateWidget');
    // print(_lineChartDataTween?.begin?.lineBarsData.first.spots.length);
    // print(_lineChartDataTween?.end?.lineBarsData.first.spots.length);
    // print('didUpdateWidget hmm');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didUpdateTweens() {
    // print('didUpdateTweens');
    // print(_lineChartDataTween?.begin?.lineBarsData.first.spots.length);
    // print(_lineChartDataTween?.end?.lineBarsData.first.spots.length);
    // print('didUpdateTweens hmm');
    super.didUpdateTweens();
  }

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
      _showingTouchedTooltips.add(ShowingTooltipIndicators(
          0,
          showingData.lineBarsData
              .map((barData) => LineBarSpot(
                  barData, showingData.lineBarsData.indexOf(barData), barData.spots.last))
              .toList()));
    }

    /// Wr wrapped our chart with [GestureDetector], and onLongPressStart callback.
    /// because we wanted to lock the widget from being scrolled when user long presses on it.
    /// If we found a solution for solve this issue, then we can remove this undoubtedly.
    final chart = _lineChartDataTween!.evaluate(
        CurvedAnimation(parent: controller, curve: Interval(0, 0.75, curve: widget.curve)));
    return GestureDetector(
      onLongPressStart: (details) {},
      child: LineChartLeaf(
        data: _withTouchedIndicators(chart.copyWith(lineBarsData: [
          chart.lineBarsData.first.copyWith(
              spots: _spotsTween!.evaluate(CurvedAnimation(
                  parent: controller, curve: Interval(0.75, 1, curve: widget.curve))))
        ])),
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
      _showingTouchedTooltips.add(ShowingTooltipIndicators(
          0,
          lineChartData.lineBarsData
              .map((barData) => LineBarSpot(
                  barData, lineChartData.lineBarsData.indexOf(barData), barData.spots.last))
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
          _showingTouchedTooltips.add(ShowingTooltipIndicators(0, sortedLineSpots));
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

    _spotsTween = visitor(
      _spotsTween,
      _getData().lineBarsData.first.spots,
      (dynamic value) {
        return FlSpotsTween(begin: value, end: widget.data.lineBarsData.first.spots);
      },
    ) as FlSpotsTween;
    // print(_lineChartDataTween?.begin?.lineBarsData.first.spots.length);
    // print(_lineChartDataTween?.end?.lineBarsData.first.spots.length);
    // print('kekWait ok');
  }
}
