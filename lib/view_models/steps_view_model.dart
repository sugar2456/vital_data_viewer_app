import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';

class StepsViewModel extends ChangeNotifier {
  final StepRepositoryInterface _stepRepository;
  final DateTime date = DateTime.now();
  StepResponse? _stepResponse;
  List<IntradayStep> get getStepsIntraday => _stepResponse!.activitiesStepsIntraday.dataset;
  int get getTotalSteps => _stepResponse!.activitiesSteps[0].value;

  StepsViewModel(this._stepRepository);

  Future<void> fetchStep() async {
    try {
      final getDate = date.toIso8601String().split('T').first;
      _stepResponse = await _stepRepository.fetchStep(getDate, '1min');
    } catch (e) {
      log('歩数情報の取得に失敗しました。$e');
    }
  }

  Future<void> fetchStepPeriod() async {
    try {
      final startDate = date.subtract(const Duration(days: 1)).toIso8601String().split('T').first;
      final endDate = date.toIso8601String().split('T').first;
      _stepResponse = await _stepRepository.fetchStepPeriod(startDate, endDate, '1min');
    } catch (e) {
      log('歩数情報の取得に失敗しました。$e');
    }
  }
}