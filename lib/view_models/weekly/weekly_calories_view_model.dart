import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/calories_repository_interdace.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';
import 'package:intl/intl.dart';

/// 週間カロリーデータを管理するViewModel
class WeeklyCaloriesViewModel extends ChangeNotifier {
  final CaloriesRepositoryInterdace _caloriesRepository;

  List<WeeklyDataPoint> _weeklyData = [];
  List<WeeklyDataPoint> get weeklyData => _weeklyData;

  double _totalCalories = 0;
  double get totalCalories => _totalCalories;

  double _averageCalories = 0;
  double get averageCalories => _averageCalories;

  WeeklyCaloriesViewModel(this._caloriesRepository);

  /// 直近7日間のカロリーデータを取得
  Future<void> fetchWeeklyCalories() async {
    final now = DateTime.now();
    final endDate = now.toIso8601String().split('T').first;
    final startDate = now.subtract(const Duration(days: 6)).toIso8601String().split('T').first;

    final response = await _caloriesRepository.fetchCaloriesByDateRange(startDate, endDate);

    // APIレスポンスをWeeklyDataPointに変換
    final dateFormat = DateFormat('M/d');
    final Map<String, double> dataByDate = {};

    for (final item in response.activitiesCalories) {
      dataByDate[item.dateTime] = item.value;
    }

    // 7日分のデータを生成（データがない日も含む）
    _weeklyData = [];
    double total = 0;
    int daysWithData = 0;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T').first;
      final label = dateFormat.format(date);

      if (dataByDate.containsKey(dateStr) && dataByDate[dateStr]! > 0) {
        final value = dataByDate[dateStr]!;
        _weeklyData.add(WeeklyDataPoint(
          label: label,
          value: value,
        ));
        total += value;
        daysWithData++;
      } else {
        _weeklyData.add(WeeklyDataPoint.noData(label));
      }
    }

    _totalCalories = total;
    _averageCalories = daysWithData > 0 ? total / daysWithData : 0;
    notifyListeners();
  }
}
