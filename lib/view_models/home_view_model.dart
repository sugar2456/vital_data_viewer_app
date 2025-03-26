import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/activity_goal_response.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';

class HomeViewModel extends ChangeNotifier {
  final ActivityGoalRepositoryInterface _activityGoalRepository;
  HomeViewModel(this._activityGoalRepository);

  AcitivityGoalResponse? _activityGoalResponse;
  AcitivityGoalResponse? get activityGoalResponse => _activityGoalResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getActivityGoal() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _activityGoalRepository.fetchActivityGoal();
      _activityGoalResponse = response;
    } catch (e) {
      print('Error fetching activity goal: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    TokenManager().deleteToken();
    notifyListeners();
  }
}