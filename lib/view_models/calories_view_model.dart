import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/calories_dataset.dart';
import 'package:vital_data_viewer_app/models/response/calories_response.dart';
import 'package:vital_data_viewer_app/repositories/impls/calories_repository_impl.dart';

class CaloriesViewModel extends ChangeNotifier {
  final CaloriesRepositoryImpl _caloriesRepository;
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  CaloriesResponse? _caloriesResponse;

  double get getTotalCalories {
    if (_caloriesResponse == null) {
      return 0.0;
    }
    return _caloriesResponse!.activitiesCalories[0].value;
  }

  List<CaloriesDataset> get getCaloriesIntraday =>
      _caloriesResponse!.activitiesCaloriesIntraday.dataset;
  CaloriesViewModel(this._caloriesRepository);


  Future<void> fetchCalories() async {
    final getDate = date.toIso8601String().split('T').first;
    _caloriesResponse =
        await _caloriesRepository.fetchCalories(getDate, '1min');
    notifyListeners();
  }
  Future<void> setSelectedDate(DateTime selectedDate) async {
    final getDate = selectedDate.toIso8601String().split('T').first;
    _date = selectedDate;
    _caloriesResponse =
        await _caloriesRepository.fetchCalories(getDate, '1min');
    notifyListeners();
  }
}
