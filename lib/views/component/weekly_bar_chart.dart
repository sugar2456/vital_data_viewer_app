import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vital_data_viewer_app/views/component/info_card.dart';

/// 週間データを表示する棒グラフウィジェット
class WeeklyBarChart extends StatelessWidget {
  final String title;
  final String unit;
  final List<WeeklyDataPoint> data;
  final Color barColor;

  const WeeklyBarChart({
    super.key,
    required this.title,
    required this.unit,
    required this.data,
    this.barColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.isEmpty
        ? 100.0
        : data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final adjustedMaxY = maxValue == 0 ? 100.0 : maxValue * 1.2;

    return InfoCard(
      child: SizedBox(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$title ($unit)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: adjustedMaxY,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final dataPoint = data[group.x.toInt()];
                          if (!dataPoint.hasData) {
                            return BarTooltipItem(
                              '${dataPoint.label}\nデータなし',
                              const TextStyle(color: Colors.white),
                            );
                          }
                          return BarTooltipItem(
                            '${dataPoint.label}\n${dataPoint.value.toStringAsFixed(0)} $unit',
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= data.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data[index].label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            if (value == adjustedMaxY) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
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
                      drawHorizontalLine: true,
                    ),
                    barGroups: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final point = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: point.hasData ? point.value : 0,
                            color: point.hasData
                                ? barColor
                                : Colors.grey.withValues(alpha: 0.3),
                            width: 30,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 週間データポイント
class WeeklyDataPoint {
  final String label;
  final double value;
  final bool hasData;

  const WeeklyDataPoint({
    required this.label,
    required this.value,
    this.hasData = true,
  });

  factory WeeklyDataPoint.noData(String label) {
    return WeeklyDataPoint(
      label: label,
      value: 0,
      hasData: false,
    );
  }
}
