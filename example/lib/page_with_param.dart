import 'package:flutter/material.dart';

class PageWithParam extends StatelessWidget {
  final String id;

  const PageWithParam({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page with param'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Value from param: $id'),
        ],
      ),
    );
  }
}
