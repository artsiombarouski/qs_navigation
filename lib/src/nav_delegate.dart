import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:qs_navigation/src/nav_page.dart';
import 'package:universal_platform/universal_platform.dart';

import 'nav.dart';
import 'nav_extended_page.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final _heroController = HeroController();
List<NavExtendedPage> _pages = [];

/// Put this as your routerDelegate in [MaterialApp.router].

class NavDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  //TODO: not a good idea to store context
  final BuildContext _context;
  final Nav _nav;
  final bool alwaysIncludeHome;

  Map<String, String> _queryParams = {};
  Map<String, String> _params = {};

  Map<String, String> get params => Map.unmodifiable(_params);

  Map<String, String> get queryParams => Map.unmodifiable(_queryParams);

  final List<NavigatorObserver> observers;

  NavDelegate({
    required BuildContext context,
    required Nav nav,
    this.observers = const [],
    this.alwaysIncludeHome = true,
  })  : _context = context,
        _nav = nav {
    this.nav(currentConfiguration);
  }

  static Widget _makeChild(Nav node) {
    return Builder(builder: node.builder!);
  }

  static NavExtendedPage _makePage(String path, Nav node,
      [bool uniqueKey = false]) {
    final child = _makeChild(node);
    return NavExtendedPage(
      page: node.transition.when(
        adaptive: () => (UniversalPlatform.isIOS || UniversalPlatform.isMacOS)
            ? CupertinoPage(
                name: node.name ?? path,
                key: uniqueKey ? UniqueKey() : ValueKey(path),
                child: child,
                fullscreenDialog: node.fullscreenDialog,
                maintainState: node.maintainState,
              )
            : MaterialPage(
                name: node.name ?? path,
                key: uniqueKey ? UniqueKey() : ValueKey(path),
                child: child,
                fullscreenDialog: node.fullscreenDialog,
                maintainState: node.maintainState,
              ),
        material: () => MaterialPage(
          name: node.name ?? path,
          key: uniqueKey ? UniqueKey() : ValueKey(path),
          child: child,
          fullscreenDialog: node.fullscreenDialog,
          maintainState: node.maintainState,
        ),
        cupertino: () => CupertinoPage(
          name: node.name ?? path,
          key: uniqueKey ? UniqueKey() : ValueKey(path),
          child: child,
          fullscreenDialog: node.fullscreenDialog,
          maintainState: node.maintainState,
        ),
        custom: (
          transitionsBuilder,
          opaque,
          barrierDismissible,
          reverseTransitionDuration,
          transitionDuration,
          barrierColor,
          barrierLabel,
        ) =>
            NavPage(
          name: node.name ?? path,
          key: uniqueKey ? UniqueKey() : ValueKey(path),
          transitionsBuilder: transitionsBuilder,
          fullscreenDialog: node.fullscreenDialog,
          maintainState: node.maintainState,
          opaque: opaque,
          barrierDismissible: barrierDismissible,
          reverseTransitionDuration: reverseTransitionDuration,
          transitionDuration: transitionDuration,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          child: child,
        ),
      ),
      path: path,
    );
  }

  List<NavExtendedPage>? _dfs(
    Nav node,
    String path,
    int matchedTill, [
    bool uniqueKey = false,
    List<String> skipGuards = const [],
  ]) {
    final pages = <NavExtendedPage>[];
    if (node.regExp != null) {
      // Handling relative and non-relative paths correctly
      final isRootPath = node.path!.startsWith('/');
      if (isRootPath) matchedTill = 0;
      final match = node.regExp!.matchAsPrefix(path.substring(matchedTill));
      if (match != null) {
        final isFinal = matchedTill + match.end == path.length;
        _params.addAll(extract(node.parameters, match));
        if (node.builder != null) {
          final queryPath = Uri(queryParameters: _queryParams).query;
          final pagePath = path.substring(0, matchedTill + match.end) +
              (isFinal && queryPath.isNotEmpty ? '?$queryPath' : '');
          //TODO: not tested well
          if (node.guards != null) {
            for (final guard in node.guards!) {
              if (!skipGuards.contains(guard.key) &&
                  guard.runner(_context, pagePath)) {
                final originPath =
                    Uri(path: path, queryParameters: _queryParams);
                final redirect =
                    guard.redirect(_context, originPath.toString());
                final redirectUri = Uri.parse(redirect);
                _queryParams = {
                  ..._queryParams,
                  ...redirectUri.queryParameters
                };
                return _dfs(_nav, redirectUri.path, 0);
              }
            }
          }
          pages.add(_makePage(pagePath, node, uniqueKey));
        }
        if (isFinal) {
          // The matching is final.
          return pages;
        }
        if (path[matchedTill + match.end - 1] == '/') {
          matchedTill += match.end;
        } else if (path[matchedTill + match.end] == '/') {
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
        final childList = _dfs(
          node.children![childIndex],
          path,
          matchedTill,
          uniqueKey,
          skipGuards,
        );
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

  @override
  Widget build(Object context) {
    if (_pages.isNotEmpty) {
      return Navigator(
        key: _navigatorKey,
        pages: _pages.map((e) => e.page).toList(),
        observers: [_heroController, ...observers],
        onPopPage: (route, result) {
          nav();
          return false;
        },
      );
    }
    return Container();
  }

  /// Navigates to another path. If no arguments are given, it pops the top page.
  void nav([String? path]) {
    _params = {};
    _queryParams = {};
    if (path == null) {
      if (_pages.length == 1) {
        return;
      }
      _pages.removeLast();
      notifyListeners();
      return;
    }
    final uri = Uri.parse(path);
    _queryParams = uri.queryParameters;
    if (path.startsWith('/')) {
      _pages = _dfs(_nav, uri.path, 0)!;
      _ensureHomePage();
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      nav(location + (location != '/' ? '/' : '') + path);
    }
  }

  void replaceCurrent(String path, {List<String>? skipGuards}) {
    if (_pages.isEmpty) {
      return;
    }
    _pages.removeLast();
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
    if (_pages.isEmpty) {
      _pages = _dfs(_nav, homePageUri.path, 0)!;
    } else if (_pages.length == 1) {
      final firstPageUri = Uri.parse(_pages[0].path);
      if (!_isHomePage(firstPageUri.path)) {
        _pages = [
          ..._dfs(_nav, homePageUri.path, 0)!,
          ..._pages,
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

  void navOnTop(String path) {
    final uri = Uri.parse(path);
    _queryParams = {..._queryParams, ...uri.queryParameters};
    if (path.startsWith('/')) {
      final newPages = _dfs(
        _nav,
        uri.path,
        0,
      )!;
      _pages = [
        ..._pages,
        ...newPages.where(
            (element) => _pages.where((e) => e.path == element.path).isEmpty),
      ];
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      navOnTop(location + (location != '/' ? '/' : '') + path);
    }
  }

  void push(String path, {List<String>? skipGuards}) {
    final uri = Uri.parse(path);
    _queryParams = {..._queryParams, ...uri.queryParameters};
    if (path.startsWith('/')) {
      final newPages = _dfs(
        _nav,
        uri.path,
        0,
        true,
        skipGuards ?? [],
      )!;
      _pages = [
        ..._pages,
        newPages.last,
      ];
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      push(
        location + (location != '/' ? '/' : '') + path,
        skipGuards: skipGuards,
      );
    }
  }

  bool popTo(String path) {
    final uri = Uri.parse(path);
    _queryParams = {..._queryParams, ...uri.queryParameters};
    if (path.startsWith('/')) {
      int index = _pages.indexWhere((element) => element.path == path);
      if (index < 0) {
        return false;
      }
      _pages = _pages.sublist(0, index + 1);
      notifyListeners();
      return true;
    } else {
      final location = Uri.parse(currentConfiguration).path;
      return popTo(location + (location != '/' ? '/' : '') + path);
    }
  }

  void changePath(String path) {
    _pages[_pages.length - 1] = _pages.last.copyWith(path: path);
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    return Future.sync(() {
      if (_pages.length == 1) {
        return false;
      }
      final targetPath = _pages[_pages.length - 2].path;
      if (!popTo(targetPath)) {
        nav(_pages[_pages.length - 2].path);
      }
      return true;
    });
  }

  @override
  Future<void> setNewRoutePath(String path) {
    return Future.sync(() {
      nav(path);
    });
  }

  @override
  String get currentConfiguration => _pages.isNotEmpty ? _pages.last.path : '/';

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
