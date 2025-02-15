import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/response/login_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/login_repository_interface.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepositoryInterface _loginRepository;
  LoginResponse? authToken;
  LoginViewModel(this._loginRepository);

  LoginResponse? get getAuthToken => authToken;

  Future<void> login(String email, String password) async {
    authToken = await _loginRepository.login(email, password);
    notifyListeners();
  }
}