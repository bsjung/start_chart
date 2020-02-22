import 'dart:math';
import 'package:flutter/material.dart';
import './renderer/line_renderer.dart';

class LineChart extends StatelessWidget {
  LineChart({
    @required this.data,
    this.size = const Size(150, 150),
  }) : assert(data != null);

  final List data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return new LimitedBox(
      child: new CustomPaint(
        size: size,
        painter: new LineChartPainter(
           points: data,
           pointSize: 5.0, 
           pointColor: Colors.pinkAccent, 
           lineColor: Colors.pinkAccent, 
           lineWidth: 2.0),
      ), // CustomPaint
    ); // LimitedBox
  }
}

