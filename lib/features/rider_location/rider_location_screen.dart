import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../shared/widgets/ridex_drawer.dart';
import '../../shared/widgets/ridex_status_badge.dart';

class RiderLocationScreen extends StatefulWidget {
  const RiderLocationScreen({super.key});
  @override
  State<RiderLocationScreen> createState() => _RiderLocationScreenState();
}

class _RiderLocationScreenState extends State<RiderLocationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseRed;
  late final AnimationController _pulseOrange;

  @override
  void initState() {
    super.initState();
    _pulseRed = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..repeat();
    _pulseOrange = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..repeat();
    // Stagger the orange pulse
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _pulseOrange.forward(from: 0.3);
    });
  }

  @override
  void dispose() {
    _pulseRed.dispose();
    _pulseOrange.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0),
      drawer: const RidexDrawer(activeRoute: AppRoutes.riderLocation),
      body: SafeArea(
        child: Consumer<LocationService>(
          builder: (context, svc, _) {
            return Column(
              children: [
                _buildAppBar(context, svc),
                Expanded(child: _buildMapPlaceholder(svc)),
                _buildBottomPanel(svc),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, LocationService svc) {
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
              Text('Rider & Bike Location',
                  style: RidexTextStyles.titleLarge),
              Text('Live tracking',
                  style: RidexTextStyles.bodySmall),
            ],
          ),
          const Spacer(),
          RidexStatusBadge(
            label: svc.isTogether ? 'TOGETHER' : 'SEPARATED',
            variant: svc.isTogether ? BadgeVariant.pass : BadgeVariant.fail,
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(LocationService svc) {
    final riderLL = ll.LatLng(svc.riderLocation.lat, svc.riderLocation.lng);
    final bikeLL = ll.LatLng(svc.bikeLocation.lat, svc.bikeLocation.lng);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E4D8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: RidexColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: ll.LatLng(
                  (riderLL.latitude + bikeLL.latitude) / 2,
                  (riderLL.longitude + bikeLL.longitude) / 2,
                ),
                initialZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.ridex',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [riderLL, bikeLL],
                      strokeWidth: 4,
                      color: RidexColors.muted.withValues(alpha: 0.8),
                      pattern: StrokePattern.dashed(segments: const [10.0, 10.0]),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: riderLL,
                      width: 60,
                      height: 70,
                      child: AnimatedBuilder(
                        animation: _pulseRed,
                        builder: (context, child) => _LocationMarker(
                          emoji: '🪖',
                          label: 'Rider',
                          color: RidexColors.red,
                          pulseProgress: _pulseRed.value,
                        ),
                      ),
                    ),
                    Marker(
                      point: bikeLL,
                      width: 60,
                      height: 70,
                      child: AnimatedBuilder(
                        animation: _pulseOrange,
                        builder: (context, child) => _LocationMarker(
                          emoji: '🏍️',
                          label: 'Bike',
                          color: RidexColors.orange,
                          pulseProgress: _pulseOrange.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Map data © OpenStreetMap contributors',
                  style: RidexTextStyles.bodySmall.copyWith(fontSize: 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel(LocationService svc) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: RidexColors.border),
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 20, offset: const Offset(0, -4),
        )],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _LocationCard(
                icon: '🪖',
                title: 'Rider',
                subtitle: 'Helmet Connected',
                connected: svc.riderConnected,
                color: RidexColors.red,
              )),
              const SizedBox(width: 10),
              Expanded(child: _LocationCard(
                icon: '🏍️',
                title: 'Bike',
                subtitle: 'Connected',
                connected: svc.bikeConnected,
                color: RidexColors.orange,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: svc.isTogether
                  ? RidexColors.emeraldBg : const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(svc.statusLabel,
                    style: RidexTextStyles.titleSmall.copyWith(
                      color: svc.isTogether
                          ? RidexColors.emeraldDark : RidexColors.red,
                    )),
                Text('Distance: ~${svc.distanceMeters.toInt()} m',
                    style: RidexTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: just now  •  '
            'Lat: ${svc.riderLocation.lat.toStringAsFixed(4)}',
            style: RidexTextStyles.bodySmall.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool connected;
  final Color color;

  const _LocationCard({
    required this.icon, required this.title,
    required this.subtitle, required this.connected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RidexColors.ivory,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RidexColors.border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: RidexTextStyles.titleSmall.copyWith(
                      color: color,
                    )),
                Text(subtitle, style: RidexTextStyles.bodySmall),
              ],
            ),
          ),
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: connected ? RidexColors.emerald : RidexColors.muted,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final double pulseProgress;

  const _LocationMarker({
    required this.emoji, required this.label,
    required this.color, required this.pulseProgress,
  });

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 + pulseProgress * 0.45;
    final opacity = (1.0 - pulseProgress).clamp(0.0, 1.0);

    return SizedBox(
      width: 48, height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse ring
          Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                ),
              ),
            ),
          ),
          // Marker
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  boxShadow: [BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8, offset: const Offset(0, 3),
                  )],
                ),
                child: Center(
                  child: Text(emoji,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(label,
                    style: const TextStyle(
                      color: Colors.white, fontSize: 9,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
