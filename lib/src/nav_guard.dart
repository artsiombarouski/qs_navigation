import 'package:flutter/widgets.dart';

typedef NavRedirect = String Function(BuildContext context, String originPath);
typedef NavGuardRunner = bool Function(
    BuildContext context, String originPath);

class NavGuard {
  final String key;
  final NavRedirect redirect;
  final NavGuardRunner runner;

  NavGuard({required this.key, required this.redirect, required this.runner});
}
