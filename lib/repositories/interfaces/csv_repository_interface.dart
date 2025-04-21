abstract class CsvRepositoryInterface {
  Future<bool> saveCsvFile(
    String fileName,
    String filePath,
    List<String> csvData,
  );
  Future<bool> saveMultipleCsvFiles(
    List<String> fileNames,
    String filePath,
    List<List<String>> csvDataList,
  );
}