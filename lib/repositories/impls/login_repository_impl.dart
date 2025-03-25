import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/login_response.dart';
import '../interfaces/login_repository_interface.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class LoginRepositoryImpl implements LoginRepositoryInterface {
  String CALLBACK_URL = 'myapp://callback';
  @override
  Future<LoginResponse> login(String clientId) async {
    final url = Uri.https('www.fitbit.com', '/oauth2/authorize', {
      'response_type': 'token',
      'client_id': clientId,
      'redirect_uri': CALLBACK_URL,
      'scope': 'activity heartrate location nutrition profile settings sleep weight',
    });
    final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: 'myapp');
    final fragment = Uri.parse(result).fragment;
    final fragmentParams = Uri.splitQueryString(fragment);
    final token = fragmentParams['access_token'];

    return LoginResponse(token: token ?? "" , tokenType: 'Bearer');
  }
}