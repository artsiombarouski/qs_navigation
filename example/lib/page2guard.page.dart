import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qs_navigation/nav.dart';

class Page2GuardPage extends StatelessWidget {
  const Page2GuardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page2 Guard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.replaceCurrent('/page2?guard_passed=true'),
          child: const Text("Continue to Page2"),
        ),
      ),
    );
  }
}
