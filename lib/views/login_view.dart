import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/login_view_model.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await loginViewModel.login(
                    emailController.text,
                    passwordController.text,
                  );
                  // Navigate to home screen or show success message
                } catch (e) {
                  // Show error message
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Text('Auth Token: ${context.watch<LoginViewModel>().authToken?.token ?? "Not logged in"}'),
          ],
        ),
      ),
    );
  }
}