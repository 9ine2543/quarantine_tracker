import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.containsKey('name') &&
      prefs.containsKey('surname') &&
      prefs.containsKey('citizenId') &&
      prefs.containsKey('hospital') &&
      prefs.containsKey('organization') &&
      prefs.containsKey('days') &&
      prefs.containsKey('startDate');
}

Future<Map<String, dynamic>> getPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> profiles = {
    'name': prefs.getString('name'),
    'citizenId': prefs.getString('citizenId'),
    'surname': prefs.getString('surname'),
    'hospital': prefs.getString('hospital'),
    'organization': prefs.getString('organization'),
    'days': prefs.getInt('days'),
    'startDate': prefs.getString('startDate')
  };

  return profiles;
}

// Get current location.
Future<Position> getHomeLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Position homeLocation = Position(
      latitude: double.parse(prefs.getString('homeLat')),
      longitude: double.parse(prefs.getString('homeLong')));

  return homeLocation;
}

// Get elapsed time by difference between current time and started date.
Future<int> getElapsedTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var difference =
      DateTime.now().difference(DateTime.parse(prefs.getString('startDate')));
  return difference.inDays;
}
