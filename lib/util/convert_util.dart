class ConvertUtil {
  /// 文字列を整数に変換する
  static int stringToInt(String? value) {
    if (value == null || value.isEmpty) {
      return 0;
    }
    try {
      return int.parse(value);
    } catch (e) {
      print('Error parsing int: $e');
      return 0;
    }
  }
}
