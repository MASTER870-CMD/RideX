import 'package:flutter/material.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../core/constants/ridex_constants.dart';
import '../../core/routing/app_router.dart';

class _DrawerItem {
  final String route;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _DrawerItem({
    required this.route,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

const _items = [
  _DrawerItem(
    route: AppRoutes.documentVault,
    title: 'Document Vault',
    subtitle: 'Store vehicle documents',
    icon: Icons.folder_outlined,
    iconBg: Color(0xFFFFF3E0),
    iconColor: Color(0xFFF95A2C),
  ),
  _DrawerItem(
    route: AppRoutes.helmetSafety,
    title: 'Helmet Safety Check',
    subtitle: 'Check helmet condition',
    icon: Icons.shield_outlined,
    iconBg: Color(0xFFFFF1F2),
    iconColor: RidexColors.red,
  ),
  _DrawerItem(
    route: AppRoutes.safeRide,
    title: 'Safe Ride & Credits',
    subtitle: 'Ride safely & earn credits',
    icon: Icons.monetization_on_outlined,
    iconBg: Color(0xFFFFFBEB),
    iconColor: Color(0xFFB45309),
  ),
  _DrawerItem(
    route: AppRoutes.riderLocation,
    title: 'Rider & Bike Location',
    subtitle: 'View connected locations',
    icon: Icons.location_on_outlined,
    iconBg: Color(0xFFECFDF5),
    iconColor: RidexColors.emerald,
  ),
  _DrawerItem(
    route: AppRoutes.emissionTest,
    title: 'Emission Test',
    subtitle: 'Track PUC & expiry alerts',
    icon: Icons.article_outlined,
    iconBg: Color(0xFFEFF6FF),
    iconColor: Color(0xFF2563EB),
  ),
];

class RidexDrawer extends StatelessWidget {
  final String? activeRoute;

  const RidexDrawer({super.key, this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: RidexColors.drawerBg,
      width: MediaQuery.of(context).size.width * 0.80,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Image.asset(
                    RidexConstants.logoAsset,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RIDEX Hub',
                          style: RidexTextStyles.titleLarge),
                      Text('Riding safety suite',
                          style: RidexTextStyles.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close, size: 16,
                          color: RidexColors.charcoal),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: RidexColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Text(
                'SAFETY & VEHICLE FEATURES',
                style: RidexTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: RidexColors.muted,
                ),
              ),
            ),
            // Nav items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: _items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, i) {
                  final item = _items[i];
                  final isActive = activeRoute == item.route;
                  return _DrawerTile(
                    item: item,
                    isActive: isActive,
                    onTap: () {
                      Navigator.of(context).pop();
                      if (ModalRoute.of(context)?.settings.name != item.route) {
                        Navigator.of(context).pushNamed(item.route);
                      }
                    },
                  );
                },
              ),
            ),
            // Footer
            Divider(color: RidexColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: RidexColors.emerald, shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('RIDEX OS ${RidexConstants.appVersion}',
                      style: RidexTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: RidexColors.charcoal,
                      )),
                  const Spacer(),
                  Text('Sync: 12ms',
                      style: RidexTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final _DrawerItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RidexConstants.radiusLG),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? RidexColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(RidexConstants.radiusLG),
          border: Border.all(
            color: isActive
                ? RidexColors.red.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
          boxShadow: isActive
              ? [BoxShadow(
                  color: RidexColors.red.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )]
              : null,
        ),
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 3,
                height: 36,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [RidexColors.red, RidexColors.orange],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: RidexTextStyles.titleSmall.copyWith(
                      color: isActive ? RidexColors.red : RidexColors.charcoal,
                    ),
                  ),
                  Text(item.subtitle, style: RidexTextStyles.bodySmall),
                ],
              ),
            ),
            if (isActive)
              const _DrawerActiveBadge(label: 'ACTIVE')
            else
              const Icon(Icons.chevron_right,
                  size: 16, color: RidexColors.muted),
          ],
        ),
      ),
    );
  }
}

// Inline micro-badge used only inside drawer
class _DrawerActiveBadge extends StatelessWidget {
  final String label;
  const _DrawerActiveBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: RidexColors.red.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9, fontWeight: FontWeight.w800,
          color: RidexColors.red, letterSpacing: 0.5,
        ),
      ),
    );
  }
}
