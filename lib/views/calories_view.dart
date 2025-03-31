import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/calories_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/calories_line_chart.dart';
import 'package:vital_data_viewer_app/views/component/custom_line_chart.dart';

class CaloriesView extends StatelessWidget {
  const CaloriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final caloriesViewModel =
        Provider.of<CaloriesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カロリー画面'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: caloriesViewModel.fetchCalories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました'));
          } else {
            return Consumer<CaloriesViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomLineChart(
                      xAxisLabel: '時刻',
                      xAxisUnit: '分',
                      yAxisLabel: '消費カロリー',
                      yAxisUnit: 'kcal',
                      data: viewModel.getCaloriesIntraday),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
