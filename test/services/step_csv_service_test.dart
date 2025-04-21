import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_data_viewer_app/models/response/step_response.dart';
import 'package:vital_data_viewer_app/services/csv/step_csv_service.dart';
import 'dart:io';

void main() {
  late StepResponse stepResponse;

  setUp(() async {
    // テスト用のJSONファイルを読み込む
    final file = File('lib/repositories/data/step.json');
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);
    stepResponse = StepResponse.fromJson(jsonData);
  });

  group('StepCsvService', () {
    test('convertCsvDataはStepResponseから正しくStepCsvDataに変換する', () {
      // テスト実行 - 静的メソッドを使用
      final result = StepCsvService.convertCsvData(stepResponse);
      
      // 検証
      expect(result, isA<StepCsvData>());
      expect(result.stepCsvSummary.date, '2023-01-19');
      expect(result.stepCsvSummary.totalSteps, 9919);
      expect(result.stepCsvSummary.interval, 1);
      expect(result.stepCsvSummary.unit, 'minute');
      
      // データ件数の確認 (step.jsonには1440件のデータが含まれる)
      expect(result.stepDatasets.length, 1440);
      
      // いくつかのデータポイントをサンプルチェック
      expect(result.stepDatasets[0].dateTime.hour, 0);
      expect(result.stepDatasets[0].dateTime.minute, 0);
      expect(result.stepDatasets[0].value, 0);
      
      // 例: 19:26の歩数は113
      final index19_26 = result.stepDatasets.indexWhere((dataset) => 
          dataset.dateTime.hour == 19 && dataset.dateTime.minute == 26);
      expect(result.stepDatasets[index19_26].value, 113);
    });

    test('createStepSummaryCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final stepCsvData = StepCsvService.convertCsvData(stepResponse);
      
      // テスト実行 - 静的メソッドを使用
      final headerResult = StepCsvService.createStepSummaryCsv(stepCsvData.stepCsvSummary);
      
      // 検証
      expect(headerResult.length, 2);
      expect(headerResult[0], '日付,総合歩数,間隔,単位');
      expect(headerResult[1], '2023-01-19,9919,1,minute');
    });
    
    test('createStepDatasetCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final stepCsvData = StepCsvService.convertCsvData(stepResponse);
      
      // テスト実行 - 静的メソッドを使用
      final datasetResult = StepCsvService.createStepDatasetCsv(stepCsvData.stepDatasets);
      
      // 検証
      expect(datasetResult.length, 1441); // ヘッダー + 1440データポイント
      expect(datasetResult[0], '時間,歩数');
      
      // サンプルデータをチェック (時刻によって異なるので注意)
      // 日付データを含まないため、文字列マッチングで確認
      expect(datasetResult.any((line) => line.contains('00:00:00') && line.contains('0')), true);
      expect(datasetResult.any((line) => line.contains('19:26:00') && line.contains('113')), true);
    });
    
    test('stepResponseがnullのときは空のデータを返す', () {
      // テスト実行 - nullを渡して静的メソッドを呼び出す
      final result = StepCsvService.convertCsvData(null);
      
      // 検証
      expect(result.stepCsvSummary.date, '');
      expect(result.stepCsvSummary.totalSteps, 0);
      expect(result.stepDatasets.isEmpty, true);
    });
  });
}