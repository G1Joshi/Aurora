import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final double pulse;
  final Color themeColor;
  BackgroundPainter({required this.pulse, required this.themeColor});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pScale = (sin(pulse * pi) * 0.1) + 1.0;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        colors: [
          themeColor.withValues(alpha: 0.08 * pScale),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    const spacing = 16.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.5, dotPaint);
      }
    }

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.01)
      ..strokeWidth = 0.5;

    for (double i = -size.height; i < size.width; i += spacing * 2) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter old) => true;
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double pulse;
  ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.pulse,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 45;
    final pPulse = (sin(pulse * pi) * 0.08) + 1.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3 * pPulse)
        ..strokeWidth = 18 * pPulse
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 * pPulse);
      canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, glowPaint);

      final sweepShader = SweepGradient(
        transform: const GradientRotation(-pi / 2),
        startAngle: 0.0,
        endAngle: (2 * pi * progress) + 0.01,
        colors: [
          color.withValues(alpha: 0.0),
          color,
          Colors.white.withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.9, 1.0],
      ).createShader(rect);

      final ringPaint = Paint()
        ..shader = sweepShader
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, ringPaint);
    }
  }

  @override
  bool shouldRepaint(ProgressRingPainter old) => true;
}

class PotPainter extends CustomPainter {
  final double progress;
  final double steamAnimation;
  final bool isRunning;
  final Color color;
  PotPainter({
    required this.progress,
    required this.steamAnimation,
    required this.isRunning,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    if (isRunning) {
      for (int i = 0; i < 3; i++) {
        final xOff = (i - 1) * 32.0;
        final animY = (steamAnimation + (i * 0.33)) % 1.0;
        final paint = Paint()
          ..color = Colors.white.withValues(alpha: (1.0 - animY) * 0.4)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        final path = Path()
          ..moveTo(center.dx + xOff, center.dy - 20)
          ..quadraticBezierTo(
            center.dx + xOff + (sin(animY * 4 * pi) * 8),
            center.dy - 40 - (animY * 50),
            center.dx + xOff,
            center.dy - 100,
          );
        canvas.drawPath(path, paint);
      }
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 90, height: 50),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xFF1A1A24),
    );
    canvas.drawRect(
      Rect.fromCenter(center: center.translate(0, -28), width: 96, height: 4),
      Paint()..color = const Color(0xFF2E2E3A),
    );
  }

  @override
  bool shouldRepaint(PotPainter old) => true;
}

class CupPainter extends CustomPainter {
  final double progress;
  final double teaAnimation;
  final bool isRunning;
  CupPainter({
    required this.progress,
    required this.teaAnimation,
    required this.isRunning,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 15);
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - 30, center.dy - 30)
        ..lineTo(center.dx + 30, center.dy - 30)
        ..quadraticBezierTo(
          center.dx + 30,
          center.dy + 30,
          center.dx,
          center.dy + 30,
        )
        ..quadraticBezierTo(
          center.dx - 30,
          center.dy + 30,
          center.dx - 30,
          center.dy - 30,
        ),
      Paint()..color = Colors.white,
    );
    canvas.drawPath(
      Path()..addOval(
        Rect.fromCenter(
          center: center.translate(34, -10),
          width: 26,
          height: 30,
        ),
      ),
      Paint()
        ..color = Colors.white12
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );
    if (isRunning) {
      final bagY = center.dy - 35 + (sin(teaAnimation * 8 * pi) * 18);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(center.dx, bagY), width: 16, height: 20),
        Paint()..color = const Color(0xFFFF5252),
      );
      canvas.drawLine(
        Offset(center.dx, bagY - 12),
        Offset(center.dx, center.dy - 120),
        Paint()..color = Colors.white24,
      );
    }
  }

  @override
  bool shouldRepaint(CupPainter old) => true;
}

class TreePainter extends CustomPainter {
  final double progress;
  final double animation;
  final bool isRunning;
  final Color color;
  TreePainter({
    required this.progress,
    required this.animation,
    required this.isRunning,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 40);
    final trunkH = 12.0 + (progress * 50);
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 5, center.dy - trunkH, 10, trunkH),
      Paint()..color = const Color(0xFF2D1B16),
    );
    if (progress > 0.05) {
      final leafScale = (progress - 0.05) / 0.95;
      final fRad = 24.0 + (leafScale * 50);
      final pAura = isRunning ? sin(animation * 12) * 6 : 0;
      canvas.drawCircle(
        center.translate(0, -trunkH - 12),
        fRad + pAura,
        Paint()
          ..color = color.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24),
      );
      canvas.drawCircle(
        center.translate(0, -trunkH - 12),
        fRad,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(TreePainter old) => true;
}

class WateringCanPainter extends CustomPainter {
  final double progress;
  final double animation;
  final bool isRunning;
  WateringCanPainter({
    required this.progress,
    required this.animation,
    required this.isRunning,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 - 20, size.height / 2 + 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 48, height: 36),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFF00FF88),
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx + 24, center.dy - 8, 30, 6),
      Paint()..color = const Color(0xFF00FF88),
    );
    if (isRunning) {
      for (int i = 0; i < 6; i++) {
        final dAnim = (animation + (i * 0.16)) % 1.0;
        canvas.drawCircle(
          Offset(
            center.dx + 54 + (sin(dAnim * 6) * 6),
            center.dy + 5 + (dAnim * 50),
          ),
          3,
          Paint()
            ..color = Colors.cyanAccent.withValues(alpha: (1.0 - dAnim) * 0.8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(WateringCanPainter old) => true;
}

class RocketPainter extends CustomPainter {
  final double progress;
  final double animation;
  final bool isRunning;
  final Color color;
  RocketPainter({
    required this.progress,
    required this.animation,
    required this.isRunning,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 40);
    final paint = Paint()..color = const Color(0xFFF0F7FF);
    if (progress > 0.05) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center.translate(0, -12),
            width: 28,
            height: 32,
          ),
          const Radius.circular(6),
        ),
        paint,
      );
    }
    if (progress > 0.5) {
      final path = Path()
        ..moveTo(center.dx - 14, center.dy - 28)
        ..lineTo(center.dx + 14, center.dy - 28)
        ..lineTo(center.dx, center.dy - 64)
        ..close();
      canvas.drawPath(path, paint);
    }
    if (isRunning) {
      final fPaint = Paint()
        ..color = Colors.blueAccent
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(0, 8 + sin(animation * 40) * 10),
          width: 18,
          height: 30 + sin(animation * 30) * 15,
        ),
        fPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(0, 4 + sin(animation * 40) * 5),
          width: 10,
          height: 16,
        ),
        Paint()..color = Colors.white70,
      );
    }
  }

  @override
  bool shouldRepaint(RocketPainter old) => true;
}

class AstronautPainter extends CustomPainter {
  final double progress;
  final double animation;
  final bool isRunning;
  AstronautPainter({
    required this.progress,
    required this.animation,
    required this.isRunning,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2 + (sin(animation * 2 * pi) * 30),
      size.height / 2 + (cos(animation * 2 * pi) * 20),
    );
    canvas.drawCircle(center, 14, Paint()..color = Colors.white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center.translate(0, 24), width: 26, height: 32),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center.translate(0, -3),
      10,
      Paint()..color = const Color(0xFF0A0A1F),
    );
    canvas.drawLine(
      center.translate(0, 50),
      center.translate(-60, 100),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(AstronautPainter old) => true;
}
