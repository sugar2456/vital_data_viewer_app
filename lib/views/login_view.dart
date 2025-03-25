import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/login_view_model.dart';

class LoginView extends StatelessWidget {
  final TextEditingController fitbitIdController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fitbitIdController,
              decoration: const InputDecoration(labelText: 'fitbit ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await loginViewModel.login(
                    fitbitIdController.text
                  );
                } catch (e) {
                  // 警告ダイアログを表示
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Text('Auth Token: ${context.watch<LoginViewModel>().authToken ?? "ログインしていません"}'),
          ],
        ),
      ),
    );
  }
}