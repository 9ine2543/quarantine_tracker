class LocationLog {
  int id;
  double lat;
  double long;
  DateTime timestamp = DateTime.now();
  String status;

  LocationLog(this.id, this.lat, this.long);

  Map toJson() => {'Id': id, 'Lat': lat, 'Long': long};

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'long': long,
        'ts': timestamp.toIso8601String(),
        'status': status
      };

  @override
  String toString() {
    return 'LocationLog{lat: $lat, long: $long, timestamp: $timestamp, status: $status}';
  }
}
