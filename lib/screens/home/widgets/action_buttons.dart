import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onLike;

  const ActionButtons({super.key, required this.onPass, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleAction(
          icon: Icons.close_rounded,
          color: AppColors.textSecondary,
          onTap: onPass,
          size: 58,
        ),
        const SizedBox(width: 24),
        _CircleAction(
          icon: Icons.favorite_rounded,
          color: AppColors.primary,
          onTap: onLike,
          size: 68,
          filled: true,
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final bool filled;

  const _CircleAction({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.size,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? color : Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: filled ? Colors.white : color, size: size * 0.45),
        ),
      ),
    );
  }
}
