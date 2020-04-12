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
import 'package:quarantine_tracker/services/preferences.dart';

var initScreen;

String name, surname, hospital, _startDate;
var days;
int total_away = 0, total_lost = 0;
List listData = [];
bool _haveRegistered = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initScreen = await checkPreferences().then((haveRegistered) {
    _haveRegistered = haveRegistered;
    return haveRegistered ? '/' : 'register';
  });
  print('$initScreen');
  if (initScreen == '/') {
    getValueForDashboard();
  }
  runApp(MyApp());
}

Future<void> getValueForDashboard() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  name = prefs.getString('name');
  surname = prefs.getString('surname');
  hospital = prefs.getString('hospital');
  _startDate = prefs.getString('startDate');
  days = DateTime.now().difference(DateTime.parse(_startDate));
  for (int i = 0; i < days.inDays + 1; i++) {
    listData.insert(0, prefs.getStringList('listData[${i}]'));
  }
}

Future<void> setValuePreferences(List<String> dataList, int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('listData[${index}]', dataList);
}

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
  double lati,
      long,
      home_lat = 13.6082817,
      home_lng = 100.7166733,
      distance = 0;
  MQTTClientWrapper mqttClientWrapper;
  Timer geofetchTimer;
  int status;
  int id;
  void mqttSetup() {
    mqttClientWrapper = MQTTClientWrapper();
    mqttClientWrapper.prepareMqttClient();
  }

  Future<void> _onCalculate() async {
    distance =
        await Geolocator().distanceBetween(home_lat, home_lng, lati, long);
  }

  void _getAndPublishLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      setState(() {
        this.lati = location.latitude;
        this.long = location.longitude;
      });
      _onCalculate();
      if (name == null) {
        getValueForDashboard();
        print(name);
      }
      print(DateTime.now().toUtc().toString());
      print("Latitude: $lati Longitude: $long");
      days = DateTime.now().difference(DateTime.parse(_startDate));
      print(days);
      if (days.inDays == listData.length) {
        setValuePreferences([
          '${days.inDays + 1}',
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year + 543}',
          '0',
          '0'
        ], listData.length);
        if (DateTime.now().day > 9 && DateTime.now().month > 9)
          listData.insert(0, [
            '${days.inDays + 1}',
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year + 543}',
            '0',
            '0'
          ]);
        else if (DateTime.now().day > 9 && DateTime.now().month < 10)
          listData.insert(0, [
            '${days.inDays + 1}',
            '${DateTime.now().day}/0${DateTime.now().month}/${DateTime.now().year + 543}',
            '0',
            '0'
          ]);
        else if (DateTime.now().day < 10 && DateTime.now().month > 9)
          listData.insert(0, [
            '${days.inDays + 1}',
            '0${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year + 543}',
            '0',
            '0'
          ]);
        else if (DateTime.now().day < 10 && DateTime.now().month < 10)
          listData.insert(0, [
            '${days.inDays + 1}',
            '0${DateTime.now().day}/0${DateTime.now().month}/${DateTime.now().year + 543}',
            '0',
            '0'
          ]);
      }
      LocationLog mockLog = LocationLog(Random().nextInt(1000000), this.lati,
          this.long, this.status, this.distance);
      print('distance: ${distance}');
      // print(mockLog.toString());
      database.insert(mockLog);
      database.logs().then((logs) => getQuery(logs));
      mqttClientWrapper.publishLocation(
          this.id, location.latitude, location.longitude, this.status);
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
      // print(queryResult[index]);
    });
  }

  @override
  void initState() {
    super.initState();
    mqttSetup();
    BackgroundLocation.startLocationService();
    if (name == null) {
      geofetchTimer = Timer.periodic(Duration(seconds: 15), (Timer t) {
        _getAndPublishLocation();
      });
    }
    geofetchTimer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      _getAndPublishLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: name != null
                ? dashBoardMain(
                    name: name,
                    surname: surname,
                    hospital: hospital,
                    days: days.inDays + 1,
                    listData: listData,
                    total_away: total_away,
                    total_lost: total_lost)
                : QuarantineLocation(
                    lat: home_lat,
                    lng: home_lng,
                  )));
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
