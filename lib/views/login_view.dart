import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/exceptions/external_service_exception.dart';
import '../view_models/login_view_model.dart';

class LoginView extends StatelessWidget {
  final TextEditingController fitbitIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: fitbitIdController,
                      decoration: const InputDecoration(
                        labelText: 'Fitbit ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Fitbit IDを入力してください';
                        }
                        if (value.length < 6) {
                          return 'Fitbit IDは6文字以上で入力してください';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await loginViewModel.login(fitbitIdController.text);

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamed('/home');
                          } catch (e) {
                            String titleError = 'エラー';
                            String errorMessage = 'ログインに失敗しました';
                            if (e is ExternalServiceException) {
                              titleError = '通信エラー';
                              errorMessage = e.userMessage;
                            }
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(titleError),
                                  content: Text(errorMessage),
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
      ),
    );
  }
}
