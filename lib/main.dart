import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:quarantine_tracker/model/mqtt.dart';
import 'package:quarantine_tracker/pages/RegisterQuarantine.dart';
import 'package:quarantine_tracker/services/mqttClientWrapper.dart';
import 'package:quarantine_tracker/pages/quarantineLocation.dart';
import 'package:quarantine_tracker/model/locationLog.dart';
import 'package:quarantine_tracker/services/localDatabase.dart';
import 'package:quarantine_tracker/services/preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quarantine_tracker/pages/dashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

var initScreen;
LocalSQL database = LocalSQL.db;
String name, surname, hospital, _startDate, log = '';
double home_lat , home_lng;
int id, count = 0;
var days;
int total_away = 0, total_lost = 0, awayinDay = 0, lostinDay = 0;
bool inHome, isStarted = true;
List listData = [];
List<List<String>> areaData = [];
Position _currentPosition = Position(latitude: 0, longitude: 0);

Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initScreen = await checkPreferences().then((haveRegistered) {
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
  home_lat = prefs.getDouble('homeLat');
  home_lng = prefs.getDouble('homeLong');
  total_away = prefs.getInt('totalAway');
  total_lost = prefs.getInt('totalLost');
  id = prefs.getInt('id');
  inHome = prefs.getBool('inHome');
  days = DateTime.now().difference(DateTime.parse(_startDate));
  List<String> start_date = [_startDate.substring(0,4), _startDate.substring(5,7), _startDate.substring(8,10)];
  print(start_date);
  for (int i = 0; i < days.inDays + 1; i++) {
    if(prefs.getStringList('listData[$i]') == null)
    {
      total_lost += 1;
      lostinDay = 1;
      DateTime _date =  DateTime(int.parse(start_date[0]), int.parse(start_date[1]), int.parse(start_date[2])+i);
      if(i != days.inDays){
        database.insert(LocationLog(0, null, null, 3, null, _date));
      }
      if (_date.day > 9 && _date.month > 9)
          listData.insert(0,[
          '${i + 1}',
          '${_date.day}/${_date.month}/${_date.year + 543}',
          '0',
          '$lostinDay'
        ]);
        else if (_date.day > 9 && _date.month < 10)
          listData.insert(0,[
          '${i + 1}',
          '${_date.day}/0${_date.month}/${_date.year + 543}',
          '0',
          '$lostinDay'
        ]);
        else if (_date.day < 10 && _date.month > 9)
          listData.insert(0,[
          '${i + 1}',
          '0${_date.day}/${_date.month}/${_date.year + 543}',
          '0',
          '$lostinDay'
        ]);
        else if (_date.day < 10 && _date.month < 10)
          listData.insert(0,[
          '${i + 1}',
          '0${_date.day}/0${_date.month}/${_date.year + 543}',
          '0',
          '$lostinDay'
        ]);
      saveTotalValue(total_away, total_lost);
      setValuePreferences(listData[0], i);
      if(i == days.inDays){ //current
        awayinDay = 0;
        lostinDay = 1;
      }
    }
    else{
      listData.insert(0, prefs.getStringList('listData[$i]'));
      if(i == days.inDays){ //current
        awayinDay = int.parse(listData[0][2]);
        lostinDay = int.parse(listData[0][3]);
      }
    }
  }
  while(prefs.getStringList('areaData[$count]') != null){
    areaData.add(prefs.getStringList('areaData[$count]'));
    count += 1;
  }
  // print(prefs.getStringList('areaData[5]'));
}

Future<void> saveTotalValue(int away, int lost) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('totalAway', away);
  prefs.setInt('totalLost', lost);
}

Future<void> setValuePreferences(List<String> dataList, int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('listData[$index]', dataList);
}
Future<void> setInHome(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('inHome', value);
}
Future<void> setAreaPreferences(List<String> dataList, int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('areaData[$index]', dataList);
  print(prefs.getStringList('areaData[$index]'));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quarantine Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: rootPage(),
    );
  }
}

class rootPage extends StatefulWidget {
  @override
  _rootPageState createState() => _rootPageState();
}

class _rootPageState extends State<rootPage> {

  void _registered() {
    setState(() {
      initScreen = '/';
    });
  }


  @override
  Widget build(BuildContext context) {
    switch (initScreen) {
      case 'register':
        return RegisterQuarantine(
          onRegistered: _registered,
        );
      case '/':
        return MyHomePage();
      default:
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isConnected = true;
  ConnectivityResult _connectivity ;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool canCal = false;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List queryResult = [];
  double lati,
      long,
      distance;
  MQTTClientWrapper mqttClientWrapper;
  Timer geofetchTimer;
  int status = 1; //default
  void mqttSetup() {
    mqttClientWrapper = MQTTClientWrapper();
    mqttClientWrapper.prepareMqttClient();
  }


  Future<void> _onCalculate(double home_lat, double home_lng, double lat, double lng) async {
    distance = await Geolocator().distanceBetween(home_lat, home_lng, lati, long);
    
    // distance = await Geolocator().distanceBetween(13.7992131, 100.5486174, 13.7918731, 100.5499642);
    print('aaaaaaaaaaaa');//13.7227906, 100.7245833
    print(distance);
  }

  void _getAndPublishLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      setState(() {
        isStarted = false;
        this.lati = location.latitude;
        this.long = location.longitude;
        if (name == null || listData[0] == null) {
          getValueForDashboard();
        }
        print("Latitude: $lati Longitude: $long");
        print('bbbbbbbbbbbbbb');
        if(home_lat != null && home_lng != null && lati != null && long != null)
        _onCalculate(home_lat, home_lng, this.lati, this.long);
      });
      Future.delayed(new Duration(milliseconds: 500), ()
      {
        if(distance <= 30){// normal
          if(isConnected){
            status = 1;
          }
          else
            status = 11;
          inHome = true;
        }
        else //away
          if(isConnected){
            status = 2;
          }
          else
            status = 22;
        
        days = DateTime.now().difference(DateTime.parse(_startDate));
        if (days.inDays == listData.length) {
          awayinDay = 0;
          lostinDay = 0;
          setValuePreferences([
            '${days.inDays + 1}',
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year + 543}',
            '$awayinDay',
            '$lostinDay'
          ], listData.length);
          if (DateTime.now().day > 9 && DateTime.now().month > 9)
            listData.insert(0, [
              '${days.inDays + 1}',
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year + 543}',
              '$awayinDay',
              '$lostinDay'
            ]);
          else if (DateTime.now().day > 9 && DateTime.now().month < 10)
            listData.insert(0, [
              '${days.inDays + 1}',
              '${DateTime.now().day}/0${DateTime.now().month}/${DateTime.now().year + 543}',
              '$awayinDay',
              '$lostinDay'
            ]);
          else if (DateTime.now().day < 10 && DateTime.now().month > 9)
            listData.insert(0, [
              '${days.inDays + 1}',
              '0${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year + 543}',
              '$awayinDay',
              '$lostinDay'
            ]);
          else if (DateTime.now().day < 10 && DateTime.now().month < 10)
            listData.insert(0, [
              '${days.inDays + 1}',
              '0${DateTime.now().day}/0${DateTime.now().month}/${DateTime.now().year + 543}',
              '$awayinDay',
              '$lostinDay'
            ]);
        }
        
        if((status == 2 || status == 22) && inHome == true){
          awayinDay += 1;
          total_away += 1;
          inHome = false;
        }
        saveTotalValue(total_away, total_lost);
        listData[0][2] = '$awayinDay';
        listData[0][3] = '$lostinDay';
        if(distance != null){
          // areaData.add(['${count + 1}', listData[0][1], DateTime.now().toString().substring(11,16), '$status', '${distance.toInt()}']);
          areaData.add(['$lati', '$long', DateTime.now().toString().substring(11,16), '$status', '${distance.toInt()}', '${count + 1}']);
          setAreaPreferences(areaData[areaData.length - 1], count);
          count += 1;
        }
        setValuePreferences(listData[0], listData.length - 1);
        
        LocationLog mockLog = LocationLog(Random().nextInt(1000000), this.lati,
            this.long, this.status, this.distance, DateTime.now());
        print(mqttClientWrapper.connectionState);
        setInHome(inHome);
        database.insert(mockLog);
        database.logs().then((logs) => getQuery(logs));
        if(isConnected){
          mqttClientWrapper.publishLocation(
              id, location.latitude, location.longitude, this.status);
        }
      });
        
      _connectivitySubscription == Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
        _connectivity = result;
        if(result == ConnectivityResult.none){ //ปิดเน็ต
          if(isConnected){
            lostinDay += 1;
            total_lost += 1;
          }
          isConnected = false;
        }
      });
      if((_connectivity != ConnectivityResult.none && isConnected == false) || (_connectivity != ConnectivityResult.none && mqttClientWrapper.connectionState == MqttCurrentConnectionState.DISCONNECTED)){
          mqttSetup();
          isConnected = true;
      }
      
    });
  }
  void getQuery(List<Map<String, dynamic>> res) {
    print('List length: ${res.length}');
    setState(() {
      queryResult.clear();
      queryResult.addAll(res);
    });
    // print(queryResult.length);
    queryResult.asMap().forEach((index, value) {
      // print(queryResult[index]);
    });
    log = queryResult[queryResult.length-1].toString();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _connectivitySubscription == Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      print(result);
      if(result == ConnectivityResult.none){ //ปิดเน็ต
        if(isConnected){
          lostinDay += 1;
          total_lost += 1;
        }
        isConnected = false;
      }
      _connectivity = result;
    });
    if(isConnected)
      mqttSetup();
    BackgroundLocation.startLocationService();
      geofetchTimer = Timer.periodic(Duration(seconds: 3), (Timer t) {
        print('in process');
        _getAndPublishLocation();
        isStarted = false;
        print(name != null);
        print(isStarted == false);
        if(name != null && isStarted == false){
          t.cancel();
        }
      });
      geofetchTimer = Timer.periodic(Duration(minutes: 15), (Timer t) {
        print('2');
        _getAndPublishLocation();
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: name != null && listData[0] != []
                ? dashBoardMain(
                    name: name,
                    surname: surname,
                    hospital: hospital,
                    days: days.inDays + 1,
                    listData: listData,
                    total_away: total_away,
                    total_lost: total_lost, 
                    log: log,
                    areaData: areaData,
                    homelat: home_lat,
                    homelng: home_lng,
                  )
                : QuarantineLocation(
                    lat: _currentPosition.latitude,
                    lng: _currentPosition.longitude,
                  )));
  }

  void _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lati = _currentPosition.latitude;
        long = _currentPosition.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _connectivitySubscription.cancel();
    print('disconnect');
    super.dispose();
  }
}
