import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/ridex_constants.dart';
import '../../core/routing/app_router.dart';
import '../../core/services/safety_service.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../shared/models/safety_status.dart';
import '../../shared/widgets/ridex_drawer.dart';
import '../../shared/widgets/ridex_primary_button.dart';
import '../../shared/widgets/ridex_status_badge.dart';

class SafetyGateScreen extends StatefulWidget {
  const SafetyGateScreen({super.key});
  @override
  State<SafetyGateScreen> createState() => _SafetyGateScreenState();
}

class _SafetyGateScreenState extends State<SafetyGateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _radarCtrl;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _radarCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 7))
      ..repeat();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _radarCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RidexColors.background,
      drawer: const RidexDrawer(activeRoute: AppRoutes.safetyGate),
      body: SafeArea(
        child: Consumer<SafetyService>(
          builder: (context, svc, _) {
            final status = svc.status;
            return Column(
              children: [
                _buildAppBar(context, status),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        _buildHeadline(status),
                        const SizedBox(height: 8),
                        _buildHelmetHero(status),
                        const SizedBox(height: 12),
                        _buildSensorCards(status),
                        const SizedBox(height: 10),
                        _buildQualificationBar(status),
                        const SizedBox(height: 12),
                        _buildStartRide(context, svc, status),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SafetyStatus status) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Builder(builder: (ctx) => InkWell(
            onTap: () => Scaffold.of(ctx).openDrawer(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: RidexColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RidexColors.border),
                boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8, offset: const Offset(0, 2),
                )],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bar(), const SizedBox(height: 4),
                  _bar(), const SizedBox(height: 4),
                  _bar(),
                ],
              ),
            ),
          )),
          const SizedBox(width: 12),
          Image.asset(RidexConstants.logoAsset, height: 28,
              fit: BoxFit.contain),
          const SizedBox(width: 8),
          Container(width: 1, height: 16, color: RidexColors.border),
          const SizedBox(width: 8),
          Text('Safety Check', style: RidexTextStyles.titleSmall),
          const Spacer(),
          Builder(builder: (context) {
            final isOffline = status.checksComplete == 0;
            final dotColor = status.canStartRide
                ? RidexColors.emerald
                : (isOffline ? RidexColors.muted : RidexColors.warning);
            final textColor = status.canStartRide
                ? RidexColors.emeraldDark
                : (isOffline ? RidexColors.muted : RidexColors.warning);
            final text = status.canStartRide
                ? 'Online'
                : (isOffline ? 'Offline' : 'Alert');

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: RidexColors.card,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: RidexColors.border),
              ),
              child: Row(
                children: [
                  if (!isOffline)
                    _PulsingDot(color: dotColor)
                  else
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: dotColor, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text(
                    text,
                    style: RidexTextStyles.labelBold.copyWith(
                      color: textColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _bar() => Container(
      width: 16, height: 2,
      decoration: BoxDecoration(
        color: RidexColors.charcoal,
        borderRadius: BorderRadius.circular(1),
      ));

  Widget _buildHeadline(SafetyStatus status) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: RidexColors.red.withValues(alpha: 0.15)),
          ),
          child: Text('PRE-RIDE SAFETY GATE',
              style: RidexTextStyles.labelBold.copyWith(
                color: RidexColors.red, fontSize: 10,
              )),
        ),
        const SizedBox(height: 6),
        Text('READY TO RIDE?', style: RidexTextStyles.displayLarge),
        const SizedBox(height: 4),
        Text('Secure your helmet & chinstrap before starting',
            style: RidexTextStyles.bodyMedium),
      ],
    );
  }

  Widget _buildHelmetHero(SafetyStatus status) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radar rings
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (context, child) {
              final t = _pulseCtrl.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  _radarRing(200, RidexColors.emerald, 0.08 + t * 0.04),
                  _radarRing(160, RidexColors.emerald, 0.12 + t * 0.06),
                  _radarRing(120, RidexColors.emerald, 0.04),
                ],
              );
            },
          ),
          // Rotating radar beam
          AnimatedBuilder(
            animation: _radarCtrl,
            builder: (context, _) => Transform.rotate(
              angle: _radarCtrl.value * 2 * math.pi,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: RidexColors.emerald.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Helmet image
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                RidexConstants.helmet3dAsset,
                width: 160, height: 145,
                fit: BoxFit.contain,
                color: RidexColors.background,
                colorBlendMode: BlendMode.darken,
                errorBuilder: (ctx, err, stack) => const Icon(
                  Icons.sports_motorsports,
                  size: 100, color: RidexColors.charcoal,
                ),
              ),
              // Chin lock overlay
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: status.chinstrapFastened
                        ? const Color(0xFF86EFAC)
                        : RidexColors.warning.withValues(alpha: 0.5),
                  ),
                  boxShadow: [BoxShadow(
                    color: (status.chinstrapFastened
                        ? RidexColors.emerald : RidexColors.warning)
                        .withValues(alpha: 0.18),
                    blurRadius: 12, offset: const Offset(0, 4),
                  )],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: status.chinstrapFastened
                            ? RidexColors.emerald : RidexColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status.chinstrapFastened
                          ? 'Chin Lock Engaged (100%)'
                          : 'Chinstrap Open',
                      style: RidexTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: status.chinstrapFastened
                            ? const Color(0xFF065F46) : RidexColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _radarRing(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: color.withValues(alpha: opacity),
        width: 1,
      ),
    ),
  );

  Widget _buildSensorCards(SafetyStatus status) {
    return Row(
      children: [
        Expanded(child: _SensorCard(
          icon: Icons.sports_motorsports_outlined,
          label: 'Helmet Sensor',
          value: status.helmetDetected ? 'Detected' : 'Not Found',
          pass: status.helmetDetected,
        )),
        const SizedBox(width: 10),
        Expanded(child: _SensorCard(
          icon: Icons.lock_outline,
          label: 'Chinstrap Lock',
          value: status.chinstrapFastened ? 'Fastened' : 'Open',
          pass: status.chinstrapFastened,
        )),
      ],
    );
  }

  Widget _buildQualificationBar(SafetyStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RidexColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              color: status.canStartRide
                  ? RidexColors.emerald : RidexColors.border,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check,
                size: 12,
                color: status.canStartRide
                    ? Colors.white : RidexColors.muted),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${status.checksComplete} / 2 Safety Checks Complete',
                  style: RidexTextStyles.titleSmall),
              Text(
                status.canStartRide
                    ? 'Motorcycle ignition unlock authorized'
                    : 'Complete all checks to start',
                style: RidexTextStyles.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          RidexStatusBadge(
            label: status.canStartRide ? 'READY' : 'WAIT',
            variant: status.canStartRide
                ? BadgeVariant.ready : BadgeVariant.warn,
          ),
        ],
      ),
    );
  }

  Widget _buildStartRide(BuildContext context, SafetyService svc,
      SafetyStatus status) {
    return Column(
      children: [
        RidexPrimaryButton(
          label: 'START RIDE',
          trailingIcon: Icons.arrow_forward,
          onPressed: status.canStartRide
              ? () {
                  svc.startRide();
                  Navigator.of(context).pushNamed(AppRoutes.safeRide);
                }
              : null,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined,
                size: 14, color: RidexColors.emerald),
            const SizedBox(width: 5),
            Text('Safety monitoring active • Auto-pauses if unbuckled',
                style: RidexTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
    );
  }

}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Container(
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.6 + _c.value * 0.4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool pass;

  const _SensorCard({
    required this.icon, required this.label,
    required this.value, required this.pass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pass
              ? const Color(0xFFA7F3D0)
              : RidexColors.warning.withValues(alpha: 0.4),
        ),
        boxShadow: [BoxShadow(
          color: (pass ? RidexColors.emerald : RidexColors.warning)
              .withValues(alpha: 0.06),
          blurRadius: 10, offset: const Offset(0, 2),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: pass
                      ? RidexColors.emeraldBg : RidexColors.warningBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15,
                    color: pass
                        ? RidexColors.emeraldDark : RidexColors.warning),
              ),
              RidexStatusBadge(
                label: pass ? '✓ PASS' : '✗ FAIL',
                variant: pass ? BadgeVariant.pass : BadgeVariant.fail,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: RidexTextStyles.bodySmall),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(value,
                  style: RidexTextStyles.titleSmall.copyWith(fontSize: 13)),
              const SizedBox(width: 4),
              Icon(
                pass ? Icons.check_circle : Icons.cancel,
                size: 13,
                color: pass ? RidexColors.emerald : RidexColors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

