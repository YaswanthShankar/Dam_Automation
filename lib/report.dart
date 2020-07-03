import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;

import 'dart:convert';

import 'package:project/batch.dart';

List<Batch> f = [];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    const oneSecond = const Duration(seconds: 5);
    new Timer.periodic(oneSecond, (Timer t) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: new AppBar(
        // backgroundColor: Colors.purple,
        title: const Text('Report'),
      ),
      body: new Center(
        child: new FutureBuilder<List<Batch>>(
          future: downloadJSON(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Batch> batch = snapshot.data;
              return createViewItem(batch, context);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            //return  a circular progress indicator.
            return new CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List<Batch>> downloadJSON() async {
  final jsonEndpoint =
      "https://adc.bitsathy.ac.in/projects/iac/dam/final.php?limit=100";

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List batch = json.decode(response.body);
    f = batch.map((batch) => new Batch.fromJson(batch)).toList();
    print(f.length);

    return f;
  } else
    print('We were not able to successfully download the json data.');
  return null;
}

Widget createViewItem(List<Batch> batch, BuildContext context) {
  return SingleChildScrollView(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: TableColumns,
        rows: batch.map((f) {
          var rain;
          var rain1 = int.tryParse(f.rain);
          if (rain1 == null) {
            rain = '';
          } else if (rain1 <= 500) {
            rain = 'Heavy Rain';
          } else if (rain1 > 500) {
            rain = 'No Rain';
          }
          return DataRow(cells: <DataCell>[
            DataCell(Text(f.event, textAlign: TextAlign.center)),
            DataCell(
                Text('        ' + f.distance, textAlign: TextAlign.center)),
            DataCell(
                Text('         ' + f.temperature, textAlign: TextAlign.center)),
            DataCell(
                Text('        ' + f.humidity, textAlign: TextAlign.center)),
            DataCell(Text(' ' + rain, textAlign: TextAlign.center)),
            DataCell(
                Text('        ' + f.flowlevel, textAlign: TextAlign.center)),
          ]);
        }).toList(),
      ),
    ),
  );
}

const TableColumns = <DataColumn>[
  DataColumn(
    label: const Text(
      '   DATE & TIME',
      style: TextStyle(
          fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: const Text('WATER LEVEL',
        style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black),
        textAlign: TextAlign.center),
  ),
  DataColumn(
    label: const Text('TEMPERATURE',
        style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black),
        textAlign: TextAlign.center),
  ),
  DataColumn(
    label: const Text('HUMIDITY',
        style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black),
        textAlign: TextAlign.center),
  ),
  DataColumn(
    label: const Text(' RAIN',
        style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black),
        textAlign: TextAlign.center),
  ),
  DataColumn(
    label: const Text('FLOWLEVEL',
        style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black),
        textAlign: TextAlign.center),
  ),
];
