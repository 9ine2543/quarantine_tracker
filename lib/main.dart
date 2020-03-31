import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:quarantine_tracker/mqttClientWrapper.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer geolocationTimer;
  String latitude = "waiting...";
  String longitude = "waiting...";

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
        appBar: AppBar(
          title: const Text('Quarantine Tracker'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              locationData("Latitude: " + latitude),
              locationData("Longitude: " + longitude),
              locationData("X" + _gyroscopeValues[0].toString()),
              locationData("Y" + _gyroscopeValues[1].toString()),
              locationData("Z" + _gyroscopeValues[2].toString()),
            ],
          ),
        ),
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
