import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/exceptions/external_service_exception.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/donut_chart.dart';
import 'package:vital_data_viewer_app/views/component/error_dialog.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム画面'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: homeViewModel.getActivityGoal(), // 非同期データ取得
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // ローディング中
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              String errorMessage = 'エラーが発生しました';
              if (snapshot.error is ExternalServiceException) {
                errorMessage = (snapshot.error as ExternalServiceException).userMessage;
              }
              ErrorDialog.show(context, errorMessage);
            });
            return const Center(child: Text('エラーが発生しました'));
          } else {
            return Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.activitySummaryResponse == null) {
                  return const Center(child: Text('データなし'));
                }
                final goalSteps = viewModel.activitySummaryResponse!.goals.steps;
                final actualSteps = viewModel.activitySummaryResponse!.summary.steps;
                final goalActiveMinutes = viewModel.activitySummaryResponse!.goals.activeMinutes;
                final actualActiveMinutes = viewModel.activitySummaryResponse!.summary.veryActiveMinutes;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      DonutChart(
                        title: '歩数',
                        goal: goalSteps,
                        actual: actualSteps,
                        unit: '歩',
                      ),
                      DonutChart(
                        title: '活動時間',
                        goal: goalActiveMinutes,
                        actual: actualActiveMinutes,
                        unit: '分',
                      ),
                      DonutChart(
                        title: 'カロリー',
                        goal: viewModel.activitySummaryResponse!.goals.caloriesOut,
                        actual: viewModel.activitySummaryResponse!.summary.caloriesOut,
                        unit: 'kcal',
                      ),
                      DonutChart(
                        title: '距離',
                        goal: viewModel.activitySummaryResponse!.goals.distance,
                        actual: viewModel.totalDistance,
                        unit: 'km',
                      ),
                      DonutChart(
                        title: '睡眠時間',
                        goal: viewModel.sleepGoal,
                        actual: viewModel.sleepActual,
                        unit: '分'
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await homeViewModel.getActivityGoal(); // データを再取得
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}