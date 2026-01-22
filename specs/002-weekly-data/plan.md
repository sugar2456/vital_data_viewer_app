# Implementation Plan: 直近一週間のデータ参照機能

**Branch**: `002-weekly-data` | **Date**: 2026-01-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-weekly-data/spec.md`

## Summary

直近7日間の歩数、睡眠、心拍数、消費カロリー、水泳ストロークデータを棒グラフ形式で表示する機能を追加する。メニュー（ドロワー）から直接週間表示画面に遷移できるようにする。

## Technical Context

**Language/Version**: Dart 3.5.4 / Flutter SDK
**Primary Dependencies**: fl_chart (棒グラフ), provider (状態管理), http (API通信)
**Storage**: N/A (Fitbit APIからリアルタイム取得)
**Testing**: flutter_test, mockito
**Target Platform**: macOS, Windows (デスクトップアプリ)
**Project Type**: mobile (Flutterモバイル/デスクトップアプリ)
**Performance Goals**: 週間データの読み込み5秒以内
**Constraints**: Fitbit API利用、既存アーキテクチャ（MVVM + Repository）を維持
**Scale/Scope**: 5データ種別 × 週間表示 = 5画面の新規作成

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] 既存アーキテクチャ（MVVM + Repository パターン）に従う
- [x] 新規ライブラリ追加なし（fl_chartは既存）
- [x] テスト可能な設計（ViewModelのユニットテスト）
- [x] 単一責任の原則（週間専用ViewModel/Viewを新規作成）

## Project Structure

### Documentation (this feature)

```text
specs/002-weekly-data/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
lib/
├── models/
│   └── daily_summary/             # 新規：日別サマリーモデル
│       ├── daily_step_summary.dart
│       ├── daily_sleep_summary.dart
│       ├── daily_heart_rate_summary.dart
│       ├── daily_calories_summary.dart
│       └── daily_swimming_summary.dart
├── repositories/
│   ├── interfaces/                # 修正：期間指定メソッド追加
│   │   ├── step_repository_interface.dart
│   │   ├── sleep_repository_interface.dart
│   │   ├── heart_rate_repository_interface.dart
│   │   ├── calories_repository_interface.dart
│   │   └── swimming_repository_interface.dart
│   └── impls/                     # 修正：期間指定メソッド実装
│       ├── step_repository_impl.dart
│       ├── sleep_repository_impl.dart
│       ├── heart_rate_repository_impl.dart
│       ├── calories_repository_impl.dart
│       └── swimming_repository_impl.dart
├── view_models/
│   └── weekly/                    # 新規：週間専用ViewModel
│       ├── weekly_steps_view_model.dart
│       ├── weekly_sleep_view_model.dart
│       ├── weekly_heart_rate_view_model.dart
│       ├── weekly_calories_view_model.dart
│       └── weekly_swimming_view_model.dart
├── views/
│   └── weekly/                    # 新規：週間専用View
│       ├── weekly_step_view.dart
│       ├── weekly_sleep_view.dart
│       ├── weekly_heart_rate_view.dart
│       ├── weekly_calories_view.dart
│       └── weekly_swimming_view.dart
├── views/component/
│   ├── custom_drawer.dart         # 修正：週間メニュー項目追加
│   └── weekly_bar_chart.dart      # 新規：週間棒グラフコンポーネント
├── providers/
│   └── provider_setup.dart        # 修正：週間ViewModelのProvider追加
└── main.dart                      # 修正：週間画面のルート追加

test/
├── view_models/weekly/            # 週間ViewModelユニットテスト
└── repositories/                  # リポジトリユニットテスト
```

**Structure Decision**:
- リポジトリインターフェースに `fetchXxxByDateRange(startDate, endDate)` メソッドを追加
- 週間表示は日別表示とは独立した画面として実装
- メニュー（ドロワー）から直接アクセス可能
- 既存の日別画面は変更しない

## Complexity Tracking

該当なし（既存アーキテクチャの自然な拡張）
