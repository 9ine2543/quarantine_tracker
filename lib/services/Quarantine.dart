import 'package:http/http.dart' as http;
import 'dart:convert';

final String url = "http://203.151.51.75:8008";

Future<int> sendPayloadForRegister(
    {String organization,
    String citizenId,
    String name,
    String surname,
    String phoneNumber,
    String hospital,
    String days}) async {
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
          "Lat": 13.7218,
          "Lon": 100.727
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
