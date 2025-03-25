import 'package:vital_data_viewer_app/models/response/login_response.dart';

abstract class LoginRepositoryInterface {
  Future<LoginResponse> login(String clientId);
}