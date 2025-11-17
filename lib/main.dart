import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vital_data_viewer_app/providers/providers.dart';
import 'package:vital_data_viewer_app/views/calories_view.dart';
import 'package:vital_data_viewer_app/views/csv_view.dart';
import 'package:vital_data_viewer_app/views/heart_rate_view.dart';
import 'package:vital_data_viewer_app/views/home_view.dart';
import 'package:vital_data_viewer_app/views/step_view.dart';
import 'package:vital_data_viewer_app/views/swimming_strokes_view.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1800, 980),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiProvider(
      providers: getProviders(),
      child: const MyApp(initialRoute: '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Data Viewer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ja', 'JP'),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginView(),
        '/home': (BuildContext context) => const HomeView(),
        '/step': (BuildContext context) => const StepView(),
        '/heart_rate': (BuildContext context) => const HeartRateView(),
        '/calories': (BuildContext context) => const CaloriesView(),
        '/swimming': (BuildContext context) => const SwimmingStrokesView(),
        '/csv': (BuildContext context) => const CsvView(),
      },
    );
  }
}
