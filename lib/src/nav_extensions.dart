import 'package:flutter/widgets.dart';

import 'nav.dart';

extension NavContext on BuildContext {
  /// Navigates to another path. If no arguments are given, it pops the top page.
  void nav([String? path]) {
    Nav.of(this).nav(path);
  }

  void replaceCurrent(String path) {
    Nav.of(this).replaceCurrent(path);
  }

  void navOnTop(String path) {
    Nav.of(this).navOnTop(path);
  }

  void push(String path) {
    Nav.of(this).push(path);
  }

  void changePath(String path) {
    Nav.of(this).changePath(path);
  }

  Map<String, String> get params => Nav.of(this).params;

  Map<String, String> get queryParams => Nav.of(this).queryParams;

  String get currentPath => Nav.of(this).currentConfiguration;
}
