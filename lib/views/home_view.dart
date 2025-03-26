import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Goals'),
      ),
      body: Center(
        child: homeViewModel.isLoading
            ? const CircularProgressIndicator() // ローディング中
            : homeViewModel.activityGoalResponse == null
                ? const Text('No data available') // データがない場合
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Steps: ${homeViewModel.activityGoalResponse?.steps ?? 0}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Calories Out: ${homeViewModel.activityGoalResponse?.caloriesOut ?? 0}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Distance: ${homeViewModel.activityGoalResponse?.distance ?? 0} km',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await homeViewModel.logout();
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
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