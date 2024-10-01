import 'dart:ui';

import 'package:flutter/material.dart';

/// Container with blur effect and circle shape
class BlurButtonContainer extends StatelessWidget {
  final Widget child;

  const BlurButtonContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 80,
          sigmaY: 80,
        ),
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: child,
        ),
      ),
    );
  }
}
