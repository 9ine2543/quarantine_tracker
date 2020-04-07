import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final String url = "http://203.151.51.75:8008";

Future<int> sendPayloadForRegister(
    {String organization,
    String citizenId,
    String name,
    String surname,
    String phoneNumber,
    String hospital,
    String days,
    double lat,
    double lng}) async {
  var client = http.Client();
  try {
    var response = await client.post(url,
        body: json.encode({
          "CodeID": int.parse(organization),
          "ID": int.parse(citizenId),
          "FirstName": name,
          "LastName": surname,
          "Phone": phoneNumber,
          "Type": 1,
          "Hospital": hospital,
          "Duration": int.parse(days),
          "Lat": lat,
          "Lon": lng
        }),
        headers: {"Content-Type": "application/json"});
    final int statusCode = response.statusCode;
    print('Response status: $statusCode');
    print('Response body: ${response.body}');
    return statusCode;
  } finally {
    client.close();
  }
}

Future<void> saveToSharedPreferences(
    {String organization,
    String citizenId,
    String name,
    String surname,
    String hospital,
    String days,
    double lat,
    double lng}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('organization', organization);
  prefs.setString('citizenId', citizenId);
  prefs.setString('name', name);
  prefs.setString('surname', surname);
  prefs.setString('hospital', hospital);
  prefs.setInt('days', int.parse(days));
  prefs.setString('startDate', DateTime.now().toString());
  prefs.setString('homeLat', '$lat');
  prefs.setString('homeLong', '$lng');
}
