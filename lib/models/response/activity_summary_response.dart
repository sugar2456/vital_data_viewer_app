class ActivitySummaryResponse {
  final List<dynamic> activities; // activitiesは空配列
  final Goals goals;
  final Summary summary;

  ActivitySummaryResponse({
    required this.activities,
    required this.goals,
    required this.summary,
  });

  factory ActivitySummaryResponse.fromJson(Map<String, dynamic> json) {
    return ActivitySummaryResponse(
      activities: json['activities'] ?? [],
      goals: Goals.fromJson(json['goals']),
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class Goals {
  final int activeMinutes;
  final int caloriesOut;
  final double distance;
  final int floors;
  final int steps;

  Goals({
    required this.activeMinutes,
    required this.caloriesOut,
    required this.distance,
    required this.floors,
    required this.steps,
  });

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      activeMinutes: json['activeMinutes'],
      caloriesOut: json['caloriesOut'],
      distance: (json['distance'] as num).toDouble(),
      floors: json['floors'],
      steps: json['steps'],
    );
  }
}

class Summary {
  final int activeScore;
  final int activityCalories;
  final int calorieEstimationMu;
  final int caloriesBMR;
  final int caloriesOut;
  final int caloriesOutUnestimated;
  final List<HeartRateZone> customHeartRateZones;
  final List<Distance> distances;
  final double elevation;
  final int fairlyActiveMinutes;
  final int floors;
  final List<HeartRateZone> heartRateZones;
  final int lightlyActiveMinutes;
  final int marginalCalories;
  final int restingHeartRate;
  final int sedentaryMinutes;
  final int steps;
  final bool useEstimation;
  final int veryActiveMinutes;

  Summary({
    required this.activeScore,
    required this.activityCalories,
    required this.calorieEstimationMu,
    required this.caloriesBMR,
    required this.caloriesOut,
    required this.caloriesOutUnestimated,
    required this.customHeartRateZones,
    required this.distances,
    required this.elevation,
    required this.fairlyActiveMinutes,
    required this.floors,
    required this.heartRateZones,
    required this.lightlyActiveMinutes,
    required this.marginalCalories,
    required this.restingHeartRate,
    required this.sedentaryMinutes,
    required this.steps,
    required this.useEstimation,
    required this.veryActiveMinutes,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      activeScore: json['activeScore'],
      activityCalories: json['activityCalories'],
      calorieEstimationMu: json['calorieEstimationMu'] ?? 0,
      caloriesBMR: json['caloriesBMR'],
      caloriesOut: json['caloriesOut'],
      caloriesOutUnestimated: json['caloriesOutUnestimated'] ?? 0,
      customHeartRateZones: (json['customHeartRateZones'] as List?)
          ?.map((e) => HeartRateZone.fromJson(e))
          .toList() ?? [],
      distances: (json['distances'] as List?)
          ?.map((e) => Distance.fromJson(e))
          .toList() ?? [],
      elevation: (json['elevation'] as num).toDouble(),
      fairlyActiveMinutes: json['fairlyActiveMinutes'],
      floors: json['floors'],
      heartRateZones: (json['heartRateZones'] as List?)
          ?.map((e) => HeartRateZone.fromJson(e))
          .toList() ?? [],
      lightlyActiveMinutes: json['lightlyActiveMinutes'],
      marginalCalories: json['marginalCalories'],
      restingHeartRate: json['restingHeartRate'],
      sedentaryMinutes: json['sedentaryMinutes'],
      steps: json['steps'],
      useEstimation: json['useEstimation'] ?? false,
      veryActiveMinutes: json['veryActiveMinutes'],
    );
  }
}

class HeartRateZone {
  final double caloriesOut;
  final int max;
  final int min;
  final int minutes;
  final String name;

  HeartRateZone({
    required this.caloriesOut,
    required this.max,
    required this.min,
    required this.minutes,
    required this.name,
  });

  factory HeartRateZone.fromJson(Map<String, dynamic> json) {
    return HeartRateZone(
      caloriesOut: (json['caloriesOut'] as num).toDouble(),
      max: json['max'],
      min: json['min'],
      minutes: json['minutes'],
      name: json['name'],
    );
  }
}

class Distance {
  final String activity;
  final double distance;

  Distance({
    required this.activity,
    required this.distance,
  });

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      activity: json['activity'],
      distance: (json['distance'] as num).toDouble(),
    );
  }
}