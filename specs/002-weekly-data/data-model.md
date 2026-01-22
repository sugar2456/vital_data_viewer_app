# Data Model: 直近一週間のデータ参照機能

**Date**: 2026-01-22
**Feature**: 002-weekly-data

## API Response Models

Fitbit APIのレスポンス型をそのままモデル化（既存アーキテクチャに準拠）。

### StepsRangeResponse

Activity Time Series by Date Range APIのレスポンス。

```dart
class StepsRangeResponse {
  final List<ActivityTimeSeries> activitiesSteps;
}

class ActivityTimeSeries {
  final String dateTime;  // "2026-01-22"
  final String value;     // "2504"
}
```

**API**: `GET /1/user/-/activities/steps/date/{start}/{end}.json`

---

### CaloriesRangeResponse

Activity Time Series by Date Range APIのレスポンス。

```dart
class CaloriesRangeResponse {
  final List<ActivityTimeSeries> activitiesCalories;
}
```

**API**: `GET /1/user/-/activities/calories/date/{start}/{end}.json`

---

### SwimmingRangeResponse

Activity Time Series by Date Range APIのレスポンス。

```dart
class SwimmingRangeResponse {
  final List<ActivityTimeSeries> activitiesSwimmingStrokes;
}
```

**API**: `GET /1/user/-/activities/swimming-strokes/date/{start}/{end}.json`

---

### SleepRangeResponse

Sleep Log by Date Range APIのレスポンス。

```dart
class SleepRangeResponse {
  final List<SleepLog> sleep;
}

class SleepLog {
  final String dateOfSleep;    // "2026-01-22"
  final int duration;          // milliseconds
  final int efficiency;
  final bool isMainSleep;
  final SleepLevels levels;
  final int minutesAsleep;
  final int minutesAwake;
  final int timeInBed;
  final String type;           // "stages" or "classic"
}

class SleepLevels {
  final SleepSummary summary;
}

class SleepSummary {
  final SleepStageData deep;
  final SleepStageData light;
  final SleepStageData rem;
  final SleepStageData wake;
}

class SleepStageData {
  final int count;
  final int minutes;
  final int thirtyDayAvgMinutes;
}
```

**API**: `GET /1.2/user/-/sleep/date/{start}/{end}.json`

---

### HeartRateRangeResponse

Heart Rate Time Series by Date Range APIのレスポンス。

```dart
class HeartRateRangeResponse {
  final List<HeartRateTimeSeries> activitiesHeart;
}

class HeartRateTimeSeries {
  final String dateTime;        // "2026-01-22"
  final HeartRateValue value;
}

class HeartRateValue {
  final List<HeartRateZone> heartRateZones;
  final int? restingHeartRate;
}

class HeartRateZone {
  final String name;     // "Out of Range", "Fat Burn", "Cardio", "Peak"
  final int min;
  final int max;
  final int minutes;
  final double caloriesOut;
}
```

**API**: `GET /1/user/-/activities/heart/date/{start}/{end}.json`

---

## UI Display Models

ViewModelで使用する表示用モデル。

### WeeklyDataPoint

日別データを表す汎用モデル（歩数、カロリー、水泳用）。

| Field | Type | Description |
|-------|------|-------------|
| label | String | 表示ラベル（"1/22"形式） |
| value | double | データ値（歩数、カロリー等） |
| hasData | bool | データが存在するかどうか |

```dart
class WeeklyDataPoint {
  final String label;
  final double value;
  final bool hasData;

  factory WeeklyDataPoint.noData(String label) =>
    WeeklyDataPoint(label: label, value: 0, hasData: false);
}
```

---

### WeeklySleepDataPoint

睡眠データの日別モデル（ステージ内訳を含む）。

| Field | Type | Description |
|-------|------|-------------|
| label | String | 表示ラベル（"1/22"形式） |
| deepMinutes | int | 深い睡眠時間（分） |
| lightMinutes | int | 浅い睡眠時間（分） |
| remMinutes | int | レム睡眠時間（分） |
| wakeMinutes | int | 覚醒時間（分） |
| hasData | bool | データが存在するかどうか |

```dart
class WeeklySleepDataPoint {
  final String label;
  final int deepMinutes;
  final int lightMinutes;
  final int remMinutes;
  final int wakeMinutes;
  final bool hasData;

  int get totalMinutes => deepMinutes + lightMinutes + remMinutes + wakeMinutes;
}
```

---

### WeeklyHeartRateDataPoint

心拍数データの日別モデル。

| Field | Type | Description |
|-------|------|-------------|
| label | String | 表示ラベル（"1/22"形式） |
| restingHeartRate | int? | 安静時心拍数 |
| hasData | bool | データが存在するかどうか |

```dart
class WeeklyHeartRateDataPoint {
  final String label;
  final int? restingHeartRate;
  final bool hasData;
}
```

---

## State Transitions

### ViewModel State

```
Initial → Loading → Loaded/Error
         ↑         ↓
         ←←←←←←←←←←
           (Retry)
```

## Validation Rules

- `value` は 0 以上
- `totalMinutes` = `deepMinutes` + `lightMinutes` + `remMinutes` + `wakeMinutes`
- `restingHeartRate` は 30-220 の範囲（nullは未計測）
