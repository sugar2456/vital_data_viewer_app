import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/weekly/weekly_heart_rate_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';

/// 週間心拍数データを表示する画面
class WeeklyHeartRateView extends StatelessWidget {
  const WeeklyHeartRateView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeeklyHeartRateViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('週間心拍数'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: viewModel.fetchWeeklyHeartRate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('エラー: ${snapshot.error}'),
                ],
              ),
            );
          } else {
            return Consumer<WeeklyHeartRateViewModel>(
              builder: (context, vm, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // サマリーカード
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryItem(
                                '平均',
                                vm.averageRestingHeartRate.toStringAsFixed(0),
                                'bpm',
                              ),
                              _buildSummaryItem(
                                '最小',
                                vm.minRestingHeartRate.toString(),
                                'bpm',
                              ),
                              _buildSummaryItem(
                                '最大',
                                vm.maxRestingHeartRate.toString(),
                                'bpm',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 棒グラフ
                      WeeklyBarChart(
                        title: '週間安静時心拍数',
                        unit: 'bpm',
                        data: vm.weeklyData,
                        barColor: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
