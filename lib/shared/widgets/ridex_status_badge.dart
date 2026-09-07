import 'package:flutter/material.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';

enum BadgeVariant { pass, fail, warn, ready, active }

class RidexStatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;

  const RidexStatusBadge({
    super.key,
    required this.label,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      BadgeVariant.pass   => (RidexColors.emeraldBg, RidexColors.emeraldDark),
      BadgeVariant.fail   => (RidexColors.errorBg, RidexColors.red),
      BadgeVariant.warn   => (RidexColors.warningBg, RidexColors.warning),
      BadgeVariant.ready  => (RidexColors.emeraldBg, RidexColors.emeraldDark),
      BadgeVariant.active => (const Color(0xFFFFF1F2), RidexColors.red),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: RidexTextStyles.badgeText.copyWith(color: fg),
      ),
    );
  }
}
