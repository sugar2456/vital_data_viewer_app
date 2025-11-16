# Phase 0 調査: Fitbit睡眠データの可視化

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17 | **ステータス**: 完了

## 調査概要

この文書は、Fitbit睡眠データグラフ表示機能の実装に必要な技術調査の結果をまとめたものです。

## 1. fl_chartでの時系列睡眠ステージグラフの実装

### 決定事項

**BarChart**を使用して、睡眠ステージを時系列で表示します。

### 根拠

- 睡眠ステージは離散的なカテゴリであり、棒グラフが最適
- fl_chartの`BarChart`ウィジェットは横向き（時系列）の棒グラフをサポート
- 各睡眠ステージの期間を棒の長さで表現可能
- 色分けによる視覚的な区別が容易

### 検討した代替案

- **LineChart**: 連続的なデータに適しているが、カテゴリデータには不適切
- **PieChart**: 全体の割合を示すには良いが、時系列の遷移が見えない
- **カスタムペインター**: 完全な制御が可能だが、実装コストが高い

## 2. Fitbit Sleep API レスポンス形式

### 決定事項

既存の`SleepLogResponse`モデルを使用し、`Sleep.type`フィールドで形式を判別します。

### stages形式の例

```json
{
  "sleep": [{
    "type": "stages",
    "levels": {
      "data": [
        {"dateTime": "2020-02-20T23:32:30.000", "level": "deep", "seconds": 870}
      ]
    }
  }]
}
```

### classic形式の例

```json
{
  "sleep": [{
    "type": "classic",
    "levels": {
      "data": [
        {"dateTime": "2020-02-20T23:32:30.000", "level": "asleep", "seconds": 3600}
      ]
    }
  }]
}
```

### API エンドポイント

```
GET https://api.fitbit.com/1.2/user/-/sleep/date/{date}.json
```

- `{date}`: YYYY-MM-DD形式（例: "2025-11-17"）
- 認証: Bearer トークン（既存の認証フローを使用）

## 3. Flutter日付ピッカーの実装

### 決定事項

Flutter標準の`showDatePicker`を使用します。

### 根拠

- Flutterの組み込みウィジェットで、プラットフォーム固有のデザインを自動適用
- 未来日付の選択制限が簡単（`lastDate`パラメータ）

## 4. 既存Repositoryパターンの拡張

### 決定事項

`SleepRepositoryInterface`に`fetchSleepLogByDate(String date)`メソッドを追加します。

### 根拠

- 既存の`fetchSleepLog()`は現在の日付のみをサポート
- 日付を指定できる新しいメソッドが必要
- インターフェースに追加することで、テスト時のモック化が容易

## 技術スタックの最終決定

| 要素 | 選択 | 理由 |
|------|------|------|
| グラフライブラリ | fl_chart (BarChart) | 既存使用、カテゴリデータに最適 |
| 日付ピッカー | showDatePicker | Flutter標準、簡単に実装可能 |
| 状態管理 | Provider + ChangeNotifier | 既存パターン、一貫性 |
| データモデル | 既存SleepLogResponse | すでに両形式に対応 |
| API通信 | BaseRequestClass継承 | 既存パターン、認証統合済み |

## 次のステップ

Phase 1に進み、以下を作成します：
1. data-model.md（データモデルの詳細設計）
2. contracts/（API契約とインターフェース定義）
3. quickstart.md（開発者向け実装ガイド）
