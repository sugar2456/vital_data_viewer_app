import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/calories_dataset.dart';
import 'package:vital_data_viewer_app/models/response/calories_response.dart';
import 'package:vital_data_viewer_app/repositories/impls/calories_repository_impl.dart';

class CaloriesViewModel extends ChangeNotifier {
  final CaloriesRepositoryImpl _caloriesRepository;
  final DateTime date = DateTime.now();
  CaloriesResponse? _caloriesResponse;
  List<CaloriesDataset> get getCaloriesIntraday =>
      _caloriesResponse!.activitiesCaloriesIntraday.dataset;

  CaloriesViewModel(this._caloriesRepository);

  Future<void> fetchCalories() async {
    final getDate = date.toIso8601String().split('T').first;
    _caloriesResponse =
        await _caloriesRepository.fetchCalories(getDate, '1min');
  }
}
