import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page2'),
      ),
      body: const Center(
        child: Text("page2"),
      ),
    );
  }
}
