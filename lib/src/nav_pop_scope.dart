import 'package:flutter/material.dart';

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
  NavPopScopeState createState() => NavPopScopeState();
}

class PopDelegate {
  static final Map<ModalRoute<dynamic>, PopDelegate> _cache = {};

  static PopDelegate of(BuildContext context) {
    final route = ModalRoute.of<dynamic>(context)!;
    PopDelegate? delegate = _cache[route];
    if (delegate == null) {
      delegate = PopDelegate(route);
      _cache[route] = delegate;
    }
    return delegate;
  }

  final ModalRoute route;
  final List<WillPopCallback> _callbacks = [];

  PopDelegate(this.route);

  Future<bool> willPop() async {
    for (final WillPopCallback callback
        in List<WillPopCallback>.of(_callbacks).reversed) {
      if (await callback() != true) return false;
    }
    return true;
  }

  void addCallback(WillPopCallback callback) {
    _callbacks.remove(callback);
    _callbacks.add(callback);
    attach();
  }

  void removeCallback(WillPopCallback callback) {
    _callbacks.remove(callback);
    if (_callbacks.isEmpty) {
      detach();
    }
  }

  void attach() {
    route.removeScopedWillPopCallback(willPop);
    route.addScopedWillPopCallback(willPop);
  }

  void detach() {
    route.removeScopedWillPopCallback(willPop);
    _cache.remove(route);
  }
}

class NavPopScopeState extends State<NavPopScope> {
  PopDelegate? _popDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _popDelegate?.removeCallback(widget.onWillPop);
    _popDelegate = PopDelegate.of(context);
    _popDelegate!.addCallback(widget.onWillPop);
  }

  @override
  void didUpdateWidget(covariant NavPopScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onWillPop != oldWidget.onWillPop && _popDelegate != null) {
      _popDelegate!.removeCallback(oldWidget.onWillPop);
      _popDelegate!.addCallback(widget.onWillPop);
    }
  }

  @override
  void dispose() {
    _popDelegate?.removeCallback(widget.onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
