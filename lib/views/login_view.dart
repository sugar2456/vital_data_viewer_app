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
      appBar: null,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Card(
            elevation: 4, // カードの影の強さ
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // カードの角を丸くする
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // カード内の余白
              child: Column(
                mainAxisSize: MainAxisSize.min, // 子ウィジェットの高さに合わせる
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: fitbitIdController,
                    decoration: const InputDecoration(
                      labelText: 'Fitbit ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await loginViewModel.login(fitbitIdController.text);

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed('/home');
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
