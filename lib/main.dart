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
import 'package:geolocator/geolocator.dart';
import 'package:quarantine_tracker/pages/dashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

var initScreen;

String name, surname, hospital;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  name = prefs.getString('name');
  surname = prefs.getString('surname');
  hospital = prefs.getString('hospital');
  print(hospital);
  initScreen = await checkPreferences().then((haveRegistered) {
    return haveRegistered ? '/' : 'register';
  });
  print('$initScreen');
  runApp(MyApp());
}



  // Future<void> getValueForDashboard() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   name = prefs.getString('name');
  //   surname = prefs.getString('surname');
  //   hospital = prefs.getString('hospital');
  //   print(name);
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
  double lati , long , home_lat = 13.6082817, home_lng = 100.7166733, distance = 0;
  MQTTClientWrapper mqttClientWrapper;
  Timer geofetchTimer;
  void mqttSetup() {
    mqttClientWrapper = MQTTClientWrapper();
    mqttClientWrapper.prepareMqttClient();
  }

  Future<void> _onCalculate() async {
    distance = await Geolocator().distanceBetween(
        home_lat, home_lng, lati, long);
  }

  // String name, surname, hospital;

  // Future<void> getValueForDashboard() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   name = prefs.getString('name');
  //   surname = prefs.getString('surname');
  //   hospital = prefs.getString('hospital');
  //   print(name);
  // }

  void _getAndPublishLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      setState(() {
        this.lati = location.latitude;
        this.long = location.longitude;
      });
      _onCalculate();
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
      //     body: QuarantineLocation(
      //   lat: lati,
      //   lng: long,
      // )),
      body: name != null ? dashBoardMain(name:name, surname: surname,hospital: hospital,) : QuarantineLocation(lat: home_lat,lng: home_lng,)
      )
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
