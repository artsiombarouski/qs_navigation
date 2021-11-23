import 'package:flutter/material.dart';

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
}
