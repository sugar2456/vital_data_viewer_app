import 'dart:developer';

class ConvertUtil {
  /// 文字列を整数に変換する
  static int stringToInt(String? value) {
    if (value == null || value.isEmpty || value.contains(' ')) {
      throw ArgumentError('Convert Util 不正な値が渡されました: $value');
    }
    try {
      return int.parse(value);
    } catch (e) {
      log('Error parsing int: $e');
      throw ArgumentError('Convert Util 不正な値が渡されました: $value');
    }
  }
}
