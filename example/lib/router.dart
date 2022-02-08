import 'package:flutter/cupertino.dart';
import 'package:qs_navigation/nav.dart';
import 'package:qs_navigation_example/home.dart';
import 'package:qs_navigation_example/initial_guard.page.dart';
import 'package:qs_navigation_example/nested_example.dart';
import 'package:qs_navigation_example/page1.dart';
import 'package:qs_navigation_example/page1_2.dart';
import 'package:qs_navigation_example/page2.dart';
import 'package:qs_navigation_example/page2guard.page.dart';
import 'package:qs_navigation_example/page_with_param.dart';

bool _isInitialGuardPassed = false;

final initialGuard = NavGuard(
  key: 'page2Guard',
  redirect: (context, originPath) {
    return '/initial_guard';
  },
  apply: (context, originPath) {
    if (_isInitialGuardPassed) {
      return false;
    }
    if (originPath.contains('guard_passed=true')) {
      _isInitialGuardPassed = true;
      return false;
    }
    return true;
  },
);

final page2Guard = NavGuard(
  key: 'page2Guard',
  redirect: (context, originPath) {
    return '/page2guard';
  },
  apply: (context, originPath) {
    return !originPath.contains('guard_passed=true');
  },
);

final routes = Nav(
  children: [
    Nav(
      name: 'Home',
      path: '/',
      isHomePage: true,
      guards: [initialGuard],
      builder: (ctx) => const Home(
        key: ValueKey('home'),
      ),
    ),
    Nav(
      name: 'InitialGuard',
      path: '/initial_guard',
      builder: (ctx) => const InitialGuardPage(
        key: ValueKey('initial_guard'),
      ),
    ),
    Nav(
      name: 'Page1',
      path: '/page1',
      builder: (ctx) => const Page1(
        key: ValueKey('page1'),
      ),
    ),
    Nav(
      name: 'Page1_2',
      path: '/page1_2',
      builder: (ctx) {
        return Page1_2(
          key: const ValueKey('page1_2'),
          p1: ctx.queryParams['param1'],
          p2: ctx.queryParams['param2'],
        );
      },
    ),
    Nav(
      name: 'Page2Guard',
      path: '/page2guard',
      builder: (ctx) => const Page2GuardPage(
        key: ValueKey('page2guard'),
      ),
    ),
    Nav(
      name: 'Page2',
      path: '/page2',
      guards: [page2Guard],
      builder: (ctx) => const Page2(
        key: ValueKey('page2'),
      ),
    ),
    Nav(
      name: 'Page With Param',
      path: '/page_with_param/:id',
      builder: (ctx) {
        final id = ctx.params['id'];
        return PageWithParam(id: id!);
      },
    ),
    Nav(
      name: 'NestedExample',
      path: '/nested_example',
      builder: (ctx) => const NestedExamplePage(),
    ),
  ],
);
