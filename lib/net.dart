import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project/batch.dart';

class LineChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  StreamController<LineTouchResponse> controller;
  List<Batch> batch = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    downloadJSON();
    controller = StreamController();
    controller.stream.distinct().listen((LineTouchResponse response) {
      print('response: ${response.touchInput}');
    });
  }

  downloadJSON() async {
    final jsonEndpoint = "http://10.10.170.153:9090/dam/six.php";

    final response = await get(jsonEndpoint);

    if (response.statusCode == 200) {
      List batch = json.decode(response.body);

      this.batch = batch.map((batch) => new Batch.fromJson(batch)).toList();
      setState(() {
        isLoaded = true;
      });
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  Widget build(BuildContext context) {
    double tem = -1.0;

    return Center(
      child: isLoaded
          ? AspectRatio(
              aspectRatio: 0.69,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff2c274c),
                        Color(0xff46426c),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 37,
                    ),
                    Text(
                      "Bannari Amman Institute of Technology",
                      style: TextStyle(
                        color: Color(0xff827daa),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Dam Automation",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 37,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                        child: FlChart(
                          chart: LineChart(
                            LineChartData(
                              lineTouchData: LineTouchData(
                                  touchResponseSink: controller.sink,
                                  touchTooltipData: TouchTooltipData(
                                    tooltipBgColor:
                                        Colors.blueGrey.withOpacity(0.8),
                                  )),
                              gridData: FlGridData(
                                show: false,
                              ),
                              titlesData: FlTitlesData(
                                horizontalTitlesTextStyle: TextStyle(
                                  color: Color(0xff72719b),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                horizontalTitleMargin: 10,
                                getHorizontalTitles: (value) {
                                  print(value.toInt());
                                  return batch[value.toInt()]
                                      .event
                                      .split(" ")[1];
                                },
                                verticalTitlesTextStyle: TextStyle(
                                  color: Color(0xff75729e),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                getVerticalTitles: (value) {
                                  print(value);
                                  return value.toString();
                                },
                                verticalTitleMargin: 8,
                                verticalTitlesReservedWidth: 30,
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xff4e4965),
                                      width: 4,
                                    ),
                                    left: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    right: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    top: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  )),
                              minX: 0,
                              maxX: 14,
                              maxY: 4,
                              minY: 0,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: batch.map((f) {
                                    tem += 1.0;
                                    return FlSpot(tem,
                                        double.tryParse(f.temperature) ?? 0.0);
                                  }).toList(),
                                  isCurved: true,
                                  colors: [
                                    Color(0xff4af699),
                                  ],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: false,
                                  ),
                                  belowBarData: BelowBarData(
                                    show: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
