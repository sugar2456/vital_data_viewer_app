import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/info_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム画面'),
      ),
      drawer: const CustomDrawer(), // カスタムドロワー
      body: Center(
        child: homeViewModel.isLoading
            ? const CircularProgressIndicator() // ローディング中
            : homeViewModel.activityGoalResponse == null
                ? const Text('データなし') // データがない場合
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('歩数'),
                              const Icon(Icons.directions_walk),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.steps} 歩'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('アクティブ時間'),
                              const Icon(Icons.directions_run),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.activeMinutes} 分'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('消費カロリー'),
                              const Icon(Icons.local_fire_department),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.caloriesOut} kcal'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('移動距離'),
                              const Icon(Icons.directions_bike),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.distance} km'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('睡眠時間'),
                              const Icon(Icons.bed),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.distance} 分'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('体重'),
                              const Icon(Icons.monitor_weight),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.distance} 分'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('食事'),
                              const Icon(Icons.fastfood),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.distance} 分'),
                            ],
                          ),
                        ),
                        InfoCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('デバイス情報'),
                              const Icon(Icons.watch),
                              Text(
                                  '${homeViewModel.activityGoalResponse!.distance} 分'),
                            ],
                          ),
                        ),
                      ],
                    )),
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
