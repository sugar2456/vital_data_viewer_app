/// 期間指定水泳ストロークAPIのレスポンスモデル
/// GET /1/user/-/activities/swimming-strokes/date/{start}/{end}.json
class SwimmingRangeResponse {
  final List<ActivitySwimmingStrokesTimeSeries> activitiesSwimmingStrokes;

  SwimmingRangeResponse({
    required this.activitiesSwimmingStrokes,
  });

  factory SwimmingRangeResponse.fromJson(Map<String, dynamic> json) {
    return SwimmingRangeResponse(
      activitiesSwimmingStrokes: (json['activities-swimming-strokes'] as List)
          .map((item) => ActivitySwimmingStrokesTimeSeries.fromJson(item))
          .toList(),
    );
  }
}

class ActivitySwimmingStrokesTimeSeries {
  final String dateTime;
  final int value;

  ActivitySwimmingStrokesTimeSeries({
    required this.dateTime,
    required this.value,
  });

  factory ActivitySwimmingStrokesTimeSeries.fromJson(Map<String, dynamic> json) {
    return ActivitySwimmingStrokesTimeSeries(
      dateTime: json['dateTime'],
      value: int.parse(json['value']),
    );
  }
}
