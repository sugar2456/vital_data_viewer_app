import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vital_data_viewer_app/view_models/sleep_chart_data.dart';

/// 睡眠ステージグラフコンポーネント（横方向タイムライン）
class SleepStageChart extends StatelessWidget {
  final SleepChartData data;

  const SleepStageChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 日付表示
            Text(
              DateFormat('yyyy年MM月dd日').format(data.startTime),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // 横方向タイムライン（Y軸ラベル含む）
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildHorizontalTimeline(),
              ),
            ),
            const SizedBox(height: 16),
            // X軸ラベル（時刻）
            _buildTimeLabels(),
            const SizedBox(height: 16),
            // 凡例
            _buildLegend(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 横方向タイムラインを構築（Y軸ラベル含む）
  Widget _buildHorizontalTimeline() {
    final totalDuration = data.endTime.difference(data.startTime);
    final totalMinutes = totalDuration.inMinutes.toDouble();

    final stageLabels = data.sleepType == SleepType.stages
        ? ['覚醒', 'REM睡眠', '浅い睡眠', '深い睡眠']
        : ['起きている', '不安定', '睡眠中'];

    final stages = data.sleepType == SleepType.stages
        ? ['wake', 'rem', 'light', 'deep']
        : ['awake', 'restless', 'asleep'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(stages.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 64, // 固定の高さ（2倍に）
            child: Row(
              children: [
                // Y軸ラベル
                SizedBox(
                  width: 80,
                  child: Text(
                    stageLabels[index],
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // タイムライン
                Expanded(
                  child: _buildStageTimeline(stages[index], totalMinutes),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 特定ステージのタイムラインを構築
  Widget _buildStageTimeline(String stageName, double totalMinutes) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // このステージに該当するセグメントを取得
        final stageSegments = data.stages
            .where((segment) => segment.stage == stageName);

        return SizedBox(
          height: constraints.maxHeight,
          child: Stack(
            children: [
              // 背景
              Container(
                width: width,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // ステージセグメント
              ...stageSegments.map((segment) {
                final startOffset = segment.startTime.difference(data.startTime);
                final startMinutes = startOffset.inMinutes.toDouble();
                final leftPosition = (startMinutes / totalMinutes) * width;
                final segmentWidth =
                    (segment.durationMinutes / totalMinutes) * width;

                return Positioned(
                  left: leftPosition,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      // タップ時にツールチップを表示（オプション）
                    },
                    child: Tooltip(
                      message:
                          '${_getStageLabelFromString(segment.stage)}\n${_formatDuration(segment.durationMinutes)}\n${DateFormat('HH:mm').format(segment.startTime)} - ${DateFormat('HH:mm').format(segment.endTime)}',
                      child: Container(
                        width: segmentWidth,
                        decoration: BoxDecoration(
                          color: segment.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// 時刻ラベル（X軸）を構築
  Widget _buildTimeLabels() {
    final timeLabels = <String>[];
    final labelTimes = <DateTime>[];

    // 1時間ごとのラベルを生成
    var currentTime = DateTime(
      data.startTime.year,
      data.startTime.month,
      data.startTime.day,
      data.startTime.hour,
    );

    // 次の1時間区切りに進める
    if (data.startTime.minute > 0) {
      currentTime = currentTime.add(const Duration(hours: 1));
    }

    while (currentTime.isBefore(data.endTime)) {
      labelTimes.add(currentTime);
      timeLabels.add(DateFormat('HH:mm').format(currentTime));
      currentTime = currentTime.add(const Duration(hours: 1));
    }

    final totalDuration = data.endTime.difference(data.startTime);
    final totalMinutes = totalDuration.inMinutes.toDouble();

    // 開始時刻と終了時刻を表示するかどうかを判定
    final showStartLabel = labelTimes.isEmpty ||
        data.startTime.difference(labelTimes.first).abs() >
            const Duration(minutes: 10);
    final showEndLabel = labelTimes.isEmpty ||
        data.endTime.difference(labelTimes.last).abs() >
            const Duration(minutes: 10);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const SizedBox(width: 88), // Y軸ラベルのスペース (80 + 8)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                return SizedBox(
                  height: 20, // 明示的な高さを指定
                  child: Stack(
                    children: [
                      // 開始時刻（10分以内に1時間ラベルがない場合のみ表示）
                      if (showStartLabel)
                        Positioned(
                          left: 0,
                          child: Text(
                            DateFormat('HH:mm').format(data.startTime),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      // 1時間ごとのラベル
                      ...labelTimes.asMap().entries.map((entry) {
                        final time = entry.value;
                        final offset = time.difference(data.startTime);
                        final offsetMinutes = offset.inMinutes.toDouble();
                        final leftPosition = (offsetMinutes / totalMinutes) * width;

                        return Positioned(
                          left: leftPosition,
                          child: Text(
                            timeLabels[entry.key],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }),
                      // 終了時刻（10分以内に1時間ラベルがない場合のみ表示）
                      if (showEndLabel)
                        Positioned(
                          right: 0,
                          child: Text(
                            DateFormat('HH:mm').format(data.endTime),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ステージ文字列からラベルを取得
  String _getStageLabelFromString(String stage) {
    if (data.sleepType == SleepType.stages) {
      switch (stage) {
        case 'deep':
          return '深い睡眠';
        case 'light':
          return '浅い睡眠';
        case 'rem':
          return 'REM睡眠';
        case 'wake':
          return '覚醒';
        default:
          return stage;
      }
    } else {
      switch (stage) {
        case 'asleep':
          return '睡眠中';
        case 'restless':
          return '不安定';
        case 'awake':
          return '起きている';
        default:
          return stage;
      }
    }
  }

  /// 継続時間を読みやすい形式に変換
  String _formatDuration(double minutes) {
    final hours = minutes ~/ 60;
    final mins = (minutes % 60).toInt();

    if (hours > 0) {
      return '$hours時間$mins分';
    }
    return '$mins分';
  }

  /// 凡例を構築
  Widget _buildLegend() {
    final stages = data.sleepType == SleepType.stages
        ? ['deep', 'light', 'rem', 'wake']
        : ['asleep', 'restless', 'awake'];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.0,
      children: stages.map((stage) {
        final color = _getColorForStage(stage);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
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

  /// ステージに応じた色を返す
  Color _getColorForStage(String stage) {
    if (data.sleepType == SleepType.stages) {
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
    } else {
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
  }
}
