import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import 'nav.dart';
import 'nav_extended_page.dart';

/// Put this as your routerDelegate in [MaterialApp.router].

class NavDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final _heroController = HeroController();
  final _navigatorKey = GlobalKey<NavigatorState>();

  //TODO: not a good idea to store context
  final BuildContext _context;

  final Nav _nav;
  final bool alwaysIncludeHome;

  final List<NavigatorObserver> observers;

  List<NavExtendedPage> _currentPages = [];

  Map<String, String> get params => _currentPages.lastOrNull?.params ?? {};

  Map<String, String> get queryParams =>
      _currentPages.lastOrNull?.queryParams ?? {};

  NavDelegate({
    required BuildContext context,
    required Nav nav,
    this.observers = const [],
    this.alwaysIncludeHome = true,
  })  : _context = context,
        _nav = nav {
    this.nav(currentConfiguration);
  }

  @override
  Widget build(Object context) {
    if (_currentPages.isEmpty) {
      return Container();
    }
    return Navigator(
      key: _navigatorKey,
      pages: _currentPages.map((e) => e.page).toList(),
      observers: [_heroController, ...observers],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        nav();
        return true;
      },
    );
  }

  /// Navigates to another path. If no arguments are given, it pops the top page.
  void nav([String? path]) {
    if (path == null) {
      if (_currentPages.length == 1) {
        return;
      }
      _currentPages.removeLast();
      notifyListeners();
      return;
    }
    if (path.startsWith('/')) {
      _currentPages = _buildPageStack(_nav, path, 0)!;
      // _ensureHomePage();
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      nav(location + (location != '/' ? '/' : '') + path);
    }
  }

  void replaceCurrent(String path, {List<String>? skipGuards}) {
    if (_currentPages.isEmpty) {
      return;
    }
    _currentPages.removeLast();
    return push(path, skipGuards: skipGuards);
  }

  void _ensureHomePage() {
    if (!alwaysIncludeHome) {
      return;
    }
    final homePage = _nav.children?.firstWhere((e) => e.isHomePage);
    if (homePage == null || homePage.path == null) {
      return;
    }
    final homePageUri = Uri.parse(homePage.path!);
    if (_currentPages.isEmpty) {
      _currentPages = _buildPageStack(_nav, homePageUri.path, 0)!;
    } else if (_currentPages.length == 1) {
      final firstPageUri = Uri.parse(_currentPages[0].path);
      if (!_isHomePage(firstPageUri.path)) {
        _currentPages = [
          ..._buildPageStack(_nav, homePageUri.path, 0)!,
          ..._currentPages,
        ];
      }
    }
  }

  bool _isHomePage(String path) {
    final homePages =
        _nav.children?.where((e) => e.isHomePage && e.path != null);
    final hasMatch = homePages?.any((e) => Uri.parse(e.path!).path == path);
    return hasMatch ?? false;
  }

  /// Reorder or pages for bring page with provided to front or create new one
  void navOnTop(String path) {
    if (path.startsWith('/')) {
      final newPages = _buildPageStack(_nav, path, 0)!;
      _currentPages = [
        ..._currentPages,
        ...newPages.where((element) =>
            _currentPages.where((e) => e.path == element.path).isEmpty),
      ];
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      navOnTop(location + (location != '/' ? '/' : '') + path);
    }
  }

  /// Add page on top of other
  void push(String path, {List<String>? skipGuards}) {
    if (path.startsWith('/')) {
      final newPages = _buildPageStack(_nav, path, 0, true, skipGuards ?? [])!;
      _currentPages = [..._currentPages, newPages.last];
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      push(
        location + (location != '/' ? '/' : '') + path,
        skipGuards: skipGuards,
      );
    }
  }

  /// Pop to page in current stack, if not - nothing happen
  bool popTo(String path) {
    if (path.startsWith('/')) {
      int index = _currentPages.indexWhere((element) => element.path == path);
      if (index < 0) {
        return false;
      }
      _currentPages = _currentPages.sublist(0, index + 1);
      notifyListeners();
      return true;
    } else {
      final location = Uri.parse(currentConfiguration).path;
      return popTo(location + (location != '/' ? '/' : '') + path);
    }
  }

  /// Change current page path
  void changePath(String path) {
    _currentPages[_currentPages.length - 1] =
        _currentPages.last.copyWith(path: path);
    notifyListeners();
  }

  @override
  Future<bool> popRoute() {
    return Future.sync(() {
      if (_currentPages.length == 1) {
        return false;
      }
      final targetPath = _currentPages[_currentPages.length - 2].path;
      if (!popTo(targetPath)) {
        nav(_currentPages[_currentPages.length - 2].path);
      }
      return true;
    });
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    return Future.sync(() => nav(configuration));
  }

  @override
  String get currentConfiguration =>
      _currentPages.isNotEmpty ? _currentPages.last.path : '/';

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  List<NavExtendedPage>? _buildPageStack(
    Nav node,
    String originPath,
    int matchedTill, [
    bool uniqueKey = false,
    List<String> skipGuards = const [],
  ]) {
    final uri = Uri.parse(originPath);
    final pages = <NavExtendedPage>[];
    if (node.regExp != null) {
      // Handling relative and non-relative paths correctly
      final isRootPath = node.path!.startsWith('/');
      if (isRootPath) matchedTill = 0;
      final match = node.regExp!.matchAsPrefix(uri.path.substring(matchedTill));
      if (match != null) {
        final isFinal = matchedTill + match.end == uri.path.length;
        final params = extract(node.parameters, match);
        if (node.guards != null) {
          for (final guard in node.guards!) {
            if (!skipGuards.contains(guard.key) &&
                guard.apply(_context, originPath)) {
              final redirect = guard.redirect(_context, originPath);
              return _buildPageStack(
                  _nav, redirect, 0, uniqueKey, [...skipGuards, guard.key]);
            }
          }
        }
        if (node.builder != null) {
          pages.add(NavExtendedPage.forNode(
            path: originPath,
            node: node,
            uniqueKey: uniqueKey,
            params: params,
            queryParams: uri.queryParameters,
          ));
        }
        if (isFinal) {
          // The matching is final.
          return pages;
        }
        if (uri.path[matchedTill + match.end - 1] == '/') {
          matchedTill += match.end;
        } else if (uri.path[matchedTill + match.end] == '/') {
          matchedTill += match.end + 1;
        } else {
          matchedTill = 0;
        }
      }
    }
    if (node.children != null) {
      for (int childIndex = 0;
          childIndex < node.children!.length;
          ++childIndex) {
        final childList = _buildPageStack(node.children![childIndex],
            originPath, matchedTill, uniqueKey, skipGuards);
        if (childList != null) {
          // We found a match, we can return.
          pages.addAll(childList);
          return pages;
        }
      }
    }
    // No match found in this subtree.
    return null;
  }
}
