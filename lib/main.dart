import 'package:flutter/material.dart';
import 'package:project/bottomtab.dart';
import 'package:project/report.dart';
// import 'package:project/line.dart';
import 'package:project/graph.dart';
// import 'package:project/secondpage.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor: Colors.blue[900], accentColor: Colors.grey),
      home: FirstPage(),
      routes: <String, WidgetBuilder>{
        '/myapp': (BuildContext context) => new MyApp(),
        '/secondpage': (BuildContext context) => new Report(),
      }));
}
