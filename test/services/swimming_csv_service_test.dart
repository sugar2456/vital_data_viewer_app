import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_data_viewer_app/models/response/swimming_response.dart';
import 'package:vital_data_viewer_app/services/csv/swimming_csv_service.dart';
import 'dart:io';

void main() {
  late SwimmingResponse swimmingResponse;

  setUp(() async {
    // テスト用のJSONファイルを読み込む
    final file = File('lib/repositories/data/swimming.json');
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);
    swimmingResponse = SwimmingResponse.fromJson(jsonData);
  });

  group('SwimmingCsvService', () {
    test('convertCsvDataはSwimmingResponseから正しくSwimmingCsvDataに変換する', () {
      // テスト実行 - 静的メソッドを使用
      final result = SwimmingCsvService.convertCsvData(swimmingResponse);
      
      // 検証
      expect(result, isA<SwimmingCsvData>());
      expect(result.swimmingCsvSummary.date, isNotEmpty);
      expect(result.swimmingCsvSummary.totalStrokes, greaterThanOrEqualTo(0));
      expect(result.swimmingCsvSummary.interval, greaterThan(0));
      expect(result.swimmingCsvSummary.unit, isNotEmpty);
      
      // データセットの確認
      expect(result.swimmingDatasets.length, greaterThan(0));
      
      // サンプルデータポイントの確認（最初のデータ）
      if (result.swimmingDatasets.isNotEmpty) {
        expect(result.swimmingDatasets.first.dateTime, isNotNull);
        expect(result.swimmingDatasets.first.value, isA<double>());
      }
    });

    test('createSwimmingSummaryCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final swimmingCsvData = SwimmingCsvService.convertCsvData(swimmingResponse);
      
      // テスト実行 - 静的メソッドを使用
      final headerResult = SwimmingCsvService.createSwimmingSummaryCsv(swimmingCsvData.swimmingCsvSummary);
      
      // 検証
      expect(headerResult.length, 2);
      expect(headerResult[0], '日付,総合ストローク数,間隔,単位');
      expect(headerResult[1].contains(swimmingCsvData.swimmingCsvSummary.date), isTrue);
      expect(headerResult[1].contains(swimmingCsvData.swimmingCsvSummary.totalStrokes.toString()), isTrue);
    });
    
    test('createSwimmingDatasetCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final swimmingCsvData = SwimmingCsvService.convertCsvData(swimmingResponse);
      
      // テスト実行 - 静的メソッドを使用
      final datasetResult = SwimmingCsvService.createSwimmingDatasetCsv(swimmingCsvData.swimmingDatasets);
      
      // 検証
      expect(datasetResult.length, swimmingCsvData.swimmingDatasets.length + 1); // ヘッダー + データポイント
      expect(datasetResult[0], '時間,ストローク数');
      
      // データフォーマットの確認（最初のデータが正しく変換されているか）
      if (swimmingCsvData.swimmingDatasets.isNotEmpty) {
        final firstDataset = swimmingCsvData.swimmingDatasets.first;
        final expectedTimeStr = firstDataset.dateTime.toString();
        expect(datasetResult[1].contains(expectedTimeStr), isTrue);
      }
    });
    
    test('swimmingResponseがnullのときは空のデータを返す', () {
      // テスト実行 - nullを渡して静的メソッドを呼び出す
      final result = SwimmingCsvService.convertCsvData(null);
      
      // 検証
      expect(result.swimmingCsvSummary.date, '');
      expect(result.swimmingCsvSummary.totalStrokes, 0);
      expect(result.swimmingDatasets.isEmpty, true);
    });
  });
}