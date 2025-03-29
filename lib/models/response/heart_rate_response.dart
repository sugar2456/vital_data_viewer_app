import 'package:vital_data_viewer_app/models/response/dataset.dart';

class HeartRateResponse {
  final List<ActivityHeartRate> activitiesHeartRate;
  final IntradayHeartRate activitiesHeartRateIntraday;

  HeartRateResponse({
    required this.activitiesHeartRate,
    required this.activitiesHeartRateIntraday,
  });

  factory HeartRateResponse.fromJson(Map<String, dynamic> json) {
    final baseDate = (json['activities-heart'] as List)
        .map((item) => ActivityHeartRate.fromJson(item))
        .first
        .dateTime;
    return HeartRateResponse(
      activitiesHeartRate: (json['activities-heart'] as List)
          .map((item) => ActivityHeartRate.fromJson(item))
          .toList(),
      activitiesHeartRateIntraday:
          IntradayHeartRate.fromJson(json['activities-heart-intraday'], baseDate),
    );
  }
}

class ActivityHeartRate {
  final String dateTime;
  final HeartRateValue value;

  ActivityHeartRate({
    required this.dateTime,
    required this.value,
  });

  factory ActivityHeartRate.fromJson(Map<String, dynamic> json) {
    return ActivityHeartRate(
      dateTime: json['dateTime'],
      value: HeartRateValue.fromJson(json['value']),
    );
  }
}

class HeartRateValue {
  final List<dynamic> customHeartRateZones;
  final List<dynamic> heartRateZones;
  final int restingHeartRate;

  HeartRateValue({
    required this.customHeartRateZones,
    required this.heartRateZones,
    required this.restingHeartRate,
  });
  factory HeartRateValue.fromJson(Map<String, dynamic> json) {
    return HeartRateValue(
      customHeartRateZones: json['customHeartRateZones'],
      heartRateZones: json['heartRateZones'],
      restingHeartRate: json['restingHeartRate'],
    );
  }
}

class HeartRateActivity {
  final double caloriesOut;
  final int max;
  final int min;
  final int minutes;
  final String name;

  HeartRateActivity({
    required this.caloriesOut,
    required this.max,
    required this.min,
    required this.minutes,
    required this.name,
  });

  factory HeartRateActivity.fromJson(Map<String, dynamic> json) {
    return HeartRateActivity(
      caloriesOut: json['caloriesOut'],
      max: json['max'],
      min: json['min'],
      minutes: json['minutes'],
      name: json['name'],
    );
  }
}

class IntradayHeartRate {
  final List<Dataset> dataset;
  final int datasetInterval;
  final String datasetType;

  IntradayHeartRate({
    required this.dataset,
    required this.datasetInterval,
    required this.datasetType,
  });

  factory IntradayHeartRate.fromJson(Map<String, dynamic> json, String baseDate) {
    return IntradayHeartRate(
      dataset: (json['dataset'] as List)
          .map((item) => Dataset.fromJson(item, baseDate))
          .toList(),
      datasetInterval: json['datasetInterval'],
      datasetType: json['datasetType'],
    );
  }
}
