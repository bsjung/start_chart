import 'dart:math';
import 'package:flutter/material.dart';
import './renderer/line_renderer.dart';

class LineChart extends StatelessWidget {
  LineChart({
    @required this.data,
    this.size = const Size(150, 150),
    this.pointSize = 5.0,
    this.pointColor = Colors.pinkAccent,
    this.lineWidth = 2.0,
    this.lineColor = Colors.pinkAccent,
  }) : assert(data != null);

  final List data;
  final Size size;
  final double pointSize;
  final Color pointColor;
  final double lineWidth;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return new LimitedBox(
      child: new CustomPaint(
        size: this.size,
        painter: new LineChartPainter(
           points: this.data,
           pointSize: this.pointSize,
           pointColor: this.pointColor,
           lineColor: this.lineColor,
           lineWidth: this.lineWidth),
      ), // CustomPaint
    ); // LimitedBox
  }
}

