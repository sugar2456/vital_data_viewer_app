import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';
import 'package:intl/intl.dart';

/// 週間歩数データを管理するViewModel
class WeeklyStepsViewModel extends ChangeNotifier {
  final StepRepositoryInterface _stepRepository;

  List<WeeklyDataPoint> _weeklyData = [];
  List<WeeklyDataPoint> get weeklyData => _weeklyData;

  int _totalSteps = 0;
  int get totalSteps => _totalSteps;

  double _averageSteps = 0;
  double get averageSteps => _averageSteps;

  WeeklyStepsViewModel(this._stepRepository);

  /// 直近7日間の歩数データを取得
  Future<void> fetchWeeklySteps() async {
    final now = DateTime.now();
    final endDate = now.toIso8601String().split('T').first;
    final startDate = now.subtract(const Duration(days: 6)).toIso8601String().split('T').first;

    final response = await _stepRepository.fetchStepsByDateRange(startDate, endDate);

    // APIレスポンスをWeeklyDataPointに変換
    final dateFormat = DateFormat('M/d');
    final Map<String, int> dataByDate = {};

    for (final item in response.activitiesSteps) {
      dataByDate[item.dateTime] = item.value;
    }

    // 7日分のデータを生成（データがない日も含む）
    _weeklyData = [];
    int total = 0;
    int daysWithData = 0;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T').first;
      final label = dateFormat.format(date);

      if (dataByDate.containsKey(dateStr) && dataByDate[dateStr]! > 0) {
        final value = dataByDate[dateStr]!;
        _weeklyData.add(WeeklyDataPoint(
          label: label,
          value: value.toDouble(),
        ));
        total += value;
        daysWithData++;
      } else {
        _weeklyData.add(WeeklyDataPoint.noData(label));
      }
    }

    _totalSteps = total;
    _averageSteps = daysWithData > 0 ? total / daysWithData : 0;
    notifyListeners();
  }
}
