import 'package:flutter/foundation.dart';
import '../../shared/models/safety_status.dart';

/// Safety hardware abstraction.
/// Replace [_mockStatus] with real BLE / ESP32 sensor data.
class SafetyService extends ChangeNotifier {
  SafetyStatus _status = const SafetyStatus(
    helmetDetected: false,   // Mock: helmet is off initially
    chinstrapFastened: false, // Mock: chinstrap is unfastened initially
  );

  SafetyStatus get status => _status;

  // ── Dev / Demo toggles — only used in development ──────────────────────────
  void toggleHelmet() {
    _status = _status.copyWith(helmetDetected: !_status.helmetDetected);
    notifyListeners();
  }

  void toggleChinstrap() {
    _status = _status.copyWith(chinstrapFastened: !_status.chinstrapFastened);
    notifyListeners();
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
