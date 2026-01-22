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

### Phase 1: 基盤
1. `lib/models/weekly/` - 週間データモデル作成
2. `lib/views/component/weekly_bar_chart.dart` - 週間棒グラフウィジェット作成

### Phase 2: 週間歩数（P1）
1. `lib/view_models/weekly/weekly_steps_view_model.dart` - 新規作成
2. `lib/views/weekly/weekly_step_view.dart` - 新規作成
3. `lib/providers/provider_setup.dart` - Provider追加
4. `lib/main.dart` - ルート追加
5. テスト作成・実行

### Phase 3: 週間睡眠（P1）
1. `lib/view_models/weekly/weekly_sleep_view_model.dart` - 新規作成
2. `lib/views/weekly/weekly_sleep_view.dart` - 新規作成（積み上げ棒グラフ）
3. テスト作成・実行

### Phase 4: 週間心拍数（P2）
1. `lib/view_models/weekly/weekly_heart_rate_view_model.dart` - 新規作成
2. `lib/views/weekly/weekly_heart_rate_view.dart` - 新規作成
3. テスト作成・実行

### Phase 5: 週間カロリー（P2）
1. `lib/view_models/weekly/weekly_calories_view_model.dart` - 新規作成
2. `lib/views/weekly/weekly_calories_view.dart` - 新規作成
3. テスト作成・実行

### Phase 6: 週間水泳（P3）
1. `lib/view_models/weekly/weekly_swimming_view_model.dart` - 新規作成
2. `lib/views/weekly/weekly_swimming_view.dart` - 新規作成
3. テスト作成・実行

### Phase 7: メニュー統合
1. `lib/views/component/custom_drawer.dart` - 週間メニュー項目追加

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
| `lib/models/weekly/weekly_data_point.dart` | 新規 | 汎用週間データモデル |
| `lib/models/weekly/weekly_sleep_data.dart` | 新規 | 睡眠専用週間データモデル |
| `lib/models/weekly/weekly_heart_rate_data.dart` | 新規 | 心拍数専用週間データモデル |
| `lib/views/component/weekly_bar_chart.dart` | 新規 | 週間棒グラフコンポーネント |
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
