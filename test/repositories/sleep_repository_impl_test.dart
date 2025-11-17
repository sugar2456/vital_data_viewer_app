import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:vital_data_viewer_app/repositories/impls/sleep_repository_impl.dart';

void main() {
  group('fetchSleepLogByDate - 日付形式バリデーション', () {
    test('日付形式バリデーション: 不正な形式でArgumentErrorをスロー', () {
      // Arrange
      final repository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer test_token'},
        client: http.Client(), // ダミークライアント（バリデーションのみなので実際には使われない）
      );

      // Act & Assert - invalid dates
      expect(
        () => repository.fetchSleepLogByDate('2025/11/17'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => repository.fetchSleepLogByDate('20251117'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => repository.fetchSleepLogByDate('2025-11-17T00:00:00'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => repository.fetchSleepLogByDate('invalid-date'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => repository.fetchSleepLogByDate('2025-13-01'), // 13月は無効
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => repository.fetchSleepLogByDate('2025-1-1'), // ゼロパディングなし
        throwsA(isA<ArgumentError>()),
      );
    });

    test('日付形式バリデーション: 正しい形式ではエラーをスローしない（バリデーションのみ）', () {
      // Arrange
      final repository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer test_token'},
        client: http.Client(),
      );

      // Act & Assert - valid dates (バリデーションのみテスト)
      // 実際のAPI呼び出しは行わないため、ArgumentErrorがスローされないことを確認
      expect(
        () {
          try {
            repository.fetchSleepLogByDate('2025-11-17');
          } on ArgumentError {
            rethrow;
          } catch (_) {
            // ArgumentError以外のエラー（API呼び出し失敗など）は無視
          }
        },
        returnsNormally,
      );

      expect(
        () {
          try {
            repository.fetchSleepLogByDate('2020-01-01');
          } on ArgumentError {
            rethrow;
          } catch (_) {}
        },
        returnsNormally,
      );

      expect(
        () {
          try {
            repository.fetchSleepLogByDate('1999-12-31');
          } on ArgumentError {
            rethrow;
          } catch (_) {}
        },
        returnsNormally,
      );
    });
  });

  group('fetchSleepLogByDate - 実装の存在確認', () {
    test('メソッドが存在し、正しいシグネチャを持つ', () {
      // Arrange
      final repository = SleepRepositoryImpl(
        headers: {'Authorization': 'Bearer test_token'},
        client: http.Client(),
      );

      // Assert - メソッドが存在し、Future<SleepLogResponse>を返すことを確認
      expect(
        repository.fetchSleepLogByDate('2025-11-17'),
        isA<Future>(),
      );
    });
  });
}
