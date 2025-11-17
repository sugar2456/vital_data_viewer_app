# Repository 契約: SleepRepository

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17

## 概要

この文書は、睡眠データ取得のためのRepositoryインターフェースを定義します。

## インターフェース定義

### SleepRepositoryInterface

**ファイル**: `lib/repositories/interfaces/sleep_repository_interface.dart`

```dart
abstract class SleepRepositoryInterface {
  /// 現在の日付の睡眠データを取得する（既存）
  Future<SleepLogResponse> fetchSleepLog();

  /// 指定された日付の睡眠データを取得する（新規）
  ///
  /// [date] 日付文字列（YYYY-MM-DD形式）例: "2025-11-17"
  /// Returns [SleepLogResponse] 睡眠データ
  /// Throws [ExternalServiceException] API エラー時
  Future<SleepLogResponse> fetchSleepLogByDate(String date);

  /// 睡眠目標を取得する（既存）
  Future<SleepGoalResponse> fetchSleepGoal();
}
```

## 実装クラス

### SleepRepositoryImpl

**ファイル**: `lib/repositories/impls/sleep_repository_impl.dart`

主な変更点：
1. `fetchSleepLogByDate(String date)` メソッドの追加
2. 日付形式のバリデーション
3. エラーハンドリングの統一

## エラーハンドリング

| ケース | 例外 | メッセージ |
|--------|------|-----------|
| 不正な日付形式 | `ArgumentError` | "Invalid date format. Expected YYYY-MM-DD" |
| データなし | `ExternalServiceException` | "睡眠データが取得できませんでした。" |
| API エラー | `ExternalServiceException` | "睡眠データの取得中にエラーが発生しました" |

## Fitbit API 仕様

### エンドポイント

```
GET https://api.fitbit.com/1.2/user/-/sleep/date/{date}.json
```

### パラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|---|------|------|
| date | String | ✅ | 日付 (YYYY-MM-DD形式) |

### ヘッダー

```
Authorization: Bearer {access_token}
```

## テスト

**ファイル**: `test/repositories/sleep_repository_impl_test.dart`

テスト項目：
1. 正常ケース: 有効な日付でデータを取得
2. エラーケース: 不正な日付形式
3. エラーケース: APIエラー
