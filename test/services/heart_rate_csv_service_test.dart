import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_data_viewer_app/models/response/heart_rate_response.dart';
import 'package:vital_data_viewer_app/services/csv/heart_rate_csv_service.dart';
import 'dart:io';

void main() {
  late HeartRateResponse heartRateResponse;

  setUp(() async {
    // テスト用のJSONファイルを読み込む
    final file = File('lib/repositories/data/heart_rate.json');
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);
    heartRateResponse = HeartRateResponse.fromJson(jsonData);
  });

  group('HeartRateCsvService', () {
    test('convertCsvDataはHeartRateResponseから正しくHeartRateCsvDataに変換する', () {
      // テスト実行 - 静的メソッドを使用
      final result = HeartRateCsvService.convertCsvData(heartRateResponse);
      
      // 検証
      expect(result, isA<HeartRateCsvData>());
      expect(result.heartRateCsvSummary.date, '2023-01-19');
      expect(result.heartRateCsvSummary.interval, 1);
      expect(result.heartRateCsvSummary.unit, 'minute');
      
      // データセットの検証
      expect(result.heartRateDatasets.isNotEmpty, true);
      
      // いくつかのデータポイントをサンプルチェック
      if (result.heartRateDatasets.isNotEmpty) {
        expect(result.heartRateDatasets[0].dateTime, isA<DateTime>());
        expect(result.heartRateDatasets[0].value, isA<double>());
      }
    });

    test('createHeartRateSummaryCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final heartRateCsvData = HeartRateCsvService.convertCsvData(heartRateResponse);
      
      // テスト実行 - 静的メソッドを使用
      final headerResult = HeartRateCsvService.createHeartRateSummaryCsv(heartRateCsvData.heartRateCsvSummary);
      
      // 検証
      expect(headerResult.length, 2);
      expect(headerResult[0], '日付,平均心拍数,間隔,単位');
      expect(headerResult[1].contains('2023-01-19'), true);
    });
    
    test('createHeartRateDatasetCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final heartRateCsvData = HeartRateCsvService.convertCsvData(heartRateResponse);
      
      // テスト実行 - 静的メソッドを使用
      final datasetResult = HeartRateCsvService.createHeartRateDatasetCsv(heartRateCsvData.heartRateDatasets);
      
      // 検証
      expect(datasetResult.length, heartRateCsvData.heartRateDatasets.length + 1); // ヘッダー + データポイント
      expect(datasetResult[0], '時間,心拍数');
      
      // データ行の形式を確認
      if (heartRateCsvData.heartRateDatasets.isNotEmpty) {
        expect(datasetResult[1], contains(''));
        expect(datasetResult[1], contains(','));
      }
    });
    
    test('heartRateResponseがnullのときは空のデータを返す', () {
      // テスト実行 - nullを渡して静的メソッドを呼び出す
      final result = HeartRateCsvService.convertCsvData(null);
      
      // 検証
      expect(result.heartRateCsvSummary.date, '');
      expect(result.heartRateCsvSummary.averageHeartRate, 0);
      expect(result.heartRateDatasets.isEmpty, true);
    });
  });
}