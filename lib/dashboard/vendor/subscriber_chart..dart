import 'package:easy_homes/dashboard/vendor/subscriber_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


  class SubscriberChart extends StatelessWidget {
  final List<SubscriberSeries> data;

  SubscriberChart({required this.data});

@override
Widget build(BuildContext context) {
  List<charts.Series<SubscriberSeries, String>> series = [
    charts.Series(
        id: "Subscribers",
        data: data,
        domainFn: (SubscriberSeries series, _) => series.year,
        measureFn: (SubscriberSeries series, _) => series.subscribers,
        colorFn: (SubscriberSeries series, _) => series.barColor)
  ];

  return SingleChildScrollView(
    child: Container(
      height: MediaQuery.of(context).size.height*0.4,
      width: MediaQuery.of(context).size.width,

      child: Column(
        children: <Widget>[

          Expanded(
            child: charts.BarChart(series, animate: true),
          )
        ],
      ),
    ),
  );
}
}
