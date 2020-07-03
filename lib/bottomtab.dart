import 'package:flutter/material.dart';
// import 'package:project/net.dart';
import 'package:project/graph.dart';
import 'package:project/home.dart';
import 'package:project/report.dart';
// import 'package:project/secondpage.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[UpdateList(), MyApp(), Report()];

    final bottomTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: new Text(
          'Home',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.event_note),
        title: new Text(
          'Report',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          title: Text(
            'Graph',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))
    ];
    assert(tabs.length == bottomTabs.length);
    final bottomNavBar = BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.blue[900],
      fixedColor: Colors.white, // this will be set when a new tab is tapped

      items: bottomTabs,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
    return new Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
