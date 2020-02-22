import 'dart:math';
import 'package:flutter/material.dart';
import './renderer/bar_renderer.dart';

class BarChart extends StatelessWidget {
  BarChart({
    @required this.data,
    @required this.labels,
    this.color = Colors.blue,
    this.size = const Size(150, 150),
  }) : assert(data != null);

  final List<double> data;
  final List<String> labels;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return new LimitedBox(
      child: new CustomPaint(
        size: size,
        painter: new BarChartPainter(
           data: data, labels: labels, color : color),
      ), // CustomPaint
    ); // LimitedBox
  }
}

