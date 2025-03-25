import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/manager/auth_manager.dart';
import 'package:vital_data_viewer_app/providers/providers.dart';
import 'package:vital_data_viewer_app/views/home_view.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1800, 900),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final authManager = AuthManager();
  final isAuthenticated = authManager.isAuthenticated();

  runApp(
    MultiProvider(
      providers: getProviders(),
      child: MyApp(initialRoute: isAuthenticated ? '/home' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginView(),
        '/home': (BuildContext context) => HomeView(),
      },
    );
  }
}