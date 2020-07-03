import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project/batch.dart';

List<Batch> g = [];

Future<Batch> downloadJSON() async {
  final jsonEndpoint =
      "https://adc.bitsathy.ac.in/projects/iac/dam/final.php?limit=1";

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List batch = json.decode(response.body);
    g = batch.map((batch) => new Batch.fromJson(batch)).toList();

    return g[0];
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Widget createViewItem(Batch batch, BuildContext context) {
  var rain;
  var rain1 = int.tryParse(batch.rain);
  if (rain1 == null) {
    rain = '';
  } else if (rain1 <= 500) {
    rain = 'Heavy Rain';
  } else if (rain1 > 500) {
    rain = 'No Rain';
  }

  return new Container(
    child: Column(
      children: <Widget>[
        ListTile(
          leading: IconButton(
            color: Colors.black,
            icon: new Icon(MdiIcons.timer),
            onPressed: () {},
          ),
          title: Text('Date & Time', style: TextStyle(color: Colors.black)),
          trailing: Text(
            batch.event,
            style: TextStyle(color: Color(0xAA3B3C36)),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          leading: IconButton(
            color: Colors.blue,
            icon: new Icon(MdiIcons.waterOutline),
            onPressed: () {},
          ),
          title: Text('Water Level', style: TextStyle(color: Colors.black)),
          trailing: Text(batch.distance,
              textAlign: TextAlign.right,
              style: TextStyle(color: Color(0xAA3B3C36))),
        ),
        ListTile(
          leading: IconButton(
            color: Colors.red,
            icon: new Icon(MdiIcons.temperatureCelsius),
            onPressed: () {},
          ),
          title: Text('Temperature', style: TextStyle(color: Colors.black)),
          trailing: Text(batch.temperature,
              style: TextStyle(color: Color(0xAA3B3C36))),
        ),
        ListTile(
          leading: IconButton(
            color: Colors.lightBlue,
            icon: new Icon(MdiIcons.waterPercent),
            onPressed: () {},
          ),
          title: Text('Humidity', style: TextStyle(color: Colors.black)),
          trailing:
              Text(batch.humidity, style: TextStyle(color: Color(0xAA3B3C36))),
        ),
        ListTile(
          leading: IconButton(
            color: Colors.blue,
            icon: new Icon(MdiIcons.weatherRainy),
            onPressed: () {},
          ),
          title: Text('Rain', style: TextStyle(color: Colors.black)),
          trailing: Text(rain, style: TextStyle(color: Color(0xAA3B3C36))),
        ),
        ListTile(
          leading: IconButton(
            color: Colors.blueGrey,
            icon: new Icon(MdiIcons.waterPump),
            onPressed: () {},
          ),
          title: Text('FlowLevel', style: TextStyle(color: Colors.black)),
          trailing:
              Text(batch.flowlevel, style: TextStyle(color: Color(0xAA3B3C36))),
        ),
      ],
    ),
  );
}

class UpdateList extends StatefulWidget {
  @override
  UpdateListState createState() => UpdateListState();
}

class UpdateListState extends State<UpdateList> {
  @override
  void initState() {
    downloadJSON();
    super.initState();
    const oneSecond = const Duration(seconds: 5);
    new Timer.periodic(oneSecond, (Timer t) => createViewItem(g[0], context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        // backgroundColor: Colors.purple,
        title: Text(
          'Dam Automation',
          style: TextStyle(fontStyle: FontStyle.normal, color: Colors.white),
        ),
      ),
      body: new Center(
        child: new FutureBuilder<Batch>(
          future: downloadJSON(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Batch batch = snapshot.data;
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
