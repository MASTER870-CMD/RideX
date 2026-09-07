import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/safety_gate/safety_gate_screen.dart';
import '../../features/document_vault/document_vault_screen.dart';
import '../../features/helmet_safety/helmet_safety_screen.dart';
import '../../features/safe_ride/safe_ride_screen.dart';
import '../../features/rider_location/rider_location_screen.dart';
import '../../features/emission_test/emission_test_screen.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String safetyGate = '/safety-gate';
  static const String documentVault = '/document-vault';
  static const String helmetSafety = '/helmet-safety';
  static const String safeRide = '/safe-ride';
  static const String riderLocation = '/rider-location';
  static const String emissionTest = '/emission-test';
}

abstract final class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.safetyGate: (_) => const SafetyGateScreen(),
    AppRoutes.documentVault: (_) => const DocumentVaultScreen(),
    AppRoutes.helmetSafety: (_) => const HelmetSafetyScreen(),
    AppRoutes.safeRide: (_) => const SafeRideScreen(),
    AppRoutes.riderLocation: (_) => const RiderLocationScreen(),
    AppRoutes.emissionTest: (_) => const EmissionTestScreen(),
  };
}
