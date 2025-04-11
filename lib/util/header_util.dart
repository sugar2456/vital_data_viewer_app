import 'package:flutter/material.dart';

class HeaderUtil extends ChangeNotifier {
  Map<String, String> _headers = {};

  Map<String, String> get headers => _headers;

  void updateToken(String token) {
    _headers = {'Authorization': 'Bearer $token'};
    notifyListeners();
  }
}