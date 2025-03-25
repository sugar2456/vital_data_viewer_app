class AcitivityGoalResponse {
  final int activeMinutes;
  final int activeZoneMinutes;
  final int caloriesOut;
  final double distance;
  final int steps;

  AcitivityGoalResponse({
    required this.activeMinutes,
    required this.activeZoneMinutes,
    required this.caloriesOut,
    required this.distance,
    required this.steps,
  });

  factory AcitivityGoalResponse.fromJson(Map<String, dynamic> json) {
    return AcitivityGoalResponse(
      activeMinutes: json['activeMinutes'],
      activeZoneMinutes: json['activeZoneMinutes'],
      caloriesOut: json['caloriesOut'],
      distance: json['distance'],
      steps: json['steps'],
    );
  }
}