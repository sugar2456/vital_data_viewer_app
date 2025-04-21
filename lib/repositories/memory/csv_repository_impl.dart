import 'dart:developer';
import 'package:path/path.dart' as path;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:vital_data_viewer_app/repositories/interfaces/csv_repository_interface.dart';

class CsvRepositoryImpl implements CsvRepositoryInterface {
  final FileSystem fileSystem;

  CsvRepositoryImpl({
    FileSystem? fileSystem,
  }) : fileSystem = fileSystem ?? const LocalFileSystem();

  @override
  Future<bool> saveCsvFile(
    String fileName,
    String filePath,
    List<String> csvData,
  ) async {
    try {
      // ファイル名に拡張子がない場合は.csvを追加
      final normalizedFileName = fileName.endsWith('.csv') ? fileName : '$fileName.csv';
      
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


  /// 複数のCSVファイルを一括で保存する
  /// 
  /// [fileNames]: 保存するファイル名のリスト
  /// [filePath]: ファイルを保存するディレクトリのパス
  /// [csvDataList]: 各ファイルに対応するCSVデータのリスト
  /// 
  /// 戻り値: 全てのファイルが正常に保存された場合はtrue、1つでも失敗した場合はfalse
  @override
  Future<bool> saveMultipleCsvFiles(
    List<String> fileNames,
    String filePath,
    List<List<String>> csvDataList,
  ) async {
    // ファイル名とデータのリストの長さが一致しない場合はエラー
    if (fileNames.length != csvDataList.length) {
      log('Error: Number of file names (${fileNames.length}) does not match number of data sets (${csvDataList.length})');
      return false;
    }

    try {
      // ディレクトリが存在しない場合は作成（一度だけ）
      final directory = fileSystem.directory(filePath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // 全てのファイルを保存
      for (int i = 0; i < fileNames.length; i++) {
        final result = await saveCsvFile(fileNames[i], filePath, csvDataList[i]);
        if (!result) {
          log('Failed to save file: ${fileNames[i]}');
          return false; // 1つでも失敗したら全体を失敗とする
        }
      }
      
      log('Successfully saved ${fileNames.length} CSV files to: $filePath');
      return true;
    } catch (e) {
      log('Error saving multiple CSV files: $e');
      return false;
    }
  }
}