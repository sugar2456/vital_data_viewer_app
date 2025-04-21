import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:vital_data_viewer_app/repositories/interfaces/csv_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/step_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/heart_rate_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/sleep_repository_interface.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/calories_repository_interdace.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/swimming_repository_interface.dart';
import 'package:vital_data_viewer_app/services/csv/calories_csv_service.dart';
import 'package:vital_data_viewer_app/services/csv/step_csv_service.dart';
import 'package:vital_data_viewer_app/services/csv/heart_rate_csv_service.dart';
import 'package:vital_data_viewer_app/services/csv/swimming_csv_service.dart';
import 'package:vital_data_viewer_app/services/csv/sleep_csv_service.dart';

class CsvService {
  final StepRepositoryInterface _stepRepository;
  final HeartRateRepositoryInterdace _heartRateRepository;
  final SleepRepositoryInterface _sleepRepository;
  final CaloriesRepositoryInterdace _caloriesRepository;
  final SwimmingRepositoryInterface _swimmingRepository;
  final CsvRepositoryInterface _csvRepository;

  CsvService({
    required StepRepositoryInterface stepRepository,
    required HeartRateRepositoryInterdace heartRateRepository,
    required SleepRepositoryInterface sleepRepository,
    required CaloriesRepositoryInterdace caloriesRepository,
    required SwimmingRepositoryInterface swimmingRepository,
    required CsvRepositoryInterface csvRepository,
  })  : _stepRepository = stepRepository,
        _heartRateRepository = heartRateRepository,
        _sleepRepository = sleepRepository,
        _caloriesRepository = caloriesRepository,
        _swimmingRepository = swimmingRepository,
        _csvRepository = csvRepository;

  Future<bool> exportCsvData(
      List<String> dataTypes, DateTime selectedDate) async {
    final results = <List<String>>[];
    final generatedFileNames = <String>[];
    for (final dataType in dataTypes) {
      switch (dataType) {
        case 'steps':
          final stepData = await _stepRepository.fetchStep(
              selectedDate.toIso8601String().split('T')[0], '1min');
          final stepCsvData = StepCsvService.convertCsvData(stepData);
          final stepSummaryCsv =
              StepCsvService.createStepSummaryCsv(stepCsvData.stepCsvSummary);
          final stepDatasetCsv =
              StepCsvService.createStepDatasetCsv(stepCsvData.stepDatasets);
          results.add(stepSummaryCsv);
          results.add(stepDatasetCsv);
          generatedFileNames.add('steps_summary.csv');
          generatedFileNames.add('steps_dataset.csv');
          break;
        case 'heartrate':
          final heartRateData = await _heartRateRepository.fetchHeartRate(
              selectedDate.toIso8601String().split('T')[0], '1min');
          final heartRateCsvData =
              HeartRateCsvService.convertCsvData(heartRateData);
          final heartRateSummaryCsv =
              HeartRateCsvService.createHeartRateSummaryCsv(
                  heartRateCsvData.heartRateCsvSummary);
          final heartRateDatasetCsv =
              HeartRateCsvService.createHeartRateDatasetCsv(
                  heartRateCsvData.heartRateDatasets);
          results.add(heartRateSummaryCsv);
          results.add(heartRateDatasetCsv);
          generatedFileNames.add('heartrate_summary.csv');
          generatedFileNames.add('heartrate_dataset.csv');
          break;
        case 'calories':
          final caloriesData = await _caloriesRepository.fetchCalories(
              selectedDate.toIso8601String().split('T')[0], '1min');
          final caloriesCsvData =
              CaloriesCsvService.convertCsvData(caloriesData);
          final caloriesSummaryCsv =
              CaloriesCsvService.createCaloriesSummaryCsv(
                  caloriesCsvData.caloriesCsvSummary);
          final caloriesDatasetCsv =
              CaloriesCsvService.createCaloriesDatasetCsv(
                  caloriesCsvData.caloriesDatasets);
          results.add(caloriesSummaryCsv);
          results.add(caloriesDatasetCsv);
          generatedFileNames.add('calories_summary.csv');
          generatedFileNames.add('calories_dataset.csv');
          break;
        case 'swimming':
          final swimmingData = await _swimmingRepository.fetchSwimming(
              selectedDate.toIso8601String().split('T')[0], '1min');
          final swimmingCsvData =
              SwimmingCsvService.convertCsvData(swimmingData);
          final swimmingSummaryCsv =
              SwimmingCsvService.createSwimmingSummaryCsv(
                  swimmingCsvData.swimmingCsvSummary);
          final swimmingDatasetCsv =
              SwimmingCsvService.createSwimmingDatasetCsv(
                  swimmingCsvData.swimmingDatasets);
          results.add(swimmingSummaryCsv);
          results.add(swimmingDatasetCsv);
          generatedFileNames.add('swimming_summary.csv');
          generatedFileNames.add('swimming_dataset.csv');
          break;
        case 'sleep':
          final sleepData = await _sleepRepository.fetchSleepLog();
          final sleepCsvData = SleepCsvService.convertCsvData(sleepData);
          final sleepSummaryCsv = SleepCsvService.createSleepSummaryCsv(
              sleepCsvData.sleepCsvSummary);
          final sleepDatasetCsv =
              SleepCsvService.createSleepDatasetCsv(sleepCsvData.sleepDatasets);
          results.add(sleepSummaryCsv);
          results.add(sleepDatasetCsv);
          generatedFileNames.add('sleep_summary.csv');
          generatedFileNames.add('sleep_dataset.csv');
          break;
      }
    }

    // ユーザーにディレクトリを選択させる
    String? directoryPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'CSVファイルの保存先を選択してください',
    );

    // ユーザーがキャンセルした場合
    if (directoryPath == null) {
      return false;
    }
    // CSVファイルの保存処理
    final isSave = _csvRepository.saveMultipleCsvFiles(
        generatedFileNames, directoryPath, results);

    return isSave;
  }

// プラットフォームに応じた保存先パスを取得するメソッド
  Future<String> _getAppropriateDownloadPath() async {
    try {
      if (Platform.isMacOS) {
        // macOSではアプリのドキュメントディレクトリを使用（確実にアクセス可能）
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final csvDir =
            Directory(path.join(documentsDirectory.path, 'CSVExports'));

        // ディレクトリが存在しない場合は作成
        if (!await csvDir.exists()) {
          await csvDir.create(recursive: true);
        }

        log('Using directory: ${csvDir.path}'); // デバッグ用
        return csvDir.path;
      } else if (Platform.isWindows) {
        // Windowsではユーザープロファイルのドキュメントディレクトリを使用
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final csvDir =
            Directory(path.join(documentsDirectory.path, 'CSVExports'));

        // ディレクトリが存在しない場合は作成
        if (!await csvDir.exists()) {
          await csvDir.create(recursive: true);
        }

        log('Using directory: ${csvDir.path}'); // デバッグ用
        return csvDir.path;
      } else {
        // その他のプラットフォーム（Linuxなど）では一時ディレクトリを使用
        final tempDir = await getTemporaryDirectory();
        return tempDir.path;
      }
    } catch (e) {
      log('Error getting directory: $e'); // デバッグ用
      final tempDir = await getTemporaryDirectory();
      return tempDir.path;
    }
  }

  Future<Directory> getHomeDirectory() async {
    if (Platform.isMacOS) {
      // macOSでホームディレクトリを取得
      return Directory(Platform.environment['HOME'] ??
          '/Users/${Platform.environment['USER']}');
    } else if (Platform.isWindows) {
      // Windowsでホームディレクトリを取得
      return Directory(Platform.environment['USERPROFILE'] ??
          'C:\\Users\\${Platform.environment['USERNAME']}');
    } else {
      // その他の場合
      final documents = await getApplicationDocumentsDirectory();
      return Directory(path.dirname(documents.path));
    }
  }
}
