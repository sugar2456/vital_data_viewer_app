import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'メニュー',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('ホーム'),
              onTap: () {
                // ホーム画面への遷移処理
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('歩数'),
              onTap: () {
                // 歩数画面への遷移処理
                Navigator.pushNamed(context, '/step');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('心拍数'),
              onTap: () {
                // 心拍数画面への遷移処理
                Navigator.pushNamed(context, '/heart_rate');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('カロリー'),
              onTap: () {
                // カロリー画面への遷移処理
                Navigator.pushNamed(context, '/calories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pool),
              title: const Text('水泳'),
              onTap: () {
                // 水泳画面への遷移処理
                Navigator.pushNamed(context, '/swimming');
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('設定'),
            //   onTap: () {
            //     // 設定画面への遷移処理
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ログアウト'),
              onTap: () {
                TokenManager().deleteToken();
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      );
  }
}