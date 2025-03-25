import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';
// import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final TextEditingController fitbitIdController = TextEditingController();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: null,
      body: FutureBuilder(
          future: homeViewModel.getActivityGoal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await homeViewModel.logout();
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      'Activity Goal: ${context.watch<HomeViewModel>().getActivityGoal ?? "データ取得中"}'),
                ],
              );
            }
          }),
    );
  }
}
