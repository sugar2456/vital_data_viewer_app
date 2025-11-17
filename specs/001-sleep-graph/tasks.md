# Tasks: Fitbit睡眠データの可視化

**入力**: 設計ドキュメント `/specs/001-sleep-graph/`
**前提条件**: plan.md, spec.md, data-model.md, contracts/, research.md, quickstart.md

**テスト**: spec.mdでテストが要求されているため、テストタスクを含みます。

**組織**: タスクはユーザーストーリーごとにグループ化され、各ストーリーを独立して実装およびテストできるようにします。

## フォーマット: `[ID] [P?] [Story] 説明`

- **[P]**: 並列実行可能（異なるファイル、依存関係なし）
- **[Story]**: このタスクが属するユーザーストーリー（例: US1, US2, US3, US4）
- 説明には正確なファイルパスを含む

## パス規則

Flutter プロジェクト構造:
- ソースコード: `lib/`
- テスト: `test/`
- すべてのパスはリポジトリルートからの相対パス

---

## Phase 1: Setup（共有インフラストラクチャ）

**目的**: データモデルとヘルパークラスの作成

- [x] T001 [P] SleepType enum を lib/view_models/sleep_chart_data.dart に作成
- [x] T002 [P] SleepChartData モデルを lib/view_models/sleep_chart_data.dart に作成（formattedTotalSleep getter を含む）
- [x] T003 [P] SleepStageSegment モデルを lib/view_models/sleep_chart_data.dart に作成

**チェックポイント**: データモデルの準備完了

---

## Phase 2: Foundational（ブロッキング前提条件）

**目的**: すべてのユーザーストーリーが依存するコアインフラストラクチャ

**⚠️ 重要**: このフェーズが完了するまで、ユーザーストーリーの作業は開始できません

- [x] T004 fetchSleepLogByDate(String date) メソッドを lib/repositories/interfaces/sleep_repository_interface.dart に追加
- [x] T005 fetchSleepLogByDate メソッドを lib/repositories/impls/sleep_repository_impl.dart に実装（日付バリデーション、Fitbit API 呼び出し、エラーハンドリングを含む）
- [x] T006 _isValidDateFormat ヘルパーメソッドを lib/repositories/impls/sleep_repository_impl.dart に追加
- [x] T007 [P] fetchSleepLogByDate の単体テストを test/repositories/sleep_repository_impl_test.dart に作成（正常ケース、不正な日付形式、API エラーをカバー）

**チェックポイント**: 基盤の準備完了 - ユーザーストーリーの実装を並列開始可能

---

## Phase 3: User Story 1 - 今日の睡眠データを表示 (優先度: P1) 🎯 MVP

**ゴール**: ユーザーが睡眠可視化画面を開いたときに、今日の睡眠データをグラフ形式で表示する

**独立テスト**: 睡眠可視化画面を開き、今日の睡眠データが縦軸に睡眠ステージ、横軸に時刻を持つグラフで表示されることを確認

### User Story 1 のテスト

> **注意: これらのテストを最初に記述し、実装前に失敗することを確認してください**

- [ ] T008 [P] [US1] SleepViewModel の単体テストを test/view_models/sleep_view_model_test.dart に作成（データ取得成功ケースをカバー）
- [ ] T009 [P] [US1] SleepViewModel のエラーケーステストを test/view_models/sleep_view_model_test.dart に追加（データなし、API エラーをカバー）
- [ ] T010 [P] [US1] SleepViewModel のローディング状態テストを test/view_models/sleep_view_model_test.dart に追加

### User Story 1 の実装

- [x] T011 [US1] SleepViewModel クラスを lib/view_models/sleep_view_model.dart に作成（状態プロパティ: selectedDate, sleepChartData, isLoading, errorMessage）
- [x] T012 [US1] fetchTodaySleepData メソッドを lib/view_models/sleep_view_model.dart に実装（Repository 呼び出しとエラーハンドリングを含む）
- [x] T013 [US1] _convertToChartData プライベートメソッドを lib/view_models/sleep_view_model.dart に実装（SleepLogResponse を SleepChartData に変換、stages 形式と classic 形式の両方をサポート）
- [x] T014 [US1] _getStageColor ヘルパーメソッドを lib/view_models/sleep_view_model.dart に実装（stages: deep→blue[900], light→blue[300], rem→purple, wake→orange; classic: asleep→blue, restless→yellow, awake→red）
- [x] T015 [US1] SleepView StatefulWidget を lib/views/sleep_view.dart に作成（Scaffold、AppBar、Consumer<SleepViewModel> を含む）
- [x] T016 [US1] initState で fetchTodaySleepData を呼び出すように lib/views/sleep_view.dart を実装
- [x] T017 [US1] ローディング状態 UI（CircularProgressIndicator）を lib/views/sleep_view.dart に実装
- [x] T018 [US1] エラー状態 UI（エラーアイコンとメッセージ）を lib/views/sleep_view.dart に実装
- [x] T019 [US1] データなし状態 UI（「選択した日付の睡眠データがありません」メッセージ）を lib/views/sleep_view.dart に実装
- [x] T020 [US1] SleepViewModel を MultiProvider に lib/main.dart で登録
- [x] T021 [US1] 「睡眠データ」への ListTile ナビゲーションを lib/views/component/custom_drawer.dart に追加

**チェックポイント**: この時点で、User Story 1 は完全に機能し、独立してテスト可能です

---

## Phase 4: User Story 3 - 睡眠ステージの可視化を理解する (優先度: P1)

**ゴール**: 各睡眠ステージを明確なラベルと色で区別してグラフに表示する

**独立テスト**: 睡眠グラフを表示し、各睡眠ステージが明確にラベル付けされ、色で視覚的に区別できることを確認

**注意**: US1 と組み合わせて、完全なグラフ表示機能を提供します

### User Story 3 のテスト

- [ ] T022 [P] [US3] SleepStageChart の Widget テストを test/views/component/sleep_stage_chart_test.dart に作成（stages 形式と classic 形式の両方をカバー）
- [ ] T023 [P] [US3] グラフの色マッピングテストを test/views/component/sleep_stage_chart_test.dart に追加

### User Story 3 の実装

- [x] T024 [P] [US3] SleepStageChart StatelessWidget を lib/views/component/sleep_stage_chart.dart に作成（BarChart を使用）
- [x] T025 [US3] _buildBarChartData メソッドを lib/views/component/sleep_stage_chart.dart に実装（BarChartData 設定を含む）
- [x] T026 [US3] _buildBarGroups メソッドを lib/views/component/sleep_stage_chart.dart に実装（各セグメントを BarChartGroupData に変換）
- [x] T027 [US3] _getStageValue メソッドを lib/views/component/sleep_stage_chart.dart に実装（ステージ名を Y 軸値に変換）
- [x] T028 [US3] _getStageLabel メソッドを lib/views/component/sleep_stage_chart.dart に実装（Y 軸値を日本語ラベルに変換）
- [x] T029 [US3] _getLeftTitles メソッドを lib/views/component/sleep_stage_chart.dart に実装（Y 軸ラベル表示）
- [x] T030 [US3] _getBottomTitles メソッドを lib/views/component/sleep_stage_chart.dart に実装（X 軸の時刻ラベル、1時間ごと）
- [x] T031 [US3] ツールチップ設定を lib/views/component/sleep_stage_chart.dart に実装（ステージ名と継続時間を表示）
- [x] T032 [US3] _formatDuration ヘルパーメソッドを lib/views/component/sleep_stage_chart.dart に実装（分を「X時間Y分」形式に変換）
- [x] T033 [US3] _buildLegend メソッドを lib/views/component/sleep_stage_chart.dart に実装（凡例表示）
- [x] T034 [US3] データあり状態 UI を lib/views/sleep_view.dart に実装（日付表示、SleepStageChart ウィジェットの統合）

**チェックポイント**: User Story 1 と 3 が完全に動作し、今日の睡眠データがグラフで表示される

---

## Phase 5: User Story 4 - トータル睡眠時間を確認 (優先度: P1)

**ゴール**: 選択した日付のトータル睡眠時間を一目で確認できるように表示する

**独立テスト**: 睡眠可視化画面を開き、画面上にトータル睡眠時間（例: "7時間30分"）が表示されることを確認

### User Story 4 の実装

- [x] T035 [US4] トータル睡眠時間カード UI を lib/views/sleep_view.dart に実装（Card ウィジェット、アイコン、formattedTotalSleep 表示を含む）
- [ ] T036 [US4] formattedTotalSleep が正しく計算されることを test/view_models/sleep_view_model_test.dart でテスト

**チェックポイント**: トータル睡眠時間がグラフと一緒に表示される

---

## Phase 6: User Story 2 - カレンダーで過去の睡眠データを選択 (優先度: P2)

**ゴール**: ユーザーがカレンダーアイコンをタップして過去の日付を選択し、その日の睡眠データを表示する

**独立テスト**: カレンダーアイコンをタップし、過去の日付を選択し、グラフがその日付のデータに更新されることを確認

### User Story 2 のテスト

- [ ] T037 [P] [US2] fetchSleepData(DateTime) のテストを test/view_models/sleep_view_model_test.dart に追加（日付選択と状態更新をカバー）

### User Story 2 の実装

- [x] T038 [US2] fetchSleepData(DateTime date) メソッドを lib/view_models/sleep_view_model.dart に実装（日付を YYYY-MM-DD 形式に変換、Repository 呼び出し、データ変換を含む）
- [x] T039 [US2] カレンダーアイコンボタンを lib/views/sleep_view.dart の AppBar に追加
- [x] T040 [US2] _showDatePicker メソッドを lib/views/sleep_view.dart に実装（showDatePicker 呼び出し、lastDate を今日に設定、firstDate を 2000-01-01 に設定、ロケールを 'ja' に設定）
- [x] T041 [US2] 日付選択後に viewModel.fetchSleepData を呼び出すように lib/views/sleep_view.dart を実装
- [x] T042 [US2] 選択した日付を画面に表示するように lib/views/sleep_view.dart を更新（DateFormat('yyyy年MM月dd日') を使用）

**チェックポイント**: すべてのユーザーストーリーが独立して機能する

---

## Phase 7: Polish & Cross-Cutting Concerns

**目的**: 複数のユーザーストーリーに影響する改善

- [ ] T043 [P] stages 形式と classic 形式の両方のデータ変換を test/view_models/sleep_view_model_test.dart でテスト
- [x] T044 [P] アクセシビリティの改善を lib/views/sleep_view.dart に追加（カレンダーアイコンに tooltip: '日付を選択' を追加）
- [ ] T045 [P] アクセシビリティの改善を lib/views/sleep_view.dart に追加（ローディングインジケータに Semantics を追加）
- [ ] T046 認証エラーハンドリングを lib/views/sleep_view.dart に追加（認証エラー時にダイアログ表示）
- [ ] T047 [P] 複数の睡眠セッション処理を lib/view_models/sleep_view_model.dart でテスト（メインセッションを選択）
- [x] T048 [P] エッジケースの処理を lib/view_models/sleep_view_model.dart に追加（不完全なデータ、空のレスポンス）
- [ ] T049 quickstart.md の検証手順を実行（flutter run、ログイン、睡眠データ画面への遷移、グラフ表示、カレンダー選択をテスト）
- [x] T050 [P] コードフォーマットとリントを実行（flutter format lib/ test/、flutter analyze）

---

## 依存関係 & 実行順序

### フェーズ依存関係

- **Setup (Phase 1)**: 依存関係なし - すぐに開始可能
- **Foundational (Phase 2)**: Setup 完了に依存 - すべてのユーザーストーリーをブロック
- **User Stories (Phase 3-6)**: すべて Foundational フェーズ完了に依存
  - ユーザーストーリーはその後並列進行可能（スタッフが十分な場合）
  - または優先順位順に順次進行（P1 → P1 → P1 → P2）
- **Polish (Phase 7)**: すべての望ましいユーザーストーリーの完了に依存

### ユーザーストーリー依存関係

- **User Story 1 (P1)**: Foundational (Phase 2) 完了後に開始可能 - 他のストーリーへの依存なし
- **User Story 3 (P1)**: Foundational (Phase 2) 完了後に開始可能 - US1 のグラフ表示に統合
- **User Story 4 (P1)**: Foundational (Phase 2) 完了後に開始可能 - US1 の UI に統合
- **User Story 2 (P2)**: Foundational (Phase 2) 完了後に開始可能 - US1 のデータ取得ロジックを拡張

**注意**: US1、US3、US4 はすべて P1 であり、組み合わせて基本的な睡眠データ表示機能を提供します。US2 は P2 であり、日付選択機能を追加します。

### 各ユーザーストーリー内

- テスト（含まれる場合）は実装前に記述し、失敗することを確認
- モデルの後にサービス
- サービスの後にエンドポイント
- コア実装の後に統合
- 次の優先順位に移る前にストーリーを完成

### 並列実行の機会

- Setup の [P] タスクはすべて並列実行可能
- Foundational の [P] タスクはすべて並列実行可能（Phase 2 内）
- Foundational フェーズ完了後、すべてのユーザーストーリーを並列開始可能（チームキャパシティが許せば）
- ユーザーストーリーの [P] テストはすべて並列実行可能
- ストーリー内の [P] モデルはすべて並列実行可能
- 異なるユーザーストーリーは異なるチームメンバーによって並列作業可能

---

## 並列実行例: User Story 1

```bash
# User Story 1 のすべてのテストを一緒に起動:
Task: "SleepViewModel の単体テストを test/view_models/sleep_view_model_test.dart に作成"
Task: "SleepViewModel のエラーケーステストを test/view_models/sleep_view_model_test.dart に追加"
Task: "SleepViewModel のローディング状態テストを test/view_models/sleep_view_model_test.dart に追加"

# User Story 1 のすべてのモデルを一緒に起動（Setup で既に完了）:
# （データモデルは Setup フェーズで作成済み）
```

## 並列実行例: User Story 3

```bash
# User Story 3 のすべてのテストを一緒に起動:
Task: "SleepStageChart の Widget テストを test/views/component/sleep_stage_chart_test.dart に作成"
Task: "グラフの色マッピングテストを test/views/component/sleep_stage_chart_test.dart に追加"

# User Story 3 の並列実装タスク:
Task: "SleepStageChart StatelessWidget を lib/views/component/sleep_stage_chart.dart に作成"
```

---

## 実装戦略

### MVP First（User Story 1 + 3 + 4 のみ）

1. Phase 1: Setup を完了
2. Phase 2: Foundational を完了（重要 - すべてのストーリーをブロック）
3. Phase 3: User Story 1 を完了
4. Phase 4: User Story 3 を完了
5. Phase 5: User Story 4 を完了
6. **停止して検証**: User Story 1、3、4 を独立してテスト
7. 準備ができたらデプロイ/デモ

この時点で、ユーザーは今日の睡眠データをグラフで確認し、トータル睡眠時間を確認できます（MVP！）

### インクリメンタルデリバリー

1. Setup + Foundational を完了 → 基盤準備完了
2. User Story 1 + 3 + 4 を追加 → 独立してテスト → デプロイ/デモ（MVP！）
3. User Story 2 を追加 → 独立してテスト → デプロイ/デモ（日付選択機能追加）
4. 各ストーリーは以前のストーリーを壊すことなく価値を追加

### 並列チーム戦略

複数の開発者がいる場合:

1. チームで Setup + Foundational を一緒に完了
2. Foundational 完了後:
   - 開発者 A: User Story 1（データ取得と基本 UI）
   - 開発者 B: User Story 3（グラフコンポーネント）
   - 開発者 C: User Story 4（トータル睡眠時間表示）
   - 開発者 D: User Story 2（日付選択）
3. ストーリーは独立して完成し、統合

---

## 注意

- [P] タスク = 異なるファイル、依存関係なし
- [Story] ラベルはタスクを特定のユーザーストーリーにマッピング（トレーサビリティのため）
- 各ユーザーストーリーは独立して完成・テスト可能
- 実装前にテストが失敗することを確認
- 各タスクまたは論理グループ後にコミット
- 任意のチェックポイントで停止してストーリーを独立して検証
- 避けるべきこと: 曖昧なタスク、同じファイルの競合、独立性を壊すストーリー間の依存関係

---

## タスク概要

- **合計タスク数**: 50
- **User Story 1 のタスク数**: 14（テスト 3、実装 11）
- **User Story 3 のタスク数**: 13（テスト 2、実装 11）
- **User Story 4 のタスク数**: 2（実装 2）
- **User Story 2 のタスク数**: 6（テスト 1、実装 5）
- **Setup タスク**: 3
- **Foundational タスク**: 4
- **Polish タスク**: 8

### 並列実行機会

- Setup: 3 タスク並列実行可能
- Foundational: 2 タスク並列実行可能
- User Story 1: 3 テストタスク並列実行可能
- User Story 3: 3 タスク並列実行可能
- User Story 2: 1 タスク並列実行可能
- Polish: 6 タスク並列実行可能

### 推奨 MVP スコープ

**MVP = User Story 1 + User Story 3 + User Story 4**（今日の睡眠データをグラフで表示、トータル睡眠時間表示）

これにより、ユーザーは基本的な睡眠データ可視化機能を即座に使用でき、User Story 2（日付選択）は後で追加できます。

### フォーマット検証

✅ すべてのタスクはチェックリスト形式に従います:
- チェックボックス (`- [ ]`)
- タスク ID (T001, T002, ...)
- [P] マーカー（並列実行可能な場合）
- [Story] ラベル（ユーザーストーリーフェーズのタスクに必須）
- ファイルパスを含む明確な説明
