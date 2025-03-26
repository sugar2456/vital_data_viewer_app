import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Widget child; // カード内に表示するコンテンツ
  final double elevation; // カードの影の強さ
  final EdgeInsetsGeometry padding; // カード内の余白
  final Color? backgroundColor; // カードの背景色

  const InfoCard({
    super.key,
    required this.child,
    this.elevation = 4.0,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation, // 影の強さ
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // カードの角を丸くする
      ),
      color: backgroundColor ?? Theme.of(context).cardColor, // 背景色
      child: IntrinsicHeight( // 子要素の高さに合わせる
        child: Padding(
          padding: padding, // カード内の余白
          child: child, // カード内のコンテンツ
        ),
      ),
    );
  }
}