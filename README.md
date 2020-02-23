Start Chart
==============

Start Chart is a simple charting package for web framework.
There are good charting packages for Flutter mobile UI framework such as google charts.
But, it lacks simple architecture for web framework.
Also, it lacks candle charts with technical indicators.

Thus, I've made charting packages supporting web framework and candle charts.

![demo](https://github.com/bsjung/start_chart/blob/master/start_chart.png)

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


Gallery
------

Bar 

![bar](https://github.com/bsjung/start_chart/blob/master/start_bar.png)

Candle

![candle](https://github.com/bsjung/start_chart/blob/master/start_candle.png)

Line

![line](https://github.com/bsjung/start_chart/blob/master/start_line.png)

Pie

![pie](https://github.com/bsjung/start_chart/blob/master/start_pie.png)


Links
-----

* [Google charts] (https://github.com/google/charts).
* [K Charts] (https://github.com/OpenFlutter/k_chart).


Credits
-------

MFW ( https://github.com/OpenFlutter/k_chart ).

Copyright (c) 2020 Benjamin Jung <bsjung@gmail.com>.
