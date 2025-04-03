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
}