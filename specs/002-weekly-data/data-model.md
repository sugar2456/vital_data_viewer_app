# Data Model: 直近一週間のデータ参照機能

**Date**: 2026-01-22
**Feature**: 002-weekly-data

## Entities

### WeeklyDataPoint

日別データを表す汎用モデル。

| Field | Type | Description |
|-------|------|-------------|
| date | DateTime | データの日付 |
| value | double | データ値（歩数、カロリー等） |
| hasData | bool | データが存在するかどうか |

### WeeklySleepData

睡眠データの日別モデル（ステージ内訳を含む）。

| Field | Type | Description |
|-------|------|-------------|
| date | DateTime | データの日付 |
| totalMinutes | int | 総睡眠時間（分） |
| deepMinutes | int | 深い睡眠時間（分） |
| lightMinutes | int | 浅い睡眠時間（分） |
| remMinutes | int | レム睡眠時間（分） |
| wakeMinutes | int | 覚醒時間（分） |
| hasData | bool | データが存在するかどうか |

### WeeklyHeartRateData

心拍数データの日別モデル。

| Field | Type | Description |
|-------|------|-------------|
| date | DateTime | データの日付 |
| avgBpm | int | 平均心拍数 |
| maxBpm | int | 最高心拍数 |
| minBpm | int | 最低心拍数 |
| hasData | bool | データが存在するかどうか |

## State Transitions

### ViewModel State

```
Initial → Loading → Loaded/Error
         ↑         ↓
         ←←←←←←←←←←
           (Retry)
```

### Display Mode

```
DailyMode ←→ WeeklyMode
   (Toggle via UI button)
```

## Relationships

```
ViewModel 1──* WeeklyDataPoint
ViewModel 1──* WeeklySleepData (sleep only)
ViewModel 1──* WeeklyHeartRateData (heart rate only)
```

## Validation Rules

- `date` は過去7日以内の日付
- `value` は 0 以上
- `totalMinutes` = `deepMinutes` + `lightMinutes` + `remMinutes` + `wakeMinutes`
- `avgBpm`, `maxBpm`, `minBpm` は 30-250 の範囲
