import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FilterButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.border),
      ),
      icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
    );
  }
}
