# Repository Contracts: 週間データ取得

**Date**: 2026-01-22
**Feature**: 002-weekly-data

## アーキテクチャ方針

既存アーキテクチャに従い、RepositoryはFitbit APIのレスポンス型をそのまま返す。
ViewModelでレスポンスから必要な情報を抽出・加工する。

---

## StepRepositoryInterface

```dart
abstract class StepRepositoryInterface {
  // 既存
  Future<StepResponse> fetchStep(String date, String min);
  Future<StepResponse> fetchStepPeriod(String startDate, String endDate, String min);

  // 新規：期間指定で日別歩数データを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns Fitbit Activity Time Series APIのレスポンス
  Future<StepsRangeResponse> fetchStepsByDateRange(String startDate, String endDate);
}
```

**API**: `GET /1/user/-/activities/steps/date/{start}/{end}.json`

---

## SleepRepositoryInterface

```dart
abstract class SleepRepositoryInterface {
  // 既存
  Future<SleepGoalResponse> fetchSleepGoal();
  Future<SleepLogResponse> fetchSleepLog();
  Future<SleepLogResponse> fetchSleepLogByDate(String date);

  // 新規：期間指定で睡眠データを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns Fitbit Sleep Log by Date Range APIのレスポンス
  Future<SleepRangeResponse> fetchSleepByDateRange(String startDate, String endDate);
}
```

**API**: `GET /1.2/user/-/sleep/date/{start}/{end}.json`

---

## HeartRateRepositoryInterface

```dart
abstract class HeartRateRepositoryInterface {
  // 既存
  Future<HeartRateResponse> fetchHeartRate(String date, String detailLevel);

  // 新規：期間指定で心拍数データを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns Fitbit Heart Rate Time Series APIのレスポンス
  Future<HeartRateRangeResponse> fetchHeartRateByDateRange(String startDate, String endDate);
}
```

**API**: `GET /1/user/-/activities/heart/date/{start}/{end}.json`

---

## CaloriesRepositoryInterface

```dart
abstract class CaloriesRepositoryInterface {
  // 既存
  Future<CaloriesResponse> fetchCalories(String date, String detailLevel);

  // 新規：期間指定でカロリーデータを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns Fitbit Activity Time Series APIのレスポンス
  Future<CaloriesRangeResponse> fetchCaloriesByDateRange(String startDate, String endDate);
}
```

**API**: `GET /1/user/-/activities/calories/date/{start}/{end}.json`

---

## SwimmingRepositoryInterface

```dart
abstract class SwimmingRepositoryInterface {
  // 既存
  Future<SwimmingResponse> fetchSwimming(String date, String detailLevel);

  // 新規：期間指定で水泳データを取得
  /// [startDate] 開始日（YYYY-MM-DD形式）
  /// [endDate] 終了日（YYYY-MM-DD形式）
  /// Returns Fitbit Activity Time Series APIのレスポンス
  Future<SwimmingRangeResponse> fetchSwimmingByDateRange(String startDate, String endDate);
}
```

**API**: `GET /1/user/-/activities/swimming-strokes/date/{start}/{end}.json`

---

## ViewModel Contract

ViewModelでAPIレスポンスから表示用データを抽出・加工する。

```dart
class WeeklyStepsViewModel extends ChangeNotifier {
  final StepRepositoryInterface _repository;

  List<WeeklyDataPoint> _weeklyData = [];
  List<WeeklyDataPoint> get weeklyData => _weeklyData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// 直近7日間のデータを取得
  Future<void> fetchWeeklyData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 6));

      // APIからレスポンスを取得
      final response = await _repository.fetchStepsByDateRange(
        _formatDate(startDate),
        _formatDate(now),
      );

      // レスポンスからWeeklyDataPointに変換
      _weeklyData = _convertToWeeklyData(response, startDate, now);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'データの取得に失敗しました';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<WeeklyDataPoint> _convertToWeeklyData(
    StepsRangeResponse response,
    DateTime startDate,
    DateTime endDate,
  ) {
    // 7日分のデータを生成（データがない日はnoDataで埋める）
    final results = <WeeklyDataPoint>[];
    for (int i = 0; i <= 6; i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = _formatDate(date);
      final label = '${date.month}/${date.day}';

      final data = response.activitiesSteps.firstWhere(
        (d) => d.dateTime == dateStr,
        orElse: () => null,
      );

      if (data != null) {
        results.add(WeeklyDataPoint(
          label: label,
          value: double.parse(data.value),
          hasData: true,
        ));
      } else {
        results.add(WeeklyDataPoint.noData(label));
      }
    }
    return results;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
```
