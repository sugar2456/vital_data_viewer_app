import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('活動画面'),
      ),
      drawer: const CustomDrawer(),
      body: const Text('活動画面 複数の活動グラフを表示する予定'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // リフレッシュ処理
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}