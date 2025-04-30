import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/exceptions/external_service_exception.dart';
import 'package:vital_data_viewer_app/view_models/steps_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/custom_line_chart.dart';
import 'package:vital_data_viewer_app/views/component/error_dialog.dart';
import 'package:vital_data_viewer_app/views/component/stack_cord.dart';

class StepView extends StatelessWidget {
  const StepView({super.key});

  @override
  Widget build(BuildContext context) {
    final stepsViewModel = Provider.of<StepsViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('歩数画面'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: stepsViewModel.fetchStep(),
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
            return Consumer<StepsViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        CustomLineChart(
                            selectedDate: viewModel.dateLabel,
                            xAxisLabel: '時刻',
                            xAxisUnit: '分',
                            yAxisLabel: '歩数',
                            yAxisUnit: '歩/分',
                            data: stepsViewModel.getStepsIntraday),
                        Positioned(
                            top: 20,
                            right: 20,
                            child: StackCord(valueText: viewModel.getTotalSteps.toString(), unitText: '歩')),
                      ],
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: context.read<StepsViewModel>().date,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            stepsViewModel.setSelectedDate(selectedDate);
          }
        },
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
