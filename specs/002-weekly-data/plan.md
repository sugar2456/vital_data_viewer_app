# Implementation Plan: 直近一週間のデータ参照機能

**Branch**: `002-weekly-data` | **Date**: 2026-01-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-weekly-data/spec.md`

## Summary

直近7日間のバイタルデータ（歩数、睡眠、心拍数、カロリー、水泳）を棒グラフで表示する機能を実装。Fitbit Web APIの期間指定エンドポイントを使用して効率的にデータを取得し、既存のMVVM + Repositoryパターンに従って実装する。

## Technical Context

**Language/Version**: Dart 3.5.4 / Flutter 3.24.4
**Primary Dependencies**: fl_chart, provider, http
**Storage**: N/A（Fitbit APIからリアルタイム取得）
**Testing**: flutter_test
**Target Platform**: iOS, macOS
**Project Type**: mobile
**Performance Goals**: 週間データの読み込みは5秒以内
**Constraints**: Fitbit API レート制限（150 requests/hour）
**Scale/Scope**: 5種類のデータ × 週間表示

## Constitution Check

*GATE: Constitution未設定のためスキップ*

## Project Structure

### Documentation (this feature)

```text
specs/002-weekly-data/
├── plan.md              # This file
├── research.md          # API調査結果
├── data-model.md        # データモデル定義
├── quickstart.md        # 実装ガイド
├── contracts/           # リポジトリコントラクト
│   └── repository-contracts.md
└── tasks.md             # タスクリスト
```

### Source Code (repository root)

```text
lib/
├── models/
│   └── response/
│       ├── steps_range_response.dart      # 新規: 期間指定歩数レスポンス
│       ├── calories_range_response.dart   # 新規: 期間指定カロリーレスポンス
│       ├── sleep_range_response.dart      # 新規: 期間指定睡眠レスポンス
│       ├── heart_rate_range_response.dart # 新規: 期間指定心拍数レスポンス
│       └── swimming_range_response.dart   # 新規: 期間指定水泳レスポンス
├── repositories/
│   ├── interfaces/
│   │   ├── step_repository_interface.dart     # 拡張: fetchStepsByDateRange追加
│   │   ├── calories_repository_interface.dart # 拡張: fetchCaloriesByDateRange追加
│   │   ├── sleep_repository_interface.dart    # 拡張: fetchSleepByDateRange追加
│   │   ├── heart_rate_repository_interface.dart # 拡張: fetchHeartRateByDateRange追加
│   │   └── swimming_repository_interface.dart   # 拡張: fetchSwimmingByDateRange追加
│   └── impls/
│       ├── step_repository_impl.dart          # 拡張
│       ├── calories_repository_impl.dart      # 拡張
│       ├── sleep_repository_impl.dart         # 拡張
│       ├── heart_rate_repository_impl.dart    # 拡張
│       └── swimming_repository_impl.dart      # 拡張
├── view_models/
│   └── weekly/
│       ├── weekly_steps_view_model.dart       # 新規
│       ├── weekly_sleep_view_model.dart       # 新規
│       ├── weekly_heart_rate_view_model.dart  # 新規
│       ├── weekly_calories_view_model.dart    # 新規
│       └── weekly_swimming_view_model.dart    # 新規
├── views/
│   ├── component/
│   │   ├── weekly_bar_chart.dart              # 新規: 共通棒グラフ
│   │   └── weekly_stacked_bar_chart.dart      # 新規: 睡眠用積み上げ棒グラフ
│   └── weekly/
│       ├── weekly_step_view.dart              # 新規
│       ├── weekly_sleep_view.dart             # 新規
│       ├── weekly_heart_rate_view.dart        # 新規
│       ├── weekly_calories_view.dart          # 新規
│       └── weekly_swimming_view.dart          # 新規
├── providers/
│   └── provider_setup.dart                    # 拡張: 週間ViewModel登録
└── main.dart                                  # 拡張: ルート追加

test/
├── view_models/
│   └── weekly/                                # オプション: ViewModelテスト
└── repositories/                              # オプション: Repositoryテスト
```

**Structure Decision**: 既存のFlutter MVVM + Repositoryパターンに従い、週間データ用のViewModel、View、Repositoryメソッドを追加

## Complexity Tracking

*Constitution違反なし - 追記不要*
