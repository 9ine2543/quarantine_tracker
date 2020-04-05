class LocationLog {
  int id;
  double lat;
  double long;
  DateTime timestamp = DateTime.now();

  LocationLog(this.id, this.lat, this.long);

  Map toJson() => {'Id': id, 'Lat': lat, 'Long': long};

  Map<String, dynamic> toMap() =>
      {'citizen_id': id, 'lat': lat, 'long': long, 'timestamp': timestamp};

  @override
  String toString() {
    return 'LocationLog{Id: $id, latitude: $lat, longitude: $long, timestamp: $timestamp}';
  }
}
