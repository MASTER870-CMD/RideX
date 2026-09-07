enum MissionStatus { inProgress, paused, complete, claimed }

class Mission {
  final String id;
  final String title;
  final double requiredDistanceKm;
  final int rewardCredits;
  final bool helmetRequired;
  final double progressKm;
  final MissionStatus status;

  const Mission({
    required this.id,
    required this.title,
    required this.requiredDistanceKm,
    required this.rewardCredits,
    required this.helmetRequired,
    this.progressKm = 0,
    this.status = MissionStatus.inProgress,
  });

  double get progressFraction =>
      (progressKm / requiredDistanceKm).clamp(0.0, 1.0);

  double get remainingKm =>
      (requiredDistanceKm - progressKm).clamp(0.0, requiredDistanceKm);

  bool get isComplete => progressKm >= requiredDistanceKm;

  Mission copyWith({
    double? progressKm,
    MissionStatus? status,
  }) =>
      Mission(
        id: id,
        title: title,
        requiredDistanceKm: requiredDistanceKm,
        rewardCredits: rewardCredits,
        helmetRequired: helmetRequired,
        progressKm: progressKm ?? this.progressKm,
        status: status ?? this.status,
      );
}
