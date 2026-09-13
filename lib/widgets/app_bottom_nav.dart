import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: p.surfaceCanvas.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(color: p.borderSubtle, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                label: 'Projects',
                icon: Icons.photo_library_outlined,
                activeIcon: Icons.photo_library,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                label: 'Community',
                icon: Icons.auto_awesome_outlined,
                activeIcon: Icons.auto_awesome,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                label: 'Invoices',
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                label: 'Profile',
                icon: Icons.account_circle_outlined,
                activeIcon: Icons.account_circle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final p = context.palette;
    final isSelected = currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onIndexChanged(index),
          splashColor: p.primary.withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? p.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(color: p.primary.withValues(alpha: 0.35), width: 1)
                      : null,
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? p.textGold : p.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? p.textGold : p.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
