import 'package:flutter/material.dart';

class NavNestedRouter<T> extends StatefulWidget {
  /// see [Router]
  final RouterDelegate<T> routerDelegate;

  /// see [Router]
  final RouteInformationProvider? routeInformationProvider;

  /// see [Router]
  final RouteInformationParser<T>? routeInformationParser;

  /// see [Router]
  final BackButtonDispatcher? backButtonDispatcher;

  /// see [Router]
  final String? restorationScopeId;

  const NavNestedRouter({
    Key? key,
    required this.routerDelegate,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.backButtonDispatcher,
    this.restorationScopeId,
  }) : super(key: key);

  @override
  _NavNestedRouterState<T> createState() => _NavNestedRouterState<T>();
}

class _NavNestedRouterState<T> extends State<NavNestedRouter<T>> {
  @override
  Widget build(BuildContext context) {
    return Router<T>(
      routerDelegate: widget.routerDelegate,
      routeInformationProvider: widget.routeInformationProvider,
      routeInformationParser: widget.routeInformationParser,
      backButtonDispatcher: _resolveBackButtonDispatcher(context),
      restorationScopeId: widget.restorationScopeId,
    );
  }

  BackButtonDispatcher? _resolveBackButtonDispatcher(BuildContext context) {
    if (widget.backButtonDispatcher != null) {
      return widget.backButtonDispatcher;
    }
    final parentDispatcher = Router.of(context).backButtonDispatcher;
    final childDispatcher = parentDispatcher?.createChildBackButtonDispatcher();
    childDispatcher?.takePriority();
    return childDispatcher;
  }
}
