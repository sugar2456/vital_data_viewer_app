import 'package:flutter/material.dart';

class ErrorDialog {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}