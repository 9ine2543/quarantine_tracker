import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:quarantine_tracker/services/mqttClientWrapper.dart';
import 'package:quarantine_tracker/pages/registerQuarantine.dart';
import 'package:quarantine_tracker/pages/quarantineLocation.dart';
import 'package:quarantine_tracker/model/locationLog.dart';
import 'package:quarantine_tracker/services/localDatabase.dart';
import 'package:quarantine_tracker/services/preferences.dart';

var initScreen;
void main() => runApp(MyApp());

// Comment for testing query page.
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
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  LocalSQL database = LocalSQL.db;
  List queryResult = [];
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
        this.lati = location.latitude;
        this.long = location.longitude;
      });

      print(DateTime.now().toUtc().toString());
      print("Latitude: $lati Longitude: $long");

      LocationLog mockLog =
          LocationLog(Random().nextInt(1000000), this.lati, this.long);

      print(mockLog.toString());
      database.insert(mockLog);
      database.logs().then((logs) => getQuery(logs));
      mqttClientWrapper.publishLocation(location.latitude, location.longitude);
    });
  }

  void getQuery(List<Map<String, dynamic>> res) {
    print('List length: ${res.length}');
    setState(() {
      queryResult.clear();
      queryResult.addAll(res);
    });
    print(queryResult.length);
    queryResult.asMap().forEach((index, value) {
      print(queryResult[index]);
    });
  }

  @override
  void initState() {
    super.initState();
    mqttSetup();
    BackgroundLocation.startLocationService();
    geofetchTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _getAndPublishLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: QuarantineLocation(
        lat: lati,
        lng: long,
      )),
    );
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
