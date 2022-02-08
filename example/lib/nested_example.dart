import 'package:flutter/material.dart';
import 'package:qs_navigation/nav.dart';

final nestedRoutes = Nav(
  children: [
    Nav(
        name: 'NestedRoot',
        path: '/',
        isHomePage: true,
        builder: (ctx) => const _RootPage()),
    Nav(
        name: 'NestedPage',
        path: '/nested_page',
        builder: (ctx) => const _NestedPage()),
  ],
);

class NestedExamplePage extends StatefulWidget {
  const NestedExamplePage({Key? key}) : super(key: key);

  @override
  _NestedExamplePageState createState() => _NestedExamplePageState();
}

class _NestedExamplePageState extends State<NestedExamplePage> {
  late final NavDelegate navDelegate;

  @override
  void initState() {
    navDelegate = NavDelegate(
      context: context,
      nav: nestedRoutes,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nested example')),
      body: NavNestedRouter(
        routeInformationParser: NavInformationParser(),
        routerDelegate: navDelegate,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Test'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Test'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Test'),
        ],
      ),
    );
  }
}

class _RootPage extends StatelessWidget {
  const _RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Nested Root page"),
          ElevatedButton(
            onPressed: () {
              context.push('/nested_page');
            },
            child: const Text("To Second nested page"),
          ),
        ],
      ),
    );
  }
}

class _NestedPage extends StatelessWidget {
  const _NestedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Nested child page'),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Pop back'),
          ),
        ],
      ),
    );
  }
}
