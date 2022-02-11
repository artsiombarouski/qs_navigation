import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qs_navigation/nav.dart';

class NavPopExample extends StatefulWidget {
  const NavPopExample({Key? key}) : super(key: key);

  @override
  _NavPopExampleState createState() => _NavPopExampleState();
}

class _NavPopExampleState extends State<NavPopExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavPopScope(
        child: const _InnerPop(),
        onWillPop: () async {
          final dialogResult = await showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Root pop: close?'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
          return dialogResult == true;
        },
      ),
    );
  }
}

class _InnerPop extends StatelessWidget {
  const _InnerPop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavPopScope(
      child: Container(
        alignment: Alignment.center,
        child: const Text("NavPopScope example"),
      ),
      onWillPop: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Inner pop: close?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
        return dialogResult == true;
      },
    );
  }
}
