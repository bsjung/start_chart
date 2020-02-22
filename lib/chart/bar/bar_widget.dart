import 'dart:math';
import 'package:flutter/material.dart';
import './renderer/bar_renderer.dart';

class BarChart extends StatelessWidget {
  BarChart({
    @required this.data,
    @required this.labels,
    this.size = const Size(150, 150),
    this.color = Colors.blue,
    this.bottomPadding = 0.0,
    this.leftPadding = 0.0,
    this.textScaleFactorXAxis = 1.0,
    this.textScaleFactorYAxis = 1.2,
  }) : assert(data != null);

  final List<double> data;
  final List<String> labels;
  final Size size;
  final Color color;
  final bottomPadding;
  final leftPadding;
  final textScaleFactorXAxis;
  final textScaleFactorYAxis;

  @override
  Widget build(BuildContext context) {
    return new LimitedBox(
      child: new CustomPaint(
        size: this.size,
        painter: new BarChartPainter(
                         data: this.data, 
                         labels: this.labels, 
                         color : this.color,
                         bottomPadding : this.bottomPadding,
                         leftPadding   : this.leftPadding,
                         textScaleFactorXAxis : this.textScaleFactorXAxis,
                         textScaleFactorYAxis : this.textScaleFactorYAxis,
                     ),
      ), // CustomPaint
    ); // LimitedBox
  }
}

