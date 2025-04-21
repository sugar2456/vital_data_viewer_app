import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_data_viewer_app/models/response/calories_response.dart';
import 'package:vital_data_viewer_app/services/csv/calories_csv_service.dart';
import 'dart:io';

void main() {
  late CaloriesResponse caloriesResponse;

  setUp(() async {
    // テスト用のJSONファイルを読み込む
    final file = File('lib/repositories/data/calories.json');
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);
    caloriesResponse = CaloriesResponse.fromJson(jsonData);
  });

  group('CaloriesCsvService', () {
    test('convertCsvDataはCaloriesResponseから正しくCaloriesCsvDataに変換する', () {
      // テスト実行 - 静的メソッドを使用
      final result = CaloriesCsvService.convertCsvData(caloriesResponse);
      
      // 検証
      expect(result, isA<CaloriesCsvData>());
      expect(result.caloriesCsvSummary.date, isNotEmpty);
      expect(result.caloriesCsvSummary.totalCalories, greaterThan(0));
      expect(result.caloriesCsvSummary.interval, 1);
      expect(result.caloriesCsvSummary.unit, 'minute');
      
      // データ件数の確認 (calories.jsonのデータ件数に合わせて確認)
      expect(result.caloriesDatasets.length, caloriesResponse.activitiesCaloriesIntraday.dataset.length);
      
      // いくつかのデータポイントをサンプルチェック
      if (result.caloriesDatasets.isNotEmpty) {
        expect(result.caloriesDatasets[0].dateTime, isNotNull);
        
        // サンプルデータポイントのチェック（実際のJSONデータに合わせて調整）
        final sampleIndex = result.caloriesDatasets.length > 100 ? 100 : 0;
        final originalData = caloriesResponse.activitiesCaloriesIntraday.dataset[sampleIndex];
        expect(result.caloriesDatasets[sampleIndex].value, originalData.value);
      }
    });

    test('createCaloriesSummaryCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final caloriesCsvData = CaloriesCsvService.convertCsvData(caloriesResponse);
      
      // テスト実行 - 静的メソッドを使用
      final headerResult = CaloriesCsvService.createCaloriesSummaryCsv(caloriesCsvData.caloriesCsvSummary);
      
      // 検証
      expect(headerResult.length, 2);
      expect(headerResult[0], '"日付,総合消費カロリー,間隔,単位"');
      expect(headerResult[1].contains(caloriesCsvData.caloriesCsvSummary.date), isTrue);
      expect(headerResult[1].contains(caloriesCsvData.caloriesCsvSummary.totalCalories.toString()), isTrue);
    });
    
    test('createCaloriesDatasetCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final caloriesCsvData = CaloriesCsvService.convertCsvData(caloriesResponse);
      
      // テスト実行 - 静的メソッドを使用
      final datasetResult = CaloriesCsvService.createCaloriesDatasetCsv(caloriesCsvData.caloriesDatasets);
      
      // 検証
      expect(datasetResult.length, caloriesCsvData.caloriesDatasets.length + 1); // ヘッダー + データポイント数
      expect(datasetResult[0], '"時間,消費カロリー"');
      
      // サンプルデータをチェック
      if (caloriesCsvData.caloriesDatasets.isNotEmpty) {
        const sampleIndex = 1; // 最初のデータポイント（ヘッダーを除く）
        final sampleDataset = caloriesCsvData.caloriesDatasets[0];
        expect(datasetResult[sampleIndex].contains(sampleDataset.value.toString()), isTrue);
      }
    });
    
    test('caloriesResponseがnullのときは空のデータを返す', () {
      // テスト実行 - nullを渡して静的メソッドを呼び出す
      final result = CaloriesCsvService.convertCsvData(null);
      
      // 検証
      expect(result.caloriesCsvSummary.date, '');
      expect(result.caloriesCsvSummary.totalCalories, 0);
      expect(result.caloriesDatasets.isEmpty, true);
    });
  });
}