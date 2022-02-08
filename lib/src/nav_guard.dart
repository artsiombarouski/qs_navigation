import 'package:flutter/widgets.dart';

typedef NavRedirect = String Function(BuildContext context, String originPath);
typedef NavGuardApplier = bool Function(
    BuildContext context, String originPath);

class NavGuard {
  final String key;
  final NavRedirect redirect;
  final NavGuardApplier apply;

  NavGuard({required this.key, required this.redirect, required this.apply});
}
