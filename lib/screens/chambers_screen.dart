import 'package:flutter/material.dart';

class ChambersScreen extends StatelessWidget {
  const ChambersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chambers')),
      body: const Center(child: Text('Chambers List Placeholder')),
    );
  }
}
