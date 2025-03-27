import 'package:vital_data_viewer_app/const/response_type.dart';

class SleepGoalResponse {
  final Consistency sleepConsistency;
  final Goal goal;
  SleepGoalResponse({
    required this.sleepConsistency,
    required this.goal,
  });

  factory SleepGoalResponse.fromJson(Map<String, dynamic> json) {
    return SleepGoalResponse(
      sleepConsistency: Consistency.fromJson(json['consistency']),
      goal: Goal.fromJson(json['goal']),
    );
  }
}

class Consistency {
  final SleepConsistency flowId;

  Consistency({
    required this.flowId,
  });

  factory Consistency.fromJson(Map<String, dynamic> json) {
    return Consistency(
      flowId: SleepConsistency.values[json['flowId']],
    );
  }
}

class Goal {
  final int minDuration;
  final DateTime updatedOn;

  Goal({
    required this.minDuration,
    required this.updatedOn,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      minDuration: json['minDuration'],
      updatedOn: DateTime.parse(json['updatedOn']),
    );
  }
}