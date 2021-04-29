import 'package:flutter/material.dart';

import 'samples/line_chart_sample1.dart';
import 'samples/line_chart_sample2.dart';

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff262545),
        child: Padding(
            padding: EdgeInsets.only(left: 36.0, top: 24, right: 36), child: LineChartSample1()));
  }
}
