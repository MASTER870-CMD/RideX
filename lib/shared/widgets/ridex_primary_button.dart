import 'package:flutter/material.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../core/constants/ridex_constants.dart';

class RidexPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? trailingIcon;

  const RidexPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return SizedBox(
      width: double.infinity,
      height: RidexConstants.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [RidexColors.red, RidexColors.orange],
                )
              : null,
          color: enabled ? null : RidexColors.border,
          borderRadius: BorderRadius.circular(RidexConstants.radiusXL),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: RidexColors.red.withValues(alpha: 0.32),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : null,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RidexConstants.radiusXL),
            ),
            padding: EdgeInsets.zero,
            foregroundColor: Colors.white,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: RidexTextStyles.titleMedium.copyWith(
                        color: enabled ? Colors.white : RidexColors.muted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        trailingIcon,
                        size: 18,
                        color: enabled ? Colors.white : RidexColors.muted,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
