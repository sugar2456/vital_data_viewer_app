import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';
import 'package:vital_data_viewer_app/views/component/donut_chart.dart';

class CaloriesView extends StatelessWidget {
  const CaloriesView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('カロリー画面'),
      ),
      drawer: const CustomDrawer(),
      body: const Text('カロリー'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}