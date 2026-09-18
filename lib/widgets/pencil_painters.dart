import 'dart:math';
import 'package:flutter/material.dart';

/// Palette of pencil, graphite, paper, and colored-pencil tones.
class PencilPalette {
  static const Color paperBg = Color(0xFFFAF6EC);
  static const Color paperCard = Color(0xFFFDFBF5);
  static const Color paperDarker = Color(0xFFEFE9D8);

  // Graphite shades (HB, 2B, 2H pencils)
  static const Color graphiteDark = Color(0xFF282623); // 2B dark pencil
  static const Color graphiteMedium = Color(0xFF4A4742); // HB medium pencil
  static const Color graphiteLight = Color(0xFF8A857D); // 2H faint pencil
  static const Color graphiteFaint = Color(0xFFBDB7AC); // Eraser/guideline gray

  // Colored pencils
  static const Color redPencil = Color(0xFFB83A2E);
  static const Color bluePencil = Color(0xFF2B5B84);
  static const Color greenPencil = Color(0xFF2E6B3E);
  static const Color yellowHighlighter = Color(0x55F7E379);
  static const Color orangePencil = Color(0xFFD06A28);

  // Ruled notebook lines
  static const Color notebookRuleBlue = Color(0x44A8C0D8);
  static const Color notebookMarginRed = Color(0x44D89A9A);
}

/// Helper class to draw sketchy hand-drawn pencil paths on a Canvas.
class PencilDrawingUtils {
  /// Draws a single sketchy pencil stroke between [p1] and [p2] with deterministic wobble.
  static void drawPencilLine(
    Canvas canvas,
    Offset p1,
    Offset p2, {
    Color color = PencilPalette.graphiteDark,
    double strokeWidth = 1.4,
    double overshoot = 2.0,
    int seed = 42,
    bool doubleStroke = true,
  }) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final length = sqrt(dx * dx + dy * dy);
    if (length < 1.0) return;

    final dirX = dx / length;
    final dirY = dy / length;
    final perpX = -dirY;
    final perpY = dirX;

    // Extend endpoints slightly for authentic pencil overshoot
    final start = Offset(p1.dx - dirX * overshoot, p1.dy - dirY * overshoot);
    final end = Offset(p2.dx + dirX * overshoot, p2.dy + dirY * overshoot);

    final paint1 = Paint()
      ..color = color.withValues(alpha: color.a * 0.88)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path1 = _buildWobblyPath(start, end, length, perpX, perpY, seed, 0.8);
    canvas.drawPath(path1, paint1);

    if (doubleStroke) {
      final paint2 = Paint()
        ..color = color.withValues(alpha: color.a * 0.45)
        ..strokeWidth = strokeWidth * 0.68
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path2 = _buildWobblyPath(
        Offset(start.dx + perpX * 0.5, start.dy + perpY * 0.5),
        Offset(end.dx - perpX * 0.4, end.dy - perpY * 0.4),
        length,
        perpX,
        perpY,
        seed + 101,
        1.1,
      );
      canvas.drawPath(path2, paint2);
    }
  }

  static Path _buildWobblyPath(
    Offset start,
    Offset end,
    double length,
    double perpX,
    double perpY,
    int seed,
    double amplitude,
  ) {
    final path = Path()..moveTo(start.dx, start.dy);
    final steps = max(2, (length / 18.0).round());
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    for (int i = 1; i <= steps; i++) {
      final t = i / steps;
      // Smooth deterministic wave using sin
      final wave = sin(t * pi * 2.0 + seed * 0.73) *
          cos(t * pi * 3.5 - seed * 0.31) *
          amplitude;
      // Taper wave at endpoints so corners still meet closely
      final envelope = sin(t * pi);
      final offset = wave * envelope;

      final x = start.dx + dx * t + perpX * offset;
      final y = start.dy + dy * t + perpY * offset;
      path.lineTo(x, y);
    }
    return path;
  }

  /// Draws diagonal graphite cross-hatching / shading inside [rect].
  static void drawPencilShading(
    Canvas canvas,
    Rect rect, {
    Color color = PencilPalette.graphiteLight,
    double spacing = 7.0,
    double strokeWidth = 0.8,
    double opacity = 0.18,
    int seed = 7,
  }) {
    canvas.save();
    canvas.clipRect(rect);

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final totalSpan = rect.width + rect.height;
    int idx = 0;
    for (double d = -rect.height; d < totalSpan; d += spacing) {
      idx++;
      final jitter = sin(idx * 1.7 + seed) * 1.2;
      final p1 = Offset(rect.left + d + jitter, rect.top - 2);
      final p2 = Offset(rect.left + d - rect.height + jitter, rect.bottom + 2);
      canvas.drawLine(p1, p2, paint);
    }
    canvas.restore();
  }
}

/// Draws a ruled sketchpad background with subtle horizontal notebook lines.
class PaperBackgroundPainter extends CustomPainter {
  final double lineSpacing;
  final bool showMarginLine;
  final double marginLineOffset;

  const PaperBackgroundPainter({
    this.lineSpacing = 28.0,
    this.showMarginLine = true,
    this.marginLineOffset = 34.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = PencilPalette.paperBg;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = PencilPalette.notebookRuleBlue
      ..strokeWidth = 1.0;

    // Horizontal ruled lines
    for (double y = lineSpacing; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Subtle vertical red margin line on the left
    if (showMarginLine) {
      final marginPaint = Paint()
        ..color = PencilPalette.notebookMarginRed
        ..strokeWidth = 1.2;
      canvas.drawLine(
        Offset(marginLineOffset, 0),
        Offset(marginLineOffset, size.height),
        marginPaint,
      );
      canvas.drawLine(
        Offset(marginLineOffset + 3, 0),
        Offset(marginLineOffset + 3, size.height),
        marginPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PaperBackgroundPainter oldDelegate) =>
      oldDelegate.lineSpacing != lineSpacing ||
      oldDelegate.showMarginLine != showMarginLine ||
      oldDelegate.marginLineOffset != marginLineOffset;
}

/// Draws a hand-sketched box border with optional pencil shading or highlighter wash.
class PencilBoxPainter extends CustomPainter {
  final Color borderColor;
  final Color? fillColor;
  final bool hasPencilShading;
  final double shadingOpacity;
  final double strokeWidth;
  final double overshoot;
  final int seed;
  final bool doubleBorder;

  const PencilBoxPainter({
    this.borderColor = PencilPalette.graphiteDark,
    this.fillColor,
    this.hasPencilShading = false,
    this.shadingOpacity = 0.12,
    this.strokeWidth = 1.5,
    this.overshoot = 2.2,
    this.seed = 13,
    this.doubleBorder = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    if (fillColor != null) {
      // Slightly uneven fill polygon so it looks like a hand-colored wash
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      final rrect = RRect.fromRectAndRadius(
        rect.deflate(1.0),
        const Radius.circular(3),
      );
      canvas.drawRRect(rrect, fillPaint);
    }

    if (hasPencilShading) {
      PencilDrawingUtils.drawPencilShading(
        canvas,
        rect.deflate(2.0),
        color: borderColor,
        opacity: shadingOpacity,
        seed: seed,
      );
    }

    final tl = Offset(0, 0);
    final tr = Offset(size.width, 0);
    final br = Offset(size.width, size.height);
    final bl = Offset(0, size.height);

    // Top edge
    PencilDrawingUtils.drawPencilLine(
      canvas,
      tl,
      tr,
      color: borderColor,
      strokeWidth: strokeWidth,
      overshoot: overshoot,
      seed: seed + 1,
    );
    // Right edge
    PencilDrawingUtils.drawPencilLine(
      canvas,
      tr,
      br,
      color: borderColor,
      strokeWidth: strokeWidth,
      overshoot: overshoot,
      seed: seed + 2,
    );
    // Bottom edge
    PencilDrawingUtils.drawPencilLine(
      canvas,
      br,
      bl,
      color: borderColor,
      strokeWidth: strokeWidth,
      overshoot: overshoot,
      seed: seed + 3,
    );
    // Left edge
    PencilDrawingUtils.drawPencilLine(
      canvas,
      bl,
      tl,
      color: borderColor,
      strokeWidth: strokeWidth,
      overshoot: overshoot,
      seed: seed + 4,
    );

    if (doubleBorder) {
      const inset = 3.0;
      PencilDrawingUtils.drawPencilLine(
        canvas,
        Offset(inset, inset),
        Offset(size.width - inset, inset),
        color: borderColor,
        strokeWidth: strokeWidth * 0.75,
        overshoot: 1.0,
        seed: seed + 11,
      );
      PencilDrawingUtils.drawPencilLine(
        canvas,
        Offset(size.width - inset, inset),
        Offset(size.width - inset, size.height - inset),
        color: borderColor,
        strokeWidth: strokeWidth * 0.75,
        overshoot: 1.0,
        seed: seed + 12,
      );
      PencilDrawingUtils.drawPencilLine(
        canvas,
        Offset(size.width - inset, size.height - inset),
        Offset(inset, size.height - inset),
        color: borderColor,
        strokeWidth: strokeWidth * 0.75,
        overshoot: 1.0,
        seed: seed + 13,
      );
      PencilDrawingUtils.drawPencilLine(
        canvas,
        Offset(inset, size.height - inset),
        Offset(inset, inset),
        color: borderColor,
        strokeWidth: strokeWidth * 0.75,
        overshoot: 1.0,
        seed: seed + 14,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PencilBoxPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.hasPencilShading != hasPencilShading ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.seed != seed ||
      oldDelegate.doubleBorder != doubleBorder;
}

/// Wrapper widget that draws a sketchy pencil box around its [child].
class PencilBox extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color? fillColor;
  final bool hasPencilShading;
  final double shadingOpacity;
  final double strokeWidth;
  final double overshoot;
  final int seed;
  final bool doubleBorder;
  final EdgeInsetsGeometry padding;

  const PencilBox({
    super.key,
    required this.child,
    this.borderColor = PencilPalette.graphiteDark,
    this.fillColor,
    this.hasPencilShading = false,
    this.shadingOpacity = 0.12,
    this.strokeWidth = 1.4,
    this.overshoot = 2.0,
    this.seed = 13,
    this.doubleBorder = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PencilBoxPainter(
        borderColor: borderColor,
        fillColor: fillColor,
        hasPencilShading: hasPencilShading,
        shadingOpacity: shadingOpacity,
        strokeWidth: strokeWidth,
        overshoot: overshoot,
        seed: seed,
        doubleBorder: doubleBorder,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Draws a hand-sketched colored-pencil circle/loop around a widget (e.g. for HELD dice or winner highlight).
class PencilCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int seed;

  /// Drawing progress from 0.0 (not started) to 1.0 (complete 1.15-turn loop).
  final double progress;

  const PencilCirclePainter({
    this.color = PencilPalette.redPencil,
    this.strokeWidth = 2.2,
    this.seed = 99,
    this.progress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    if (clampedProgress <= 0.001) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final rx = size.width / 2 - 2;
    final ry = size.height / 2 - 2;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Draw a 1.15-turn spiral loop so the ends overlap like a hand-drawn circle
    const steps = 48;
    const totalAngle = pi * 2.25;
    final startAngle = -pi * 0.6 + (seed % 5) * 0.1;
    final maxStepFloat = clampedProgress * steps;
    final maxFullStep = maxStepFloat.floor();

    Offset pointAt(double t) {
      final angle = startAngle + t * totalAngle;
      final wobbleR = sin(t * pi * 5 + seed) * 1.6 + (t * 1.8);
      final x = cx + (rx + wobbleR) * cos(angle);
      final y = cy + (ry + wobbleR * 0.8) * sin(angle);
      return Offset(x, y);
    }

    for (int i = 0; i <= maxFullStep; i++) {
      final pt = pointAt(i / steps);
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    if (maxStepFloat > maxFullStep) {
      final tipPt = pointAt(clampedProgress);
      path.lineTo(tipPt.dx, tipPt.dy);
    }
    canvas.drawPath(path, paint);

    // Draw a lively 4-point pencil sparkle at the leading tip while actively sketching!
    if (clampedProgress > 0.02 && clampedProgress < 0.98) {
      final tip = pointAt(clampedProgress);
      final sparkPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      const r = 5.2;
      final sparkPath = Path()
        ..moveTo(tip.dx, tip.dy - r)
        ..lineTo(tip.dx + r * 0.3, tip.dy - r * 0.3)
        ..lineTo(tip.dx + r, tip.dy)
        ..lineTo(tip.dx + r * 0.3, tip.dy + r * 0.3)
        ..lineTo(tip.dx, tip.dy + r)
        ..lineTo(tip.dx - r * 0.3, tip.dy + r * 0.3)
        ..lineTo(tip.dx - r, tip.dy)
        ..lineTo(tip.dx - r * 0.3, tip.dy - r * 0.3)
        ..close();
      canvas.drawPath(sparkPath, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PencilCirclePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.seed != seed ||
      oldDelegate.progress != progress;
}
