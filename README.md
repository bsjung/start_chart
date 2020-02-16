Start Chart
==============

Start Chart is a simple charting package for start web framework.
There are good charting packages for Flutter mobile UI framework such as google charts.
But, it lacks simple architecture for intuitive programmers.
Also, it lacks candle charts with technical indicators.

Thus, I've made start chart packages supporting candle charts.


Example usage
-------------

```dart
import 'package:flutter/material.dart';
import 'package:start_chart/start_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChartPage extends StatelessWidget {
  List<double> points = [
    50, 90, 1003, 500, 150, 120, 200, 80
  ];

  List<String> labels = [
    "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart Page"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              LineChart(data: points),
              Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
              PieChart(percentage: 55),
              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
              BarChart(data: points, labels : labels),
            ],
          ),
        ),
      ),
    );
  }
}
```


Status
------

The API is very simple. The intend is to strictly follow Dart conventions, i.e.
make the API as 'dartish' as possible while maintaining simplicity. We are
open to any suggestions towards that goal.


Links
-----

* [Google charts] (https://github.com/google/charts).
* [K Charts] (https://github.com/OpenFlutter/k_chart).


Credits
-------

Copyright (c) 2020 Benjamin Jung <bsjung@gmail.com>.
