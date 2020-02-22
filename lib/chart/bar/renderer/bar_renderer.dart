import 'dart:math';
import 'package:flutter/material.dart';

class BarChartPainter extends CustomPainter {

  List<double> data = [];
  List<String> labels = [];
  Color color;
  double bottomPadding;
  double leftPadding;
  double textScaleFactorXAxis;
  double textScaleFactorYAxis;

  BarChartPainter({
               this.data,
               this.labels, 
               this.color,
               this.bottomPadding,
               this.leftPadding,
               this.textScaleFactorXAxis,
               this.textScaleFactorYAxis,
               });

  @override
  void paint(Canvas canvas, Size size) {
    setTextPadding(size);

    List<Offset> coordinates = getCoordinates(size);

    drawBar(canvas, size, coordinates);
    drawXLabels(canvas, size, coordinates);
    drawYLabels(canvas, size, coordinates);
    drawLines(canvas, size, coordinates);
  }

  void setTextPadding(Size size) {
    bottomPadding = size.height / 10;
    leftPadding = size.width / 10;
  }

  void drawBar(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    double barWidthMargin = (size.width * 0.09);

    for (var index = 0; index < coordinates.length; index++) {
      Offset offset = coordinates[index];
      double left = offset.dx;
      double right = offset.dx + barWidthMargin;
      double top = offset.dy;
      double bottom = size.height - bottomPadding;

      Rect rect = Rect.fromLTRB(right, top, left, bottom);
      canvas.drawRect(rect, paint);
    }
  }

  void drawXLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double fontSize = calculateFontSize(labels[0], size, xAxis: true);

    for (int index = 0; index < labels.length; index++) {

      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
          text: labels[index]);

      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();

      Offset offset = coordinates[index];
      double dx = offset.dx;
      double dy = size.height - tp.height;

      tp.paint(canvas, Offset(dx, dy));
    }
  }

  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double bottomY = coordinates[0].dy;
    double topY = coordinates[0].dy;
    int indexOfMax = 0;
    int indexOfMin = 0;

    for (int index = 0; index < coordinates.length; index++) {
      double dy = coordinates[index].dy;

      if (bottomY < dy) {
        bottomY = dy;
        indexOfMin = index;
      }

      if (topY > dy) {
        topY = dy;
        indexOfMax = index;
      }
    }

    String maxValue = "${data[indexOfMax].toInt()}";
    String minValue = "${data[indexOfMin].toInt()}";

    double fontSize = calculateFontSize(maxValue, size, xAxis: false);

    drawYText(canvas, maxValue, fontSize, topY);
    drawYText(canvas, minValue, fontSize, bottomY);
  }

  double calculateFontSize(String value, Size size, {bool xAxis}) {
    int numberOfCharacters = value.length;
    double fontSize = size.width / (numberOfCharacters *  data.length);

    if (xAxis) {
      fontSize *= textScaleFactorXAxis;
    } else {
      fontSize *= textScaleFactorYAxis;
    }

    return fontSize;
  }

  void drawLines(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = Colors.blueGrey[100]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    double bottom = size.height - bottomPadding;
    double left = coordinates[0].dx;

    Path path = Path();
    path.moveTo(left, 0);
    path.lineTo(left, bottom);
    path.lineTo(size.width, bottom);

    canvas.drawPath(path, paint);
  }

  void drawYText(Canvas canvas, String text, double fontSize, double y) {

    TextSpan span = TextSpan(
      style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600),
      text: text,
    );

    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);

    tp.layout();

    Offset offset = Offset(0.0, y);
    tp.paint(canvas, offset);
  }

  List<Offset> getCoordinates(Size size) {
    List<Offset> coordinates = [];

    double maxData = data.reduce(max);

    double width = size.width - leftPadding;
    double minBarWidth = width / data.length;

    for (var index = 0; index < data.length; index++) {
      double left = minBarWidth * index + leftPadding;

      double normalized = data[index] / maxData;
      double height = size.height - bottomPadding;
      double top = height - normalized * height;

      Offset offset = Offset(left, top);
      coordinates.add(offset);
    }

    return coordinates;
  }

  @override
  bool shouldRepaint(BarChartPainter old) {
    return old.data != data;
  }
}
