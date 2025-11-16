# ViewModel 契約: SleepViewModel

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17

## 概要

この文書は、睡眠データ表示画面の状態管理を行うViewModelの契約を定義します。

## クラス定義

### SleepViewModel

**ファイル**: `lib/view_models/sleep_view_model.dart`

```dart
class SleepViewModel extends ChangeNotifier {
  final SleepRepositoryInterface _repository;

  // 状態
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  SleepChartData? _sleepChartData;
  SleepChartData? get sleepChartData => _sleepChartData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get hasData => _sleepChartData != null;

  // メソッド
  Future<void> fetchSleepData(DateTime date);
  Future<void> fetchTodaySleepData();
}
```

## 主要メソッド

### fetchSleepData(DateTime date)

指定された日付の睡眠データを取得します。

**処理フロー**:
1. ローディング開始（`isLoading = true`）
2. Repositoryから日付指定でデータ取得
3. データをグラフ用に変換（`SleepChartData`）
4. ローディング終了、リスナーに通知

### fetchTodaySleepData()

今日の睡眠データを取得します（初期化用）。

## データモデル

### SleepChartData

```dart
class SleepChartData {
  final DateTime startTime;
  final DateTime endTime;
  final List<SleepStageSegment> stages;
  final int totalSleepMinutes;
  final SleepType sleepType;

  String get formattedTotalSleep {
    final hours = totalSleepMinutes ~/ 60;
    final minutes = totalSleepMinutes % 60;
    return '${hours}時間${minutes}分';
  }
}
```

### SleepStageSegment

```dart
class SleepStageSegment {
  final DateTime startTime;
  final DateTime endTime;
  final String stage;
  final double durationMinutes;
  final Color color;
}
```

### SleepType

```dart
enum SleepType {
  stages,  // deep, light, rem, wake
  classic, // asleep, restless, awake
}
```

## 状態遷移

```
初期状態
  ↓
[fetchTodaySleepData()]
  ↓
isLoading = true
  ↓
API呼び出し
  ↓
├─ 成功 → sleepChartData設定, isLoading = false
├─ データなし → errorMessage設定, isLoading = false
└─ エラー → errorMessage設定, isLoading = false
```

## Provider 設定

### main.dart での登録

```dart
ChangeNotifierProvider(
  create: (context) => SleepViewModel(
    repository: context.read<SleepRepositoryInterface>(),
  ),
)
```

### View での使用

```dart
Consumer<SleepViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return CircularProgressIndicator();
    }
    // ...
  },
)
```

## テスト

**ファイル**: `test/view_models/sleep_view_model_test.dart`

テスト項目：
1. 正常ケース: データ取得成功
2. エラーケース: データなし
3. エラーケース: API エラー
4. ローディング状態の管理
5. stages形式とclassic形式のデータ変換
