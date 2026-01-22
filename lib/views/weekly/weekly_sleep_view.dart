import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/weekly/weekly_sleep_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';

/// 週間睡眠データを表示する画面
class WeeklySleepView extends StatelessWidget {
  const WeeklySleepView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeeklySleepViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('週間睡眠'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: viewModel.fetchWeeklySleep(),
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
            return Consumer<WeeklySleepViewModel>(
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
                                '合計',
                                vm.totalFormatted,
                                '',
                              ),
                              _buildSummaryItem(
                                '平均',
                                vm.averageFormatted,
                                '/日',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 棒グラフ
                      WeeklyBarChart(
                        title: '週間睡眠時間',
                        unit: '時間',
                        data: vm.weeklyData,
                        barColor: Colors.indigo,
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
            if (unit.isNotEmpty) ...[
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
          ],
        ),
      ],
    );
  }
}
