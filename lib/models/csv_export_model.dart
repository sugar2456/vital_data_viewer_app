import 'package:flutter/widgets.dart';

class CsvExportModel {
  final String name;
  final String id;
  final IconData icon;
  bool isSelected;

  CsvExportModel({
    required this.name,
    required this.id,
    required this.icon,
    this.isSelected = false,
  });
}