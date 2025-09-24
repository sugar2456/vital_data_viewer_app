import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/models/manager/token_manager.dart';
import 'package:vital_data_viewer_app/models/manager/fitbit_id_manager.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/login_repository_interface.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepositoryInterface _loginRepository;
  LoginViewModel(this._loginRepository);

  String? get getAuthToken => TokenManager().getToken();

  Future<void> login(String username, BuildContext context) async {
    final response = await _loginRepository.login(username);

    // トークンを更新
    // ignore: use_build_context_synchronously
    context.read<HeaderUtil>().updateToken(response.token);

    // ログイン成功時にFitbitIdを保存
    await FitbitIdManager().saveFitbitId(username);
  }
}