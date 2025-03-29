import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:vital_data_viewer_app/models/response/dataset.dart';
import 'package:vital_data_viewer_app/views/component/info_card.dart';

class LineChart extends StatelessWidget {
  final String xAxisLabel;
  final String xAxisUnit;
  final String yAxisLabel;
  final String yAxisUnit;
  final List<dynamic> data;

  const LineChart(
      {super.key,
      required this.xAxisLabel,
      required this.xAxisUnit,
      required this.yAxisLabel,
      required this.yAxisUnit,
      required this.data});
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: SizedBox(
        height: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // グラフ本体
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Y軸のタイトル
                  RotatedBox(
                    quarterTurns: 3, // タイトルを縦向きに回転
                    child: Text(
                      '$yAxisLabel ($yAxisUnit)', // Y軸のタイトル
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // タイトルとグラフの間のスペース
                  Expanded(
                    child: Chart(
                      data: data,
                      variables: {
                        'time': Variable(
                          accessor: (dynamic data) =>
                              (data as Dataset).dateTime,
                          scale: TimeScale(
                            formatter: (time) => '${time.hour}:${time.minute}',
                            tickCount: 24,
                          ),
                        ),
                        'value': Variable(
                          accessor: (dynamic data) =>
                              (data as Dataset).value,
                          scale: LinearScale(min: 0),
                        ),
                      },
                      marks: [
                        LineMark(
                          shape:
                              ShapeEncode(value: BasicLineShape()), // 線の形状を指定
                          color: ColorEncode(value: Colors.blue), // 単一の色を指定
                          size: SizeEncode(value: 2), // 線の太さを指定
                        )
                      ],
                      axes: [
                        AxisGuide(
                          variable: 'time',
                          tickLine: TickLine(
                            length: 5,
                          ),
                          label: LabelStyle(
                            textStyle: const TextStyle(color: Colors.grey),
                            align: Alignment.center,
                            offset: const Offset(0, 20),
                          ),
                        ),
                        // Y軸の設定
                        AxisGuide(
                          variable: 'value',
                          tickLine: TickLine(
                            length: 5,
                          ),
                          label: LabelStyle(
                            textStyle: const TextStyle(color: Colors.grey),
                            align: Alignment.center,
                            offset: const Offset(-30, 0),
                          ),
                          grid: PaintStyle(
                            strokeColor: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                      ],
                      selections: {'tap': PointSelection(dim: Dim.x)},
                      tooltip: TooltipGuide(renderer: simpleTooltip),
                      crosshair: CrosshairGuide(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // グラフとx軸タイトルの間のスペース
            // X軸のタイトル
            Text(
              '$xAxisLabel ($xAxisUnit)', // X軸のタイトル
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<MarkElement> simpleTooltip(
  Size size,
  Offset anchor,
  Map<int, Tuple> selectedTuples,
) {
  List<MarkElement> elements;

  String textContent = '';
  final selectedTupleList = selectedTuples.values;
  final fields = selectedTupleList.first.keys.toList();
  if (selectedTuples.length == 1) {
    final original = selectedTupleList.single;
    var field = fields.first;
    textContent += '$field: ${original[field]}';
    for (var i = 1; i < fields.length; i++) {
      field = fields[i];
      textContent += '\n$field: ${original[field]}';
    }
  } else {
    for (var original in selectedTupleList) {
      final domainField = fields.first;
      final measureField = fields.last;
      textContent += '\n${original[domainField]}: ${original[measureField]}';
    }
  }

  const textStyle = TextStyle(fontSize: 12, color: Colors.white);
  const padding = EdgeInsets.all(5);
  const align = Alignment.topRight;
  const offset = Offset(5, -5);
  const elevation = 1.0;
  const backgroundColor = Colors.black;

  final painter = TextPainter(
    text: TextSpan(text: textContent, style: textStyle),
    textDirection: TextDirection.ltr,
  );
  painter.layout();

  final width = padding.left + painter.width + padding.right;
  final height = padding.top + painter.height + padding.bottom;

  final paintPoint = getBlockPaintPoint(
    anchor + offset,
    width,
    height,
    align,
  );

  final window = Rect.fromLTWH(
    paintPoint.dx,
    paintPoint.dy,
    width,
    height,
  );

  var textPaintPoint = paintPoint + padding.topLeft;

  elements = <MarkElement>[
    RectElement(
        rect: window,
        style: PaintStyle(fillColor: backgroundColor, elevation: elevation)),
    LabelElement(
        text: textContent,
        anchor: textPaintPoint,
        style: LabelStyle(textStyle: textStyle, align: Alignment.bottomRight)),
  ];

  return elements;
}
