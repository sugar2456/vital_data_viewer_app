import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';
import 'package:intl/intl.dart';

/// 週間心拍数データを管理するViewModel
class WeeklyHeartRateViewModel extends ChangeNotifier {
  final HeartRateRepositoryInterdace _heartRateRepository;

  List<WeeklyDataPoint> _weeklyData = [];
  List<WeeklyDataPoint> get weeklyData => _weeklyData;

  int _minRestingHeartRate = 0;
  int get minRestingHeartRate => _minRestingHeartRate;

  int _maxRestingHeartRate = 0;
  int get maxRestingHeartRate => _maxRestingHeartRate;

  double _averageRestingHeartRate = 0;
  double get averageRestingHeartRate => _averageRestingHeartRate;

  WeeklyHeartRateViewModel(this._heartRateRepository);

  /// 直近7日間の心拍数データを取得
  Future<void> fetchWeeklyHeartRate() async {
    final now = DateTime.now();
    final endDate = now.toIso8601String().split('T').first;
    final startDate = now.subtract(const Duration(days: 6)).toIso8601String().split('T').first;

    final response = await _heartRateRepository.fetchHeartRateByDateRange(startDate, endDate);

    // APIレスポンスをWeeklyDataPointに変換
    final dateFormat = DateFormat('M/d');
    final Map<String, int> dataByDate = {};

    for (final item in response.activitiesHeart) {
      if (item.value.restingHeartRate > 0) {
        dataByDate[item.dateTime] = item.value.restingHeartRate;
      }
    }

    // 7日分のデータを生成（データがない日も含む）
    _weeklyData = [];
    int total = 0;
    int daysWithData = 0;
    int minVal = 0;
    int maxVal = 0;

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

        if (minVal == 0 || value < minVal) {
          minVal = value;
        }
        if (value > maxVal) {
          maxVal = value;
        }
      } else {
        _weeklyData.add(WeeklyDataPoint.noData(label));
      }
    }

    _minRestingHeartRate = minVal;
    _maxRestingHeartRate = maxVal;
    _averageRestingHeartRate = daysWithData > 0 ? total / daysWithData : 0;
    notifyListeners();
  }
}
