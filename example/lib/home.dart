import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qs_navigation/nav.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qs Navigation Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.nav('/page1'),
            child: const Text('To Page 1'),
          ),
          ElevatedButton(
            onPressed: () => context.nav('/page2'),
            child: const Text('To Page 2'),
          ),
        ],
      ),
    );
  }
}
