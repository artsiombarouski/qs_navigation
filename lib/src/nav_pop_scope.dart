import 'package:flutter/material.dart';
import 'package:qs_navigation/nav.dart';

typedef NavPopCallback = Future<bool> Function();

class NavPopScope extends StatefulWidget {
  final Widget child;
  final NavPopCallback onWillPop;

  const NavPopScope({
    Key? key,
    required this.child,
    required this.onWillPop,
  }) : super(key: key);

  @override
  _NavPopScopeState createState() => _NavPopScopeState();
}

class _NavPopScopeState extends State<NavPopScope> {
  NavDelegate? _delegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _delegate?.removeNavPopCallback(widget.onWillPop);
    _delegate = Nav.of(context);
    _delegate?.addNavPopCallback(widget.onWillPop);
  }

  @override
  void didUpdateWidget(covariant NavPopScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onWillPop != oldWidget.onWillPop && _delegate != null) {
      _delegate!.removeNavPopCallback(oldWidget.onWillPop);
      _delegate!.addNavPopCallback(widget.onWillPop);
    }
  }

  @override
  void dispose() {
    _delegate?.removeNavPopCallback(widget.onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
