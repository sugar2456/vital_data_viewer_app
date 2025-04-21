import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:path/path.dart' as path;
import 'package:vital_data_viewer_app/repositories/memory/csv_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/memory/test_csv_repository_impl.dart';

void main() {
  late CsvRepositoryImpl csvRepository;
  late FileSystem fileSystem;

  setUp(() {
    // メモリ内ファイルシステムを作成
    fileSystem = MemoryFileSystem();

    // テスト対象のクラスを初期化
    csvRepository = CsvRepositoryImpl(fileSystem: fileSystem);
  });

  group('CSVファイル保存テスト', () {
    test('CSVファイルが正しく保存されること', () async {
      // テストデータ準備
      const fileName = 'test';
      const filePath = '/test/path';
      final csvData = [
        'header1,header2,header3',
        'data1,data2,data3',
        'data4,data5,data6'
      ];

      // テスト実行
      final result =
          await csvRepository.saveCsvFile(fileName, filePath, csvData);

      // アサーション
      expect(result, true);

      // ファイルが存在するか確認
      final fullPath = path.join(filePath, '$fileName.csv');
      expect(fileSystem.file(fullPath).existsSync(), true);

      // ファイルの内容が正しいか確認
      final content = fileSystem.file(fullPath).readAsStringSync();
      final expectedContent = '${csvData.join('\n')}\n';
      expect(content, expectedContent);
    });

    test('ファイル名に拡張子が含まれている場合も正しく保存されること', () async {
      const fileName = 'test.csv';
      const filePath = '/test/path';
      final csvData = ['data1,data2'];

      final result =
          await csvRepository.saveCsvFile(fileName, filePath, csvData);

      expect(result, true);
      final fullPath = path.join(filePath, fileName); // 既に.csvが含まれているのでそのまま使用
      expect(fileSystem.file(fullPath).existsSync(), true);
    });

    test('ディレクトリが存在しない場合は作成されること', () async {
      const fileName = 'test.csv';
      const filePath = '/new/directory/path';
      final csvData = ['data1,data2'];

      // ディレクトリが存在しないことを確認
      expect(fileSystem.directory(filePath).existsSync(), false);

      final result =
          await csvRepository.saveCsvFile(fileName, filePath, csvData);

      expect(result, true);
      // ディレクトリが作成されたことを確認
      expect(fileSystem.directory(filePath).existsSync(), true);
      // ファイルが作成されたことを確認
      final fullPath = path.join(filePath, fileName);
      expect(fileSystem.file(fullPath).existsSync(), true);
    });

    test('ファイル書き込みエラー時にfalseが返されること', () async {
      // 書き込み不可能なファイルシステムをモック
      final mockFileSystem = MemoryFileSystem();
      final mockDirectory = mockFileSystem.directory('/test/path');
      await mockDirectory.create(recursive: true);

      // エラーを発生させるリポジトリに置き換え
      final errorCsvRepository = TestCsvRepository(fileSystem: mockFileSystem);
      final result = await errorCsvRepository
          .saveCsvFile('test', '/test/path', ['data1,data2']);
      expect(result, false);
    });
  });
}
