import 'package:flutter/material.dart';
import 'package:qs_navigation/nav.dart';
import 'package:qs_navigation_example/navigation.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NavDelegate navDelegate;

  @override
  void initState() {
    navDelegate = NavDelegate(context: context, nav: routes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: NavInformationParser(),
      routerDelegate: navDelegate,
    );
  }
}
