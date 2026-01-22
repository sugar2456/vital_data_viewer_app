# Repository Contracts: 週間データ取得

**Date**: 2026-01-22
**Feature**: 002-weekly-data

## StepRepositoryInterface

```dart
abstract class StepRepositoryInterface {
  // 既存
  Future<StepResponse> fetchStep(String date, String min);
  Future<StepResponse> fetchStepPeriod(String startDate, String endDate, String min);

  // 新規：期間指定で日別サマリーを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns 日別の歩数サマリーリスト
  Future<List<DailyStepSummary>> fetchStepsByDateRange(String startDate, String endDate);
}
```

## SleepRepositoryInterface

```dart
abstract class SleepRepositoryInterface {
  // 既存
  Future<SleepGoalResponse> fetchSleepGoal();
  Future<SleepLogResponse> fetchSleepLog();
  Future<SleepLogResponse> fetchSleepLogByDate(String date);

  // 新規：期間指定で日別睡眠データを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns 日別の睡眠データリスト（ステージ内訳含む）
  Future<List<DailySleepSummary>> fetchSleepByDateRange(String startDate, String endDate);
}
```

## HeartRateRepositoryInterface

```dart
abstract class HeartRateRepositoryInterface {
  // 既存
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel);

  // 新規：期間指定で日別心拍数サマリーを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns 日別の心拍数サマリーリスト（平均、最高、最低）
  Future<List<DailyHeartRateSummary>> fetchHeartRateByDateRange(String startDate, String endDate);
}
```

## CaloriesRepositoryInterface

```dart
abstract class CaloriesRepositoryInterface {
  // 既存
  Future<CaloriesResponse> fetchCalories(String date, String detailLevel);

  // 新規：期間指定で日別カロリーサマリーを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns 日別の消費カロリーリスト
  Future<List<DailyCaloriesSummary>> fetchCaloriesByDateRange(String startDate, String endDate);
}
```

## SwimmingRepositoryInterface

```dart
abstract class SwimmingRepositoryInterface {
  // 既存
  Future<SwimmingResponse> fetchSwimming(String date, String detailLevel);

  // 新規：期間指定で日別水泳データを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns 日別の水泳ストロークリスト
  Future<List<DailySwimmingSummary>> fetchSwimmingByDateRange(String startDate, String endDate);
}
```

## 新規モデル（日別サマリー）

```dart
/// 日別歩数サマリー
class DailyStepSummary {
  final DateTime date;
  final int steps;
  final bool hasData;
}

/// 日別睡眠サマリー
class DailySleepSummary {
  final DateTime date;
  final int totalMinutes;
  final int deepMinutes;
  final int lightMinutes;
  final int remMinutes;
  final int wakeMinutes;
  final bool hasData;
}

/// 日別心拍数サマリー
class DailyHeartRateSummary {
  final DateTime date;
  final int avgBpm;
  final int maxBpm;
  final int minBpm;
  final bool hasData;
}

/// 日別カロリーサマリー
class DailyCaloriesSummary {
  final DateTime date;
  final double calories;
  final bool hasData;
}

/// 日別水泳サマリー
class DailySwimmingSummary {
  final DateTime date;
  final int strokes;
  final bool hasData;
}
```

## ViewModel Contract

各週間ViewModelのメソッド・プロパティ。

```dart
class WeeklyStepsViewModel extends ChangeNotifier {
  final StepRepositoryInterface _repository;

  List<DailyStepSummary> _weeklyData = [];
  List<DailyStepSummary> get weeklyData => _weeklyData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// 直近7日間のデータを取得
  Future<void> fetchWeeklyData() async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 6));
    _weeklyData = await _repository.fetchStepsByDateRange(
      _formatDate(startDate),
      _formatDate(endDate),
    );
    notifyListeners();
  }
}
```
