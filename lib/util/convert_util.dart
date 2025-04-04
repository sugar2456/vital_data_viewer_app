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

  /// 小数点第2位以下までの数値を四捨五入する
  static double roundToOneDecimalPlaces(double value) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError('Convert Util 不正な値が渡されました: $value');
    }
    try {
      return double.parse(value.toStringAsFixed(1));
    } catch (e) {
      log('Error rounding to two decimal places: $e');
      throw ArgumentError('Convert Util 不正な値が渡されました: $value');
    }
  }
}
