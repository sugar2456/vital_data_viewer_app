import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';

class SwimmingStrokesView extends StatelessWidget {
  const SwimmingStrokesView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('水泳時ストローク画面'),
      ),
      drawer: const CustomDrawer(),
      body: const Text('ストローク数'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // リフレッシュ処理
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}