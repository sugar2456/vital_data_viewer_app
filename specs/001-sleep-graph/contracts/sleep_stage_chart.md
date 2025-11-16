# Widget 契約: SleepStageChart

**ブランチ**: `001-sleep-graph` | **日付**: 2025-11-17

## 概要

この文書は、睡眠ステージグラフコンポーネントの契約を定義します。

## クラス定義

### SleepStageChart

**ファイル**: `lib/views/component/sleep_stage_chart.dart`

```dart
class SleepStageChart extends StatelessWidget {
  final SleepChartData data;

  const SleepStageChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        // 設定
      ),
    );
  }
}
```

## グラフ設計

### BarChart の使用理由

- 睡眠ステージは**離散的なカテゴリデータ**
- 時系列での変化を棒の並びで表現
- fl_chartの`BarChart`は横向き表示をサポート

### グラフの構造

```
┌─────────────────────────────────────────┐
│  Y軸: 睡眠ステージ                       │
│  wake    ████                            │
│  rem         ██████                      │
│  light           ████████████            │
│  deep                    ██████          │
│          ─────────────────────────────   │
│          22:00  0:00  2:00  4:00  6:00  │
│                   X軸: 時刻              │
└─────────────────────────────────────────┘
```

## fl_chart BarChartData の設定

### 基本設定

```dart
BarChartData(
  alignment: BarChartAlignment.spaceAround,
  maxY: 4, // stages形式の場合 (deep=0, light=1, rem=2, wake=3)
  barTouchData: BarTouchData(
    enabled: true,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.blueGrey,
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          '${_getStageLabel(rod.toY)}\n',
          const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: _formatDuration(data.stages[groupIndex].durationMinutes),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    ),
  ),
  titlesData: FlTitlesData(
    show: true,
    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: _getBottomTitles,
        reservedSize: 30,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: _getLeftTitles,
        reservedSize: 60,
      ),
    ),
  ),
  borderData: FlBorderData(show: false),
  barGroups: _buildBarGroups(),
  gridData: FlGridData(
    show: true,
    drawVerticalLine: true,
    horizontalInterval: 1,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.grey.withOpacity(0.3),
        strokeWidth: 1,
      );
    },
  ),
)
```

## データ変換

### _buildBarGroups メソッド

```dart
List<BarChartGroupData> _buildBarGroups() {
  return data.stages.asMap().entries.map((entry) {
    final index = entry.key;
    final segment = entry.value;
    
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: _getStageValue(segment.stage),
          color: segment.color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }).toList();
}
```

### _getStageValue メソッド

ステージ名をY軸の数値に変換：

```dart
double _getStageValue(String stage) {
  // stages形式
  if (data.sleepType == SleepType.stages) {
    switch (stage) {
      case 'deep':
        return 0;
      case 'light':
        return 1;
      case 'rem':
        return 2;
      case 'wake':
        return 3;
      default:
        return 0;
    }
  }
  
  // classic形式
  switch (stage) {
    case 'asleep':
      return 0;
    case 'restless':
      return 1;
    case 'awake':
      return 2;
    default:
      return 0;
  }
}
```

### _getStageLabel メソッド

Y軸の数値をラベルに変換：

```dart
String _getStageLabel(double value) {
  if (data.sleepType == SleepType.stages) {
    switch (value.toInt()) {
      case 0:
        return '深い睡眠';
      case 1:
        return '浅い睡眠';
      case 2:
        return 'REM睡眠';
      case 3:
        return '覚醒';
      default:
        return '';
    }
  }
  
  // classic形式
  switch (value.toInt()) {
    case 0:
      return '睡眠中';
    case 1:
      return '不安定';
    case 2:
      return '起きている';
    default:
      return '';
  }
}
```

## 軸タイトル

### 左軸（Y軸）: 睡眠ステージ

```dart
Widget _getLeftTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  
  String text = _getStageLabel(value);
  
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}
```

### 下軸（X軸）: 時刻

```dart
Widget _getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontSize: 10,
  );
  
  // 1時間ごとに表示
  final index = value.toInt();
  if (index >= 0 && index < data.stages.length) {
    final segment = data.stages[index];
    // 1時間ごとにラベル表示
    if (segment.startTime.minute == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          DateFormat('HH:mm').format(segment.startTime),
          style: style,
        ),
      );
    }
  }
  
  return const SizedBox.shrink();
}
```

## ツールチップ

### _formatDuration メソッド

継続時間を読みやすい形式に変換：

```dart
String _formatDuration(double minutes) {
  final hours = minutes ~/ 60;
  final mins = (minutes % 60).toInt();
  
  if (hours > 0) {
    return '${hours}時間${mins}分';
  }
  return '${mins}分';
}
```

## 色の定義

### stages形式の色マッピング

```dart
Color _getStageColor(String stage, SleepType type) {
  if (type == SleepType.stages) {
    switch (stage) {
      case 'deep':
        return Colors.blue[900]!;
      case 'light':
        return Colors.blue[300]!;
      case 'rem':
        return Colors.purple;
      case 'wake':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  // classic形式
  switch (stage) {
    case 'asleep':
      return Colors.blue;
    case 'restless':
      return Colors.yellow;
    case 'awake':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
```

## レジェンド（凡例）の追加

グラフの下に凡例を表示：

```dart
Widget _buildLegend() {
  final stages = data.sleepType == SleepType.stages
      ? ['deep', 'light', 'rem', 'wake']
      : ['asleep', 'restless', 'awake'];
  
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: stages.map((stage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getStageColor(stage, data.sleepType),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            Text(_getStageLabelFromString(stage)),
          ],
        ),
      );
    }).toList(),
  );
}
```

## 完全な Widget 構造

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(_buildBarChartData()),
        ),
      ),
      const SizedBox(height: 8),
      _buildLegend(),
    ],
  );
}
```

## パフォーマンス最適化

### データの事前計算

ViewModelでデータを変換する際、以下を事前計算：
- 各セグメントの色
- Y軸の値
- 継続時間（分）

これにより、ウィジェットのbuild時の計算を最小限に抑える。

## テスト

**ファイル**: `test/views/component/sleep_stage_chart_test.dart`

テスト項目：
1. stages形式のデータで正しくグラフが描画される
2. classic形式のデータで正しくグラフが描画される
3. 各ステージが正しい色で表示される
4. ツールチップが正しい情報を表示する
5. 凡例が正しく表示される
