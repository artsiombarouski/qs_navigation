# qs_navigation

QS Navigation

## Getting Started

Define your routes
```dart
final routes = Nav(
  children: [
    Nav(
      name: 'Home',
      path: '/',
      isHomePage: true,
      builder: (ctx) =>
      const Home(
        key: ValueKey('home'),
      ),
    ),
    Nav(
      name: 'Page1',
      path: '/page1',
      builder: (ctx) =>
      const Page1(
        key: ValueKey('page1'),
      ),
    ),
    ...
  ],
);
```

Create router delegate in your Widget with material app and create MaterialApp.router

```dart
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
```

Navigate where you need it

```dart
Nav.of(context).nav('/page1');
```

or with extension

```dart
context.nav('/page1');
```

### Update current path

Useful when you have tab navigation and you need update query parameters

```dart
Nav.of(context).changePath('/page1?tab=first');
...
Nav.of(context).changePath('/page1?tab=second');
```

### Use guards

Create a guard

```dart
final page2Guard = NavGuard(
  key: 'page2Guard',
  redirect: (context, originPath) {
    return '/page2guard';
  },
  runner: (context, originPath) {
    return !originPath.contains('guard_passed=true');
  },
);
```

Add guard to Nav constructor

```dart
final routes = Nav(
  children: [
    ...
    Nav(
      name: 'Page2Guard',
      path: '/page2guard',
      builder: (ctx) =>
      const Page2GuardPage(
        key: ValueKey('page2guard'),
      ),
    ),
    Nav(
      name: 'Page2',
      path: '/page2',
      guards: [page2Guard],
      builder: (ctx) =>
      const Page2(
        key: ValueKey('page2'),
      ),
    ),
    ...
  ],
);
```