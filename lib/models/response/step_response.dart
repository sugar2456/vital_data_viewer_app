class StepResponse {
  final List<ActivityStep> activitiesSteps;
  final IntradaySteps activitiesStepsIntraday;

  StepResponse({
    required this.activitiesSteps,
    required this.activitiesStepsIntraday,
  });

  factory StepResponse.fromJson(Map<String, dynamic> json) {
    final baseDate = (json['activities-steps'] as List)
        .map((item) => ActivityStep.fromJson(item))
        .first
        .dateTime;
    return StepResponse(
      activitiesSteps: (json['activities-steps'] as List)
          .map((item) => ActivityStep.fromJson(item))
          .toList(),
      activitiesStepsIntraday:
          IntradaySteps.fromJson(json['activities-steps-intraday'], baseDate),
    );
  }
}

class ActivityStep {
  final String dateTime;
  final int value;

  ActivityStep({
    required this.dateTime,
    required this.value,
  });

  factory ActivityStep.fromJson(Map<String, dynamic> json) {
    return ActivityStep(
      dateTime: json['dateTime'],
      value: int.parse(json['value']),
    );
  }
}

class IntradaySteps {
  final List<IntradayStep> dataset;
  final int datasetInterval;
  final String datasetType;

  IntradaySteps({
    required this.dataset,
    required this.datasetInterval,
    required this.datasetType,
  });

  factory IntradaySteps.fromJson(Map<String, dynamic> json, String baseDate) {
    return IntradaySteps(
      dataset: (json['dataset'] as List)
          .map((item) => IntradayStep.fromJson(item, baseDate))
          .toList(),
      datasetInterval: json['datasetInterval'],
      datasetType: json['datasetType'],
    );
  }
}

class IntradayStep {
  final String time;
  final int value;
  final DateTime dateTime;

  IntradayStep({
    required this.time,
    required this.value,
    required this.dateTime,
  });

  factory IntradayStep.fromJson(Map<String, dynamic> json, String baseDate) {
     // yyyy-MM-dd hh:mm:ss
    final fullDateTimeString = '$baseDate ${json['time']}';
    return IntradayStep(
      time: json['time'],
      value: json['value'],
      dateTime: DateTime.parse(fullDateTimeString),
    );
  }
}