import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/login_view_model.dart';
import 'package:vital_data_viewer_app/repositories/impls/login_repository_impl.dart';
import 'views/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(LoginRepositoryImpl()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginView(),
    );
  }
}