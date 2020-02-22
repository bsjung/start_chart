import 'dart:math';
import 'package:flutter/material.dart';
import './renderer/line_renderer.dart';

class LineChart extends StatelessWidget {
  LineChart({
    @required this.data,
    this.size = const Size(150, 150),
    this.lineWidth = 2.0,
    this.lineColor = Colors.pinkAccent,
    this.pointSize = 5.0,
    this.pointColor = Colors.pinkAccent,
    this.textfontSize = 18.0,
  }) : assert(data != null);

  final List data;
  final Size size;
  final double lineWidth;
  final Color lineColor;
  final double pointSize;
  final Color pointColor;
  final double textfontSize;

  @override
  Widget build(BuildContext context) {
    return new LimitedBox(
      child: new CustomPaint(
        size: this.size,
        painter: new LineChartPainter(
                         points: this.data,
                         lineColor: this.lineColor,
                         lineWidth: this.lineWidth,
                         pointSize: this.pointSize,
                         pointColor: this.pointColor,
                         textfontSize: this.textfontSize,
                      ),
      ), // CustomPaint
    ); // LimitedBox
  }
}

