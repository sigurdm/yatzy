import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yatzy_models.dart';
import 'pencil_painters.dart';

/// Intensity tier for the sketchbook celebration when a score is written.
enum ScoreCelebrationTier {
  /// Zero lower score or negative upper-section score: playful eraser crumbs & graphite puff.
  scratch,

  /// Par (0) upper score or modest lower score: comic starburst rays + 4-point sparkles.
  standard,

  /// Above-par upper score (+1..+12) or major lower combo (Full House, Straight, 4-of-a-Kind, etc.):
  /// colored-pencil confetti fountain (5-point stars, pencil shavings, sparkles).
  great,

  /// Yatzy, Super Yatzy, or clinching the Upper Section Bonus:
  /// multi-burst notebook fireworks + shockwave rings + rubber-stamp banner.
  jackpot,
}

/// Snapshot of the latest scored turn used to trigger cell-anchored fireworks & pulses.
class ScoreCelebrationEvent {
  final int eventId;
  final int playerIdx;
  final YatzyCategory category;
  final int displayScore;
  final int rawPointsAdded;
  final bool justEarnedBonus;
  final int bonusPointsAwarded;
  final ScoreCelebrationTier tier;

  const ScoreCelebrationEvent({
    required this.eventId,
    required this.playerIdx,
    required this.category,
    required this.displayScore,
    required this.rawPointsAdded,
    required this.justEarnedBonus,
    required this.bonusPointsAwarded,
    required this.tier,
  });

  factory ScoreCelebrationEvent.fromScore({
    required int eventId,
    required int playerIdx,
    required YatzyCategory category,
    required int displayScore,
    required YatzyGameRules rules,
    required bool justEarnedBonus,
  }) {
    final int rawPointsAdded = category.isUpper
        ? max(0, (category.upperFace ?? 0) * rules.upperParCount + displayScore)
        : displayScore;
    final int bonusPointsAwarded =
        justEarnedBonus ? rules.upperBonusPoints : 0;

    final ScoreCelebrationTier tier;
    if (category == YatzyCategory.yatzy ||
        category == YatzyCategory.superYatzy) {
      tier = displayScore > 0
          ? ScoreCelebrationTier.jackpot
          : ScoreCelebrationTier.scratch;
    } else if (justEarnedBonus) {
      tier = ScoreCelebrationTier.jackpot;
    } else if (category.isUpper) {
      if (displayScore > 0) {
        tier = ScoreCelebrationTier.great;
      } else if (displayScore == 0) {
        tier = ScoreCelebrationTier.standard;
      } else {
        tier = ScoreCelebrationTier.scratch;
      }
    } else {
      if (displayScore <= 0) {
        tier = ScoreCelebrationTier.scratch;
      } else if (category == YatzyCategory.fullHouse ||
          category == YatzyCategory.smallStraight ||
          category == YatzyCategory.largeStraight ||
          category == YatzyCategory.royalStraight ||
          category == YatzyCategory.fourOfAKind ||
          category == YatzyCategory.fiveOfAKind ||
          category == YatzyCategory.villa ||
          category == YatzyCategory.tower ||
          category == YatzyCategory.pyramid ||
          displayScore >= 20) {
        tier = ScoreCelebrationTier.great;
      } else {
        tier = ScoreCelebrationTier.standard;
      }
    }

    return ScoreCelebrationEvent(
      eventId: eventId,
      playerIdx: playerIdx,
      category: category,
      displayScore: displayScore,
      rawPointsAdded: rawPointsAdded,
      justEarnedBonus: justEarnedBonus,
      bonusPointsAwarded: bonusPointsAwarded,
      tier: tier,
    );
  }

  /// Floating hand-lettered badge label shown drifting up from the scored cell.
  String get floatingBadgeText {
    if (category == YatzyCategory.yatzy && displayScore > 0) {
      return '★ YATZY! +${displayScore}p ★';
    }
    if (category == YatzyCategory.superYatzy && displayScore > 0) {
      return '★ SUPER YATZY! +${displayScore}p ★';
    }
    if (justEarnedBonus) {
      final base = YatzyScorer.formatScore(category, displayScore);
      return '★ $base (BONUS +${bonusPointsAwarded}p!) ★';
    }
    if (category.isUpper) {
      if (displayScore > 0) {
        return '+$displayScore Over Par! ★';
      } else if (displayScore == 0) {
        return 'Par ✓ (+${rawPointsAdded}p)';
      } else {
        return '$displayScore';
      }
    }
    if (displayScore <= 0) {
      return '0p ×';
    }
    return tier == ScoreCelebrationTier.great
        ? '+${displayScore}p ★'
        : '+${displayScore}p';
  }
}

enum _ParticleShape {
  fivePointStar,
  fourPointSparkle,
  pencilShavingCurl,
  diamondConfetti,
  eraserCrumb,
}

class _SketchParticle {
  final Offset originOffset;
  final double vx;
  final double vy;
  final double gravity;
  final double size;
  final double initialRotation;
  final double angularVelocity;
  final double startTime;
  final Color color;
  final _ParticleShape shape;

  const _SketchParticle({
    required this.originOffset,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.size,
    required this.initialRotation,
    required this.angularVelocity,
    required this.startTime,
    required this.color,
    required this.shape,
  });
}

/// Wraps a newly-scored cell on the scorecard, providing:
/// 1. Live self-drawing green colored-pencil loop (`PencilCirclePainter` progress 0 -> 1).
/// 2. Elastic spring number pop (`scale 0.45 -> 1.38 -> 1.0`).
/// 3. Tiered sketchbook fireworks (starburst rays, colored-pencil confetti, or multi-burst Yatzy fireworks).
/// 4. Floating hand-lettered `+Points` / `★ YATZY! ★` badge drifting upward.
class ScoredCellCelebrationWidget extends StatefulWidget {
  final ScoreCelebrationEvent? celebration;
  final String formattedScore;
  final TextStyle scoreTextStyle;
  final int circleSeed;
  final Color circleColor;

  const ScoredCellCelebrationWidget({
    super.key,
    required this.celebration,
    required this.formattedScore,
    required this.scoreTextStyle,
    required this.circleSeed,
    this.circleColor = PencilPalette.greenPencil,
  });

  @override
  State<ScoredCellCelebrationWidget> createState() =>
      _ScoredCellCelebrationWidgetState();
}

class _ScoredCellCelebrationWidgetState
    extends State<ScoredCellCelebrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_SketchParticle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = _buildParticles(widget.celebration);
    _controller = AnimationController(
      vsync: this,
      duration: _durationFor(widget.celebration?.tier),
    );
    if (widget.celebration != null) {
      _controller.forward(from: 0.0);
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ScoredCellCelebrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebration?.eventId != oldWidget.celebration?.eventId &&
        widget.celebration != null) {
      _particles = _buildParticles(widget.celebration);
      _controller.duration = _durationFor(widget.celebration?.tier);
      _controller.forward(from: 0.0);
    }
  }

  Duration _durationFor(ScoreCelebrationTier? tier) {
    switch (tier) {
      case ScoreCelebrationTier.jackpot:
        return const Duration(milliseconds: 950);
      case ScoreCelebrationTier.great:
        return const Duration(milliseconds: 820);
      case ScoreCelebrationTier.standard:
        return const Duration(milliseconds: 680);
      case ScoreCelebrationTier.scratch:
      case null:
        return const Duration(milliseconds: 580);
    }
  }

  List<_SketchParticle> _buildParticles(ScoreCelebrationEvent? event) {
    if (event == null) return const [];
    final rng = Random(event.eventId * 131 + event.category.index * 37);
    final particles = <_SketchParticle>[];

    const palette = <Color>[
      PencilPalette.greenPencil,
      PencilPalette.bluePencil,
      PencilPalette.redPencil,
      PencilPalette.orangePencil,
      Color(0xFFD49E2A), // Golden pencil
    ];

    switch (event.tier) {
      case ScoreCelebrationTier.scratch:
        // 12 playful eraser crumbs & graphite motes puffing outward and dropping
        for (int i = 0; i < 12; i++) {
          final angle = -pi * 0.85 + rng.nextDouble() * pi * 0.7 +
              (i.isEven ? -0.35 : 0.35);
          final speed = 28.0 + rng.nextDouble() * 44.0;
          final isPinkCrumb = i % 3 != 0;
          particles.add(
            _SketchParticle(
              originOffset: Offset(
                (rng.nextDouble() - 0.5) * 18,
                (rng.nextDouble() - 0.5) * 8,
              ),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 12.0,
              gravity: 135.0,
              size: 4.2 + rng.nextDouble() * 3.0,
              initialRotation: rng.nextDouble() * pi * 2,
              angularVelocity: (rng.nextDouble() - 0.5) * 7.0,
              startTime: 0.0,
              color: isPinkCrumb
                  ? const Color(0xFFE58C9A)
                  : PencilPalette.graphiteMedium,
              shape: _ParticleShape.eraserCrumb,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.standard:
        // 14 crisp 4-point sparkles & diamonds radiating outward
        for (int i = 0; i < 14; i++) {
          final angle = (i / 14.0) * pi * 2 + (rng.nextDouble() - 0.5) * 0.25;
          final speed = 42.0 + rng.nextDouble() * 46.0;
          particles.add(
            _SketchParticle(
              originOffset: Offset.zero,
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 22.0,
              gravity: 95.0,
              size: 5.5 + rng.nextDouble() * 3.2,
              initialRotation: rng.nextDouble() * pi,
              angularVelocity: (rng.nextDouble() - 0.5) * 6.0,
              startTime: 0.0,
              color: palette[i % palette.length],
              shape: i.isEven
                  ? _ParticleShape.fourPointSparkle
                  : _ParticleShape.diamondConfetti,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.great:
        // 28 colored-pencil stars, shavings, and sparkles in an upward fountain
        for (int i = 0; i < 28; i++) {
          final angle = -pi * 0.92 + (i / 27.0) * pi * 0.84 +
              (rng.nextDouble() - 0.5) * 0.22;
          final speed = 58.0 + rng.nextDouble() * 78.0;
          final shape = switch (i % 4) {
            0 => _ParticleShape.fivePointStar,
            1 => _ParticleShape.fourPointSparkle,
            2 => _ParticleShape.pencilShavingCurl,
            _ => _ParticleShape.diamondConfetti,
          };
          particles.add(
            _SketchParticle(
              originOffset: Offset((rng.nextDouble() - 0.5) * 16, 0),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 28.0,
              gravity: 165.0,
              size: 6.5 + rng.nextDouble() * 4.2,
              initialRotation: rng.nextDouble() * pi * 2,
              angularVelocity: (rng.nextDouble() - 0.5) * 9.0,
              startTime: 0.0,
              color: palette[i % palette.length],
              shape: shape,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.jackpot:
        // 3 staggered firework bursts (center t=0.0, upper-left t=0.14, upper-right t=0.26)
        final burstOrigins = <Offset>[
          Offset.zero,
          const Offset(-42, -26),
          const Offset(42, -24),
        ];
        final burstStartTimes = <double>[0.0, 0.14, 0.26];

        for (int b = 0; b < burstOrigins.length; b++) {
          final count = b == 0 ? 24 : 16;
          for (int i = 0; i < count; i++) {
            final angle =
                (i / count) * pi * 2 + (rng.nextDouble() - 0.5) * 0.22;
            final speed = (b == 0 ? 75.0 : 62.0) + rng.nextDouble() * 82.0;
            final shape = (i % 3 == 0)
                ? _ParticleShape.fivePointStar
                : ((i % 3 == 1)
                    ? _ParticleShape.fourPointSparkle
                    : _ParticleShape.pencilShavingCurl);
            particles.add(
              _SketchParticle(
                originOffset: burstOrigins[b],
                vx: cos(angle) * speed,
                vy: sin(angle) * speed - 24.0,
                gravity: 150.0,
                size: 7.0 + rng.nextDouble() * 4.8,
                initialRotation: rng.nextDouble() * pi * 2,
                angularVelocity: (rng.nextDouble() - 0.5) * 10.0,
                startTime: burstStartTimes[b],
                color: palette[(i + b * 2) % palette.length],
                shape: shape,
              ),
            );
          }
        }
        break;
    }

    return particles;
  }

  double _computeNumberPopScale(double t) {
    // Elastic pop during first 45% of animation: 0.52 -> 1.36 -> 0.94 -> 1.0
    if (t >= 0.48) return 1.0;
    final u = (t / 0.48).clamp(0.0, 1.0);
    if (u < 0.42) {
      final k = Curves.easeOutCubic.transform(u / 0.42);
      return 0.52 + (1.36 - 0.52) * k;
    } else if (u < 0.74) {
      final k = Curves.easeInOut.transform((u - 0.42) / 0.32);
      return 1.36 + (0.94 - 1.36) * k;
    } else {
      final k = Curves.easeOut.transform((u - 0.74) / 0.26);
      return 0.94 + (1.0 - 0.94) * k;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final isAnimating = _controller.isAnimating;
        // Self-drawing circle completes in the first 42% of the animation
        final circleProgress =
            Curves.easeOutCubic.transform((t / 0.42).clamp(0.0, 1.0));
        final numberScale = isAnimating ? _computeNumberPopScale(t) : 1.0;

        // Subtle paper micro-shake on jackpot during first 24% of animation
        double shakeDx = 0.0;
        double shakeDy = 0.0;
        if (isAnimating &&
            widget.celebration?.tier == ScoreCelebrationTier.jackpot &&
            t < 0.24) {
          final damp = 1.0 - (t / 0.24);
          shakeDx = sin(t * pi * 36) * 2.8 * damp;
          shakeDy = cos(t * pi * 28) * 1.8 * damp;
        }

        return Transform.translate(
          offset: Offset(shakeDx, shakeDy),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 1. Live self-drawing colored-pencil circle around the score
              Positioned(
                left: 6,
                right: 6,
                top: 3,
                bottom: 3,
                child: CustomPaint(
                  painter: PencilCirclePainter(
                    color: widget.circleColor,
                    strokeWidth: 2.2,
                    seed: widget.circleSeed,
                    progress: circleProgress,
                  ),
                ),
              ),

              // 2. Cell-anchored sketchbook fireworks & starburst rays (only while animating)
              if (isAnimating && widget.celebration != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _ScoreFireworksPainter(
                        progress: t,
                        tier: widget.celebration!.tier,
                        particles: _particles,
                        seed: widget.circleSeed,
                      ),
                    ),
                  ),
                ),

              // 3. Popping score text + checkmark
              Transform.scale(
                scale: numberScale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.formattedScore,
                      style: widget.scoreTextStyle,
                    ),
                    const SizedBox(width: 2),
                    Transform.scale(
                      scale: Curves.elasticOut.transform(
                        ((t - 0.15) / 0.45).clamp(0.0, 1.0),
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: widget.circleColor,
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Floating hand-lettered "+Points" / "★ YATZY! ★" badge
              if (isAnimating && widget.celebration != null)
                _buildFloatingBadge(t, widget.celebration!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingBadge(double t, ScoreCelebrationEvent event) {
    // Badge rises from dy=-8 to dy=-36 and fades out after t=0.62
    final enterScale = Curves.elasticOut.transform((t / 0.32).clamp(0.0, 1.0));
    final opacity = t < 0.62
        ? 1.0
        : (1.0 - Curves.easeIn.transform(((t - 0.62) / 0.38).clamp(0.0, 1.0)));
    final dy = -10.0 - Curves.easeOutCubic.transform(t) * 28.0;

    final isJackpot = event.tier == ScoreCelebrationTier.jackpot;
    final isScratch = event.tier == ScoreCelebrationTier.scratch;
    final Color borderColor = isJackpot
        ? const Color(0xFFD49E2A)
        : (isScratch ? PencilPalette.redPencil : PencilPalette.greenPencil);
    final Color fillColor = isJackpot
        ? const Color(0xFFFFF8D6)
        : (isScratch ? const Color(0xFFFFF0F0) : const Color(0xFFEAF8EE));

    return Positioned(
      top: dy,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: enterScale,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isJackpot ? 8 : 6,
                vertical: isJackpot ? 2.5 : 1.5,
              ),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: borderColor,
                  width: isJackpot ? 1.5 : 1.1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 3,
                    offset: Offset(0, 1.5),
                  ),
                ],
              ),
              child: Text(
                event.floatingBadgeText,
                maxLines: 1,
                style: GoogleFonts.patrickHand(
                  fontSize: isJackpot ? 13.5 : 12.0,
                  fontWeight: FontWeight.bold,
                  color: isScratch
                      ? PencilPalette.redPencil
                      : (isJackpot
                          ? const Color(0xFF9E6B00)
                          : PencilPalette.greenPencil),
                  height: 1.05,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreFireworksPainter extends CustomPainter {
  final double progress;
  final ScoreCelebrationTier tier;
  final List<_SketchParticle> particles;
  final int seed;

  const _ScoreFireworksPainter({
    required this.progress,
    required this.tier,
    required this.particles,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Comic starburst impact rays around the cell border (first 50% of animation)
    if (progress < 0.52) {
      final rayT = (progress / 0.52).clamp(0.0, 1.0);
      final rayOpacity = (1.0 - rayT).clamp(0.0, 1.0);
      final rayCount = switch (tier) {
        ScoreCelebrationTier.jackpot => 16,
        ScoreCelebrationTier.great => 12,
        ScoreCelebrationTier.standard => 10,
        ScoreCelebrationTier.scratch => 6,
      };
      final rx = size.width * 0.46;
      final ry = size.height * 0.44;

      final rayPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = tier == ScoreCelebrationTier.jackpot ? 2.0 : 1.5
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < rayCount; i++) {
        final angle = (i / rayCount) * pi * 2 + (seed % 7) * 0.12;
        final innerDist = 0.85 + rayT * 0.35;
        final outerDist = 1.05 + Curves.easeOut.transform(rayT) *
            (tier == ScoreCelebrationTier.jackpot ? 0.85 : 0.55);

        final p1 = Offset(
          center.dx + cos(angle) * rx * innerDist,
          center.dy + sin(angle) * ry * innerDist,
        );
        final p2 = Offset(
          center.dx + cos(angle) * rx * outerDist,
          center.dy + sin(angle) * ry * outerDist,
        );

        final color = tier == ScoreCelebrationTier.scratch
            ? PencilPalette.redPencil
            : (i.isEven
                ? PencilPalette.greenPencil
                : (tier == ScoreCelebrationTier.jackpot
                    ? const Color(0xFFD49E2A)
                    : PencilPalette.bluePencil));
        rayPaint.color = color.withValues(alpha: rayOpacity * 0.85);
        canvas.drawLine(p1, p2, rayPaint);
      }
    }

    // 2. Expanding double-stroke shockwave rings for Jackpot & Great tiers
    if ((tier == ScoreCelebrationTier.jackpot ||
            tier == ScoreCelebrationTier.great) &&
        progress < 0.72) {
      final ringT = Curves.easeOutCubic.transform(
        (progress / 0.72).clamp(0.0, 1.0),
      );
      final ringAlpha = (1.0 - ringT) * 0.65;
      final ringPaint = Paint()
        ..color = (tier == ScoreCelebrationTier.jackpot
                ? const Color(0xFFD49E2A)
                : PencilPalette.greenPencil)
            .withValues(alpha: ringAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: size.width * (0.75 + ringT * 1.35),
          height: size.height * (0.75 + ringT * 1.65),
        ),
        ringPaint,
      );
    }

    // 3. Hand-sketched firework & confetti particles
    for (final p in particles) {
      if (progress <= p.startTime) continue;
      final localT =
          ((progress - p.startTime) / (1.0 - p.startTime)).clamp(0.0, 1.0);
      if (localT >= 1.0) continue;

      // Physics trajectory: x(t) = x0 + vx * t, y(t) = y0 + vy * t + 0.5 * g * t^2
      final dt = localT * 0.75;
      final px = center.dx + p.originOffset.dx + p.vx * dt;
      final py =
          center.dy + p.originOffset.dy + p.vy * dt + 0.5 * p.gravity * dt * dt;
      final rot = p.initialRotation + p.angularVelocity * dt;

      // Fade out smoothly in the last 35% of particle life
      final alpha = localT < 0.65
          ? 1.0
          : (1.0 - ((localT - 0.65) / 0.35)).clamp(0.0, 1.0);
      final currentSize =
          p.size * (localT < 0.15 ? (localT / 0.15) : (1.0 - localT * 0.25));

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(rot);

      final fillPaint = Paint()
        ..color = p.color.withValues(alpha: alpha * 0.9)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.35
        ..strokeCap = StrokeCap.round;

      switch (p.shape) {
        case _ParticleShape.fivePointStar:
          _drawFivePointStar(canvas, currentSize, fillPaint, strokePaint);
          break;
        case _ParticleShape.fourPointSparkle:
          _drawFourPointSparkle(canvas, currentSize, fillPaint, strokePaint);
          break;
        case _ParticleShape.pencilShavingCurl:
          _drawPencilCurl(canvas, currentSize, strokePaint);
          break;
        case _ParticleShape.diamondConfetti:
          _drawDiamond(canvas, currentSize, fillPaint, strokePaint);
          break;
        case _ParticleShape.eraserCrumb:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: currentSize * 1.2,
                height: currentSize * 0.8,
              ),
              const Radius.circular(1.5),
            ),
            fillPaint,
          );
          break;
      }

      canvas.restore();
    }
  }

  void _drawFivePointStar(
    Canvas canvas,
    double r,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path();
    final innerR = r * 0.44;
    for (int i = 0; i < 10; i++) {
      final radius = i.isEven ? r : innerR;
      final angle = -pi / 2 + i * (pi / 5);
      final x = cos(angle) * radius;
      final y = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawFourPointSparkle(
    Canvas canvas,
    double r,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path();
    final innerR = r * 0.28;
    for (int i = 0; i < 8; i++) {
      final radius = i.isEven ? r : innerR;
      final angle = i * (pi / 4);
      final x = cos(angle) * radius;
      final y = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawPencilCurl(Canvas canvas, double r, Paint strokePaint) {
    final path = Path()
      ..moveTo(-r * 0.8, 0)
      ..quadraticBezierTo(-r * 0.2, -r * 0.9, r * 0.3, 0)
      ..quadraticBezierTo(r * 0.7, r * 0.7, r, -r * 0.3);
    canvas.drawPath(path, strokePaint);
  }

  void _drawDiamond(
    Canvas canvas,
    double r,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path()
      ..moveTo(0, -r * 0.85)
      ..lineTo(r * 0.55, 0)
      ..lineTo(0, r * 0.85)
      ..lineTo(-r * 0.55, 0)
      ..close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _ScoreFireworksPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.seed != seed;
}

/// Pulses a summary cell (e.g. Grand Total or Upper Bonus) with a spring bounce
/// when the corresponding player scores.
class ScoreSummaryPulseWrapper extends StatefulWidget {
  final int? triggerEventId;
  final bool shouldPulse;
  final Widget child;

  const ScoreSummaryPulseWrapper({
    super.key,
    required this.triggerEventId,
    required this.shouldPulse,
    required this.child,
  });

  @override
  State<ScoreSummaryPulseWrapper> createState() =>
      _ScoreSummaryPulseWrapperState();
}

class _ScoreSummaryPulseWrapperState extends State<ScoreSummaryPulseWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    if (widget.shouldPulse && widget.triggerEventId != null) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant ScoreSummaryPulseWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPulse &&
        widget.triggerEventId != null &&
        widget.triggerEventId != oldWidget.triggerEventId) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_controller.isAnimating) return child!;
        final t = _controller.value;
        // Pulse 1.0 -> 1.24 -> 1.0
        final scale = t < 0.4
            ? 1.0 + 0.24 * Curves.easeOut.transform(t / 0.4)
            : 1.24 - 0.24 * Curves.elasticOut.transform((t - 0.4) / 0.6);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
