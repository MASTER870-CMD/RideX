import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'core/services/document_service.dart';
import 'core/services/emission_service.dart';
import 'core/services/location_service.dart';
import 'core/services/safety_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/ridex_theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCmrGALI3ATsFNJvW2LIMrSVYAouQsq_kM",
      appId: "1:737399835094:web:5a782ac1386decc3c07c77",
      messagingSenderId: "737399835094",
      projectId: "test-5cf65",
    ),
  );

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize notifications (no-op until wired)
  await NotificationService().initialize();

  // Load emission due date from persistence
  final emissionSvc = EmissionService();
  await emissionSvc.loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SafetyService()),
        ChangeNotifierProvider(create: (_) => DocumentService()),
        ChangeNotifierProvider.value(value: emissionSvc),
        ChangeNotifierProvider(create: (_) => LocationService()),
      ],
      child: const RidexApp(),
    ),
  );
}

class RidexApp extends StatelessWidget {
  const RidexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RIDEX',
      debugShowCheckedModeBanner: false,
      theme: RidexTheme.light,
      initialRoute: AppRoutes.splash,
      routes: AppRouter.routes,
    );
  }
}
