import 'package:flutter/widgets.dart';

enum _NavTransitionType {
  adaptive,
  material,
  cupertion,
  custom,
}

class NavTransition {
  final _NavTransitionType type;
  final RouteTransitionsBuilder? transitionsBuilder;
  final bool opaque;
  final bool barrierDismissible;
  final Duration reverseTransitionDuration;
  final Duration transitionDuration;
  final Color? barrierColor;
  final String? barrierLabel;

  const NavTransition._({
    required this.type,
    this.transitionsBuilder,
    this.opaque = true,
    this.barrierDismissible = false,
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.transitionDuration = const Duration(milliseconds: 300),
    this.barrierColor,
    this.barrierLabel,
  });

  static const adaptive = NavTransition._(type: _NavTransitionType.adaptive);

  static const material = NavTransition._(type: _NavTransitionType.material);

  static const cupertion = NavTransition._(type: _NavTransitionType.cupertion);

  factory NavTransition.custom({
    required RouteTransitionsBuilder transitionsBuilder,
    bool opaque = true,
    bool barrierDismissible = false,
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    Duration transitionDuration = const Duration(milliseconds: 300),
    Color? barrierColor,
    String? barrierLabel,
  }) =>
      NavTransition._(
        type: _NavTransitionType.custom,
        transitionsBuilder: transitionsBuilder,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        reverseTransitionDuration: reverseTransitionDuration,
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
      );

  TResult when<TResult extends Object?>({
    required TResult Function() adaptive,
    required TResult Function() material,
    required TResult Function() cupertino,
    required TResult Function(
            RouteTransitionsBuilder transitionsBuilder,
            bool opaque,
            bool barrierDismissible,
            Duration reverseTransitionDuration,
            Duration transitionDuration,
            Color? barrierColor,
            String? barrierLabel)
        custom,
  }) {
    switch (type) {
      case _NavTransitionType.adaptive:
        return adaptive();
      case _NavTransitionType.material:
        return material();
      case _NavTransitionType.cupertion:
        return cupertino();
      case _NavTransitionType.custom:
        return custom(
          transitionsBuilder!,
          opaque,
          barrierDismissible,
          reverseTransitionDuration,
          transitionDuration,
          barrierColor,
          barrierLabel,
        );
    }
  }
}
