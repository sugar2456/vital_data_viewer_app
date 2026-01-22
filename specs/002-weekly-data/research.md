# Research: 直近一週間のデータ参照機能

**Date**: 2026-01-22
**Feature**: 002-weekly-data

## Fitbit Web API 期間指定エンドポイント調査結果

### 1. Activity Time Series by Date Range (歩数・カロリー・水泳)

**Endpoint URL**:
```
GET https://api.fitbit.com/1/user/-/activities/{resource}/date/{start-date}/{end-date}.json
```

**サポートされるリソース**:
| Resource | 最大期間 |
|----------|---------|
| steps | 1095日 |
| calories | 1095日 |
| distance | 1095日 |
| swimming-strokes | 1095日 |

**レスポンス形式**:
```json
{
  "activities-steps": [
    { "dateTime": "2026-01-15", "value": "2504" },
    { "dateTime": "2026-01-16", "value": "3723" },
    ...
  ]
}
```

---

### 2. Sleep Log by Date Range (睡眠)

**Endpoint URL**:
```
GET https://api.fitbit.com/1.2/user/-/sleep/date/{startDate}/{endDate}.json
```

**制限**: 最大100日間

**レスポンス形式**:
```json
{
  "sleep": [
    {
      "dateOfSleep": "2026-01-22",
      "duration": 28800000,
      "efficiency": 95,
      "isMainSleep": true,
      "levels": {
        "summary": {
          "deep": { "count": 4, "minutes": 90, "thirtyDayAvgMinutes": 85 },
          "light": { "count": 23, "minutes": 210, "thirtyDayAvgMinutes": 200 },
          "rem": { "count": 5, "minutes": 80, "thirtyDayAvgMinutes": 75 },
          "wake": { "count": 12, "minutes": 40, "thirtyDayAvgMinutes": 35 }
        }
      },
      "minutesAsleep": 380,
      "minutesAwake": 40,
      "timeInBed": 420,
      "type": "stages"
    }
  ]
}
```

---

### 3. Heart Rate Time Series by Date Range (心拍数)

**Endpoint URL**:
```
GET https://api.fitbit.com/1/user/-/activities/heart/date/{start-date}/{end-date}.json
```

**制限**: 最大1年間

**レスポンス形式**:
```json
{
  "activities-heart": [
    {
      "dateTime": "2026-01-22",
      "value": {
        "heartRateZones": [
          { "name": "Out of Range", "min": 30, "max": 94, "minutes": 1200, "caloriesOut": 800 },
          { "name": "Fat Burn", "min": 94, "max": 132, "minutes": 60, "caloriesOut": 400 },
          { "name": "Cardio", "min": 132, "max": 160, "minutes": 20, "caloriesOut": 200 },
          { "name": "Peak", "min": 160, "max": 220, "minutes": 5, "caloriesOut": 50 }
        ],
        "restingHeartRate": 65
      }
    }
  ]
}
```

**注意**: Heart Rate Time Series APIは平均・最高・最低心拍数を直接返さない。安静時心拍数と心拍数ゾーンを返す。

---

## API選択の決定

### Decision: 期間指定APIを使用

各データ種別で期間指定エンドポイントを使用する。

### Rationale
1. **効率性**: 1回のAPIコールで7日分のデータを取得可能
2. **レート制限対策**: 日別APIを7回呼び出すよりもAPIコール数が少ない
3. **シンプルな実装**: 並列呼び出しの複雑性を回避

### Alternatives Considered
1. **日別APIを7回並列呼び出し** - レート制限リスク、実装複雑性のため却下

---

## 新規追加するRepositoryメソッド

| Repository | メソッド | エンドポイント |
|------------|---------|---------------|
| StepRepository | `fetchStepsByDateRange(startDate, endDate)` | `/1/user/-/activities/steps/date/{start}/{end}.json` |
| CaloriesRepository | `fetchCaloriesByDateRange(startDate, endDate)` | `/1/user/-/activities/calories/date/{start}/{end}.json` |
| SleepRepository | `fetchSleepByDateRange(startDate, endDate)` | `/1.2/user/-/sleep/date/{start}/{end}.json` |
| HeartRateRepository | `fetchHeartRateByDateRange(startDate, endDate)` | `/1/user/-/activities/heart/date/{start}/{end}.json` |
| SwimmingRepository | `fetchSwimmingByDateRange(startDate, endDate)` | `/1/user/-/activities/swimming-strokes/date/{start}/{end}.json` |

---

## 棒グラフ表示

### Decision
fl_chart の BarChart を使用して週間データを表示する。

### Rationale
- fl_chart は既にプロジェクトで使用されている（pubspec.yaml に依存関係あり）
- BarChart は日別データの比較表示に適している
- カスタマイズ性が高く、既存のUIに統合しやすい

---

## データなし表示

### Decision
データがない日は棒グラフで高さ0の棒を表示し、ラベルに「-」を表示する。

### Rationale
- 視覚的に一貫性を保てる
- ユーザーがデータなしを明確に認識できる

---

## 睡眠ステージの棒グラフ

### Decision
積み上げ棒グラフ（Stacked Bar Chart）を使用して、各睡眠ステージを色分け表示する。

### Rationale
- 総睡眠時間と各ステージの内訳を同時に可視化できる
- fl_chart で実装可能
- 仕様要件（4種類の睡眠ステージ表示）を満たす

---

## 心拍数表示の調整

### Decision
仕様のFR-003「平均、最高、最低心拍数」を「安静時心拍数」の表示に変更することを推奨。

### Rationale
- Fitbit Heart Rate Time Series APIは平均/最高/最低を直接返さない
- Intraday APIで詳細データを取得して計算する場合、APIコール数が大幅に増加
- 安静時心拍数は健康状態の指標として有用

### Alternative
Intraday APIを使用して詳細データを取得し、平均/最高/最低を計算することも可能だが、実装複雑性とAPI負荷を考慮すると推奨しない。

---

## 参照元

- [Get Activity Time Series by Date Range](https://dev.fitbit.com/build/reference/web-api/activity-timeseries/get-activity-timeseries-by-date-range/)
- [Get Sleep Log by Date Range](https://dev.fitbit.com/build/reference/web-api/sleep/get-sleep-log-by-date-range/)
- [Get Heart Rate Time Series by Date Range](https://dev.fitbit.com/build/reference/web-api/heartrate-timeseries/get-heartrate-timeseries-by-date-range/)
