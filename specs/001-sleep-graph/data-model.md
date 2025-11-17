# データモデル: Fitbit睡眠データの可視化

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17

## 概要

この文書は、Fitbit睡眠データグラフ表示機能で使用されるデータモデルを定義します。

## エンティティ

### 1. SleepLogResponse (既存)

Fitbit Sleep APIからのレスポンスを表すルートエンティティ。

**フィールド**:
- `sleep`: `List<Sleep>` - 睡眠セッションのリスト
- `summary`: `Summary` - 睡眠の要約統計

**ファイル**: `lib/models/response/sleep_log_response.dart`

### 2. Sleep (既存)

個々の睡眠セッションを表す。

**主要フィールド**:
- `type`: `String` - "stages" または "classic"
- `levels`: `Levels` - 睡眠ステージの詳細
- `minutesAsleep`: `int` - 実際の睡眠時間（分）
- `startTime`: `DateTime` - 開始時刻
- `endTime`: `DateTime` - 終了時刻

### 3. Levels (既存)

睡眠ステージの詳細データ。

**フィールド**:
- `data`: `List<LevelData>` - メインの睡眠ステージデータ
- `shortData`: `List<LevelData>` - 短い覚醒やREM断片

### 4. LevelData (既存)

個々の睡眠ステージの期間を表す。

**フィールド**:
- `dateTime`: `DateTime` - ステージの開始時刻
- `level`: `String` - ステージタイプ
  - stages形式: "deep", "light", "rem", "wake"
  - classic形式: "asleep", "restless", "awake"
- `seconds`: `int` - このステージの継続時間（秒）

### 5. SleepChartData (新規)

グラフ表示用に変換されたデータ。ViewModelで使用。

**フィールド**:
- `startTime`: `DateTime` - 表示範囲の開始時刻
- `endTime`: `DateTime` - 表示範囲の終了時刻
- `stages`: `List<SleepStageSegment>` - グラフ用ステージセグメント
- `totalSleepMinutes`: `int` - トータル睡眠時間（分）
- `sleepType`: `SleepType` - stages または classic

### 6. SleepStageSegment (新規)

グラフの1つのセグメント（棒）を表す。

**フィールド**:
- `startTime`: `DateTime` - セグメントの開始時刻
- `endTime`: `DateTime` - セグメントの終了時刻
- `stage`: `String` - ステージタイプ
- `durationMinutes`: `double` - 継続時間（分）
- `color`: `Color` - 表示色

### 7. SleepType (新規 - Enum)

睡眠データの形式を表す列挙型。

```dart
enum SleepType {
  stages,  // 新しいFitbitデバイス
  classic, // 古いFitbitデバイス
}
```

## ステージ色マッピング

### stages形式

| ステージ | 色 | 説明 |
|---------|-----|------|
| deep | `Colors.blue[900]` | 深い睡眠（濃い青） |
| light | `Colors.blue[300]` | 浅い睡眠（明るい青） |
| rem | `Colors.purple` | REM睡眠（紫） |
| wake | `Colors.orange` | 覚醒（オレンジ） |

### classic形式

| ステージ | 色 | 説明 |
|---------|-----|------|
| asleep | `Colors.blue` | 睡眠中（青） |
| restless | `Colors.yellow` | 不安定（黄色） |
| awake | `Colors.red` | 起きている（赤） |

## データフロー

```
Fitbit API Response (JSON)
    ↓
SleepLogResponse.fromJson()
    ↓
SleepLogResponse オブジェクト
    ↓
SleepViewModel._convertToChartData()
    ↓
SleepChartData
    ↓
SleepStageChart ウィジェット
    ↓
fl_chart BarChart
```

## 次のステップ

- API契約の定義（contracts/）
- クイックスタートガイドの作成（quickstart.md）
