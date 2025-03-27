import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/body_goal_repository_interface.dart';
import 'package:vital_data_viewer_app/models/response/activity_summary_response.dart';

class HomeViewModel extends ChangeNotifier {
  final ActivityGoalRepositoryInterface _activityGoalRepository;
  final BodyGoalRepositoryInterface _bodyGoalRepository;
  HomeViewModel(this._activityGoalRepository, this._bodyGoalRepository);

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

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  Future<void> getActivityGoal() async {
    // _isLoading = true;
    // notifyListeners();

    try {
      _activitySummaryResponse =
          await _activityGoalRepository.fetchActivitySummary();
      _bodyGoalResponse = await _bodyGoalRepository.fetchBodyGoal();
    } catch (e) {
      log('Error fetching activity goal: $e');
    } finally {
      // _isLoading = false;
      // notifyListeners();
    }
  }

  Future<void> logout() async {
    TokenManager().deleteToken();
    notifyListeners();
  }
}
