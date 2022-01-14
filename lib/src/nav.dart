import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:qs_navigation/src/nav_delegate.dart';
import 'package:qs_navigation/src/nav_guard.dart';
import 'package:qs_navigation/src/nav_transition.dart';

typedef NavWidgetBuilder = Widget Function(BuildContext context);

/// The class that defines your routing tree structure.
///
/// If several Navss match a given path the very top one will be chosen.
class Nav {
  static NavDelegate of(BuildContext context) {
    return Router.of(context).routerDelegate as NavDelegate;
  }

  final String? name;

  /// The blueprint path for this nav.
  ///
  /// You can use parameters and regexes inside paranthesis.
  /// For example `'/user/:id(/d+)'` means the path should match
  /// `'/user/10'` but not `'/user/alice'`.
  ///
  /// It can also be relative. For example if the parent nav has a
  /// path of `'/profile'` and this nav has a path of `'settings'`
  /// it's actually matching `'/profile/settings'`.
  final String? path;

  /// A function that gets the path and query parameters and builds the widget.
  final NavWidgetBuilder? builder;

  /// A list of subnavs of this nav.
  final List<Nav>? children;

  /// The default transition of this nav.
  ///
  /// Defaults to [NavTransition.adaptive].
  final NavTransition transition;

  /// Whether or not to maintain the state of this nav.
  ///
  /// Defaults to true.
  final bool maintainState;

  /// Whether it's a dialog or a normal page.
  ///
  /// Dialogs have a close button instead of a back button by default.
  /// Defaults to false.
  final bool fullscreenDialog;

  final bool isHomePage;

  final List<NavGuard>? guards;

  final List<String> parameters;
  late final RegExp? regExp;

  Nav({
    this.name,
    this.path,
    bool caseSensitive = true,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.builder,
    this.children,
    this.transition = NavTransition.adaptive,
    this.isHomePage = false,
    this.guards,
  }) : parameters = [] {
    if (children != null && children!.isEmpty) {
      throw ArgumentError('children cannot be empty');
    }
    if (path == null && children == null) {
      throw ArgumentError('Both path and children cannot be null.');
    }
    if (path != null) {
      regExp = pathToRegExp(
        path!,
        parameters: parameters,
        prefix: true,
        caseSensitive: caseSensitive,
      );
    } else {
      regExp = null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Nav && hashCode == other.hashCode;
  }

  @override
  int get hashCode {
    int h = super.hashCode;
    for (final child in children ?? []) {
      h ^= child.hashCode;
    }
    return h ^ path.hashCode;
  }
}
