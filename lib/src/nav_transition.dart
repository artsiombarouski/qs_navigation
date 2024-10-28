import 'package:flutter/widgets.dart';

enum NavTransitionType {
  adaptive,
  material,
  cupertino,
  custom,
}

class NavTransition {
  final NavTransitionType type;
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

  static const adaptive = NavTransition._(type: NavTransitionType.adaptive);

  static const material = NavTransition._(type: NavTransitionType.material);

  static const cupertino = NavTransition._(type: NavTransitionType.cupertino);

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
        type: NavTransitionType.custom,
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
      case NavTransitionType.adaptive:
        return adaptive();
      case NavTransitionType.material:
        return material();
      case NavTransitionType.cupertino:
        return cupertino();
      case NavTransitionType.custom:
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
