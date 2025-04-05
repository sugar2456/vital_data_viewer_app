import 'package:vital_data_viewer_app/models/response/calories_dataset.dart';
import 'package:vital_data_viewer_app/util/convert_util.dart';

class CaloriesResponse {
  final List<ActivityCalories> activitiesCalories;
  final IntradayCalories activitiesCaloriesIntraday;

  CaloriesResponse({
    required this.activitiesCalories,
    required this.activitiesCaloriesIntraday,
  });

  factory CaloriesResponse.fromJson(Map<String, dynamic> json) {
    final baseDate = (json['activities-calories'] as List)
        .map((item) => ActivityCalories.fromJson(item))
        .first
        .dateTime;
    return CaloriesResponse(
      activitiesCalories: (json['activities-calories'] as List)
          .map((item) => ActivityCalories.fromJson(item))
          .toList(),
      activitiesCaloriesIntraday:
          IntradayCalories.fromJson(json['activities-calories-intraday'], baseDate),
    );
  }
}

class ActivityCalories {
  final String dateTime;
  final double value;

  ActivityCalories({
    required this.dateTime,
    required this.value,
  });

  factory ActivityCalories.fromJson(Map<String, dynamic> json) {
    final calorories = ConvertUtil.convertStringToDouble(json['value']);
    return ActivityCalories(
      dateTime: json['dateTime'],
      value: ConvertUtil.roundToOneDecimalPlaces(calorories),
    );
  }
}

class IntradayCalories {
  final List<CaloriesDataset> dataset;
  final int datasetInterval;
  final String datasetType;

  IntradayCalories({
    required this.dataset,
    required this.datasetInterval,
    required this.datasetType,
  });

  factory IntradayCalories.fromJson(Map<String, dynamic> json, String baseDate) {
    return IntradayCalories(
      dataset: (json['dataset'] as List)
          .map((item) => CaloriesDataset.fromJson(item, baseDate))
          .toList(),
      datasetInterval: json['datasetInterval'],
      datasetType: json['datasetType'],
    );
  }
}
