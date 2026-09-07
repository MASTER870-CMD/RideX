import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/ridex_constants.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.88, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _ctrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        Navigator.of(context).pushReplacementNamed(AppRoutes.safetyGate);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: RidexColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Subtle radial brand glow
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.04),
                    radius: 0.72,
                    colors: [
                      Color(0x0EEB3C1E),
                      Color(0x06F5A623),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Center content
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        RidexConstants.logoAsset,
                        width: MediaQuery.of(context).size.width * 0.72,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 40,
                        height: 1,
                        color: RidexColors.muted.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        RidexConstants.tagline.toUpperCase(),
                        style: RidexTextStyles.tagline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Positioned(
              bottom: 36,
              left: 0, right: 0,
              child: FadeTransition(
                opacity: _fade,
                child: Text(
                  RidexConstants.poweredBy.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: RidexTextStyles.poweredBy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
