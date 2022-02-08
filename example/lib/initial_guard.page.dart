import 'package:flutter/material.dart';
import 'package:qs_navigation/nav.dart';

class InitialGuardPage extends StatelessWidget {
  const InitialGuardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('To main page'),
          onPressed: () {
            context.replaceCurrent('/?guard_passed=true');
          },
        ),
      ),
    );
  }
}
