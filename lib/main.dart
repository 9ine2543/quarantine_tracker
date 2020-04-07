import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:quarantine_tracker/services/mqttClientWrapper.dart';
import 'package:quarantine_tracker/pages/registerQuarantine.dart';
import 'package:quarantine_tracker/pages/quarantineLocation.dart';
import 'package:flutter_geofence/geofence.dart';

var initScreen;
void main() => runApp(MyApp());

// Main for routing pages.

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   initScreen = await checkPreferences().then((haveRegistered) {
//     return haveRegistered ? '/' : 'register';
//   });
//   print('$initScreen');
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quarantine Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: initScreen,
        routes: {
          '/': (context) => MyHomePage(),
          'register': (context) => RegisterQuarantine()
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  double lati = 13, long = 100;
  MQTTClientWrapper mqttClientWrapper;
  Timer geofetchTimer;

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
      // mqttClientWrapper.publishLocation(location.latitude, location.longitude);
    });
  }

  String latitude = "waiting...";
  String longitude = "waiting...";

  void initPlatformState() {
    Geofence.initialize();
    Geofence.startListening(GeolocationEvent.entry, (entry) {
      print('Entering ');
      print(entry.id);
      print(GeolocationEvent.values);
    });

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      print('Exiting ');
      print(entry.id);
      print(GeolocationEvent.values);
    });

    Geolocation location = Geolocation(
        latitude: 13.6744122174,
        longitude: 100.543417046,
        radius: 25.0,
        id: "home");
    Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
      print("great success");
    }).catchError((onError) {
      print("great failure");
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    BackgroundLocation.startLocationService();
    geofetchTimer = Timer.periodic(Duration(minutes: 15), (Timer t) {
      _getAndPublishLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: QuarantineLocation(
        lat: 13.6744122174,
        lng: 100.543417046,
      )),
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
