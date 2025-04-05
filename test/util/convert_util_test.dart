import 'package:flutter_test/flutter_test.dart';
import 'package:vital_data_viewer_app/util/convert_util.dart';

void main() {
  group('ConvertUtil.stringToInt', () {
    test('null を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.stringToInt(null), throwsA(isA<ArgumentError>()));
    });

    test('空文字列を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.stringToInt(''), throwsA(isA<ArgumentError>()));
    });

    test('空白を含む文字列を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.stringToInt(' 123 '), throwsA(isA<ArgumentError>()));
    });

    test('無効な文字列を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.stringToInt('abc'), throwsA(isA<ArgumentError>()));
    });

    test('有効な整数文字列を渡すと対応する整数を返す', () {
      expect(ConvertUtil.stringToInt('123'), 123);
    });

    test('負の整数文字列を渡すと対応する負の整数を返す', () {
      expect(ConvertUtil.stringToInt('-456'), -456);
    });

    test('0を渡すと0を返す', () {
      expect(ConvertUtil.stringToInt('0'), 0);
    });
  });

  group('ConvertUtil.roundToOneDecimalPlaces', () {
    test('整数を渡すとそのまま返す', () {
      expect(ConvertUtil.roundToOneDecimalPlaces(123), 123.0);
    });

    test('小数点以下1桁の数値を渡すとそのまま返す', () {
      expect(ConvertUtil.roundToOneDecimalPlaces(123.4), 123.4);
    });

    test('小数点以下2桁以上の数値を渡すと四捨五入される', () {
      expect(ConvertUtil.roundToOneDecimalPlaces(123.45), 123.5);
    });

    test('負の数値の小数点以下1桁の数値を渡すとそのまま返す', () {
      expect(ConvertUtil.roundToOneDecimalPlaces(-123.4), -123.4);
    });

    test('負の数値の小数点以下2桁以上の数値を渡すと四捨五入される', () {
      expect(ConvertUtil.roundToOneDecimalPlaces(-123.45), -123.5);
    });

    test('0を渡すと0を返す', () {
      expect(ConvertUtil.roundToOneDecimalPlaces(0), 0.0);
    });

    test('null を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.roundToOneDecimalPlaces(null), throwsA(isA<ArgumentError>()));
    });

    test('なんらかの理由で無効な値が渡された場合、ArgumentError をスローする', () {
      expect(() => ConvertUtil.roundToOneDecimalPlaces(double.nan), throwsA(isA<ArgumentError>()));
      expect(() => ConvertUtil.roundToOneDecimalPlaces(double.infinity), throwsA(isA<ArgumentError>()));
    });
  });

  group('ConvertUtil.convertStringToDouble', () {
    test('null を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.convertStringToDouble(null), throwsA(isA<ArgumentError>()));
    });

    test('空文字列を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.convertStringToDouble(''), throwsA(isA<ArgumentError>()));
    });

    test('空白を含む文字列を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.convertStringToDouble(' 123.45 '), throwsA(isA<ArgumentError>()));
    });

    test('無効な文字列を渡すと ArgumentError をスローする', () {
      expect(() => ConvertUtil.convertStringToDouble('abc'), throwsA(isA<ArgumentError>()));
    });

    test('有効な小数点数文字列を渡すと対応する double を返す', () {
      expect(ConvertUtil.convertStringToDouble('123.45'), 123.45);
    });

    test('負の小数点数文字列を渡すと対応する負の double を返す', () {
      expect(ConvertUtil.convertStringToDouble('-123.45'), -123.45);
    });

    test('0を渡すと0.0を返す', () {
      expect(ConvertUtil.convertStringToDouble('0'), 0.0);
    });
  });
}