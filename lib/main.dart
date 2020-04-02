import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'package:quarantine_tracker/pages/RegisterQuarantine.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quarantine Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterQuarantine(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));

    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
        this.accuracy = location.accuracy.toString();
        this.altitude = location.altitude.toString();
        this.bearing = location.bearing.toString();
        this.speed = location.speed.toString();
      });

      print("""\n
      Latitude:  $latitude
      Longitude: $longitude
      Altitude: $altitude
      Accuracy: $accuracy
      Bearing:  $bearing
      Speed: $speed
      """);
      print(_gyroscopeValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                BackgroundLocation.startLocationService();
              },
            ),
            RaisedButton(
                onPressed: () {
                  BackgroundLocation.stopLocationService();
                },
                child: Text("Stop Location Service")),
            RaisedButton(
                onPressed: () {
                  getCurrentLocation();
                },
                child: Text("Get Current Location")),
          ],
        ),
      ),
    );
  }

  getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print("This is current Location" + location.longitude.toString());
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
