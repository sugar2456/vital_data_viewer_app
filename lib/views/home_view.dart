import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final TextEditingController fitbitIdController = TextEditingController();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {

              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}