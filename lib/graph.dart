import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart';
import 'package:project/batch.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue[50],
            title: new Text(
              'Graph Info',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                  title: Text(
                    'Temperature',
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                  title: Text(
                    'Humidity',
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(
                    'Flow Level',
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                  title: Text(
                    'Water Level',
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
            ),
          );
        });
  }

  int graphCount = 0;
  bool isLoaded = false;
  bool hasValue = true;
  List<Batch> batch = [];

  @override
  void initState() {
    downloadJSON();
    super.initState();

    const oneSecond = const Duration(seconds: 5);
    new Timer.periodic(oneSecond, (Timer t) => build(context));
  }

  downloadJSON() async {
    final jsonEndpoint =
        "https://adc.bitsathy.ac.in/projects/iac/dam/final.php?limit=6";

    final response = await get(jsonEndpoint);

    if (response.statusCode == 200) {
      List batch = json.decode(response.body);

      this.batch = batch
          .map((batch) => new Batch.fromJson(batch))
          .toList()
          .reversed
          .toList();
      setState(() {
        isLoaded = true;
      });
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  double tem = -1.0;
  double tem1 = -1.0;
  double tem2 = -1.0;
  double tem3 = -1.0;

  double w = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(title: Text('Graph'),
          // backgroundColor: Colors.purple,
          actions: <Widget>[
            IconButton(
                icon: new Icon(MdiIcons.information),
                onPressed: () {
                  _showDialog();
                })
          ]),
      body: isLoaded
          ? Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Container(
                        width: 500,
                        height: 1500,
                        child: FlChart(
                          chart: LineChart(
                            LineChartData(
                                lineTouchData: LineTouchData(
                                    touchTooltipData: TouchTooltipData(
                                        tooltipBgColor:
                                            Colors.white.withOpacity(0.8),
                                        tooltipBottomMargin: -100)),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: batch.map((f) {
                                      tem += 1.0;
                                      return FlSpot(
                                          tem,
                                          double.tryParse(f.temperature) ??
                                              0.0);
                                    }).toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    belowBarData: BelowBarData(
                                      show: false,
                                    ),
                                    dotData: FlDotData(show: true),
                                  ),
                                  LineChartBarData(
                                    colors: const [Colors.black],
                                    spots: batch.map((f) {
                                      tem1 += 1.0;
                                      return FlSpot(tem1,
                                          double.tryParse(f.humidity) ?? 0.0);
                                    }).toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    belowBarData: BelowBarData(
                                      show: false,
                                    ),
                                    dotData: FlDotData(show: true),
                                  ),
                                  LineChartBarData(
                                    colors: const [Colors.blue],
                                    spots: batch.map((f) {
                                      tem2 += 1.0;
                                      return FlSpot(
                                          tem2,
                                          double.tryParse(
                                                  f.flowlevel.toString()) ??
                                              0.0);
                                    }).toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    belowBarData: BelowBarData(
                                      show: false,
                                    ),
                                    dotData: FlDotData(show: true),
                                  ),
                                  LineChartBarData(
                                    colors: const [Colors.green],
                                    spots: batch.map((f) {
                                      tem3 += 1.0;
                                      return FlSpot(tem3,
                                          double.tryParse(f.distance) ?? 0.0);
                                    }).toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    belowBarData: BelowBarData(
                                      show: false,
                                    ),
                                    dotData: FlDotData(show: true),
                                  ),
                                ],
                                minY: 0,
                                titlesData: FlTitlesData(
                                    getVerticalTitles: (val) {
                                      return val.toString();
                                    },
                                    verticalTitleMargin: 10,
                                    horizontalTitleMargin: 20,
                                    verticalTitlesReservedWidth: 20,
                                    showVerticalTitles: true,
                                    getHorizontalTitles: (val) {
                                      return batch[val.toInt()]
                                          .event
                                          .split(" ")[1];
                                    },
                                    verticalTitlesTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                    horizontalTitlesTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    )),
                                gridData: FlGridData(
                                  drawHorizontalGrid: true,
                                ),
                                borderData: FlBorderData(
                                    show: true, border: Border.all()),
                                clipToBorder: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

//   getph() async {
//     FirebaseDatabase db = FirebaseDatabase.instance;
//     var data =
//         db.reference().child('bot/ph').orderByChild('time').limitToLast(6);
//     data.onValue.listen((Event onvalue) {
//       if (onvalue.snapshot.value == null) {
//         setState(() {
//           isLoaded = true;
//           hasValue = false;
//         });
//       }
//       double s = 0;
//       Map<dynamic, dynamic> snapshot = onvalue.snapshot.value;
//       List<dynamic> list = snapshot.values.toList()
//         ..sort((a, b) => b['time'].compareTo(a['time']));
//       print(list.toString());
//       print(onvalue.snapshot.value.toString());
//       list = list.reversed.toList();
//       double i = 0;
//       _plot.clear();
//       list.forEach((value) {
//         s = value['value'] * 1.0;
//         _plot.add(FlSpot(i, s));
//         DateTime time = DateTime.fromMillisecondsSinceEpoch(value['time']);
//         _time.add(time.toString().split(' ').last.split('.').first);
//         i++;
//         graphCount++;
//       });
//       setState(() {
//         isLoaded = true;
//       });
//     });
//   }
}
// new SimpleDialog(
//                 title: new Text(
//                   'GRAPH INFO',
//                   style: TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 children: <Widget>[
//                   new SimpleDialogOption(
//                       child: new Text(
//                     'Temperature',
//                   )),
//                   new SimpleDialogOption(
//                       child: new Text(
//                     'Humidity',
//                     style: TextStyle(color: Colors.black),
//                   )),
//                   new SimpleDialogOption(
//                       child: new Text(
//                     'Flow Level',
//                     style: TextStyle(color: Colors.pinkAccent),
//                   )),
//                   new SimpleDialogOption(
//                       child: new Text(
//                     'Water Level',
//                     style: TextStyle(color: Colors.green),
//                   )),
//                 ],
//               );
