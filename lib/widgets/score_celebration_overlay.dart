import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yatzy_models.dart';
import 'pencil_painters.dart';

/// Intensity tier for the sketchbook celebration when a score is written.
enum ScoreCelebrationTier {
  /// Zero lower score or negative upper-section score: playful eraser crumbs & graphite puff.
  scratch,

  /// Par (0) upper score or modest lower score: comic starburst rays + central burst + aerial pop.
  standard,

  /// Above-par upper score (+1..+12) or major lower combo (Full House, Straight, 4-of-a-Kind, etc.):
  /// central fountain + 2 ascending firework rockets exploding into colored-pencil stars & ribbons.
  great,

  /// Yatzy, Super Yatzy, or clinching the Upper Section Bonus:
  /// massive central supernova + 4 staggered aerial firework rockets across the notebook + stamp banner.
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
  streamerRibbon,
  diamondConfetti,
  eraserCrumb,
}

class _AerialRocket {
  final Offset targetOffset;
  final double launchTime;
  final double detonateTime;
  final Color color;

  const _AerialRocket({
    required this.targetOffset,
    required this.launchTime,
    required this.detonateTime,
    required this.color,
  });
}

class _SketchParticle {
  final Offset originOffset;
  final double vx;
  final double vy;
  final double gravity;
  final double drag;
  final double flutterAmp;
  final double flutterFreq;
  final double flutterPhase;
  final double size;
  final double initialRotation;
  final double angularVelocity;
  final double startTime;
  final double lifeSpan;
  final Color color;
  final _ParticleShape shape;

  const _SketchParticle({
    required this.originOffset,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.drag,
    required this.flutterAmp,
    required this.flutterFreq,
    required this.flutterPhase,
    required this.size,
    required this.initialRotation,
    required this.angularVelocity,
    required this.startTime,
    required this.lifeSpan,
    required this.color,
    required this.shape,
  });

  Offset positionAt(double localT) {
    // Non-linear air-drag trajectory so particles shoot out fast and then float & flutter!
    final effectiveT = (1.0 - exp(-drag * localT * 2.2)) / drag;
    final gravityDrop = 0.5 * gravity * localT * localT;
    final flutterX =
        sin(localT * flutterFreq + flutterPhase) * flutterAmp * localT;
    return Offset(
      originOffset.dx + vx * effectiveT + flutterX,
      originOffset.dy + vy * effectiveT + gravityDrop,
    );
  }
}

/// Wraps a newly-scored cell on the scorecard, providing:
/// 1. Live self-drawing green colored-pencil loop (`PencilCirclePainter` progress 0 -> 1).
/// 2. Elastic spring number pop (`scale 0.42 -> 1.44 -> 0.92 -> 1.0`).
/// 3. Root `OverlayEntry` fireworks (`CompositedTransformFollower`) so rockets, stars,
///    and floating banners burst high above the entire scorecard without any clipping or occlusion!
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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  late AnimationController _controller;
  late List<_AerialRocket> _rockets;
  late List<_SketchParticle> _particles;

  @override
  void initState() {
    super.initState();
    _buildChoreography(widget.celebration);
    _controller = AnimationController(
      vsync: this,
      duration: _durationFor(widget.celebration?.tier),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _removeOverlay();
        }
      });

    if (widget.celebration != null) {
      _controller.forward(from: 0.0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.isAnimating) {
          _showOverlay();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ScoredCellCelebrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebration?.eventId != oldWidget.celebration?.eventId &&
        widget.celebration != null) {
      _buildChoreography(widget.celebration);
      _controller.duration = _durationFor(widget.celebration?.tier);
      _controller.forward(from: 0.0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.isAnimating) {
          _showOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.maybeOf(context);
    if (overlay == null || widget.celebration == null) return;

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.center,
                  followerAnchor: Alignment.center,
                  child: SizedBox(
                    width: 620,
                    height: 480,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final t = _controller.value;
                        return Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _ScoreFireworksPainter(
                                  progress: t,
                                  tier: widget.celebration!.tier,
                                  rockets: _rockets,
                                  particles: _particles,
                                  seed: widget.circleSeed,
                                ),
                              ),
                            ),
                            _buildFloatingBadge(t, widget.celebration!),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  Duration _durationFor(ScoreCelebrationTier? tier) {
    switch (tier) {
      case ScoreCelebrationTier.jackpot:
        return const Duration(milliseconds: 2100);
      case ScoreCelebrationTier.great:
        return const Duration(milliseconds: 1650);
      case ScoreCelebrationTier.standard:
        return const Duration(milliseconds: 1350);
      case ScoreCelebrationTier.scratch:
      case null:
        return const Duration(milliseconds: 1050);
    }
  }

  void _buildChoreography(ScoreCelebrationEvent? event) {
    if (event == null) {
      _rockets = const [];
      _particles = const [];
      return;
    }
    final rng = Random(event.eventId * 131 + event.category.index * 37);
    final rockets = <_AerialRocket>[];
    final particles = <_SketchParticle>[];

    const palette = <Color>[
      PencilPalette.greenPencil,
      PencilPalette.bluePencil,
      PencilPalette.redPencil,
      PencilPalette.orangePencil,
      Color(0xFFD49E2A), // Golden highlighter/pencil
      Color(0xFF8E44AD), // Royal purple pencil
    ];

    void addBurst({
      required Offset origin,
      required int count,
      required double startTime,
      required double minSpeed,
      required double maxSpeed,
      required double upwardBias,
      required double gravity,
      required double sizeBase,
      bool fullCircle = true,
    }) {
      for (int i = 0; i < count; i++) {
        final double angle;
        if (fullCircle) {
          angle = (i / count) * pi * 2 + (rng.nextDouble() - 0.5) * 0.28;
        } else {
          angle = -pi * 0.92 +
              (i / max(1, count - 1)) * pi * 0.84 +
              (rng.nextDouble() - 0.5) * 0.2;
        }
        final speed = minSpeed + rng.nextDouble() * (maxSpeed - minSpeed);
        final shape = switch (i % 5) {
          0 => _ParticleShape.fivePointStar,
          1 => _ParticleShape.fourPointSparkle,
          2 => _ParticleShape.streamerRibbon,
          3 => _ParticleShape.pencilShavingCurl,
          _ => _ParticleShape.diamondConfetti,
        };
        particles.add(
          _SketchParticle(
            originOffset: origin,
            vx: cos(angle) * speed,
            vy: sin(angle) * speed - upwardBias,
            gravity: gravity,
            drag: 1.35 + rng.nextDouble() * 0.55,
            flutterAmp: 12.0 + rng.nextDouble() * 18.0,
            flutterFreq: 8.0 + rng.nextDouble() * 8.0,
            flutterPhase: rng.nextDouble() * pi * 2,
            size: sizeBase + rng.nextDouble() * 5.6,
            initialRotation: rng.nextDouble() * pi * 2,
            angularVelocity: (rng.nextDouble() - 0.5) * 11.0,
            startTime: startTime,
            lifeSpan: (1.0 - startTime).clamp(0.55, 1.0),
            color: palette[(i + origin.dx.round().abs()) % palette.length],
            shape: shape,
          ),
        );
      }
    }

    switch (event.tier) {
      case ScoreCelebrationTier.scratch:
        // 24 playful pink eraser crumbs & graphite dust motes puffing wide and tumbling down
        for (int i = 0; i < 24; i++) {
          final angle = -pi * 0.95 +
              (i / 23.0) * pi * 0.90 +
              (rng.nextDouble() - 0.5) * 0.25;
          final speed = 85.0 + rng.nextDouble() * 110.0;
          final isPinkCrumb = i % 3 != 0;
          particles.add(
            _SketchParticle(
              originOffset: Offset(
                (rng.nextDouble() - 0.5) * 26,
                (rng.nextDouble() - 0.5) * 10,
              ),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 35.0,
              gravity: 250.0,
              drag: 1.5,
              flutterAmp: 10.0,
              flutterFreq: 9.0,
              flutterPhase: rng.nextDouble() * pi * 2,
              size: 6.0 + rng.nextDouble() * 4.2,
              initialRotation: rng.nextDouble() * pi * 2,
              angularVelocity: (rng.nextDouble() - 0.5) * 9.0,
              startTime: 0.0,
              lifeSpan: 0.95,
              color: isPinkCrumb
                  ? const Color(0xFFE58C9A)
                  : PencilPalette.graphiteMedium,
              shape: i % 4 == 0
                  ? _ParticleShape.pencilShavingCurl
                  : _ParticleShape.eraserCrumb,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.standard:
        // Central starburst (32 particles) + 2 crisscrossing aerial firework rockets!
        addBurst(
          origin: Offset.zero,
          count: 32,
          startTime: 0.0,
          minSpeed: 115.0,
          maxSpeed: 235.0,
          upwardBias: 50.0,
          gravity: 205.0,
          sizeBase: 7.5,
          fullCircle: true,
        );
        const stdRockets = <_AerialRocket>[
          _AerialRocket(
            targetOffset: Offset(-56, -78),
            launchTime: 0.01,
            detonateTime: 0.16,
            color: PencilPalette.greenPencil,
          ),
          _AerialRocket(
            targetOffset: Offset(56, -74),
            launchTime: 0.06,
            detonateTime: 0.22,
            color: PencilPalette.bluePencil,
          ),
        ];
        rockets.addAll(stdRockets);
        for (final r in stdRockets) {
          addBurst(
            origin: r.targetOffset,
            count: 20,
            startTime: r.detonateTime,
            minSpeed: 95.0,
            maxSpeed: 185.0,
            upwardBias: 25.0,
            gravity: 175.0,
            sizeBase: 7.0,
            fullCircle: true,
          );
        }
        break;

      case ScoreCelebrationTier.great:
        // Central fountain (42 particles) + 3 staggered aerial firework rockets!
        addBurst(
          origin: Offset.zero,
          count: 42,
          startTime: 0.0,
          minSpeed: 135.0,
          maxSpeed: 280.0,
          upwardBias: 70.0,
          gravity: 230.0,
          sizeBase: 8.6,
          fullCircle: false,
        );
        const greatRockets = <_AerialRocket>[
          _AerialRocket(
            targetOffset: Offset(-88, -96),
            launchTime: 0.01,
            detonateTime: 0.16,
            color: PencilPalette.bluePencil,
          ),
          _AerialRocket(
            targetOffset: Offset(88, -92),
            launchTime: 0.07,
            detonateTime: 0.23,
            color: Color(0xFFD49E2A),
          ),
          _AerialRocket(
            targetOffset: Offset(0, -132),
            launchTime: 0.13,
            detonateTime: 0.30,
            color: PencilPalette.greenPencil,
          ),
        ];
        rockets.addAll(greatRockets);
        for (final r in greatRockets) {
          addBurst(
            origin: r.targetOffset,
            count: 28,
            startTime: r.detonateTime,
            minSpeed: 105.0,
            maxSpeed: 225.0,
            upwardBias: 30.0,
            gravity: 185.0,
            sizeBase: 8.2,
            fullCircle: true,
          );
        }
        break;

      case ScoreCelebrationTier.jackpot:
        // Massive central supernova (52 particles) + 5 staggered aerial firework rockets!
        addBurst(
          origin: Offset.zero,
          count: 52,
          startTime: 0.0,
          minSpeed: 155.0,
          maxSpeed: 330.0,
          upwardBias: 80.0,
          gravity: 220.0,
          sizeBase: 9.6,
          fullCircle: true,
        );
        const jackpotRockets = <_AerialRocket>[
          _AerialRocket(
            targetOffset: Offset(-124, -96),
            launchTime: 0.01,
            detonateTime: 0.14,
            color: Color(0xFFD49E2A),
          ),
          _AerialRocket(
            targetOffset: Offset(124, -92),
            launchTime: 0.06,
            detonateTime: 0.20,
            color: PencilPalette.greenPencil,
          ),
          _AerialRocket(
            targetOffset: Offset(-68, -152),
            launchTime: 0.11,
            detonateTime: 0.26,
            color: PencilPalette.redPencil,
          ),
          _AerialRocket(
            targetOffset: Offset(68, -148),
            launchTime: 0.16,
            detonateTime: 0.32,
            color: PencilPalette.bluePencil,
          ),
          _AerialRocket(
            targetOffset: Offset(0, -176),
            launchTime: 0.21,
            detonateTime: 0.38,
            color: Color(0xFF8E44AD),
          ),
        ];
        rockets.addAll(jackpotRockets);
        for (final r in jackpotRockets) {
          addBurst(
            origin: r.targetOffset,
            count: 32,
            startTime: r.detonateTime,
            minSpeed: 115.0,
            maxSpeed: 260.0,
            upwardBias: 35.0,
            gravity: 180.0,
            sizeBase: 8.8,
            fullCircle: true,
          );
        }
        break;
    }

    _rockets = rockets;
    _particles = particles;
  }

  double _computeNumberPopScale(double t) {
    // Dramatic elastic pop during first 35% of animation: 0.42 -> 1.46 -> 0.92 -> 1.0
    if (t >= 0.36) return 1.0;
    final u = (t / 0.36).clamp(0.0, 1.0);
    if (u < 0.40) {
      final k = Curves.easeOutCubic.transform(u / 0.40);
      return 0.42 + (1.46 - 0.42) * k;
    } else if (u < 0.72) {
      final k = Curves.easeInOut.transform((u - 0.40) / 0.32);
      return 1.46 + (0.92 - 1.46) * k;
    } else {
      final k = Curves.easeOut.transform((u - 0.72) / 0.28);
      return 0.92 + (1.0 - 0.92) * k;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final isAnimating = _controller.isAnimating;
          // Self-drawing circle whips around the score in the first 32% of the animation
          final circleProgress =
              Curves.easeOutCubic.transform((t / 0.32).clamp(0.0, 1.0));
          final numberScale = isAnimating ? _computeNumberPopScale(t) : 1.0;

          // Subtle paper micro-shake on jackpot/great during first 18% of animation
          double shakeDx = 0.0;
          double shakeDy = 0.0;
          if (isAnimating &&
              (widget.celebration?.tier == ScoreCelebrationTier.jackpot ||
                  widget.celebration?.tier == ScoreCelebrationTier.great) &&
              t < 0.18) {
            final damp = 1.0 - (t / 0.18);
            final amp =
                widget.celebration?.tier == ScoreCelebrationTier.jackpot
                    ? 3.6
                    : 2.0;
            shakeDx = sin(t * pi * 42) * amp * damp;
            shakeDy = cos(t * pi * 34) * (amp * 0.65) * damp;
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
                      strokeWidth: 2.3,
                      seed: widget.circleSeed,
                      progress: circleProgress,
                    ),
                  ),
                ),

                // 2. Popping score text + checkmark
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
                          ((t - 0.10) / 0.35).clamp(0.0, 1.0),
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingBadge(double t, ScoreCelebrationEvent event) {
    // Badge stamps in with elastic bounce, rises 68px above cell, and fades out smoothly
    final enterScale = Curves.elasticOut.transform((t / 0.28).clamp(0.0, 1.0));
    final opacity = t < 0.68
        ? 1.0
        : (1.0 - Curves.easeIn.transform(((t - 0.68) / 0.32).clamp(0.0, 1.0)));
    final dy = -26.0 - Curves.easeOutCubic.transform(t) * 48.0;

    final isJackpot = event.tier == ScoreCelebrationTier.jackpot;
    final isGreat = event.tier == ScoreCelebrationTier.great;
    final isScratch = event.tier == ScoreCelebrationTier.scratch;

    final Color borderColor = isJackpot
        ? const Color(0xFFD49E2A)
        : (isScratch
            ? PencilPalette.redPencil
            : (isGreat ? PencilPalette.greenPencil : PencilPalette.bluePencil));
    final Color fillColor = isJackpot
        ? const Color(0xFFFFF6C4)
        : (isScratch ? const Color(0xFFFFF0F0) : const Color(0xFFEAF8EE));

    return Transform.translate(
      offset: Offset(0, dy),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: isJackpot ? -0.045 : -0.025,
          child: Transform.scale(
            scale: enterScale,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isJackpot ? 12 : (isGreat ? 10 : 8),
                vertical: isJackpot ? 4.5 : 3.0,
              ),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: borderColor,
                  width: isJackpot ? 2.0 : 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 6,
                    offset: Offset(0, 2.5),
                  ),
                ],
              ),
              child: Text(
                event.floatingBadgeText,
                maxLines: 1,
                style: GoogleFonts.patrickHand(
                  fontSize: isJackpot ? 18.0 : (isGreat ? 15.5 : 14.0),
                  fontWeight: FontWeight.bold,
                  color: isScratch
                      ? PencilPalette.redPencil
                      : (isJackpot
                          ? const Color(0xFF8F5E00)
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
  final List<_AerialRocket> rockets;
  final List<_SketchParticle> particles;
  final int seed;

  const _ScoreFireworksPainter({
    required this.progress,
    required this.tier,
    required this.rockets,
    required this.particles,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Warm highlighter burst glow at cell center during first 35%
    if (progress < 0.35 && tier != ScoreCelebrationTier.scratch) {
      final glowT = (progress / 0.35).clamp(0.0, 1.0);
      final glowRadius = 24.0 + Curves.easeOut.transform(glowT) *
          (tier == ScoreCelebrationTier.jackpot ? 95.0 : 62.0);
      final glowColor = tier == ScoreCelebrationTier.jackpot
          ? const Color(0xFFFFE066)
          : const Color(0xFFB7F0C0);
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            glowColor.withValues(alpha: (1.0 - glowT) * 0.48),
            glowColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
      canvas.drawCircle(center, glowRadius, glowPaint);
    }

    // 2. Long Comic Starburst Impact Rays radiating out (up to 110px!)
    if (progress < 0.46) {
      final rayT = (progress / 0.46).clamp(0.0, 1.0);
      final rayOpacity = (1.0 - Curves.easeIn.transform(rayT)).clamp(0.0, 1.0);
      final rayCount = switch (tier) {
        ScoreCelebrationTier.jackpot => 22,
        ScoreCelebrationTier.great => 16,
        ScoreCelebrationTier.standard => 12,
        ScoreCelebrationTier.scratch => 8,
      };
      final maxRayRadius = switch (tier) {
        ScoreCelebrationTier.jackpot => 125.0,
        ScoreCelebrationTier.great => 92.0,
        ScoreCelebrationTier.standard => 70.0,
        ScoreCelebrationTier.scratch => 48.0,
      };

      final rayPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = tier == ScoreCelebrationTier.jackpot ? 2.4 : 1.8
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < rayCount; i++) {
        final angle = (i / rayCount) * pi * 2 + (seed % 7) * 0.12;
        final isLongRay = i.isEven;
        final reach = maxRayRadius * (isLongRay ? 1.0 : 0.68);
        final innerR = 20.0 + Curves.easeOut.transform(rayT) * (reach * 0.48);
        final outerR = 32.0 + Curves.easeOutCubic.transform(rayT) * reach;

        final p1 = Offset(
          center.dx + cos(angle) * innerR,
          center.dy + sin(angle) * innerR * 0.82,
        );
        final p2 = Offset(
          center.dx + cos(angle) * outerR,
          center.dy + sin(angle) * outerR * 0.82,
        );

        final color = tier == ScoreCelebrationTier.scratch
            ? PencilPalette.redPencil
            : (i % 3 == 0
                ? PencilPalette.greenPencil
                : (i % 3 == 1
                    ? const Color(0xFFD49E2A)
                    : PencilPalette.bluePencil));
        rayPaint.color = color.withValues(alpha: rayOpacity * 0.88);
        canvas.drawLine(p1, p2, rayPaint);
      }
    }

    // 3. Expanding Double-Stroke Shockwave Rings (at origin and aerial burst centers)
    if (tier != ScoreCelebrationTier.scratch && progress < 0.62) {
      final ringT = Curves.easeOutCubic.transform(
        (progress / 0.62).clamp(0.0, 1.0),
      );
      final ringAlpha = (1.0 - ringT) * 0.7;
      final maxRadius = tier == ScoreCelebrationTier.jackpot
          ? 145.0
          : (tier == ScoreCelebrationTier.great ? 105.0 : 75.0);

      final ringPaint = Paint()
        ..color = (tier == ScoreCelebrationTier.jackpot
                ? const Color(0xFFD49E2A)
                : PencilPalette.greenPencil)
            .withValues(alpha: ringAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: 36.0 + ringT * maxRadius * 2.0,
          height: 24.0 + ringT * maxRadius * 1.55,
        ),
        ringPaint,
      );
    }

    // 4. Ascending Aerial Firework Rockets (spark trail + glowing head before detonation)
    for (final rocket in rockets) {
      if (progress >= rocket.launchTime && progress <= rocket.detonateTime) {
        final u = ((progress - rocket.launchTime) /
                max(0.01, rocket.detonateTime - rocket.launchTime))
            .clamp(0.0, 1.0);
        final curvedU = Curves.easeOutQuad.transform(u);
        final headPos = Offset(
          center.dx + rocket.targetOffset.dx * curvedU,
          center.dy + rocket.targetOffset.dy * curvedU,
        );
        final tailU = max(0.0, curvedU - 0.35);
        final tailPos = Offset(
          center.dx + rocket.targetOffset.dx * tailU,
          center.dy + rocket.targetOffset.dy * tailU,
        );

        final trailPaint = Paint()
          ..color = rocket.color.withValues(alpha: 0.85)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        canvas.drawLine(tailPos, headPos, trailPaint);

        // Bright spark head at tip of ascending rocket
        final headPaint = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(headPos, 4.2, headPaint);
      } else if (progress > rocket.detonateTime &&
          progress < rocket.detonateTime + 0.28) {
        // Aerial detonation flash ring!
        final flashT = ((progress - rocket.detonateTime) / 0.28).clamp(0.0, 1.0);
        final burstCenter = center + rocket.targetOffset;
        final ringPaint = Paint()
          ..color = rocket.color.withValues(alpha: (1.0 - flashT) * 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8;
        canvas.drawCircle(
          burstCenter,
          8.0 + Curves.easeOut.transform(flashT) * 58.0,
          ringPaint,
        );
      }
    }

    // 5. Hand-Sketched Firework Stars, Ribbons, Curls & Confetti with Motion Trails
    for (final p in particles) {
      if (progress <= p.startTime) continue;
      final localT =
          ((progress - p.startTime) / p.lifeSpan).clamp(0.0, 1.0);
      if (localT >= 1.0) continue;

      final pos = center + p.positionAt(localT);
      final prevPos = center + p.positionAt(max(0.0, localT - 0.055));
      final rot = p.initialRotation + p.angularVelocity * localT;

      // Twinkle & smooth fade out in the last 30% of particle life
      final fadeAlpha = localT < 0.70
          ? 1.0
          : (1.0 - Curves.easeIn.transform((localT - 0.70) / 0.30))
              .clamp(0.0, 1.0);
      final twinkle = 0.88 + 0.18 * sin(localT * pi * 10 + p.flutterPhase);
      final scaleFactor = localT < 0.10
          ? (localT / 0.10)
          : (1.0 - localT * 0.22) * twinkle;
      final currentSize = max(2.0, p.size * scaleFactor);

      // Draw motion-blur pencil tail behind fast-moving firework particles
      if (localT < 0.65 && p.shape != _ParticleShape.eraserCrumb) {
        final tailPaint = Paint()
          ..color = p.color.withValues(alpha: fadeAlpha * 0.38)
          ..strokeWidth = max(1.0, currentSize * 0.28)
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(prevPos, pos, tailPaint);
      }

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(rot);

      final fillPaint = Paint()
        ..color = p.color.withValues(alpha: fadeAlpha * 0.92)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = p.color.withValues(alpha: fadeAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.45
        ..strokeCap = StrokeCap.round;

      switch (p.shape) {
        case _ParticleShape.fivePointStar:
          _drawFivePointStar(canvas, currentSize, fillPaint, strokePaint);
          break;
        case _ParticleShape.fourPointSparkle:
          _drawFourPointSparkle(canvas, currentSize, fillPaint, strokePaint);
          break;
        case _ParticleShape.streamerRibbon:
          _drawStreamerRibbon(
            canvas,
            currentSize,
            localT,
            p.flutterPhase,
            strokePaint,
          );
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
                width: currentSize * 1.25,
                height: currentSize * 0.85,
              ),
              const Radius.circular(2.0),
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

  void _drawStreamerRibbon(
    Canvas canvas,
    double r,
    double localT,
    double phase,
    Paint strokePaint,
  ) {
    final wave = sin(localT * pi * 6 + phase) * r * 0.65;
    final ribbonPaint = Paint()
      ..color = strokePaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(-r * 1.2, -wave * 0.4)
      ..cubicTo(-r * 0.4, wave, r * 0.4, -wave, r * 1.2, wave * 0.4);
    canvas.drawPath(path, ribbonPaint);
  }

  void _drawPencilCurl(Canvas canvas, double r, Paint strokePaint) {
    final path = Path()
      ..moveTo(-r * 0.85, 0)
      ..quadraticBezierTo(-r * 0.2, -r * 0.95, r * 0.3, 0)
      ..quadraticBezierTo(r * 0.75, r * 0.75, r * 1.05, -r * 0.35);
    canvas.drawPath(path, strokePaint);
  }

  void _drawDiamond(
    Canvas canvas,
    double r,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path()
      ..moveTo(0, -r * 0.9)
      ..lineTo(r * 0.58, 0)
      ..lineTo(0, r * 0.9)
      ..lineTo(-r * 0.58, 0)
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
      duration: const Duration(milliseconds: 680),
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
        // Pulse 1.0 -> 1.32 -> 1.0
        final scale = t < 0.36
            ? 1.0 + 0.32 * Curves.easeOutCubic.transform(t / 0.36)
            : 1.32 - 0.32 * Curves.elasticOut.transform((t - 0.36) / 0.64);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
