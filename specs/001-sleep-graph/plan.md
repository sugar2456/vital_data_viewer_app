# 実装計画: Fitbit睡眠データの可視化

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17 | **仕様書**: [spec.md](spec.md)  
**入力**: 機能仕様書 `/specs/001-sleep-graph/spec.md`

## 概要

Fitbit Web APIから取得した睡眠データ（stages形式とclassic形式の両方）をグラフで可視化し、ユーザーがカレンダーで日付を選択して過去の睡眠パターンを確認できる機能を実装します。既存のFlutterアプリケーションに新しいビュー、ViewModel、Repositoryを追加し、MVVMアーキテクチャとProviderパターンを活用します。

## 技術コンテキスト

**言語/バージョン**: Dart 3.5.4 / Flutter (SDK: flutter)  
**主要な依存関係**:
- `provider: ^6.1.2` (状態管理)
- `fl_chart: ^0.70.2` (グラフ描画)
- `http: ^1.2.2` (API通信)
- `intl: ^0.19.0` (日付フォーマット)

**ストレージ**: N/A (APIから取得したデータをメモリ内で管理)  
**テスト**: `flutter_test` (SDKに含まれる), `mockito: ^5.4.5`  
**ターゲットプラットフォーム**: macOS, Windows (デスクトップアプリ)  
**プロジェクトタイプ**: モバイル/デスクトップアプリケーション  
**パフォーマンス目標**: グラフ描画が60fps、データ取得時のローディング表示  
**制約**: Fitbit APIのレスポンス時間に依存、ネットワーク接続必須  
**規模/スコープ**:
- 新規ビュー: 1画面
- 新規ViewModel: 1クラス
- 新規Repository: 睡眠データ取得機能の拡張
- グラフコンポーネント: 1つ（カスタムチャート）

## Constitution Check

*ゲート: Phase 0の調査前に合格必須。Phase 1の設計後に再チェック。*

**注**: プロジェクトに固有のconstitutionファイルがテンプレート状態のため、一般的なFlutter/Dartのベストプラクティスに従います：

✅ **MVVM アーキテクチャ**: 既存コードベースと一貫性を保つ  
✅ **Provider パターン**: 既存の状態管理手法を継続  
✅ **Repository パターン**: 既存のデータアクセスパターンを継続  
✅ **単体テスト**: mockitoを使用したViewModel及びRepositoryのテスト  
✅ **既存コンポーネントの再利用**: `custom_drawer.dart`, `error_dialog.dart`など

## プロジェクト構造

### ドキュメント（この機能）

```text
specs/001-sleep-graph/
├── spec.md              # 機能仕様書
├── plan.md              # このファイル (/speckit.plan コマンド出力)
├── research.md          # Phase 0 出力 (/speckit.plan コマンド)
├── data-model.md        # Phase 1 出力 (/speckit.plan コマンド)
├── quickstart.md        # Phase 1 出力 (/speckit.plan コマンド)
├── contracts/           # Phase 1 出力 (/speckit.plan コマンド)
└── tasks.md             # Phase 2 出力 (/speckit.tasks コマンド)
```

### ソースコード（リポジトリルート）

```text
lib/
├── models/
│   └── response/
│       └── sleep_log_response.dart  # 既存
├── repositories/
│   ├── interfaces/
│   │   └── sleep_repository_interface.dart  # 既存
│   └── impls/
│       └── sleep_repository_impl.dart  # 既存（日付指定メソッド追加）
├── view_models/
│   └── sleep_view_model.dart  # 新規作成
├── views/
│   └── sleep_view.dart  # 新規作成
└── views/component/
    └── sleep_stage_chart.dart  # 新規作成

test/
├── view_models/
│   └── sleep_view_model_test.dart  # 新規作成
└── repositories/
    └── sleep_repository_impl_test.dart  # 既存テストの拡張
```

**構造の決定**: 既存のFlutterプロジェクト構造に従い、MVVMアーキテクチャを維持します。

## Phase 0: アウトライン & 調査

調査結果の詳細は `research.md` に記載します。

## Phase 1: 設計 & 契約

詳細は以下のファイルに記載します：
- データモデル: `data-model.md`
- API契約: `contracts/`
- クイックスタート: `quickstart.md`

## 次のステップ

1. Phase 0の調査を完了し、`research.md` を作成 ✅
2. Phase 1の設計を完了し、`data-model.md`, `contracts/`, `quickstart.md` を作成 ✅
3. `/speckit.tasks` コマンドで `tasks.md` を生成し、実装タスクを作成

---

**ステータス**: Phase 1 完了
