import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/safety_status.dart';

/// Safety hardware abstraction.
/// Replace [_mockStatus] with real BLE / ESP32 sensor data.
class SafetyService extends ChangeNotifier {
  SafetyStatus _status = const SafetyStatus(
    helmetDetected: false,   // Mock: helmet is off initially
    chinstrapFastened: false, // Mock: chinstrap is unfastened initially
  );

  SafetyService() {
    _initFirebaseListener();
  }

  SafetyStatus get status => _status;

  void _initFirebaseListener() {
    FirebaseFirestore.instance
        .collection('requests')
        .doc('webDemo')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final power = data['power'] as bool? ?? false;
        final helmet = data['helmetDetected'] as bool? ?? false;

        _status = _status.copyWith(
          helmetDetected: helmet,
          chinstrapFastened: power, // Mapping web simulator 'power' to 'chinstrapFastened'
        );
        notifyListeners();
      }
    });
  }
  void startRide() {
    if (_status.canStartRide) {
      _status = _status.copyWith(rideActive: true);
      notifyListeners();
    }
  }

  void stopRide() {
    _status = _status.copyWith(rideActive: false);
    notifyListeners();
  }

  // ── Future: plug in real BLE stream here ───────────────────────────────────
  // void connectBleDevice(BleDevice device) { ... }
  // StreamSubscription _helmetStream;
  // StreamSubscription _chinstrapStream;
}
