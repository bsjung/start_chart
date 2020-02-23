import 'dart:math';
export 'package:flutter/material.dart'
    show Color, required, TextStyle, Rect, Canvas, Size, CustomPainter;
import 'package:flutter/material.dart'
    show Color, required, TextStyle, Rect, Canvas, Size, CustomPainter;

import '../candle_widget.dart';
import '../../utils/date_format_util.dart';
import '../entity/candle_entity.dart';
import '../style/candle_style.dart' show CandleStyle;

abstract class BaseCandlePainter extends CustomPainter {
  static double maxScrollX = 0.0;
  List<LineEntity> datas;
  MainState mainState = MainState.MA;
  SecondaryState secondaryState = SecondaryState.MACD;
  double scaleX = 1.0, scrollX = 0.0, selectX;
  bool isLongPress = false;
  bool isLine = false;

  // block size and position
  Rect mMainRect, mVolRect, mSecondaryRect;
  double mDisplayHeight, mWidth;
  double mTopPadding = 30.0, mBottomPadding = 20.0, mChildPadding = 12.0;
  final int mGridRows = 4, mGridColumns = 4;
  int mStartIndex = 0, mStopIndex = 0;
  double mMainMaxValue = double.minPositive, mMainMinValue = double.maxFinite;
  double mVolMaxValue = double.minPositive, mVolMinValue = double.maxFinite;
  double mSecondaryMaxValue = double.minPositive,
      mSecondaryMinValue = double.maxFinite;
  double mTranslateX = double.minPositive;
  int mMainMaxIndex = 0, mMainMinIndex = 0;
  double mMainHighMaxValue = double.minPositive,
      mMainLowMinValue = double.maxFinite;
  int mItemCount = 0;
  double mDataLen = 0.0; 
  double mPointWidth = CandleStyle.pointWidth;
  List<String> mFormats = [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]; 

  BaseCandlePainter(
      {@required this.datas,
      @required this.scaleX,
      @required this.scrollX,
      @required this.isLongPress,
      @required this.selectX,
      this.mainState,
      this.secondaryState,
      this.isLine}) {
    mItemCount = datas?.length ?? 0;
    mDataLen = mItemCount * mPointWidth;
    initFormats();
  }

  void initFormats() {
    // [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]
    if (mItemCount < 2) return;
    int firstTime = datas.first?.time ?? 0;
    int secondTime = datas[1]?.time ?? 0;
    int time = secondTime - firstTime;
    time ~/= 1000;
    //月线
    if (time >= 24 * 60 * 60 * 28)
      mFormats = [yy, '-', mm];
    //日线等
    else if (time >= 24 * 60 * 60)
      mFormats = [yy, '-', mm, '-', dd];
    //小时线等
    else
      mFormats = [mm, '-', dd, ' ', HH, ':', nn];
  }

  @override
  void paint(Canvas canvas, Size size) {
    mDisplayHeight = size.height - mTopPadding - mBottomPadding;
    mWidth = size.width;
    initRect(size);
    calculateValue();
    initChartRenderer();

    canvas.save();
    canvas.scale(1, 1);
    drawBg(canvas, size);
    drawGrid(canvas);
    if (datas != null && datas.isNotEmpty) {
      drawChart(canvas, size);
      drawRightText(canvas);
      drawDate(canvas, size);
      if (isLongPress == true) drawCrossLineText(canvas, size);
      drawText(canvas, datas?.last, 5);
      drawMaxAndMin(canvas);
    }
    canvas.restore();
  }

  void initChartRenderer();

  //Painted background
  void drawBg(Canvas canvas, Size size);

  //Draw grid
  void drawGrid(canvas);

  //Draw a chart
  void drawChart(Canvas canvas, Size size);

  //Draw the right text
  void drawRightText(canvas);

  //Draw time
  void drawDate(Canvas canvas, Size size);

  //Draw text
  void drawText(Canvas canvas, LineEntity data, double x);

  //Draw maximum and minimum
  void drawMaxAndMin(Canvas canvas);

  //Cross line text
  void drawCrossLineText(Canvas canvas, Size size);

  void initRect(Size size) {
    double mainHeight = secondaryState != SecondaryState.NONE
        ? mDisplayHeight * 0.6
        : mDisplayHeight * 0.8;
    double volHeight = mDisplayHeight * 0.2;
    double secondaryHeight = mDisplayHeight * 0.2;
    mMainRect = Rect.fromLTRB(0, mTopPadding, mWidth, mTopPadding + mainHeight);
    mVolRect = Rect.fromLTRB(0, mMainRect.bottom + mChildPadding, mWidth,
        mMainRect.bottom + volHeight);
    //secondaryState == SecondaryState.NONE隐藏副视图
    if (secondaryState != SecondaryState.NONE)
      mSecondaryRect = Rect.fromLTRB(0, mVolRect.bottom + mChildPadding, mWidth,
          mVolRect.bottom + secondaryHeight);
  }

  calculateValue() {
    if (datas == null || datas.isEmpty) return;
    maxScrollX = getMinTranslateX().abs();
    setTranslateXFromScrollX(scrollX);
    mStartIndex = indexOfTranslateX(xToTranslateX(0));
    mStopIndex = indexOfTranslateX(xToTranslateX(mWidth));
    for (int i = mStartIndex; i <= mStopIndex; i++) {
      var item = datas[i];
      getMainMaxMinValue(item, i);
      getVolMaxMinValue(item);
      getSecondaryMaxMinValue(item);
    }
  }

  void getMainMaxMinValue(LineEntity item, int i) {
    if (isLine == true) {
      mMainMaxValue = max(mMainMaxValue, item.close);
      mMainMinValue = min(mMainMinValue, item.close);
    } else {
      double maxPrice, minPrice;
      if (mainState == MainState.MA) {
        maxPrice = max(item.high, _findMaxMA(item.maValueList));
        minPrice = min(item.low, _findMinMA(item.maValueList));
      } else if (mainState == MainState.BOLL) {
        maxPrice = max(item.up ?? 0, item.high);
        minPrice = min(item.dn ?? 0, item.low);
      } else {
        maxPrice = item.high;
        minPrice = item.low;
      }
      mMainMaxValue = max(mMainMaxValue, maxPrice);
      mMainMinValue = min(mMainMinValue, minPrice);

      if (mMainHighMaxValue < item.high) {
        mMainHighMaxValue = item.high;
        mMainMaxIndex = i;
      }
      if (mMainLowMinValue > item.low) {
        mMainLowMinValue = item.low;
        mMainMinIndex = i;
      }
    }
  }

  double _findMaxMA(List<double> a) {
    double result = double.minPositive;
    for (double i in a) {
      result = max(result, i);
    }
    return result;
  }

  double _findMinMA(List<double> a) {
    double result = double.maxFinite;
    for (double i in a) {
      result = min(result, i == 0 ? double.maxFinite : i);
    }
    return result;
  }

  void getVolMaxMinValue(LineEntity item) {
    mVolMaxValue = max(mVolMaxValue,
        max(item.vol, max(item.MA5Volume ?? 0, item.MA10Volume ?? 0)));
    mVolMinValue = min(mVolMinValue,
        min(item.vol, min(item.MA5Volume ?? 0, item.MA10Volume ?? 0)));
  }

  void getSecondaryMaxMinValue(LineEntity item) {
    if (secondaryState == SecondaryState.MACD) {
      mSecondaryMaxValue =
          max(mSecondaryMaxValue, max(item.macd, max(item.dif, item.dea)));
      mSecondaryMinValue =
          min(mSecondaryMinValue, min(item.macd, min(item.dif, item.dea)));
    } else if (secondaryState == SecondaryState.KDJ) {
      if (item.d != null) {
        mSecondaryMaxValue =
            max(mSecondaryMaxValue, max(item.k, max(item.d, item.j)));
        mSecondaryMinValue =
            min(mSecondaryMinValue, min(item.k, min(item.d, item.j)));
      }
    } else if (secondaryState == SecondaryState.RSI) {
      if (item.rsi != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, item.rsi);
        mSecondaryMinValue = min(mSecondaryMinValue, item.rsi);
      }
    } else if (secondaryState == SecondaryState.WR) {
      mSecondaryMaxValue = 0;
      mSecondaryMinValue = -100;
    } else {
      mSecondaryMaxValue = 0;
      mSecondaryMinValue = 0;
    }
  }

  double xToTranslateX(double x) => -mTranslateX + x / scaleX;

  int indexOfTranslateX(double translateX) =>
      _indexOfTranslateX(translateX, 0, mItemCount - 1);

  ///Find the index of the current value in binary
  int _indexOfTranslateX(double translateX, int start, int end) {
    if (end == start || end == -1) {
      return start;
    }
    if (end - start == 1) {
      double startValue = getX(start);
      double endValue = getX(end);
      return (translateX - startValue).abs() < (translateX - endValue).abs()
          ? start
          : end;
    }
    int mid = start + (end - start) ~/ 2;
    double midValue = getX(mid);
    if (translateX < midValue) {
      return _indexOfTranslateX(translateX, start, mid);
    } else if (translateX > midValue) {
      return _indexOfTranslateX(translateX, mid, end);
    } else {
      return mid;
    }
  }

  ///Get the x coordinate based on the index
  ///+ mPointWidth / 2 prevent the first and last k lines from showing
  ///@param position Index value
  double getX(int position) => position * mPointWidth + mPointWidth / 2;

  Object getItem(int position) {
    if (datas != null) {
      return datas[position];
    } else {
      return null;
    }
  }

  ///scrollX Translate to TranslateX
  void setTranslateXFromScrollX(double scrollX) =>
      mTranslateX = scrollX + getMinTranslateX();

  ///Get the minimum value of translation
  double getMinTranslateX() {
    var x = -mDataLen + mWidth / scaleX - mPointWidth / 2;
    return x >= 0 ? 0.0 : x;
  }

  ///Calculate the value of x after long press and convert it to index
  int calculateSelectedX(double selectX) {
    int mSelectedIndex = indexOfTranslateX(xToTranslateX(selectX));
    if (mSelectedIndex < mStartIndex) {
      mSelectedIndex = mStartIndex;
    }
    if (mSelectedIndex > mStopIndex) {
      mSelectedIndex = mStopIndex;
    }
    return mSelectedIndex;
  }

  ///translate X to x in view
  double translateXtoX(double translateX) =>
      (translateX + mTranslateX) * scaleX;

  TextStyle getTextStyle(Color color) {
    return TextStyle(fontSize: 10.0, color: color);
  }

  @override
  bool shouldRepaint(BaseCandlePainter oldDelegate) {
    return true;
//    return oldDelegate.datas != datas ||
//        oldDelegate.datas?.length != datas?.length ||
//        oldDelegate.scaleX != scaleX ||
//        oldDelegate.scrollX != scrollX ||
//        oldDelegate.isLongPress != isLongPress ||
//        oldDelegate.selectX != selectX ||
//        oldDelegate.isLine != isLine ||
//        oldDelegate.mainState != mainState ||
//        oldDelegate.secondaryState != secondaryState;
  }
}
