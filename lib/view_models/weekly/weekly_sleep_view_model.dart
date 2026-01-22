import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';
import 'package:intl/intl.dart';

/// 週間睡眠データを管理するViewModel
class WeeklySleepViewModel extends ChangeNotifier {
  final SleepRepositoryInterface _sleepRepository;

  List<WeeklyDataPoint> _weeklyData = [];
  List<WeeklyDataPoint> get weeklyData => _weeklyData;

  int _totalMinutes = 0;
  int get totalMinutes => _totalMinutes;

  double _averageMinutes = 0;
  double get averageMinutes => _averageMinutes;

  /// 合計時間を「X時間Y分」形式で取得
  String get totalFormatted => _formatMinutes(_totalMinutes);

  /// 平均時間を「X時間Y分」形式で取得
  String get averageFormatted => _formatMinutes(_averageMinutes.round());

  WeeklySleepViewModel(this._sleepRepository);

  /// 直近7日間の睡眠データを取得
  Future<void> fetchWeeklySleep() async {
    final now = DateTime.now();
    final endDate = now.toIso8601String().split('T').first;
    final startDate = now.subtract(const Duration(days: 6)).toIso8601String().split('T').first;

    final response = await _sleepRepository.fetchSleepByDateRange(startDate, endDate);

    // 日別に睡眠時間を集計（同じ日に複数のSleepレコードがある場合があるため）
    final dateFormat = DateFormat('M/d');
    final Map<String, int> sleepByDate = {};

    for (final sleep in response.sleep) {
      // isMainSleepがtrueのデータのみ使用（主睡眠）
      if (sleep.isMainSleep) {
        final date = sleep.dateOfSleep;
        sleepByDate[date] = (sleepByDate[date] ?? 0) + sleep.minutesAsleep;
      }
    }

    // 7日分のデータを生成（データがない日も含む）
    _weeklyData = [];
    int total = 0;
    int daysWithData = 0;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T').first;
      final label = dateFormat.format(date);

      if (sleepByDate.containsKey(dateStr) && sleepByDate[dateStr]! > 0) {
        final minutes = sleepByDate[dateStr]!;
        // グラフ表示用に時間単位に変換（小数点1桁）
        final hours = minutes / 60.0;
        _weeklyData.add(WeeklyDataPoint(
          label: label,
          value: hours,
        ));
        total += minutes;
        daysWithData++;
      } else {
        _weeklyData.add(WeeklyDataPoint.noData(label));
      }
    }

    _totalMinutes = total;
    _averageMinutes = daysWithData > 0 ? total / daysWithData : 0;
    notifyListeners();
  }

  /// 分を「X時間Y分」形式に変換
  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) {
      return '$hours時間$mins分';
    } else if (hours > 0) {
      return '$hours時間';
    } else {
      return '$mins分';
    }
  }
}
