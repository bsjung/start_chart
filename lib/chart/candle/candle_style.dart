import 'package:flutter/material.dart' show Color;

class ChartColors {
  ChartColors._();

  static const Color kLineColor = Color(0xff4C86CD);
  static const Color lineFillColor = Color(0x554C86CD);
  static const Color ma5Color = Color(0xffC9B885);
  static const Color ma10Color = Color(0xff6CB0A6);
  static const Color ma30Color = Color(0xff9979C6);
  static const Color upColor = Color(0xff4DAA90);
  static const Color dnColor = Color(0xffC15466);
  static const Color volColor = Color(0xff4729AE);

  static const Color macdColor = Color(0xff4729AE);
  static const Color difColor = Color(0xffC9B885);
  static const Color deaColor = Color(0xff6CB0A6);

  static const Color kColor = Color(0xffC9B885);
  static const Color dColor = Color(0xff6CB0A6);
  static const Color jColor = Color(0xff9979C6);
  static const Color rsiColor = Color(0xffC9B885);

  static const Color defaultTextColor = Color(0xff60738E);

  //Color depth
  static const Color depthBuyColor = Color(0xff60A893);
  static const Color depthSellColor = Color(0xffC15866);
  //Display value border color when selected.
  static const Color selectBorderColor = Color(0xff6C7A86);

  //Fill color of the value background when selected.
  static const Color selectFillColor = Color(0xff0D1722);

  static Color getMAColor(int index) {
    Color maColor = ma5Color;
    switch (index % 3) {
      case 0:
        maColor = ma5Color;
        break;
      case 1:
        maColor = ma10Color;
        break;
      case 2:
        maColor = ma30Color;
        break;
    }
    return maColor;
  }
}

class ChartStyle {
  ChartStyle._();

  //Point-to-point distance
  static const double pointWidth = 11.0;

  // Candle width
  static const double candleWidth = 8.5;

  //Candle midline width
  static const double candleLineWidth = 1.5;

  //vol pillar width
  static const double volWidth = 8.5;

  //macd pillar width
  static const double macdWidth = 3.0;

  //Vertical cross line width
  static const double vCrossWidth = 8.5;

  //Horizontal cross line width
  static const double hCrossWidth = 0.5;
}
