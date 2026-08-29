import 'package:flutter/material.dart';

/// يدي إحساس دخول متتالي للعناصر (كارت كارت) بدل ما تظهر كلها مرة واحدة.
class StaggeredFadeSlide extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggeredFadeSlide({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + (index * 90)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 24),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}