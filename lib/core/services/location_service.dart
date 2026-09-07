import 'package:flutter/foundation.dart';

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

class LocationService extends ChangeNotifier {
  // Mock locations — replace with GPS / BLE real data
  final LatLng _riderLocation = const LatLng(12.9716, 77.5946);
  final LatLng _bikeLocation  = const LatLng(12.9718, 77.5948);
  final bool _riderConnected = true;
  final bool _bikeConnected  = true;
  final DateTime _lastUpdated = DateTime.now();

  LatLng get riderLocation => _riderLocation;
  LatLng get bikeLocation  => _bikeLocation;
  bool get riderConnected => _riderConnected;
  bool get bikeConnected  => _bikeConnected;
  DateTime get lastUpdated => _lastUpdated;

  double get distanceMeters {
    // Simplified Haversine approximation for small distances
    const earthRadius = 6371000.0;
    final dLat = (_bikeLocation.lat - _riderLocation.lat) * (3.14159265 / 180);
    final dLng = (_bikeLocation.lng - _riderLocation.lng) * (3.14159265 / 180);
    final a = dLat * dLat + dLng * dLng;
    return earthRadius * a; // approx
  }

  bool get isTogether => distanceMeters < 50;

  String get statusLabel => isTogether ? 'Rider & Bike Together' : 'Rider & Bike Separated';

  // Future: plug in real GPS stream / BLE location updates here
}
