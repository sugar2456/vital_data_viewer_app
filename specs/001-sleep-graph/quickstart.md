# クイックスタート: Fitbit睡眠データ可視化機能の実装

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17

## 概要

このガイドは、睡眠データグラフ表示機能を実装するための手順を説明します。

## 実装順序

1. データモデルの拡張
2. Repositoryの拡張
3. ViewModelの作成
4. グラフコンポーネントの作成
5. Viewの作成
6. ルーティングとナビゲーションの追加

## 前提条件

- Dart 3.5.4 / Flutter SDK がインストールされていること
- プロジェクトが`001-sleep-graph`ブランチにあること
- 依存パッケージがインストール済み（`flutter pub get`）

## ステップ 1: データモデルの作成

**ファイル**: `lib/view_models/sleep_chart_data.dart`

ViewModelで使用する補助モデルを作成します：

```dart
import 'package:flutter/material.dart';

enum SleepType { stages, classic }

class SleepChartData {
  final DateTime startTime;
  final DateTime endTime;
  final List<SleepStageSegment> stages;
  final int totalSleepMinutes;
  final SleepType sleepType;

  SleepChartData({
    required this.startTime,
    required this.endTime,
    required this.stages,
    required this.totalSleepMinutes,
    required this.sleepType,
  });

  String get formattedTotalSleep {
    final hours = totalSleepMinutes ~/ 60;
    final minutes = totalSleepMinutes % 60;
    return '${hours}時間${minutes}分';
  }
}

class SleepStageSegment {
  final DateTime startTime;
  final DateTime endTime;
  final String stage;
  final double durationMinutes;
  final Color color;

  SleepStageSegment({
    required this.startTime,
    required this.endTime,
    required this.stage,
    required this.durationMinutes,
    required this.color,
  });
}
```

## ステップ 2: Repositoryの拡張

### 2.1 インターフェースの更新

**ファイル**: `lib/repositories/interfaces/sleep_repository_interface.dart`

```dart
Future<SleepLogResponse> fetchSleepLogByDate(String date); // 追加
```

### 2.2 実装クラスの更新

**ファイル**: `lib/repositories/impls/sleep_repository_impl.dart`

```dart
@override
Future<SleepLogResponse> fetchSleepLogByDate(String date) async {
  if (!_isValidDateFormat(date)) {
    throw ArgumentError('Invalid date format. Expected YYYY-MM-DD');
  }

  final uri = Uri.https(
    'api.fitbit.com',
    '/1.2/user/-/sleep/date/$date.json',
  );

  final responseBody = await super.get(uri, headers);

  if (responseBody.isEmpty) {
    throw ExternalServiceException('睡眠データが取得できませんでした。');
  }

  return SleepLogResponse.fromJson(responseBody);
}

bool _isValidDateFormat(String date) {
  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  return regex.hasMatch(date);
}
```

## ステップ 3: ViewModelの作成

**ファイル**: `lib/view_models/sleep_view_model.dart`

完全な実装は[contracts/sleep_view_model.md](contracts/sleep_view_model.md)を参照してください。

## ステップ 4: グラフコンポーネントの作成

**ファイル**: `lib/views/component/sleep_stage_chart.dart`

fl_chartのBarChartを使用してグラフを実装します。

## ステップ 5: Viewの作成

**ファイル**: `lib/views/sleep_view.dart`

睡眠データを表示するメイン画面を作成します。

## ステップ 6: Providerの登録とルーティング

### 6.1 Providerの登録

**ファイル**: `lib/main.dart`

```dart
ChangeNotifierProvider(
  create: (context) => SleepViewModel(
    repository: SleepRepositoryImpl(...),
  ),
)
```

### 6.2 ナビゲーションの追加

**ファイル**: `lib/views/component/custom_drawer.dart`

```dart
ListTile(
  leading: const Icon(Icons.bedtime),
  title: const Text('睡眠データ'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SleepView()),
    );
  },
),
```

## テストの実行

```bash
# Repositoryのテスト
flutter test test/repositories/sleep_repository_impl_test.dart

# ViewModelのテスト
flutter test test/view_models/sleep_view_model_test.dart
```

## 動作確認

1. アプリを起動: `flutter run`
2. ログイン
3. ドロワーから「睡眠データ」を選択
4. グラフが表示されることを確認
5. 右下のカレンダーアイコンをタップ
6. 過去の日付を選択
7. 選択した日付のデータが表示されることを確認

## トラブルシューティング

### データが表示されない

- Fitbit APIの認証トークンが有効か確認
- 選択した日付に睡眠データがあるか確認
- ネットワーク接続を確認

### グラフが正しく表示されない

- `fl_chart`パッケージのバージョンを確認: `^0.70.2`
- データ変換ロジックをデバッグ

## 次のステップ

1. `/speckit.tasks`コマンドで詳細な実装タスクを生成
2. タスクに従って実装を進める
3. テストを作成・実行

## 参考資料

- [機能仕様書](spec.md)
- [実装計画](plan.md)
- [調査結果](research.md)
- [データモデル](data-model.md)
- [Repository契約](contracts/sleep_repository.md)
- [ViewModel契約](contracts/sleep_view_model.md)
