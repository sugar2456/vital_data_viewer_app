import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/body_goal_repository_interface.dart';
import 'package:vital_data_viewer_app/models/response/activity_summary_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';

class HomeViewModel extends ChangeNotifier {
  final ActivityGoalRepositoryInterface _activityGoalRepository;
  final BodyGoalRepositoryInterface _bodyGoalRepository;
  final SleepRepositoryInterface _sleepRepository;

  HomeViewModel(
    this._activityGoalRepository,
    this._bodyGoalRepository,
    this._sleepRepository,
  );

  ActivitySummaryResponse? _activitySummaryResponse;
  ActivitySummaryResponse? get activitySummaryResponse =>
      _activitySummaryResponse;

  double get totalDistance {
    if (_activitySummaryResponse == null) {
      return 0.0;
    }

    return _activitySummaryResponse!.summary.distances
        .firstWhere(
          (distance) => distance.activity == 'total', // 条件: activityが'total'
          orElse: () =>
              Distance(activity: 'total', distance: 0.0), // 見つからない場合のデフォルト値
        )
        .distance;
  }

  BodyGoalResponse? _bodyGoalResponse;
  BodyGoalResponse? get bodyGoalResponse => _bodyGoalResponse;

  SleepGoalResponse? _sleepGoalResponse;
  SleepLogResponse? _sleepLogResponse;

  int get sleepGoal {
    if (_sleepGoalResponse == null) {
      return 0;
    }

    return _sleepGoalResponse!.goal.minDuration;
  }

  int get sleepActual {
    if (_sleepLogResponse == null) {
      return 0;
    }

    return _sleepLogResponse!.summary.totalMinutesAsleep;
  }

  Future<void> getActivityGoal() async {
    try {
      _activitySummaryResponse =
          await _activityGoalRepository.fetchActivitySummary();

      try {
        _bodyGoalResponse = await _bodyGoalRepository.fetchBodyGoal();
      } catch (e) {
        // 体重目標が設定されていない場合はnullのまま継続
        _bodyGoalResponse = null;
      }

      try {
        _sleepGoalResponse = await _sleepRepository.fetchSleepGoal();
      } catch (e) {
        // 睡眠目標が設定されていない場合はnullのまま継続
        _sleepGoalResponse = null;
      }

      try {
        _sleepLogResponse = await _sleepRepository.fetchSleepLog();
      } catch (e) {
        // 睡眠ログが取得できない場合はnullのまま継続
        _sleepLogResponse = null;
      }
      notifyListeners();
    } catch (e) {
      rethrow; // 他のAPIエラーは上位に伝播
    }
  }

  Future<void> logout() async {
    TokenManager().deleteToken();
    notifyListeners();
  }
}
