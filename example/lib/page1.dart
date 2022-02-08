import 'package:flutter/material.dart';
import 'package:qs_navigation/nav.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("page1"),
            ElevatedButton(
              onPressed: () {
                context.push('/page1_2?param1=p1&param2=p2');
              },
              child: const Text('To Page 1_2'),
            ),
          ],
        ),
      ),
    );
  }
}
