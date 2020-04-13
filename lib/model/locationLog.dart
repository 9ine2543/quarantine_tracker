class LocationLog {
  int id;
  double lat;
  double long;
  DateTime timestamp;
  int status;
  double distance;

  LocationLog(this.id, this.lat, this.long, this.status, this.distance, this.timestamp);

  Map toJson() => {'Id': id, 'Lat': lat, 'Long': long, 'Status': status};

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
      'ts': timestamp.toIso8601String(),
      'status': status,
      'distance': distance
    };
  }

  @override
  String toString() {
    return 'LocationLog{Id: $id, latitude: $lat, longitude: $long, timestamp: $timestamp, distance: $distance}';
  }
}
