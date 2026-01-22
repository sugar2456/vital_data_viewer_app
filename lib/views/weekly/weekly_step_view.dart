import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/weekly/weekly_steps_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/weekly_bar_chart.dart';

/// 週間歩数データを表示する画面
class WeeklyStepView extends StatelessWidget {
  const WeeklyStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeeklyStepsViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('週間歩数'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: viewModel.fetchWeeklySteps(),
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
            return Consumer<WeeklyStepsViewModel>(
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
                                _formatNumber(vm.totalSteps),
                                '歩',
                              ),
                              _buildSummaryItem(
                                '平均',
                                _formatNumber(vm.averageSteps.round()),
                                '歩/日',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 棒グラフ
                      WeeklyBarChart(
                        title: '週間歩数',
                        unit: '歩',
                        data: vm.weeklyData,
                        barColor: Colors.green,
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

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
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
