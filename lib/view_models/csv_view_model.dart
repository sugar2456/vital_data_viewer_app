import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/models/csv_export_model.dart';
// import 'package:vital_data_viewer_app/repositories/interfaces/csv_repository_interdace.dart';

class CsvViewModel extends ChangeNotifier {
  // final CsvRepositoryInterdace? csvRepository;
  
  CsvViewModel();

  // CSV出力可能なデータの選択肢
  final List<CsvExportModel> _dataOptions = [
    CsvExportModel(name: '歩数', id: 'steps', icon: Icons.directions_walk),
    CsvExportModel(name: '心拍数', id: 'heartrate', icon: Icons.favorite),
    CsvExportModel(name: '血圧', id: 'bloodpressure', icon: Icons.health_and_safety),
    CsvExportModel(name: '体温', id: 'temperature', icon: Icons.thermostat),
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
    if (selectedOptions.isEmpty) {
      return null;
    }
    
    if (_selectedDate == null) {
      return null;
    }
    
    try {
      // selectedOptionsとstartDate, endDateを使ってCSV生成処理
      // この部分は実際のリポジトリ実装に依存
      
      // 仮の実装
      final selectedIds = selectedOptions.map((option) => option.id).toList();
      return 'CSV出力完了！選択項目: ${selectedIds.join(", ")}';
    } catch (e) {
      return 'エラーが発生しました: $e';
    }
  }
}