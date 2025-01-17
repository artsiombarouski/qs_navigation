import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Put this as your routeInformationParser in [MaterialApp.router].
class NavInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(routeInformation.location ?? '/');

  @override
  RouteInformation? restoreRouteInformation(String configuration) =>
      RouteInformation(location: configuration);
}
