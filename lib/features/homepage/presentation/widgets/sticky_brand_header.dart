import 'package:flutter/material.dart';

class StickyBrandHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyBrandHeader({required this.child});

  @override
  double get minExtent => 140;

  @override
  double get maxExtent => 140;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(StickyBrandHeader oldDelegate) {
    return false;
  }
}
