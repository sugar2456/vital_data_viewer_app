import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/dataset.dart';
import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:intl/intl.dart';

class StepsViewModel extends ChangeNotifier {
  final StepRepositoryInterface _stepRepository;
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  String get dateLabel => DateFormat('yyyy/MM/dd').format(_date.toLocal());
  StepResponse? _stepResponse;
  List<Dataset> get getStepsIntraday =>
      _stepResponse!.activitiesStepsIntraday.dataset;
  int get getTotalSteps => _stepResponse!.activitiesSteps[0].value;

  StepsViewModel(this._stepRepository);

  Future<void> fetchStep() async {
    final getDate = _date.toIso8601String().split('T').first;
    _stepResponse = await _stepRepository.fetchStep(getDate, '1min');
    notifyListeners();
  }

  Future<void> setSelectedDate(DateTime selectedDate) async {
    final getDate = selectedDate.toIso8601String().split('T').first;
    _date = selectedDate;
    _stepResponse = await _stepRepository.fetchStep(getDate, '1min');
    notifyListeners();
  }

  Future<void> fetchStepPeriod() async {
    final startDate = _date
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    final endDate = _date.toIso8601String().split('T').first;
    _stepResponse =
        await _stepRepository.fetchStepPeriod(startDate, endDate, '1min');
  }
}
