import 'package:vital_data_viewer_app/const/response_type.dart';

class BodyGoalResponse {
  final GoalTyle goalType;
  final DateTime? startDate;
  final double? startWeight;
  final double? weight;
  final double? weightThreshold;

  BodyGoalResponse({
    required this.goalType,
    this.startDate,
    this.startWeight,
    this.weight,
    this.weightThreshold,
  });

  factory BodyGoalResponse.fromJson(Map<String, dynamic> json) {
    return BodyGoalResponse(
      goalType: GoalTyleExtension.fromString(json['goalType']), // StringをGoalTyleに変換
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      startWeight: json['startWeight'] != null
          ? (json['startWeight'] as num).toDouble()
          : null,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      weightThreshold: json['weightThreshold'] != null
          ? (json['weightThreshold'] as num).toDouble()
          : null,
    );
  }
}