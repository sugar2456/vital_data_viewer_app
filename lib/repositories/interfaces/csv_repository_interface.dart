abstract class CsvRepositoryInterface {
  Future<bool> saveCsvFile(
    String fileName,
    String filePath,
    List<String> csvData,
  );
}