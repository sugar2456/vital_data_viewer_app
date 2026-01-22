# Quickstart: 直近一週間のデータ参照機能

**Date**: 2026-01-22
**Feature**: 002-weekly-data

## Prerequisites

- Flutter SDK 3.5.4+
- 既存のvital_data_viewer_appが動作する環境
- Fitbit APIアクセストークン（ログイン済み）

## Development Setup

```bash
# リポジトリをクローン（既存）
cd vital_data_viewer_app

# 依存関係をインストール
flutter pub get

# アプリを起動
flutter run -d macos
```

## Implementation Order

### Phase 1: Setup
1. `lib/view_models/weekly/` - ディレクトリ作成
2. `lib/views/weekly/` - ディレクトリ作成

### Phase 2: 基盤（Foundational）

#### 2.1 APIレスポンスモデル作成
1. `lib/models/response/steps_range_response.dart` - 歩数期間レスポンス
2. `lib/models/response/calories_range_response.dart` - カロリー期間レスポンス
3. `lib/models/response/sleep_range_response.dart` - 睡眠期間レスポンス
4. `lib/models/response/heart_rate_range_response.dart` - 心拍数期間レスポンス
5. `lib/models/response/swimming_range_response.dart` - 水泳期間レスポンス

#### 2.2 Repositoryインターフェース拡張
1. `lib/repositories/interfaces/step_repository_interface.dart` - `fetchStepsByDateRange` 追加
2. `lib/repositories/interfaces/sleep_repository_interface.dart` - `fetchSleepByDateRange` 追加
3. `lib/repositories/interfaces/heart_rate_repository_interface.dart` - `fetchHeartRateByDateRange` 追加
4. `lib/repositories/interfaces/calories_repository_interface.dart` - `fetchCaloriesByDateRange` 追加
5. `lib/repositories/interfaces/swimming_repository_interface.dart` - `fetchSwimmingByDateRange` 追加

#### 2.3 Repository実装拡張
1. `lib/repositories/impls/step_repository_impl.dart` - 実装追加
2. `lib/repositories/impls/sleep_repository_impl.dart` - 実装追加
3. `lib/repositories/impls/heart_rate_repository_impl.dart` - 実装追加
4. `lib/repositories/impls/calories_repository_impl.dart` - 実装追加
5. `lib/repositories/impls/swimming_repository_impl.dart` - 実装追加

#### 2.4 共通UIコンポーネント
1. `lib/views/component/weekly_bar_chart.dart` - 週間棒グラフウィジェット

### Phase 3: 週間歩数（US1 - P1）
1. `lib/view_models/weekly/weekly_steps_view_model.dart` - ViewModel作成
2. `lib/views/weekly/weekly_step_view.dart` - View作成
3. `lib/providers/provider_setup.dart` - Provider追加
4. `lib/main.dart` - ルート追加
5. `lib/views/component/custom_drawer.dart` - メニュー項目追加

### Phase 4: 週間睡眠（US2 - P1）
1. `lib/views/component/weekly_stacked_bar_chart.dart` - 積み上げ棒グラフ
2. `lib/view_models/weekly/weekly_sleep_view_model.dart` - ViewModel作成
3. `lib/views/weekly/weekly_sleep_view.dart` - View作成
4. Provider追加、ルート追加、メニュー項目追加

### Phase 5: 週間心拍数（US3 - P2）
1. `lib/view_models/weekly/weekly_heart_rate_view_model.dart` - ViewModel作成
2. `lib/views/weekly/weekly_heart_rate_view.dart` - View作成
3. Provider追加、ルート追加、メニュー項目追加

### Phase 6: 週間カロリー（US4 - P2）
1. `lib/view_models/weekly/weekly_calories_view_model.dart` - ViewModel作成
2. `lib/views/weekly/weekly_calories_view.dart` - View作成
3. Provider追加、ルート追加、メニュー項目追加

### Phase 7: 週間水泳（US5 - P3）
1. `lib/view_models/weekly/weekly_swimming_view_model.dart` - ViewModel作成
2. `lib/views/weekly/weekly_swimming_view.dart` - View作成
3. Provider追加、ルート追加、メニュー項目追加

## Testing

```bash
# ユニットテスト実行
flutter test

# 特定のテストファイル実行
flutter test test/view_models/weekly/weekly_steps_view_model_test.dart
```

## Key Files

| File | Type | Description |
|------|------|-------------|
| `lib/models/response/*_range_response.dart` | 新規 | Fitbit APIレスポンスモデル（5ファイル） |
| `lib/repositories/interfaces/*.dart` | 修正 | `fetchXxxByDateRange` メソッド追加（5ファイル） |
| `lib/repositories/impls/*.dart` | 修正 | 期間指定API実装追加（5ファイル） |
| `lib/views/component/weekly_bar_chart.dart` | 新規 | 週間棒グラフコンポーネント |
| `lib/views/component/weekly_stacked_bar_chart.dart` | 新規 | 睡眠用積み上げ棒グラフ |
| `lib/view_models/weekly/*.dart` | 新規 | 週間専用ViewModel（5ファイル） |
| `lib/views/weekly/*.dart` | 新規 | 週間専用View（5ファイル） |
| `lib/views/component/custom_drawer.dart` | 修正 | 週間メニュー項目追加 |
| `lib/providers/provider_setup.dart` | 修正 | 週間ViewModelのProvider追加 |
| `lib/main.dart` | 修正 | 週間画面のルート追加 |

## Acceptance Criteria Checklist

- [ ] メニューから「週間歩数」画面に遷移できる
- [ ] メニューから「週間睡眠」画面に遷移できる
- [ ] メニューから「週間心拍数」画面に遷移できる
- [ ] メニューから「週間カロリー」画面に遷移できる
- [ ] メニューから「週間水泳」画面に遷移できる
- [ ] 各週間画面で棒グラフが表示される
- [ ] 睡眠画面で4種類のステージが積み上げ棒グラフで表示される
- [ ] データなしの日が明確に表示される
- [ ] 週間データが5秒以内に読み込まれる
- [ ] 2タップで週間表示に到達できる（メニュー→週間画面）
