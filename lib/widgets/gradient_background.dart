import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final String? imageAsset;

  const GradientBackground({super.key, required this.child, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    if (imageAsset == null) {
      return Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(child: child),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imageAsset!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.25),
                Colors.transparent,
                Colors.black.withOpacity(0.78),
              ],
              stops: const [0.0, 0.38, 0.9],
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
