import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/view_models/heart_rate_view_model.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/views/component/custom_line_chart.dart';

class HeartRateView extends StatelessWidget {
  const HeartRateView({super.key});

  @override
  Widget build(BuildContext context) {
    final heartRateViewModel =
        Provider.of<HeartRateViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('心拍数画面'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: heartRateViewModel.fetchHeartRate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました'));
          } else {
            return Consumer<HeartRateViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomLineChart(
                    xAxisLabel: '時刻',
                    xAxisUnit: '分',
                    yAxisLabel: '心拍数',
                    yAxisUnit: 'bpm',
                    data: heartRateViewModel.getHeartRateIntraday,
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // リフレッシュ処理
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
