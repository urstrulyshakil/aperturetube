import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ApertureLogo extends StatelessWidget {
  final double size;
  final bool showAura;

  const ApertureLogo({
    super.key,
    this.size = 72,
    this.showAura = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showAura)
            Container(
              width: size * 1.3,
              height: size * 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.28),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLowest,
              border: Border.all(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: Size(size * 0.72, size * 0.72),
                painter: _ApertureBladesPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApertureBladesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bladePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = AppColors.surfaceCanvas
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const numBlades = 6;
    final angleStep = (2 * math.pi) / numBlades;

    for (int i = 0; i < numBlades; i++) {
      final startAngle = i * angleStep;
      final path = Path();

      final p1 = Offset(
        center.dx + radius * math.cos(startAngle),
        center.dy + radius * math.sin(startAngle),
      );

      final p2 = Offset(
        center.dx + radius * math.cos(startAngle + angleStep * 0.9),
        center.dy + radius * math.sin(startAngle + angleStep * 0.9),
      );

      final p3 = Offset(
        center.dx + (radius * 0.35) * math.cos(startAngle + angleStep * 0.45),
        center.dy + (radius * 0.35) * math.sin(startAngle + angleStep * 0.45),
      );

      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
      path.close();

      canvas.drawPath(path, bladePaint);
      canvas.drawPath(path, outlinePaint);
    }

    final innerHolePaint = Paint()
      ..color = AppColors.surfaceCanvas
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, innerHolePaint);

    final innerRingPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius * 0.3, innerRingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
