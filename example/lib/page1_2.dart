import 'package:flutter/material.dart';

class Page1_2 extends StatelessWidget {
  final String? p1;
  final String? p2;

  const Page1_2({Key? key, this.p1, this.p2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1_2'),
      ),
      body: Column(
        children: [
          const Text("page1_2"),
          Text("p1: $p1"),
          Text("p2: $p2"),
        ],
      ),
    );
  }
}
