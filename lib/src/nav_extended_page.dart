import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qs_navigation/src/nav.dart';
import 'package:qs_navigation/src/nav_page.dart';
import 'package:universal_platform/universal_platform.dart';

class NavExtendedPage {
  final Page<dynamic> page;
  final String path;

  const NavExtendedPage({
    required this.page,
    required this.path,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavExtendedPage &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          path == other.path;

  @override
  int get hashCode => page.hashCode ^ path.hashCode;

  NavExtendedPage copyWith({
    Page<dynamic>? page,
    String? path,
  }) {
    return NavExtendedPage(
      page: page ?? this.page,
      path: path ?? this.path,
    );
  }

  factory NavExtendedPage.forNode(
    String path,
    Nav node, [
    bool uniqueKey = false,
  ]) {
    final child = Builder(builder: node.builder!);
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
}
