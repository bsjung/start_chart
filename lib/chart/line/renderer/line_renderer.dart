import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  List<double> points;
  double lineWidth;
  double pointSize;
  Color lineColor;
  Color pointColor;
  double textfontSize;

  int maxValueIndex;
  int minValueIndex;

  LineChartPainter({
                    this.points, 
                    this.pointSize, 
                    this.lineWidth, 
                    this.lineColor, 
                    this.pointColor,
                    this.textfontSize,
                   });

  @override
  void paint(Canvas canvas, Size size) {
    List<Offset> offsets = getCoordinates(points, size);

    drawText(canvas, offsets);

    drawLines(canvas, size,  offsets);
    drawPoints(canvas, size, offsets);
  }

  void drawLines(Canvas canvas, Size size, List<Offset> offsets) {
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    double dx = offsets[0].dx;
    double dy = offsets[0].dy;

    path.moveTo(dx, dy);
    offsets.map((offset) => path.lineTo(offset.dx , offset.dy)).toList();

    canvas.drawPath(path, paint);
  }

  void drawPoints(Canvas canvas, Size size, List<Offset> offsets) {
    Paint paint = Paint()
        ..color = pointColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = pointSize;

    canvas.drawPoints(PointMode.points, offsets, paint);
  }

  List<Offset> getCoordinates(List<double> points, Size size) {
    List<Offset> coordinates = [];

    double spacing = size.width / (points.length - 1);
    double maxY = points.reduce(max);
    double minY = points.reduce(min);

    double bottomPadding = textfontSize * 2;
    double topPadding = bottomPadding * 2;
    double h = size.height - topPadding;

    for (int index = 0; index < points.length; index++) {
      double x = spacing * index;
      double normalizedY = points[index] / maxY; // Normalize
      double y = getYPos(h, bottomPadding, normalizedY); 

      Offset coord = Offset(x, y);
      coordinates.add(coord);

      findMaxIndex(points, index, maxY, minY);
      findMinIndex(points, index, maxY, minY);
    }

    return coordinates;
  }

  double getYPos(double h, double bottomPadding, double normalizedY) => (h + bottomPadding) - (normalizedY * h);

  void findMaxIndex(List<double> points, int index, double maxY, double minY) {
    if (maxY == points[index]) {
      maxValueIndex = index;
    }
  }

  void findMinIndex(List<double> points, int index, double maxY,double minY) {
    if (minY == points[index]) {
      minValueIndex = index;
    }
  }

  void drawText(Canvas canvas, List<Offset> offsets) {
    String maxValue = "${points.reduce(max)}";
    String minValue = "${points.reduce(min)}";

    drawTextValue(canvas, minValue, offsets[minValueIndex], false);
    drawTextValue(canvas, maxValue, offsets[maxValueIndex], true);
  }

  void drawTextValue(Canvas canvas, String text, Offset pos, bool textUpward) {
    TextSpan maxSpan = TextSpan(style: TextStyle(fontSize: textfontSize, color: Colors.black, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: maxSpan, textDirection: TextDirection.ltr);
    tp.layout();

    double y = textUpward ? -tp.height * 1.5  : tp.height * 0.5;
    double dx = pos.dx - tp.width / 2;
    double dy = pos.dy + y;

    Offset offset = Offset(dx, dy);

    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
