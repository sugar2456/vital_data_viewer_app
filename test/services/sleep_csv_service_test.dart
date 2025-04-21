import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_data_viewer_app/models/response/sleep_log_response.dart';
import 'package:vital_data_viewer_app/services/csv/sleep_csv_service.dart';
import 'dart:io';

void main() {
  late SleepLogResponse sleepLogResponse;

  setUp(() async {
    // テスト用のJSONファイルを読み込む
    final file = File('lib/repositories/data/sleep.json');
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);
    sleepLogResponse = SleepLogResponse.fromJson(jsonData);
  });

  group('SleepCsvService', () {
    test('convertCsvDataはSleepLogResponseから正しくSleepCsvDataに変換する', () {
      // テスト実行 - 静的メソッドを使用
      final result = SleepCsvService.convertCsvData(sleepLogResponse);
      
      // 検証
      expect(result, isA<SleepCsvData>());
      expect(result.sleepCsvSummary.date, isNotEmpty);
      expect(result.sleepCsvSummary.totalMinutesAsleep, greaterThanOrEqualTo(0));
      expect(result.sleepCsvSummary.totalTimeInBed, greaterThanOrEqualTo(0));
      expect(result.sleepCsvSummary.sleepEfficiency, greaterThanOrEqualTo(0));
      
      // データセットの確認
      expect(result.sleepDatasets, isNotEmpty);
      
      // いくつかのデータポイントをサンプルチェック
      if (result.sleepDatasets.isNotEmpty) {
        expect(result.sleepDatasets.first.dateTime, isA<DateTime>());
        expect(result.sleepDatasets.first.level, isNotEmpty);
        expect(result.sleepDatasets.first.seconds, greaterThan(0));
      }
    });

    test('createSleepSummaryCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final sleepCsvData = SleepCsvService.convertCsvData(sleepLogResponse);
      
      // テスト実行 - 静的メソッドを使用
      final headerResult = SleepCsvService.createSleepSummaryCsv(sleepCsvData.sleepCsvSummary);
      
      // 検証
      expect(headerResult.length, 2);
      expect(headerResult[0], '"日付,睡眠時間(分),ベッドでの時間(分),睡眠効率(%)"');
      expect(headerResult[1].contains(sleepCsvData.sleepCsvSummary.date), isTrue);
      expect(headerResult[1].contains(sleepCsvData.sleepCsvSummary.totalMinutesAsleep.toString()), isTrue);
    });
    
    test('createSleepDatasetCsvはcsvを生成する', () {
      // テスト用のデータを準備
      final sleepCsvData = SleepCsvService.convertCsvData(sleepLogResponse);
      
      // テスト実行 - 静的メソッドを使用
      final datasetResult = SleepCsvService.createSleepDatasetCsv(sleepCsvData.sleepDatasets);
      
      // 検証
      expect(datasetResult.length, sleepCsvData.sleepDatasets.length + 1); // ヘッダー + データポイント
      expect(datasetResult[0], '"時間,睡眠レベル,継続時間(秒)"');
      
      // データフォーマットの確認（最初のデータが正しく変換されているか）
      if (sleepCsvData.sleepDatasets.isNotEmpty) {
        final firstDataset = sleepCsvData.sleepDatasets.first;
        expect(datasetResult[1].contains(firstDataset.level), isTrue);
        expect(datasetResult[1].contains(firstDataset.seconds.toString()), isTrue);
      }
    });
    
    test('sleepLogResponseがnullのときは空のデータを返す', () {
      // テスト実行 - nullを渡して静的メソッドを呼び出す
      final result = SleepCsvService.convertCsvData(null);
      
      // 検証
      expect(result.sleepCsvSummary.date, '');
      expect(result.sleepCsvSummary.totalMinutesAsleep, 0);
      expect(result.sleepCsvSummary.totalTimeInBed, 0);
      expect(result.sleepCsvSummary.sleepEfficiency, 0);
      expect(result.sleepDatasets.isEmpty, true);
    });
  });
}