import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1'),
      ),
      body: const Center(
        child: Text("page1"),
      ),
    );
  }
}
