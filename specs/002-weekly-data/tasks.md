# Tasks: 直近一週間のデータ参照機能

**Input**: Design documents from `/specs/002-weekly-data/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/repository-contracts.md, quickstart.md

**Tests**: テストタスクは仕様に明示されていないため、オプションとして含めています。

**Organization**: タスクはユーザーストーリーごとにグループ化され、各ストーリーを独立して実装・テスト可能です。

## Format: `[ID] [P?] [Story] Description`

- **[P]**: 並列実行可能（異なるファイル、依存関係なし）
- **[Story]**: タスクが属するユーザーストーリー（US1, US2, etc.）
- 説明には正確なファイルパスを含む

---

## Phase 1: Setup（共有インフラ）

**Purpose**: プロジェクト初期化と基本構造

- [ ] T001 Create directory structure `lib/view_models/weekly/`
- [ ] T002 [P] Create directory structure `lib/views/weekly/`

---

## Phase 2: Foundational（ブロッキング前提条件）

**Purpose**: すべてのユーザーストーリー実装前に完了が必要なコアインフラ

**⚠️ CRITICAL**: このフェーズが完了するまでユーザーストーリーの作業は開始できません

### 2.1 APIレスポンスモデル作成

- [ ] T003 [P] Create StepsRangeResponse model in `lib/models/response/steps_range_response.dart`
- [ ] T004 [P] Create CaloriesRangeResponse model in `lib/models/response/calories_range_response.dart`
- [ ] T005 [P] Create SleepRangeResponse model in `lib/models/response/sleep_range_response.dart`
- [ ] T006 [P] Create HeartRateRangeResponse model in `lib/models/response/heart_rate_range_response.dart`
- [ ] T007 [P] Create SwimmingRangeResponse model in `lib/models/response/swimming_range_response.dart`

### 2.2 Repositoryインターフェース拡張

- [ ] T008 [P] Add `fetchStepsByDateRange()` method to `lib/repositories/interfaces/step_repository_interface.dart`
- [ ] T009 [P] Add `fetchSleepByDateRange()` method to `lib/repositories/interfaces/sleep_repository_interface.dart`
- [ ] T010 [P] Add `fetchHeartRateByDateRange()` method to `lib/repositories/interfaces/heart_rate_repository_interface.dart`
- [ ] T011 [P] Add `fetchCaloriesByDateRange()` method to `lib/repositories/interfaces/calories_repository_interface.dart`
- [ ] T012 [P] Add `fetchSwimmingByDateRange()` method to `lib/repositories/interfaces/swimming_repository_interface.dart`

### 2.3 Repository実装拡張

- [ ] T013 Implement `fetchStepsByDateRange()` in `lib/repositories/impls/step_repository_impl.dart` (depends on T003, T008)
- [ ] T014 Implement `fetchSleepByDateRange()` in `lib/repositories/impls/sleep_repository_impl.dart` (depends on T005, T009)
- [ ] T015 Implement `fetchHeartRateByDateRange()` in `lib/repositories/impls/heart_rate_repository_impl.dart` (depends on T006, T010)
- [ ] T016 Implement `fetchCaloriesByDateRange()` in `lib/repositories/impls/calories_repository_impl.dart` (depends on T004, T011)
- [ ] T017 Implement `fetchSwimmingByDateRange()` in `lib/repositories/impls/swimming_repository_impl.dart` (depends on T007, T012)

### 2.4 共通UIコンポーネント

- [ ] T018 Create WeeklyBarChart widget in `lib/views/component/weekly_bar_chart.dart` (fl_chart BarChart使用)

**Checkpoint**: 基盤完了 - ユーザーストーリー実装開始可能

---

## Phase 3: User Story 1 - 週間歩数データの確認 (Priority: P1) 🎯 MVP

**Goal**: メニューから週間歩数画面に遷移し、直近7日間の歩数データを棒グラフで表示する

**Independent Test**: 歩数画面で過去7日間のデータが棒グラフ形式で表示され、各日の歩数が確認できる

### Implementation for User Story 1

- [ ] T019 [US1] Create WeeklyStepsViewModel in `lib/view_models/weekly/weekly_steps_view_model.dart`
- [ ] T020 [US1] Create WeeklyStepView in `lib/views/weekly/weekly_step_view.dart`
- [ ] T021 [US1] Register WeeklyStepsViewModel provider in `lib/providers/provider_setup.dart`
- [ ] T022 [US1] Add route for weekly step view in `lib/main.dart`
- [ ] T023 [US1] Add "週間歩数" menu item to `lib/views/component/custom_drawer.dart`

**Checkpoint**: User Story 1（週間歩数）が完全に機能し、独立してテスト可能

---

## Phase 4: User Story 2 - 週間睡眠データの確認 (Priority: P1)

**Goal**: メニューから週間睡眠画面に遷移し、直近7日間の睡眠データを積み上げ棒グラフで表示する

**Independent Test**: 睡眠画面で過去7日間の睡眠データが表示され、各日の総睡眠時間と睡眠ステージ（深い睡眠、浅い睡眠、レム睡眠、覚醒）の内訳が確認できる

### Implementation for User Story 2

- [ ] T024 [US2] Create WeeklyStackedBarChart widget for sleep stages in `lib/views/component/weekly_stacked_bar_chart.dart`
- [ ] T025 [US2] Create WeeklySleepViewModel in `lib/view_models/weekly/weekly_sleep_view_model.dart`
- [ ] T026 [US2] Create WeeklySleepView in `lib/views/weekly/weekly_sleep_view.dart` (積み上げ棒グラフ使用)
- [ ] T027 [US2] Register WeeklySleepViewModel provider in `lib/providers/provider_setup.dart`
- [ ] T028 [US2] Add route for weekly sleep view in `lib/main.dart`
- [ ] T029 [US2] Add "週間睡眠" menu item to `lib/views/component/custom_drawer.dart`

**Checkpoint**: User Story 1 AND 2 がどちらも独立して機能する

---

## Phase 5: User Story 3 - 週間心拍数データの確認 (Priority: P2)

**Goal**: メニューから週間心拍数画面に遷移し、直近7日間の心拍数データを棒グラフで表示する

**Independent Test**: 心拍数画面で過去7日間のデータが表示され、各日の安静時心拍数が確認できる

### Implementation for User Story 3

- [ ] T030 [US3] Create WeeklyHeartRateViewModel in `lib/view_models/weekly/weekly_heart_rate_view_model.dart`
- [ ] T031 [US3] Create WeeklyHeartRateView in `lib/views/weekly/weekly_heart_rate_view.dart`
- [ ] T032 [US3] Register WeeklyHeartRateViewModel provider in `lib/providers/provider_setup.dart`
- [ ] T033 [US3] Add route for weekly heart rate view in `lib/main.dart`
- [ ] T034 [US3] Add "週間心拍数" menu item to `lib/views/component/custom_drawer.dart`

**Checkpoint**: User Story 1, 2, 3 がすべて独立して機能する

---

## Phase 6: User Story 4 - 週間消費カロリーデータの確認 (Priority: P2)

**Goal**: メニューから週間カロリー画面に遷移し、直近7日間の消費カロリーデータを棒グラフで表示する

**Independent Test**: カロリー画面で過去7日間のデータが表示され、各日の消費カロリーが確認できる

### Implementation for User Story 4

- [ ] T035 [US4] Create WeeklyCaloriesViewModel in `lib/view_models/weekly/weekly_calories_view_model.dart`
- [ ] T036 [US4] Create WeeklyCaloriesView in `lib/views/weekly/weekly_calories_view.dart`
- [ ] T037 [US4] Register WeeklyCaloriesViewModel provider in `lib/providers/provider_setup.dart`
- [ ] T038 [US4] Add route for weekly calories view in `lib/main.dart`
- [ ] T039 [US4] Add "週間カロリー" menu item to `lib/views/component/custom_drawer.dart`

**Checkpoint**: User Story 1, 2, 3, 4 がすべて独立して機能する

---

## Phase 7: User Story 5 - 週間水泳ストロークデータの確認 (Priority: P3)

**Goal**: メニューから週間水泳画面に遷移し、直近7日間の水泳ストロークデータを棒グラフで表示する

**Independent Test**: 水泳画面で過去7日間のデータが表示され、各日の水泳ストローク数が確認できる

### Implementation for User Story 5

- [ ] T040 [US5] Create WeeklySwimmingViewModel in `lib/view_models/weekly/weekly_swimming_view_model.dart`
- [ ] T041 [US5] Create WeeklySwimmingView in `lib/views/weekly/weekly_swimming_view.dart`
- [ ] T042 [US5] Register WeeklySwimmingViewModel provider in `lib/providers/provider_setup.dart`
- [ ] T043 [US5] Add route for weekly swimming view in `lib/main.dart`
- [ ] T044 [US5] Add "週間水泳" menu item to `lib/views/component/custom_drawer.dart`

**Checkpoint**: すべてのユーザーストーリーが独立して機能する

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: 複数のユーザーストーリーに影響する改善

- [ ] T045 Verify all weekly views display "データなし" for days without data
- [ ] T046 Verify loading state is displayed during data fetch
- [ ] T047 Verify error handling and retry option works correctly
- [ ] T048 Verify weekly data loads within 5 seconds (performance requirement)
- [ ] T049 Run quickstart.md acceptance criteria checklist validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: 依存関係なし - 即時開始可能
- **Foundational (Phase 2)**: Setup完了に依存 - すべてのユーザーストーリーをブロック
- **User Stories (Phase 3-7)**: Foundational phase完了に依存
  - ユーザーストーリーは並列実行可能（リソースがあれば）
  - または優先度順に順次実行（P1 → P2 → P3）
- **Polish (Phase 8)**: 必要なユーザーストーリーすべての完了に依存

### User Story Dependencies

- **User Story 1 (P1)**: Foundational (Phase 2) 完了後開始可能 - 他のストーリーに依存しない
- **User Story 2 (P1)**: Foundational (Phase 2) 完了後開始可能 - 他のストーリーに依存しない
- **User Story 3 (P2)**: Foundational (Phase 2) 完了後開始可能 - 他のストーリーに依存しない
- **User Story 4 (P2)**: Foundational (Phase 2) 完了後開始可能 - 他のストーリーに依存しない
- **User Story 5 (P3)**: Foundational (Phase 2) 完了後開始可能 - 他のストーリーに依存しない

### Within Each User Story

- ViewModel before View
- Provider registration before route
- Route before menu item
- ストーリー完了後、次の優先度へ移行

### Parallel Opportunities

- Phase 2のAPIレスポンスモデル (T003-T007) は並列実行可能
- Phase 2のリポジトリインターフェース拡張 (T008-T012) は並列実行可能
- Foundational phase完了後、すべてのユーザーストーリーを並列開始可能

---

## Parallel Example: Phase 2 Models

```bash
# Launch all API response models together:
Task: "Create StepsRangeResponse model in lib/models/response/steps_range_response.dart"
Task: "Create CaloriesRangeResponse model in lib/models/response/calories_range_response.dart"
Task: "Create SleepRangeResponse model in lib/models/response/sleep_range_response.dart"
Task: "Create HeartRateRangeResponse model in lib/models/response/heart_rate_range_response.dart"
Task: "Create SwimmingRangeResponse model in lib/models/response/swimming_range_response.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (週間歩数)
4. **STOP and VALIDATE**: User Story 1を独立してテスト
5. 準備ができればデプロイ/デモ

### Incremental Delivery

1. Setup + Foundational完了 → 基盤完了
2. Add User Story 1 → 独立テスト → デプロイ/デモ (MVP!)
3. Add User Story 2 → 独立テスト → デプロイ/デモ
4. Add User Story 3 → 独立テスト → デプロイ/デモ
5. Add User Story 4 → 独立テスト → デプロイ/デモ
6. Add User Story 5 → 独立テスト → デプロイ/デモ
7. 各ストーリーは前のストーリーを壊さずに価値を追加

---

## Notes

- [P] タスク = 異なるファイル、依存関係なし
- [Story] ラベルはタスクを特定のユーザーストーリーにマッピング
- 各ユーザーストーリーは独立して完了・テスト可能
- タスクまたは論理的なグループ後にコミット
- 任意のチェックポイントで停止し、ストーリーを独立して検証
- 避けるべき: 曖昧なタスク、同一ファイルの競合、独立性を壊すストーリー間依存関係
- **アーキテクチャ**: RepositoryはFitbit APIレスポンス型をそのまま返し、ViewModelでデータを加工
