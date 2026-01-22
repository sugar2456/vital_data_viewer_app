import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/swimming_repository_interface.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';
import 'package:intl/intl.dart';

/// 週間水泳データを管理するViewModel
class WeeklySwimmingViewModel extends ChangeNotifier {
  final SwimmingRepositoryInterface _swimmingRepository;

  List<WeeklyDataPoint> _weeklyData = [];
  List<WeeklyDataPoint> get weeklyData => _weeklyData;

  int _totalStrokes = 0;
  int get totalStrokes => _totalStrokes;

  double _averageStrokes = 0;
  double get averageStrokes => _averageStrokes;

  WeeklySwimmingViewModel(this._swimmingRepository);

  /// 直近7日間の水泳データを取得
  Future<void> fetchWeeklySwimming() async {
    final now = DateTime.now();
    final endDate = now.toIso8601String().split('T').first;
    final startDate = now.subtract(const Duration(days: 6)).toIso8601String().split('T').first;

    final response = await _swimmingRepository.fetchSwimmingByDateRange(startDate, endDate);

    // APIレスポンスをWeeklyDataPointに変換
    final dateFormat = DateFormat('M/d');
    final Map<String, int> dataByDate = {};

    for (final item in response.activitiesSwimmingStrokes) {
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

    _totalStrokes = total;
    _averageStrokes = daysWithData > 0 ? total / daysWithData : 0;
    notifyListeners();
  }
}
