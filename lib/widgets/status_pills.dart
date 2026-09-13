import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool hasPulseDot;

  const StatusPill({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.hasPulseDot = false,
  });

  factory StatusPill.escrow({String label = 'ESCROW SECURED'}) {
    return StatusPill(
      label: label,
      backgroundColor: const Color(0xFFC45A00).withValues(alpha: 0.12),
      textColor: const Color(0xFFC45A00),
      hasPulseDot: true,
    );
  }

  factory StatusPill.action({String label = 'Action'}) {
    return StatusPill(
      label: label,
      backgroundColor: const Color(0xFFC45A00).withValues(alpha: 0.15),
      textColor: const Color(0xFFC45A00),
      hasPulseDot: true,
    );
  }

  factory StatusPill.verified({String label = 'Tier 1'}) {
    return StatusPill(
      label: label,
      backgroundColor: const Color(0xFF197A3E).withValues(alpha: 0.14),
      textColor: const Color(0xFF197A3E),
      icon: Icons.verified,
    );
  }

  factory StatusPill.activePro({String label = 'Active Pro'}) {
    return StatusPill(
      label: label,
      backgroundColor: const Color(0xFF197A3E).withValues(alpha: 0.12),
      textColor: const Color(0xFF197A3E),
    );
  }

  factory StatusPill.goldBadge(String text) {
    return StatusPill(
      label: text,
      backgroundColor: AppColors.primary.withValues(alpha: 0.18),
      textColor: const Color(0xFF966800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasPulseDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: textColor,
                boxShadow: [
                  BoxShadow(
                    color: textColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.monoSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
