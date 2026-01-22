/// 期間指定歩数APIのレスポンスモデル
/// GET /1/user/-/activities/steps/date/{start}/{end}.json
class StepsRangeResponse {
  final List<ActivityStepTimeSeries> activitiesSteps;

  StepsRangeResponse({
    required this.activitiesSteps,
  });

  factory StepsRangeResponse.fromJson(Map<String, dynamic> json) {
    return StepsRangeResponse(
      activitiesSteps: (json['activities-steps'] as List)
          .map((item) => ActivityStepTimeSeries.fromJson(item))
          .toList(),
    );
  }
}

class ActivityStepTimeSeries {
  final String dateTime;
  final int value;

  ActivityStepTimeSeries({
    required this.dateTime,
    required this.value,
  });

  factory ActivityStepTimeSeries.fromJson(Map<String, dynamic> json) {
    return ActivityStepTimeSeries(
      dateTime: json['dateTime'],
      value: int.parse(json['value']),
    );
  }
}
