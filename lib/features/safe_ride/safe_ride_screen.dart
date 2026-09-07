import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/ridex_constants.dart';
import '../../core/routing/app_router.dart';
import '../../core/services/safety_service.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../shared/widgets/ridex_drawer.dart';
import '../../shared/widgets/ridex_primary_button.dart';
import '../../shared/widgets/ridex_status_badge.dart';
import 'models/mission_model.dart';

class SafeRideScreen extends StatefulWidget {
  const SafeRideScreen({super.key});
  @override
  State<SafeRideScreen> createState() => _SafeRideScreenState();
}

class _SafeRideScreenState extends State<SafeRideScreen> {
  int _credits = RidexConstants.mockAvailableCredits;
  Mission _mission = const Mission(
    id: 'm1',
    title: 'Safe 15 KM Ride',
    requiredDistanceKm: RidexConstants.mockMissionRequiredKm,
    rewardCredits: RidexConstants.mockMissionRewardCredits,
    helmetRequired: true,
    progressKm: RidexConstants.mockMissionProgressKm,
  );

  void _claimCredits() {
    if (_mission.isComplete && _mission.status == MissionStatus.complete) {
      setState(() {
        _credits += _mission.rewardCredits;
        _mission = _mission.copyWith(status: MissionStatus.claimed);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${_mission.rewardCredits} RIDEX Credits Added!'),
          backgroundColor: RidexColors.emerald,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RidexColors.background,
      drawer: const RidexDrawer(activeRoute: AppRoutes.safeRide),
      body: SafeArea(
        child: Consumer<SafetyService>(
          builder: (context, svc, _) {
            final helmetOn = svc.status.helmetDetected;
            final effectiveMission = helmetOn
                ? _mission
                : (_mission.status == MissionStatus.inProgress
                    ? _mission.copyWith(status: MissionStatus.paused)
                    : _mission);

            return Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    child: Column(
                      children: [
                        _buildCreditsWallet(),
                        const SizedBox(height: 16),
                        if (!helmetOn) _buildHelmetWarning(),
                        if (!helmetOn) const SizedBox(height: 12),
                        _buildMissionCard(effectiveMission, helmetOn),
                        const SizedBox(height: 12),
                        _buildStatusRow(svc),
                        const SizedBox(height: 16),
                        if (effectiveMission.isComplete &&
                            effectiveMission.status != MissionStatus.claimed)
                          _buildClaimButton()
                        else if (effectiveMission.status ==
                            MissionStatus.claimed)
                          _buildClaimedState(),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: RidexColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RidexColors.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: RidexColors.charcoal),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Safe Ride & Credits', style: RidexTextStyles.titleLarge),
              Text('Ride safely & earn rewards',
                  style: RidexTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsWallet() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [RidexColors.red, RidexColors.orange],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: RidexColors.red.withValues(alpha: 0.3),
          blurRadius: 20, offset: const Offset(0, 8),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RIDEX CREDITS',
              style: RidexTextStyles.labelBold.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              )),
          const SizedBox(height: 4),
          Text(
            _credits.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]},'),
            style: RidexTextStyles.creditAmount.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.monetization_on_outlined,
                  size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text('Loyalty reward credits • Not cryptocurrency',
                  style: RidexTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelmetWarning() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RidexColors.warningBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RidexColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined,
              color: RidexColors.warning, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Helmet not detected',
                    style: RidexTextStyles.titleSmall.copyWith(
                      color: RidexColors.warning,
                    )),
                Text('Reward progress paused',
                    style: RidexTextStyles.bodySmall.copyWith(
                      color: RidexColors.warning.withValues(alpha: 0.8),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Mission mission, bool helmetOn) {
    final isPaused = mission.status == MissionStatus.paused;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: RidexColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RidexStatusBadge(
                      label: isPaused ? 'PAUSED' : 'ACTIVE MISSION',
                      variant: isPaused
                          ? BadgeVariant.warn : BadgeVariant.pass,
                    ),
                    const SizedBox(height: 6),
                    Text(mission.title,
                        style: RidexTextStyles.titleLarge),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [RidexColors.red, RidexColors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+${mission.rewardCredits} Credits',
                  style: RidexTextStyles.labelBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: mission.progressFraction,
              minHeight: 8,
              backgroundColor: RidexColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPaused ? RidexColors.warning : RidexColors.emerald,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${mission.progressKm.toStringAsFixed(1)} / '
                '${mission.requiredDistanceKm.toStringAsFixed(0)} KM',
                style: RidexTextStyles.titleSmall,
              ),
              Text(
                '${mission.remainingKm.toStringAsFixed(1)} KM remaining',
                style: RidexTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(SafetyService svc) {
    return Row(
      children: [
        Expanded(child: _StatusItem(
          icon: Icons.sports_motorsports_outlined,
          label: 'Helmet',
          value: svc.status.helmetDetected ? 'Detected' : 'Not Found',
          ok: svc.status.helmetDetected,
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatusItem(
          icon: Icons.directions_bike_outlined,
          label: 'Ride',
          value: svc.status.rideActive ? 'Active' : 'Inactive',
          ok: svc.status.rideActive,
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatusItem(
          icon: Icons.route_outlined,
          label: 'Distance',
          value: '${RidexConstants.mockMissionProgressKm} KM',
          ok: true,
        )),
      ],
    );
  }

  Widget _buildClaimButton() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RidexColors.emeraldBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: RidexColors.emerald.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text('MISSION COMPLETE',
                  style: RidexTextStyles.displayMedium.copyWith(
                    color: RidexColors.emeraldDark,
                  )),
              Text('+${_mission.rewardCredits} RIDEX Credits',
                  style: RidexTextStyles.titleMedium.copyWith(
                    color: RidexColors.emerald,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        RidexPrimaryButton(
          label: 'Claim ${_mission.rewardCredits} Credits',
          trailingIcon: Icons.redeem,
          onPressed: _claimCredits,
        ),
      ],
    );
  }

  Widget _buildClaimedState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RidexColors.emeraldBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RidexColors.emerald.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: RidexColors.emerald, size: 20),
          const SizedBox(width: 8),
          Text('${_mission.rewardCredits} Credits Added',
              style: RidexTextStyles.titleSmall.copyWith(
                color: RidexColors.emeraldDark,
              )),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool ok;

  const _StatusItem({
    required this.icon, required this.label,
    required this.value, required this.ok,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RidexColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16,
              color: ok ? RidexColors.emerald : RidexColors.warning),
          const SizedBox(height: 4),
          Text(label, style: RidexTextStyles.bodySmall),
          Text(value,
              style: RidexTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: ok ? RidexColors.charcoal : RidexColors.warning,
                fontSize: 11,
              ),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
