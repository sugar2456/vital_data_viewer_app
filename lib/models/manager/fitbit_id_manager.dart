import 'package:shared_preferences/shared_preferences.dart';

class FitbitIdManager {
  static final FitbitIdManager _instance = FitbitIdManager._internal();
  factory FitbitIdManager() => _instance;

  FitbitIdManager._internal();

  static const String _fitbitIdKey = 'fitbit_id';

  Future<void> saveFitbitId(String fitbitId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fitbitIdKey, fitbitId);
  }

  Future<String?> getFitbitId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fitbitIdKey);
  }

  Future<void> deleteFitbitId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fitbitIdKey);
  }
}