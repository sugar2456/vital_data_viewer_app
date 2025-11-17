import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/sleep_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/sleep_stage_chart.dart';
import 'package:vital_data_viewer_app/views/component/stack_cord.dart';

/// 睡眠データを表示するメイン画面
class SleepView extends StatefulWidget {
  const SleepView({super.key});

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
    final sleepViewModel = Provider.of<SleepViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠データ'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: sleepViewModel.isLoading ? null : Future.value(),
        builder: (context, snapshot) {
          return Consumer<SleepViewModel>(
            builder: (context, viewModel, child) {
              // ローディング状態
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // エラー状態
              if (viewModel.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
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

              // データなし状態
              if (!viewModel.hasData) {
                return const Center(
                  child: Text(
                    '選択した日付の睡眠データがありません',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // データあり状態
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SleepStageChart(data: viewModel.sleepChartData!),
                  ),
                  Positioned(
                    top: 36,
                    right: 36,
                    child: StackCord(
                      valueText: viewModel.sleepChartData!.formattedTotalSleep,
                      unitText: '',
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: context.read<SleepViewModel>().selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            locale: const Locale('ja', 'JP'),
          );
          if (selectedDate != null && context.mounted) {
            await sleepViewModel.fetchSleepData(selectedDate);
          }
        },
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
