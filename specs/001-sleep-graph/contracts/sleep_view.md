# View 契約: SleepView

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17

## 概要

この文書は、睡眠データ表示画面のメインビューの契約を定義します。

## クラス定義

### SleepView

**ファイル**: `lib/views/sleep_view.dart`

```dart
class SleepView extends StatelessWidget {
  const SleepView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠データ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(context),
          ),
        ],
      ),
      body: Consumer<SleepViewModel>(
        builder: (context, viewModel, child) {
          // 状態に応じた表示
        },
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context);
}
```

## UI構造

```
Scaffold
├── AppBar
│   ├── タイトル: "睡眠データ"
│   └── Actions
│       └── カレンダーアイコンボタン (右側)
└── Body (Consumer<SleepViewModel>)
    ├── ローディング状態
    │   └── Center(CircularProgressIndicator)
    ├── エラー状態
    │   └── Center(Text: errorMessage)
    ├── データなし状態
    │   └── Center(Text: "選択した日付の睡眠データがありません")
    └── データあり状態
        ├── 日付表示 (Padding + Text)
        ├── トータル睡眠時間 (Card)
        └── グラフ (SleepStageChart)
```

## 状態別UI

### 1. ローディング状態 (`isLoading == true`)

```dart
if (viewModel.isLoading) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
```

### 2. エラー状態 (`errorMessage != null`)

```dart
if (viewModel.errorMessage != null) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            viewModel.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
```

### 3. データなし状態 (`sleepChartData == null && !isLoading`)

```dart
if (!viewModel.hasData) {
  return const Center(
    child: Text(
      '選択した日付の睡眠データがありません',
      style: TextStyle(fontSize: 16),
    ),
  );
}
```

### 4. データあり状態

```dart
return SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 日付表示
      Text(
        DateFormat('yyyy年MM月dd日').format(viewModel.selectedDate),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 16),
      
      // トータル睡眠時間カード
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.bedtime, size: 32),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('トータル睡眠時間'),
                  Text(
                    viewModel.sleepChartData!.formattedTotalSleep,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      
      // グラフ
      SizedBox(
        height: 300,
        child: SleepStageChart(data: viewModel.sleepChartData!),
      ),
    ],
  ),
);
```

## 日付ピッカーの実装

### _showDatePicker メソッド

```dart
Future<void> _showDatePicker(BuildContext context) async {
  final viewModel = context.read<SleepViewModel>();
  
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: viewModel.selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(), // 未来の日付を選択できないようにする
    locale: const Locale('ja', 'JP'),
  );
  
  if (selectedDate != null && context.mounted) {
    await viewModel.fetchSleepData(selectedDate);
  }
}
```

## 初期化

### initState での自動ロード

StatelessWidgetの代わりにStatefulWidgetを使用する場合：

```dart
class SleepView extends StatefulWidget {
  const SleepView({Key? key}) : super(key: key);

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
  @override
  void initState() {
    super.initState();
    // 初回ロード
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepViewModel>().fetchTodaySleepData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

## ナビゲーション統合

### custom_drawer.dart への追加

```dart
ListTile(
  leading: const Icon(Icons.bedtime),
  title: const Text('睡眠データ'),
  onTap: () {
    Navigator.pop(context); // ドロワーを閉じる
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SleepView()),
    );
  },
),
```

## テーマとスタイリング

### 推奨スタイル

- **パディング**: 16.0 (標準)、24.0 (セクション間)
- **カードの標準的な使用**: 重要な情報（トータル睡眠時間）を強調
- **アイコンサイズ**: 32 (情報カード内)、64 (エラー表示)
- **グラフの高さ**: 300 (固定)

## アクセシビリティ

- カレンダーアイコンに適切なtooltipを追加: `tooltip: '日付を選択'`
- エラーメッセージは読み上げ可能
- ローディングインジケータにSemantics追加

```dart
IconButton(
  icon: const Icon(Icons.calendar_today),
  tooltip: '日付を選択',
  onPressed: () => _showDatePicker(context),
)
```

## エラーハンドリング

### 認証エラー

ViewModelから認証エラーが返された場合、ログイン画面に遷移：

```dart
if (viewModel.errorMessage?.contains('認証') ?? false) {
  // ログイン画面への遷移を促す
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('認証エラー'),
      content: const Text('再度ログインしてください'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // ログイン画面へ遷移
          },
          child: const Text('ログイン'),
        ),
      ],
    ),
  );
}
```

## テスト

**ファイル**: `test/views/sleep_view_test.dart`

テスト項目：
1. 初回表示時に今日のデータを取得する
2. ローディング状態でCircularProgressIndicatorが表示される
3. データがある場合、グラフとトータル睡眠時間が表示される
4. データがない場合、適切なメッセージが表示される
5. カレンダーアイコンタップで日付ピッカーが開く
6. 日付選択後、ViewModelのfetchSleepDataが呼ばれる
