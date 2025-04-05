import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/exceptions/external_service_exception.dart';
import 'package:vital_data_viewer_app/view_models/calories_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/custom_line_chart.dart';
import 'package:vital_data_viewer_app/views/component/error_dialog.dart';

class CaloriesView extends StatelessWidget {
  const CaloriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final caloriesViewModel =
        Provider.of<CaloriesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カロリー消費画面'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: caloriesViewModel.fetchCalories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
            return Consumer<CaloriesViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomLineChart(
                      xAxisLabel: '時刻',
                      xAxisUnit: '分',
                      yAxisLabel: '消費カロリー',
                      yAxisUnit: 'kcal/分',
                      data: viewModel.getCaloriesIntraday),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: context.read<CaloriesViewModel>().date,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null && context.mounted) {
            await caloriesViewModel.setSelectedDate(selectedDate);
          }
        },
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
