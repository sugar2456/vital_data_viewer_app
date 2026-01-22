import 'package:vital_data_viewer_app/util/convert_util.dart';

/// 期間指定カロリーAPIのレスポンスモデル
/// GET /1/user/-/activities/calories/date/{start}/{end}.json
class CaloriesRangeResponse {
  final List<ActivityCaloriesTimeSeries> activitiesCalories;

  CaloriesRangeResponse({
    required this.activitiesCalories,
  });

  factory CaloriesRangeResponse.fromJson(Map<String, dynamic> json) {
    return CaloriesRangeResponse(
      activitiesCalories: (json['activities-calories'] as List)
          .map((item) => ActivityCaloriesTimeSeries.fromJson(item))
          .toList(),
    );
  }
}

class ActivityCaloriesTimeSeries {
  final String dateTime;
  final double value;

  ActivityCaloriesTimeSeries({
    required this.dateTime,
    required this.value,
  });

  factory ActivityCaloriesTimeSeries.fromJson(Map<String, dynamic> json) {
    final calories = ConvertUtil.convertStringToDouble(json['value']);
    return ActivityCaloriesTimeSeries(
      dateTime: json['dateTime'],
      value: ConvertUtil.roundToOneDecimalPlaces(calories),
    );
  }
}
