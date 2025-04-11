import 'package:vital_data_viewer_app/const/http_status_code.dart';
import 'package:vital_data_viewer_app/exceptions/external_service_exception.dart';
import 'package:vital_data_viewer_app/models/response/login_response.dart';
import '../interfaces/login_repository_interface.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class LoginRepositoryImpl implements LoginRepositoryInterface {
  String callbackUrl = 'myapp://callback';
  @override
  Future<LoginResponse> login(String clientId) async {
    try {
      final url = Uri.https('www.fitbit.com', '/oauth2/authorize', {
        'response_type': 'token',
        'client_id': clientId,
        'redirect_uri': callbackUrl,
        'scope': 'activity heartrate location nutrition profile settings sleep weight',
      });
      final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: 'myapp');
      final fragment = Uri.parse(result).fragment;
      final fragmentParams = Uri.splitQueryString(fragment);
      final token = fragmentParams['access_token'];

      return LoginResponse(token: token ?? "" , tokenType: 'Bearer');
    } catch (e) {
      throw ExternalServiceException(e.toString(), '認証に失敗しました', HttpStatusCode.unauthorized);
    }
  }
}