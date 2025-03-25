import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/models/response/login_response.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/login_repository_interface.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepositoryInterface _loginRepository;
  String? authToken;
  LoginViewModel(this._loginRepository) {
    authToken = TokenManager().getToken();
  }

  String? get getAuthToken => authToken;

  Future<void> login(String clientId) async {
    LoginResponse? response = await _loginRepository.login(clientId);
    TokenManager().setToken(response.token);
    authToken = response.token;
    notifyListeners();
  }
}