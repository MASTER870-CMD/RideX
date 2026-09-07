import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/services/emission_service.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../shared/widgets/ridex_drawer.dart';
import '../../shared/widgets/ridex_primary_button.dart';
import '../../shared/widgets/ridex_status_badge.dart';

class EmissionTestScreen extends StatefulWidget {
  const EmissionTestScreen({super.key});
  @override
  State<EmissionTestScreen> createState() => _EmissionTestScreenState();
}

class _EmissionTestScreenState extends State<EmissionTestScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1200))
      ..forward();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  Future<void> _uploadCertificate(
      BuildContext context, EmissionService svc) async {
    setState(() => _isUploading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        // Mock: set due date 6 months from today
        final newDue = DateTime.now().add(const Duration(days: 183));
        await svc.setDueDate(newDue);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emission certificate uploaded & date updated'),
              backgroundColor: RidexColors.emerald,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _pickDueDate(
      BuildContext context, EmissionService svc) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: svc.dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: RidexColors.red,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) svc.setDueDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RidexColors.background,
      drawer: const RidexDrawer(activeRoute: AppRoutes.emissionTest),
      body: SafeArea(
        child: Consumer<EmissionService>(
          builder: (context, svc, _) {
            return Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      children: [
                        _buildStatusCard(svc),
                        const SizedBox(height: 14),
                        _buildProgressSection(svc),
                        const SizedBox(height: 14),
                        _buildDueDatePicker(context, svc),
                        const SizedBox(height: 14),
                        _buildReminders(svc),
                        const SizedBox(height: 16),
                        RidexPrimaryButton(
                          label: 'Upload Emission Certificate',
                          trailingIcon: Icons.upload_file,
                          isLoading: _isUploading,
                          onPressed: _isUploading
                              ? null
                              : () => _uploadCertificate(context, svc),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Accepted: PDF, JPG, PNG',
                          style: RidexTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
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
              Text('Emission Test', style: RidexTextStyles.titleLarge),
              Text('Track PUC & expiry alerts',
                  style: RidexTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(EmissionService svc) {
    final (bg, fg, icon) = switch (svc.statusLevel) {
      EmissionStatusLevel.valid   =>
        (RidexColors.emeraldBg, RidexColors.emeraldDark, Icons.check_circle_outline),
      EmissionStatusLevel.dueSoon =>
        (RidexColors.warningBg, RidexColors.warning, Icons.warning_amber_outlined),
      EmissionStatusLevel.dueToday =>
        (RidexColors.warningBg, RidexColors.warning, Icons.schedule_outlined),
      EmissionStatusLevel.overdue =>
        (const Color(0xFFFFF1F2), RidexColors.red, Icons.cancel_outlined),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(
          color: fg.withValues(alpha: 0.08),
          blurRadius: 16, offset: const Offset(0, 4),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EMISSION TEST STATUS',
                  style: RidexTextStyles.labelBold.copyWith(
                    color: fg.withValues(alpha: 0.7), fontSize: 10,
                  )),
              RidexStatusBadge(
                label: svc.statusLabel,
                variant: switch (svc.statusLevel) {
                  EmissionStatusLevel.valid => BadgeVariant.pass,
                  EmissionStatusLevel.dueSoon => BadgeVariant.warn,
                  EmissionStatusLevel.dueToday => BadgeVariant.warn,
                  EmissionStatusLevel.overdue => BadgeVariant.fail,
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: fg, size: 28),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(svc.daysLabel,
                      style: RidexTextStyles.displayMedium.copyWith(
                        color: fg,
                        fontSize: 20,
                      )),
                  Text(
                    'Next due: ${DateFormat('d MMM yyyy').format(svc.dueDate)}',
                    style: RidexTextStyles.bodyMedium.copyWith(color: fg),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(EmissionService svc) {
    final total = 180; // 6-month validity
    final remaining = svc.daysRemaining.clamp(0, total);
    final fraction = (remaining / total).clamp(0.0, 1.0);

    final barColor = switch (svc.statusLevel) {
      EmissionStatusLevel.valid   => RidexColors.emerald,
      EmissionStatusLevel.dueSoon => RidexColors.warning,
      EmissionStatusLevel.dueToday => RidexColors.warning,
      EmissionStatusLevel.overdue => RidexColors.red,
    };

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Validity Period', style: RidexTextStyles.titleSmall),
              Text('${remaining}d / ${total}d',
                  style: RidexTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _progressCtrl,
            builder: (context, _) => ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: fraction * _progressCtrl.value,
                minHeight: 10,
                backgroundColor: RidexColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 days', style: RidexTextStyles.bodySmall),
              Text('180 days', style: RidexTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDueDatePicker(BuildContext context, EmissionService svc) {
    return InkWell(
      onTap: () => _pickDueDate(context, svc),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RidexColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RidexColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_today_outlined,
                  color: RidexColors.red, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Due Date',
                      style: RidexTextStyles.bodySmall),
                  Text(
                    DateFormat('dd MMMM yyyy').format(svc.dueDate),
                    style: RidexTextStyles.titleMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined,
                size: 16, color: RidexColors.muted),
          ],
        ),
      ),
    );
  }

  Widget _buildReminders(EmissionService svc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RidexColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined,
              color: RidexColors.charcoal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expiry Reminders',
                    style: RidexTextStyles.titleSmall),
                Text('30 days â€¢ 7 days â€¢ 1 day before due',
                    style: RidexTextStyles.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: svc.remindersEnabled,
            onChanged: (_) => svc.toggleReminders(),
            activeThumbColor: RidexColors.red,
            activeTrackColor: RidexColors.red.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

