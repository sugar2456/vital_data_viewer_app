import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_data_viewer_app/view_models/csv_view_model.dart';
import 'package:vital_data_viewer_app/views/component/custom_drawer.dart';

class CsvView extends StatelessWidget {
  const CsvView({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModelの状態を監視する
    return Consumer<CsvViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('CSV出力'),
          ),
          drawer: const CustomDrawer(),
          body: Center(  // ここでCenterを使用
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'ダウンロードするデータを選択',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                // 期間表示部分
                if (viewModel.startDate != null && viewModel.endDate != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '期間: ${_formatDate(viewModel.startDate!)} 〜 ${_formatDate(viewModel.endDate!)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),  // 最大幅を制限
                  child: ListView.builder(
                      shrinkWrap: true,  // リストの内容に合わせてサイズを調整
                      physics: const NeverScrollableScrollPhysics(),  // リスト内でのスクロールを無効化
                      itemCount: viewModel.dataOptions.length,
                      itemBuilder: (context, index) {
                        final option = viewModel.dataOptions[index];
                        return CheckboxListTile(
                          title: Text(option.name),
                          value: option.isSelected,
                          onChanged: (_) {
                            viewModel.toggleDataOption(option.id);
                          },
                          secondary: Icon(option.icon),
                        );
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 300,  // ボタンの幅を制限
                    child: ElevatedButton(
                      onPressed: viewModel.selectedOptions.isEmpty ||
                              viewModel.startDate == null ||
                              viewModel.endDate == null
                          ? null // 選択がない場合は無効化
                          : () async {
                              final result = await viewModel.exportCsv();
                              if (result != null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result)),
                                );
                              }
                            },
                      child: const Text('選択したデータをCSVでダウンロード'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // カレンダーで日付範囲を選択する処理
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange:
                    viewModel.startDate != null && viewModel.endDate != null
                        ? DateTimeRange(
                            start: viewModel.startDate!,
                            end: viewModel.endDate!,
                          )
                        : null,
              );

              if (result != null) {
                viewModel.setDateRange(result.start, result.end);
              }
            },
            child: const Icon(Icons.calendar_month),
          ),
        );
      },
    );
  }

  // 日付フォーマット用のヘルパーメソッド
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}