import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:quarantine_tracker/mqttClientWrapper.dart';
import 'package:sensors/sensors.dart';

import 'package:quarantine_tracker/pages/quarantineLocation.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer geolocationTimer;
  String latitude = "waiting...";
  String longitude = "waiting...";

  double lati = 13,long = 100;

  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  MQTTClientWrapper mqttClientWrapper;

  void mqttSetup() {
    mqttClientWrapper = MQTTClientWrapper();
    mqttClientWrapper.prepareMqttClient();
  }

  void _getAndPublishLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
        this.lati = location.latitude;
        this.long = location.longitude;
      });

      print("""\n
        Latitude:  $latitude
        Longitude: $longitude
      """);

      print(DateTime.now().toUtc().toString());
      mqttClientWrapper.publishLocation(location.latitude, location.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    mqttSetup();

    BackgroundLocation.startLocationService();
    geolocationTimer = Timer.periodic(
        Duration(hours: 1), (Timer t) => _getAndPublishLocation());

    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: quarantineLocation(lat: 13.608332 ,lng: 100.716687,)//13.608332, 100.716687
      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }
}
