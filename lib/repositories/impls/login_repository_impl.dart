import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/models/response/login_response.dart';
import '../interfaces/login_repository_interface.dart';

class LoginRepositoryImpl implements LoginRepositoryInterface {
  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}