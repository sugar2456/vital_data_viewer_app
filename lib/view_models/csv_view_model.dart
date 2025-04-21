import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/csv_export_model.dart';
import 'package:vital_data_viewer_app/services/csv/csv_service.dart';
// import 'package:vital_data_viewer_app/repositories/interfaces/csv_repository_interdace.dart';

class CsvViewModel extends ChangeNotifier {
  // final CsvRepositoryInterdace? csvRepository;
  final CsvService csvService;
  
  CsvViewModel({
    required this.csvService,
  });

  // CSV出力可能なデータの選択肢
  final List<CsvExportModel> _dataOptions = [
    CsvExportModel(name: '歩数', id: 'steps', icon: Icons.directions_walk),
    CsvExportModel(name: '心拍数', id: 'heartrate', icon: Icons.favorite),
    CsvExportModel(name: 'カロリー', id: 'calories', icon: Icons.local_fire_department),
    CsvExportModel(name: '水泳', id: 'swimming', icon: Icons.pool),
    CsvExportModel(name: '睡眠', id: 'sleep', icon: Icons.bedtime),
  ];

  // 期間指定用の日付範囲
  DateTime? _selectedDate;
  // DateTime? _endDate;
  
  // ゲッター
  List<CsvExportModel> get dataOptions => _dataOptions;
  DateTime? get selectedDate => _selectedDate;
  // DateTime? get endDate => _endDate;
  
  // 選択されているデータ項目を取得
  List<CsvExportModel> get selectedOptions => 
      _dataOptions.where((option) => option.isSelected).toList();
  
  // 項目の選択状態を切り替え
  void toggleDataOption(String id) {
    final index = _dataOptions.indexWhere((option) => option.id == id);
    if (index != -1) {
      _dataOptions[index].isSelected = !_dataOptions[index].isSelected;
      notifyListeners();
    }
  }
  
  // 日付範囲の設定
  // void setDateRange(DateTime start, DateTime end) {
  //   _startDate = start;
  //   _endDate = end;
  //   notifyListeners();
  // }

  void setSelectedDate(DateTime start) {
    _selectedDate = start;
    notifyListeners();
  }
  
  // CSV出力処理
  Future<String?> exportCsv() async {
    if (selectedOptions.isEmpty || _selectedDate == null) {
      return null;
    }
    
    try {
      final selectedIds = selectedOptions.map((option) => option.id).toList();
      final result = await csvService.exportCsvData(selectedIds, _selectedDate!);
      if (result == []) {
        return 'CSV出力に失敗しました';
      }
      return 'CSV出力完了！選択項目: ${selectedIds.join(", ")}';
    } catch (e) {
      return 'エラーが発生しました: $e';
    }
  }
}