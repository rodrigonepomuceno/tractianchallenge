import 'package:flutter/material.dart';
import 'package:tractianchallenge/core/theme/app_theme.dart';
import 'package:tractianchallenge/core/theme/app_typography.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.buttonSelected : Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: isSelected ? AppTheme.buttonSelected : AppTheme.buttonBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              color: isSelected ? AppTheme.background : AppTheme.buttonText,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.mediumSm.copyWith(
                color: isSelected ? AppTheme.background : AppTheme.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
