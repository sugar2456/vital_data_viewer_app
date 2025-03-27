import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/activity_goal_response.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/models/response/body_goal_response.dart';
import 'package:vital_data_viewer_app/models/response/device_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/activity_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/body_goal_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/device_repository_interdace.dart';
import 'package:vital_data_viewer_app/models/response/activity_summary_response.dart';
class HomeViewModel extends ChangeNotifier {
  final ActivityGoalRepositoryInterface _activityGoalRepository;
  final BodyGoalRepositoryInterface _bodyGoalRepository;
  final DeviceRepositoryInterface _deviceRepository;
  HomeViewModel(this._activityGoalRepository, this._bodyGoalRepository, this._deviceRepository);

  AcitivityGoalResponse? _activityGoalResponse;
  AcitivityGoalResponse? get activityGoalResponse => _activityGoalResponse;

  ActivitySummaryResponse? _activitySummaryResponse;
  ActivitySummaryResponse? get activitySummaryResponse => _activitySummaryResponse;

  BodyGoalResponse? _bodyGoalResponse;
  BodyGoalResponse? get bodyGoalResponse => _bodyGoalResponse;

  DeviceResponse? _deviceResponse;
  DeviceResponse? get deviceResponse => _deviceResponse;

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  Future<void> getActivityGoal() async {
    // _isLoading = true;
    // notifyListeners();

    try {
      _activitySummaryResponse = await _activityGoalRepository.fetchActivitySummary();
      _activityGoalResponse = await _activityGoalRepository.fetchActivityGoal();
      _bodyGoalResponse = await _bodyGoalRepository.fetchBodyGoal();
      _deviceResponse = await _deviceRepository.fetchDevice();
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