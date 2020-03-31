import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:quarantine_tracker/mqttClientWrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer geolocationTimer;
  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";

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
        Duration(minutes: 1), (Timer t) => _getAndPublishLocation());
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
              locationData("Altitude: " + altitude),
              locationData("Accuracy: " + accuracy),
              locationData("Bearing: " + bearing),
              locationData("Speed: " + speed),
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

  getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print("This is current Location" + location.longitude.toString());
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
