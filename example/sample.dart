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
  List<double> points = [50, 90, 1003, 500, 150, 120, 200, 80];

  List<String> labels = [
    "2012",
    "2013",
    "2014",
    "2015",
    "2016",
    "2017",
    "2018",
    "2019",
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
