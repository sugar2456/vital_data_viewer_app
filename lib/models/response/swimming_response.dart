import 'package:vital_data_viewer_app/models/response/dataset.dart';

class SwimmingResponse {
  final List<ActivitySwimmingStroke> activitiesSwimmingStroke;
  final ActivitySwimmingStrokeIntraday activitiesSwimmingStrokeIntraday;

  SwimmingResponse({
    required this.activitiesSwimmingStroke,
    required this.activitiesSwimmingStrokeIntraday,
  });

  factory SwimmingResponse.fromJson(Map<String, dynamic> json) {
    final baseDate = (json['activities-swimming-strokes'] as List)
        .map((item) => ActivitySwimmingStroke.fromJson(item))
        .first
        .dateTime;
    return SwimmingResponse(
      activitiesSwimmingStroke: (json['activities-swimming-strokes'] as List)
          .map((item) => ActivitySwimmingStroke.fromJson(item))
          .toList(),
      activitiesSwimmingStrokeIntraday:
          ActivitySwimmingStrokeIntraday.fromJson(json['activities-swimming-strokes-intraday'], baseDate),
    );
  }
}

class ActivitySwimmingStroke {
  final String dateTime;
  final int value;

  ActivitySwimmingStroke({
    required this.dateTime,
    required this.value,
  });

  factory ActivitySwimmingStroke.fromJson(Map<String, dynamic> json) {
    return ActivitySwimmingStroke(
      dateTime: json['dateTime'],
      value: int.parse(json['value']),
    );
  }
}

class ActivitySwimmingStrokeIntraday {
  final List<Dataset> dataset;
  final int datasetInterval;
  final String datasetType;

  ActivitySwimmingStrokeIntraday({
    required this.dataset,
    required this.datasetInterval,
    required this.datasetType,
  });

  factory ActivitySwimmingStrokeIntraday.fromJson(Map<String, dynamic> json, String baseDate) {
    return ActivitySwimmingStrokeIntraday(
      dataset: (json['dataset'] as List)
          .map((item) => Dataset.fromJson(item, baseDate))
          .toList(),
      datasetInterval: json['datasetInterval'],
      datasetType: json['datasetType'],
    );
  }
}