import 'package:flutter/material.dart';
import '../../core/constants/ridex_constants.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../shared/widgets/ridex_drawer.dart';
import '../../shared/widgets/ridex_status_badge.dart';
import '../../shared/widgets/ridex_primary_button.dart';

enum HelmetCondition { good, needsAttention, unsafe }

class HelmetSafetyScreen extends StatefulWidget {
  const HelmetSafetyScreen({super.key});
  @override
  State<HelmetSafetyScreen> createState() => _HelmetSafetyScreenState();
}

class _HelmetSafetyScreenState extends State<HelmetSafetyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  final HelmetCondition _condition = HelmetCondition.good;
  bool _isAnalyzing = false;

  static const _checks = [
    'Shell',
    'Visor',
    'Chin Strap',
    'Padding',
    'Exterior',
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _isAnalyzing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RidexColors.background,
      drawer: const RidexDrawer(activeRoute: AppRoutes.helmetSafety),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    _buildConditionBadge(),
                    const SizedBox(height: 16),
                    _buildHelmetDisplay(),
                    const SizedBox(height: 20),
                    _buildChecklist(),
                    const SizedBox(height: 20),
                    _buildConditionMessage(),
                    const SizedBox(height: 16),
                    RidexPrimaryButton(
                      label: 'Analyze Helmet',
                      trailingIcon: Icons.search,
                      isLoading: _isAnalyzing,
                      onPressed: _isAnalyzing ? null : _analyze,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI-powered visual analysis • Not a safety certification',
                      style: RidexTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
              Text('Helmet Safety Check', style: RidexTextStyles.titleLarge),
              Text('Inspect your helmet condition',
                  style: RidexTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionBadge() {
    final (label, variant) = switch (_condition) {
      HelmetCondition.good =>
        ('GOOD CONDITION', BadgeVariant.pass),
      HelmetCondition.needsAttention =>
        ('NEEDS ATTENTION', BadgeVariant.warn),
      HelmetCondition.unsafe =>
        ('UNSAFE CONDITION', BadgeVariant.fail),
    };
    return Center(
      child: RidexStatusBadge(label: label, variant: variant),
    );
  }

  Widget _buildHelmetDisplay() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        final glow = _pulseCtrl.value;
        return Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: RidexColors.ivory,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: RidexColors.border),
            boxShadow: [BoxShadow(
              color: RidexColors.emerald.withValues(alpha: 0.06 + glow * 0.06),
              blurRadius: 24 + glow * 8,
              spreadRadius: 2,
            )],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing ring
              Opacity(
                opacity: 0.15 + glow * 0.1,
                child: Container(
                  width: 180, height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: RidexColors.emerald,
                  ),
                ),
              ),
              Image.asset(
                RidexConstants.helmet3dAsset,
                width: 160, height: 160,
                fit: BoxFit.contain,
                color: RidexColors.ivory,
                colorBlendMode: BlendMode.darken,
                errorBuilder: (ctx, err, stack) => const Icon(
                  Icons.sports_motorsports,
                  size: 100, color: RidexColors.charcoal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChecklist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RidexColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inspection Points', style: RidexTextStyles.titleSmall),
          const SizedBox(height: 12),
          ..._checks.map((check) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 20, height: 20,
                  decoration: const BoxDecoration(
                    color: RidexColors.emeraldBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      size: 12, color: RidexColors.emeraldDark),
                ),
                const SizedBox(width: 10),
                Text(check, style: RidexTextStyles.bodyMedium.copyWith(
                  color: RidexColors.charcoal,
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildConditionMessage() {
    final (icon, title, subtitle, bg, fg) = switch (_condition) {
      HelmetCondition.good => (
        Icons.check_circle_outline,
        'Helmet is in good condition',
        'All inspection points passed. Safe to ride.',
        RidexColors.emeraldBg,
        RidexColors.emeraldDark,
      ),
      HelmetCondition.needsAttention => (
        Icons.warning_amber_outlined,
        'Helmet needs attention',
        'Some areas require inspection before riding.',
        RidexColors.warningBg,
        RidexColors.warning,
      ),
      HelmetCondition.unsafe => (
        Icons.cancel_outlined,
        'Helmet is unsafe',
        'Do not ride with this helmet. Replace immediately.',
        const Color(0xFFFFF1F2),
        RidexColors.red,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: RidexTextStyles.titleSmall.copyWith(
                  color: fg,
                )),
                Text(subtitle, style: RidexTextStyles.bodySmall.copyWith(
                  color: fg.withValues(alpha: 0.8),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

