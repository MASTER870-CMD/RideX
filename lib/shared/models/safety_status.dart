/// Domain model for helmet + chinstrap safety state.
/// Designed to be replaced with real BLE/hardware data later.
class SafetyStatus {
  final bool helmetDetected;
  final bool chinstrapFastened;
  final bool rideActive;

  const SafetyStatus({
    this.helmetDetected = false,
    this.chinstrapFastened = false,
    this.rideActive = false,
  });

  /// Both checks must pass before starting a ride.
  bool get canStartRide => helmetDetected && chinstrapFastened;

  /// 0, 1, or 2 safety checks complete.
  int get checksComplete =>
      [helmetDetected, chinstrapFastened].where((c) => c).length;

  /// Human-readable gate status.
  String get gateStatusLabel {
    if (canStartRide) return 'READY TO RIDE';
    if (helmetDetected && !chinstrapFastened) return 'CHINSTRAP OPEN';
    return 'HELMET NOT DETECTED';
  }

  SafetyStatus copyWith({
    bool? helmetDetected,
    bool? chinstrapFastened,
    bool? rideActive,
  }) =>
      SafetyStatus(
        helmetDetected: helmetDetected ?? this.helmetDetected,
        chinstrapFastened: chinstrapFastened ?? this.chinstrapFastened,
        rideActive: rideActive ?? this.rideActive,
      );
}
