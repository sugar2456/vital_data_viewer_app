import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/models/response/activity_goal_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';

class HomeViewModel extends ChangeNotifier {
  final ActivityGoalRepositoryInterface _activityGoalRepository;
  HomeViewModel(this._activityGoalRepository);

  AcitivityGoalResponse? _activityGoalResponse;
  AcitivityGoalResponse? get activityGoalResponse => _activityGoalResponse;

  Future<AcitivityGoalResponse> getActivityGoal() async {
    return await _activityGoalRepository.fetchActivityGoal();
  }

  Future<void> logout() async {
    TokenManager().deleteToken();
    notifyListeners();
  }
}