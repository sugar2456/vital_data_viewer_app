import 'package:flutter/material.dart';
import 'package:vital_data_viewer_app/views/component/info_card.dart';

class StackCord extends StatelessWidget {
  final String valueText;
  final String unitText;

  const StackCord({
    super.key,
    required this.valueText,
    required this.unitText,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valueText,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  unitText,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            )));
  }
}
