// ignore_for_file: dead_code

import 'package:vital_data_viewer_app/repositories/interfaces/csv_repository_interface.dart';
import 'dart:developer';
import 'package:path/path.dart' as path;
import 'package:file/file.dart';
import 'package:file/local.dart';

class TestCsvRepository extends CsvRepositoryInterface {
  final FileSystem fileSystem;

  TestCsvRepository({
    FileSystem? fileSystem,
  }) : fileSystem = fileSystem ?? const LocalFileSystem();

  @override
  Future<bool> saveCsvFile(
      String fileName, String filePath, List<String> csvData) async {
    try {
      throw Exception('Test exception'); // テスト用の例外をスロー
      
      // ファイル名に拡張子がない場合は.csvを追加
      final normalizedFileName =
          fileName.endsWith('.csv') ? fileName : '$fileName.csv';

      // OSによって区切り文字が異なるため、path.joinを使用してパスを正規化
      final fullPath = path.join(filePath, normalizedFileName);

      // ディレクトリが存在しない場合は作成
      final directory = fileSystem.directory(filePath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // ファイルを作成して書き込み
      final file = fileSystem.file(fullPath);
      final sink = file.openWrite();
      for (var line in csvData) {
        sink.writeln(line);
      }
      await sink.flush();
      await sink.close();

      log('CSV file saved successfully at: $fullPath');
      return true;
    } catch (e) {
      log('Error saving CSV file: $e');
      return false;
    }
  }
  @override
  Future<bool> saveMultipleCsvFiles(
      List<String> fileNames, String filePath, List<List<String>> csvDataList) async {
    try {
      for (int i = 0; i < fileNames.length; i++) {
        final fileName = fileNames[i];
        final csvData = csvDataList[i];
        await saveCsvFile(fileName, filePath, csvData);
      }
      return true;
    } catch (e) {
      log('Error saving multiple CSV files: $e');
      return false;
    }
  }
}
