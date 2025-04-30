import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vital_data_viewer_app/views/component/info_card.dart';

class CustomLineChart extends StatelessWidget {
  final String selectedDate;
  final String xAxisLabel;
  final String xAxisUnit;
  final String yAxisLabel;
  final String yAxisUnit;
  final List<dynamic> data;

  const CustomLineChart(
      {super.key,
      required this.selectedDate,
      required this.xAxisLabel,
      required this.xAxisUnit,
      required this.yAxisLabel,
      required this.yAxisUnit,
      required this.data});

  List<FlSpot> generateFlSpots(List<dynamic> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      final current = data[i];
      final currentTime =
          (current.dateTime as DateTime).millisecondsSinceEpoch.toDouble();
      final currentValue = current.value.toDouble();

      // 最初のデータポイントはそのまま追加
      if (i == 0) {
        spots.add(FlSpot(currentTime, currentValue));
        continue;
      }

      final previous = data[i - 1];
      final previousTime =
          (previous.dateTime as DateTime).millisecondsSinceEpoch.toDouble();

      // 30分（1800000ミリ秒）以上間隔が空いている場合、NaNを挿入
      if (currentTime - previousTime > 1800000) {
        spots.add(const FlSpot(double.nan, double.nan)); // グラフを切る
      }

      // 現在のデータポイントを追加
      spots.add(FlSpot(currentTime, currentValue));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: SizedBox(
        height: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // グラフ本体
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Y軸のタイトル
                  RotatedBox(
                    quarterTurns: 3, // タイトルを縦向きに回転
                    child: Text(
                      '$yAxisLabel ($yAxisUnit)', // Y軸のタイトル
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // タイトルとグラフの間のスペース
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: generateFlSpots(data),
                              isCurved: false,
                              color: Colors.blue,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(show: false),
                              dotData: const FlDotData(
                                show: false,
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  //データの最大値のラベルは表示しない
                                  final maxY = data.isNotEmpty
                                      ? data
                                          .map((item) => (item.value as double))
                                          .reduce((a, b) => a > b ? a : b)
                                      : 0;
                                  if (value == maxY) {
                                    return const SizedBox
                                        .shrink(); // 空のウィジェットを返す
                                  }
                                  return Text(
                                    value.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 3600000, // 1時間ごとに表示
                                getTitlesWidget: (value, meta) {
                                  final date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());
                                  final maxX = data.isNotEmpty
                                      ? data
                                          .map((item) =>
                                              (item.dateTime as DateTime)
                                                  .millisecondsSinceEpoch)
                                          .reduce((a, b) => a > b ? a : b)
                                      : 0;

                                  // 最新データのラベルを非表示にする
                                  if (value.toInt() == maxX) {
                                    return const SizedBox
                                        .shrink(); // 空のウィジェットを返す
                                  }
                                  return Text(
                                    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              left: BorderSide(color: Colors.grey),
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          gridData: const FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              drawHorizontalLine: true),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          spot.x.toInt());
                                  return LineTooltipItem(
                                    'time: ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}\nvalue: ${spot.y}',
                                    const TextStyle(color: Colors.white),
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // グラフとx軸タイトルの間のスペース
            // X軸のタイトル
            Text(
              '$xAxisLabel ($xAxisUnit) / 日付: $selectedDate', // X軸のタイトル
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
