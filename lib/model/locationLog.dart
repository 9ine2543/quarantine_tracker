class LocationLog {
  int id;
  double lat;
  double long;
  final DateTime timestamp = DateTime.now();
  String status;

  LocationLog(this.id, this.lat, this.long);

  Map toJson() => {'Id': id, 'Lat': lat, 'Long': long};

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
      'ts': timestamp.toIso8601String(),
      'status': status
    };
  }

  @override
  String toString() {
    return 'LocationLog{Id: $id, latitude: $lat, longitude: $long, timestamp: $timestamp}';
  }
}
