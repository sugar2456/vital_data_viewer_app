import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:vital_data_viewer_app/views/component/info_card.dart';

class DonutChart extends StatelessWidget {
  final String title;
  final int goalSteps;
  final int actualSteps;

  const DonutChart({
    super.key,
    required this.title,
    required this.goalSteps,
    required this.actualSteps,
  });

  @override
  Widget build(BuildContext context) {
    final remainingSteps = goalSteps - actualSteps;

    return InfoCard(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Chart(
            data: [
              {'label': '実際の歩数', 'value': actualSteps},
              {'label': '残りの歩数', 'value': remainingSteps},
            ],
            variables: {
              'label': Variable(
                accessor: (Map map) => map['label'] as String,
              ),
              'value': Variable(
                accessor: (Map map) => map['value'] as num,
              ),
            },
            transforms: [
              Proportion(
                variable: 'value',
                as: 'percent',
              )
            ],
            marks: [
              IntervalMark(
                position: Varset('percent') / Varset('label'),
                color: ColorEncode(
                  variable: 'label',
                  values: [Colors.blue, Colors.grey[300]!],
                ),
                modifiers: [StackModifier()],
              )
            ],
            coord: PolarCoord(
              transposed: true,
              dimCount: 1,
              // 円グラフ空白の半径
              startRadius: 0.8,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '$actualSteps歩',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '目標: $goalSteps歩',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
