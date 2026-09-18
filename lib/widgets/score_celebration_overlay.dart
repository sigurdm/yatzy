import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yatzy_models.dart';
import 'pencil_painters.dart';

/// Intensity tier for the sketchbook celebration when a score is written.
enum ScoreCelebrationTier {
  /// Zero lower score or negative upper-section score:
  /// The wooden pencil flips 180° to its pink rubber eraser and scrubs across the cell,
  /// kicking up pink eraser crumbs and sketching a grumpy `( ×_× )` storm-cloud doodle!
  scratch,

  /// Par (0) upper score or modest lower score:
  /// A 3D wooden pencil swoops in, traces the circle around the number, then sketches
  /// a double-underline, swooshing checkmark (`✓`), and hand-drawn 5-stroke notebook stars (`☆`).
  standard,

  /// Above-par upper score (+1..+12) or major lower combo (Full House, Straight, 4-of-a-Kind, etc.):
  /// A chisel-tip fluorescent Highlighter sweeps across the cell while colored pencils live-sketch
  /// a 3D Ribbon Banner, a Crown doodle, loop-de-loop spirals, pentagram stars, and cedar pencil shavings!
  great,

  /// Yatzy, Super Yatzy, or clinching the Upper Section Bonus:
  /// Full Notebook Margin Takeover! Highlighter sweep + dual Gold/Red pencils live-sketching a giant Crown,
  /// a hand-drawn Paper Airplane flying a loop-de-loop across the page with a dashed pencil trail,
  /// cedar wood sharpener curls, and a slammed Red-Ink Grade Stamp (`★ YATZY! +50p ★`).
  jackpot,
}

/// Snapshot of the latest scored turn used to trigger cell-anchored pencil & notebook animations.
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

  /// Hand-lettered notebook stamp/ribbon label shown above the scored cell.
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

/// A self-drawing continuous pencil doodle path on the notebook paper.
/// Drawn progressively using `PathMetric.extractPath(0, len * progress)` with a physical
/// wooden pencil tip following the active stroke!
class _ProgressiveDoodleStroke {
  final Path path;
  final Color color;
  final double strokeWidth;
  final double startTime;
  final double endTime;
  final bool showPencilActor;
  final Color? fillAfterComplete;

  const _ProgressiveDoodleStroke({
    required this.path,
    required this.color,
    this.strokeWidth = 2.1,
    required this.startTime,
    required this.endTime,
    this.showPencilActor = false,
    this.fillAfterComplete,
  });
}

/// Physical paper debris (pink eraser crumbs or scalloped cedar-wood pencil sharpener shavings).
class _NotebookDebris {
  final Offset origin;
  final double vx;
  final double vy;
  final double gravity;
  final double size;
  final double initialRotation;
  final double spin;
  final double startTime;
  final Color primaryColor;
  final bool isWoodShavingFan;

  const _NotebookDebris({
    required this.origin,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.size,
    required this.initialRotation,
    required this.spin,
    required this.startTime,
    required this.primaryColor,
    required this.isWoodShavingFan,
  });
}

/// Wraps a newly-scored cell on the scorecard, providing:
/// 1. Live self-drawing colored-pencil circle (`PencilCirclePainter` progress 0 -> 1).
/// 2. Elastic spring number pop (`scale 0.42 -> 1.44 -> 0.92 -> 1.0`).
/// 3. Root `OverlayEntry` (`CompositedTransformFollower`) featuring a **Living 3D Wooden Pencil**,
///    **Chisel-Tip Yellow Highlighter**, **Pink Rubber Eraser Scrub**, **Self-Drawing Margin Doodles**,
///    and a **Paper Airplane Loop-de-Loop** on Jackpots!
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
  late List<_ProgressiveDoodleStroke> _doodleStrokes;
  late List<_NotebookDebris> _debris;
  Path? _airplaneFlightPath;

  @override
  void initState() {
    super.initState();
    _buildNotebookScene(widget.celebration);
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
      _buildNotebookScene(widget.celebration);
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
                    width: 660,
                    height: 500,
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
                                painter: _LivingPencilNotebookPainter(
                                  progress: t,
                                  event: widget.celebration!,
                                  doodleStrokes: _doodleStrokes,
                                  debris: _debris,
                                  airplaneFlightPath: _airplaneFlightPath,
                                  circleColor: widget.circleColor,
                                  circleSeed: widget.circleSeed,
                                ),
                              ),
                            ),
                            _buildNotebookStampBanner(t, widget.celebration!),
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
        return const Duration(milliseconds: 2300);
      case ScoreCelebrationTier.great:
        return const Duration(milliseconds: 1800);
      case ScoreCelebrationTier.standard:
        return const Duration(milliseconds: 1400);
      case ScoreCelebrationTier.scratch:
      case null:
        return const Duration(milliseconds: 1250);
    }
  }

  /// Builds continuous single-stroke hand-drawn pentagram star (`☆`) at [center] with radius [r].
  static Path _createPentagramStarPath(Offset center, double r,
      {double rotation = 0.0}) {
    // Order of vertices for a continuous 5-stroke hand-drawn star: 0 -> 2 -> 4 -> 1 -> 3 -> 0
    const order = [0, 2, 4, 1, 3, 0];
    final path = Path();
    for (int i = 0; i < order.length; i++) {
      final idx = order[i];
      final angle = -pi / 2 + rotation + idx * (2 * pi / 5);
      final pt = Offset(
        center.dx + cos(angle) * r,
        center.dy + sin(angle) * r,
      );
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    return path;
  }

  /// Builds a continuous hand-drawn 3-peak Crown doodle (`👑`) centered at [center].
  static Path _createCrownPath(Offset center, double width, double height) {
    final l = center.dx - width / 2;
    final r = center.dx + width / 2;
    final b = center.dy + height / 2;
    final t = center.dy - height / 2;
    return Path()
      ..moveTo(l + width * 0.08, b)
      ..lineTo(l, t + height * 0.18)
      ..lineTo(center.dx - width * 0.22, b - height * 0.36)
      ..lineTo(center.dx, t)
      ..lineTo(center.dx + width * 0.22, b - height * 0.36)
      ..lineTo(r, t + height * 0.18)
      ..lineTo(r - width * 0.08, b)
      ..close();
  }

  /// Builds a continuous loop-de-loop notebook spiral flourish (`➰`).
  static Path _createSpiralFlourishPath(
    Offset start, {
    required bool goRight,
    required double scale,
  }) {
    final dir = goRight ? 1.0 : -1.0;
    final path = Path()..moveTo(start.dx, start.dy);
    const steps = 36;
    for (int i = 1; i <= steps; i++) {
      final u = i / steps;
      final theta = u * pi * 3.4;
      final dx = dir * (u * 58.0 * scale + sin(theta) * 14.0 * scale);
      final dy = -u * 26.0 * scale - (1.0 - cos(theta)) * 12.0 * scale;
      path.lineTo(start.dx + dx, start.dy + dy);
    }
    return path;
  }

  /// Builds a swooshing double-underline + checkmark (`✓`) path underneath the cell.
  static Path _createUnderlineAndCheckPath(Offset cellCenter) {
    final path = Path()
      // First underline stroke
      ..moveTo(cellCenter.dx - 36, cellCenter.dy + 21)
      ..quadraticBezierTo(
        cellCenter.dx,
        cellCenter.dy + 18,
        cellCenter.dx + 38,
        cellCenter.dy + 22,
      )
      // Second underline stroke
      ..moveTo(cellCenter.dx + 34, cellCenter.dy + 26)
      ..quadraticBezierTo(
        cellCenter.dx,
        cellCenter.dy + 24,
        cellCenter.dx - 28,
        cellCenter.dy + 27,
      )
      // Big swooshing Checkmark on the right side of the cell
      ..moveTo(cellCenter.dx + 44, cellCenter.dy - 4)
      ..lineTo(cellCenter.dx + 53, cellCenter.dy + 7)
      ..quadraticBezierTo(
        cellCenter.dx + 66,
        cellCenter.dy - 14,
        cellCenter.dx + 80,
        cellCenter.dy - 26,
      );
    return path;
  }

  /// Builds a grumpy storm cloud + lightning bolt + `( ×_× )` doodle for scratches!
  static Path _createGrumpyCloudDoodlePath(Offset center) {
    final path = Path()
      // Storm cloud puffs
      ..moveTo(center.dx - 24, center.dy)
      ..cubicTo(
        center.dx - 32,
        center.dy - 14,
        center.dx - 12,
        center.dy - 22,
        center.dx - 4,
        center.dy - 14,
      )
      ..cubicTo(
        center.dx + 4,
        center.dy - 26,
        center.dx + 24,
        center.dy - 20,
        center.dx + 24,
        center.dy - 6,
      )
      ..cubicTo(
        center.dx + 34,
        center.dy - 4,
        center.dx + 30,
        center.dy + 8,
        center.dx + 18,
        center.dy + 8,
      )
      ..lineTo(center.dx - 20, center.dy + 8)
      ..close()
      // Jagged lightning bolt below cloud
      ..moveTo(center.dx + 2, center.dy + 9)
      ..lineTo(center.dx - 7, center.dy + 22)
      ..lineTo(center.dx + 3, center.dy + 21)
      ..lineTo(center.dx - 5, center.dy + 35);
    return path;
  }

  void _buildNotebookScene(ScoreCelebrationEvent? event) {
    if (event == null) {
      _doodleStrokes = const [];
      _debris = const [];
      _airplaneFlightPath = null;
      return;
    }

    final rng = Random(event.eventId * 151 + event.category.index * 43);
    final strokes = <_ProgressiveDoodleStroke>[];
    final debris = <_NotebookDebris>[];
    _airplaneFlightPath = null;

    // Note: (0, 0) in stroke coordinates is the center of the 660x500 overlay (the scored cell center)
    switch (event.tier) {
      case ScoreCelebrationTier.scratch:
        // 1. Grumpy storm cloud & lightning bolt sketched by pencil in upper-right margin
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createGrumpyCloudDoodlePath(const Offset(72, -34)),
            color: PencilPalette.graphiteDark,
            strokeWidth: 2.0,
            startTime: 0.25,
            endTime: 0.72,
            showPencilActor: true,
          ),
        );
        // 2. Scribbled X marks left and right
        final leftX = Path()
          ..moveTo(-64, -10)
          ..lineTo(-48, 8)
          ..moveTo(-48, -10)
          ..lineTo(-64, 8);
        strokes.add(
          _ProgressiveDoodleStroke(
            path: leftX,
            color: PencilPalette.redPencil,
            strokeWidth: 2.2,
            startTime: 0.15,
            endTime: 0.45,
          ),
        );
        // 3. 26 pink rubber eraser crumbs kicked out during the back-and-forth eraser scrub!
        for (int i = 0; i < 26; i++) {
          final angle = -pi * 0.9 + (i / 25.0) * pi * 0.8 +
              (rng.nextDouble() - 0.5) * 0.3;
          final speed = 65.0 + rng.nextDouble() * 95.0;
          debris.add(
            _NotebookDebris(
              origin: Offset((rng.nextDouble() - 0.5) * 38, 0),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 20.0,
              gravity: 250.0,
              size: 4.8 + rng.nextDouble() * 4.2,
              initialRotation: rng.nextDouble() * pi * 2,
              spin: (rng.nextDouble() - 0.5) * 10.0,
              startTime: 0.06 + (i % 5) * 0.04,
              primaryColor: i % 4 == 0
                  ? PencilPalette.graphiteMedium
                  : const Color(0xFFF08A9D),
              isWoodShavingFan: false,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.standard:
        // 1. Pencil sketches double-underline + swooshing Checkmark (t = 0.28 .. 0.62)
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createUnderlineAndCheckPath(Offset.zero),
            color: PencilPalette.greenPencil,
            strokeWidth: 2.4,
            startTime: 0.26,
            endTime: 0.60,
            showPencilActor: true,
          ),
        );
        // 2. Hand-drawn 5-stroke Pentagram Stars left & right
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createPentagramStarPath(
              const Offset(-68, -16),
              16.0,
              rotation: -0.2,
            ),
            color: const Color(0xFFD49E2A),
            strokeWidth: 2.0,
            startTime: 0.30,
            endTime: 0.66,
            fillAfterComplete: const Color(0xFFFFF3B0),
          ),
        );
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createPentagramStarPath(
              const Offset(88, -8),
              14.0,
              rotation: 0.25,
            ),
            color: PencilPalette.bluePencil,
            strokeWidth: 1.9,
            startTime: 0.42,
            endTime: 0.74,
            fillAfterComplete: const Color(0xFFDDF0FF),
          ),
        );
        // 3. 10 cedar-wood pencil sharpener shavings & graphite curls
        for (int i = 0; i < 10; i++) {
          final angle = -pi * 0.85 + (i / 9.0) * pi * 0.70;
          final speed = 75.0 + rng.nextDouble() * 65.0;
          debris.add(
            _NotebookDebris(
              origin: Offset((i.isEven ? -1 : 1) * 28.0, -8.0),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 25.0,
              gravity: 190.0,
              size: 9.0 + rng.nextDouble() * 4.0,
              initialRotation: rng.nextDouble() * pi * 2,
              spin: (rng.nextDouble() - 0.5) * 6.0,
              startTime: 0.18 + i * 0.02,
              primaryColor: i.isEven
                  ? PencilPalette.greenPencil
                  : PencilPalette.bluePencil,
              isWoodShavingFan: true,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.great:
        // 1. Pencil sketches a 3D Crown right above the cell (t = 0.24 .. 0.56)
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createCrownPath(const Offset(0, -34), 46.0, 24.0),
            color: const Color(0xFFD49E2A),
            strokeWidth: 2.4,
            startTime: 0.24,
            endTime: 0.56,
            showPencilActor: true,
            fillAfterComplete: const Color(0xFFFFEC8B),
          ),
        );
        // 2. Left & Right Loop-de-Loop Spiral Flourishes
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createSpiralFlourishPath(
              const Offset(-46, 4),
              goRight: false,
              scale: 1.15,
            ),
            color: PencilPalette.bluePencil,
            strokeWidth: 2.1,
            startTime: 0.20,
            endTime: 0.58,
          ),
        );
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createSpiralFlourishPath(
              const Offset(46, 4),
              goRight: true,
              scale: 1.15,
            ),
            color: PencilPalette.greenPencil,
            strokeWidth: 2.1,
            startTime: 0.24,
            endTime: 0.62,
          ),
        );
        // 3. 4 Hand-Drawn 5-Stroke Pentagram Stars around the margin
        final greatStarOffsets = <Offset>[
          const Offset(-92, -36),
          const Offset(92, -34),
          const Offset(-62, -62),
          const Offset(64, -60),
        ];
        final greatColors = <Color>[
          const Color(0xFFD49E2A),
          PencilPalette.greenPencil,
          PencilPalette.redPencil,
          PencilPalette.bluePencil,
        ];
        for (int i = 0; i < greatStarOffsets.length; i++) {
          strokes.add(
            _ProgressiveDoodleStroke(
              path: _createPentagramStarPath(
                greatStarOffsets[i],
                16.0 + (i.isEven ? 3.0 : 0.0),
                rotation: (i - 1.5) * 0.2,
              ),
              color: greatColors[i],
              strokeWidth: 2.1,
              startTime: 0.32 + i * 0.06,
              endTime: 0.68 + i * 0.06,
              showPencilActor: i == 3,
              fillAfterComplete: greatColors[i].withValues(alpha: 0.22),
            ),
          );
        }
        // 4. 18 Scalloped Cedar-Wood Pencil Sharpener Shavings spiraling down
        for (int i = 0; i < 18; i++) {
          final angle = -pi * 0.90 + (i / 17.0) * pi * 0.80;
          final speed = 95.0 + rng.nextDouble() * 90.0;
          debris.add(
            _NotebookDebris(
              origin: Offset((rng.nextDouble() - 0.5) * 40, -10),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 35.0,
              gravity: 195.0,
              size: 10.5 + rng.nextDouble() * 5.0,
              initialRotation: rng.nextDouble() * pi * 2,
              spin: (rng.nextDouble() - 0.5) * 7.5,
              startTime: 0.14 + (i % 6) * 0.03,
              primaryColor: greatColors[i % greatColors.length],
              isWoodShavingFan: true,
            ),
          );
        }
        break;

      case ScoreCelebrationTier.jackpot:
        // 1. Giant Hand-Drawn 3D Royal Crown (`👑`) above the cell (t = 0.20 .. 0.50)
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createCrownPath(const Offset(0, -38), 64.0, 32.0),
            color: const Color(0xFFD49E2A),
            strokeWidth: 2.8,
            startTime: 0.18,
            endTime: 0.48,
            showPencilActor: true,
            fillAfterComplete: const Color(0xFFFFE566),
          ),
        );
        // 2. Sweeping Double Underline & Flourishes
        strokes.add(
          _ProgressiveDoodleStroke(
            path: _createUnderlineAndCheckPath(Offset.zero),
            color: PencilPalette.redPencil,
            strokeWidth: 2.6,
            startTime: 0.22,
            endTime: 0.52,
          ),
        );
        // 3. 6 Large Continuous 5-Stroke Pentagram Stars across the notebook
        final jackpotStars = <Offset>[
          const Offset(-126, -42),
          const Offset(126, -40),
          const Offset(-86, -88),
          const Offset(88, -86),
          const Offset(-144, 18),
          const Offset(144, 20),
        ];
        const jackpotPalette = <Color>[
          Color(0xFFD49E2A),
          PencilPalette.redPencil,
          PencilPalette.greenPencil,
          PencilPalette.bluePencil,
          PencilPalette.orangePencil,
          Color(0xFF8E44AD),
        ];
        for (int i = 0; i < jackpotStars.length; i++) {
          strokes.add(
            _ProgressiveDoodleStroke(
              path: _createPentagramStarPath(
                jackpotStars[i],
                19.0 + (i % 2) * 4.0,
                rotation: (i - 2.5) * 0.18,
              ),
              color: jackpotPalette[i],
              strokeWidth: 2.3,
              startTime: 0.24 + i * 0.05,
              endTime: 0.62 + i * 0.05,
              showPencilActor: i == 1 || i == 4,
              fillAfterComplete: jackpotPalette[i].withValues(alpha: 0.25),
            ),
          );
        }
        // 4. Hand-Drawn Paper Airplane Loop-de-Loop Flight Path across the scorecard!
        _airplaneFlightPath = Path()
          ..moveTo(-180, 42)
          ..cubicTo(-95, 25, -45, -15, 0, -48)
          // Full loop-de-loop high above the cell!
          ..cubicTo(48, -82, 68, -148, 8, -152)
          ..cubicTo(-52, -156, -32, -82, 28, -58)
          // Swoop out toward upper-right margin
          ..cubicTo(98, -32, 165, -75, 225, -125);

        // 5. 24 Cedar-Wood & Gold Pencil Sharpener Curls
        for (int i = 0; i < 24; i++) {
          final angle = -pi * 0.94 + (i / 23.0) * pi * 0.88;
          final speed = 115.0 + rng.nextDouble() * 115.0;
          debris.add(
            _NotebookDebris(
              origin: Offset((rng.nextDouble() - 0.5) * 52, -12),
              vx: cos(angle) * speed,
              vy: sin(angle) * speed - 45.0,
              gravity: 190.0,
              size: 11.5 + rng.nextDouble() * 5.5,
              initialRotation: rng.nextDouble() * pi * 2,
              spin: (rng.nextDouble() - 0.5) * 8.5,
              startTime: 0.10 + (i % 8) * 0.03,
              primaryColor: jackpotPalette[i % jackpotPalette.length],
              isWoodShavingFan: true,
            ),
          );
        }
        break;
    }

    _doodleStrokes = strokes;
    _debris = debris;
  }

  double _computeNumberPopScale(double t) {
    // Elastic stamp pop during first 35% of animation: 0.42 -> 1.46 -> 0.92 -> 1.0
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
          // Self-drawing circle whips around the score in the first 28% of the animation
          final circleProgress =
              Curves.easeOutCubic.transform((t / 0.28).clamp(0.0, 1.0));
          final numberScale = isAnimating ? _computeNumberPopScale(t) : 1.0;

          // Subtle paper micro-shake on jackpot/great or eraser scrub on scratch
          double shakeDx = 0.0;
          double shakeDy = 0.0;
          if (isAnimating) {
            if (widget.celebration?.tier == ScoreCelebrationTier.scratch &&
                t >= 0.12 &&
                t <= 0.52) {
              // Horizontal back-and-forth vibration while the pink eraser scrubs the cell!
              final scrubT = (t - 0.12) / 0.40;
              shakeDx = sin(scrubT * pi * 12) * 2.6 * (1.0 - scrubT);
            } else if ((widget.celebration?.tier ==
                        ScoreCelebrationTier.jackpot ||
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

  /// Hand-drawn Teacher's Grade Stamp / Notebook Ribbon Banner above the cell.
  Widget _buildNotebookStampBanner(double t, ScoreCelebrationEvent event) {
    final enterScale =
        Curves.elasticOut.transform(((t - 0.08) / 0.30).clamp(0.0, 1.0));
    final opacity = t < 0.72
        ? 1.0
        : (1.0 - Curves.easeIn.transform(((t - 0.72) / 0.28).clamp(0.0, 1.0)));
    final dy = -52.0 - Curves.easeOutCubic.transform(t) * 26.0;

    final isJackpot = event.tier == ScoreCelebrationTier.jackpot;
    final isGreat = event.tier == ScoreCelebrationTier.great;
    final isScratch = event.tier == ScoreCelebrationTier.scratch;

    final Color inkColor = isJackpot
        ? PencilPalette.redPencil
        : (isScratch
            ? PencilPalette.redPencil
            : (isGreat ? PencilPalette.greenPencil : PencilPalette.bluePencil));
    final Color paperFill = isJackpot
        ? const Color(0xFFFFF8DC)
        : (isScratch ? const Color(0xFFFFF2F2) : const Color(0xFFF4FBF4));

    return Transform.translate(
      offset: Offset(0, dy),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: isJackpot ? -0.065 : (isScratch ? 0.04 : -0.035),
          child: Transform.scale(
            scale: enterScale,
            child: PencilBox(
              borderColor: inkColor,
              fillColor: paperFill,
              doubleBorder: isJackpot || isGreat,
              hasPencilShading: true,
              shadingOpacity: 0.14,
              strokeWidth: isJackpot ? 2.1 : 1.6,
              seed: event.eventId * 19 + 7,
              padding: EdgeInsets.symmetric(
                horizontal: isJackpot ? 14 : (isGreat ? 11 : 9),
                vertical: isJackpot ? 5 : 3,
              ),
              child: Text(
                event.floatingBadgeText,
                maxLines: 1,
                style: GoogleFonts.patrickHand(
                  fontSize: isJackpot ? 19.0 : (isGreat ? 16.0 : 14.5),
                  fontWeight: FontWeight.bold,
                  letterSpacing: isJackpot ? 0.6 : 0.2,
                  color: inkColor,
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

/// CustomPainter that brings the notebook page to life with:
/// - A Chisel-Tip Yellow Highlighter Marker sweeping across the cell (`great` / `jackpot`)
/// - A 3D Wooden Pencil (`_drawWoodenPencil`) physically tracing the circle & doodles
/// - Flip-to-Pink-Eraser back-and-forth scrubbing on `scratch` scores
/// - Progressive `PathMetric` self-sketching margin doodles (Crown, Pentagram Stars, Spirals, Checkmark, Storm Cloud)
/// - A Hand-Drawn Paper Airplane flying a loop-de-loop with a dashed pencil trail on `jackpot`!
class _LivingPencilNotebookPainter extends CustomPainter {
  final double progress;
  final ScoreCelebrationEvent event;
  final List<_ProgressiveDoodleStroke> doodleStrokes;
  final List<_NotebookDebris> debris;
  final Path? airplaneFlightPath;
  final Color circleColor;
  final int circleSeed;

  const _LivingPencilNotebookPainter({
    required this.progress,
    required this.event,
    required this.doodleStrokes,
    required this.debris,
    required this.airplaneFlightPath,
    required this.circleColor,
    required this.circleSeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Chisel-Tip Fluorescent Yellow Highlighter Swatch & Marker Actor (Great & Jackpot)
    if (event.tier == ScoreCelebrationTier.great ||
        event.tier == ScoreCelebrationTier.jackpot) {
      _paintHighlighterSweep(canvas, center);
    }

    // 2. Progressive Self-Drawing Margin Doodles (`PathMetrics.extractPath`)
    Offset? activeDoodlePencilTip;
    Color activeDoodleLeadColor = circleColor;

    for (final stroke in doodleStrokes) {
      if (progress <= stroke.startTime) continue;
      final localT = ((progress - stroke.startTime) /
              max(0.01, stroke.endTime - stroke.startTime))
          .clamp(0.0, 1.0);
      final fadeOut = progress < 0.78
          ? 1.0
          : (1.0 - Curves.easeIn.transform((progress - 0.78) / 0.22))
              .clamp(0.0, 1.0);
      if (fadeOut <= 0.001) continue;

      final translatedPath = stroke.path.shift(center);

      // Optional soft colored-pencil fill once the doodle outline completes
      if (localT >= 0.85 && stroke.fillAfterComplete != null) {
        final fillAlpha =
            ((localT - 0.85) / 0.15).clamp(0.0, 1.0) * fadeOut * 0.85;
        final fillPaint = Paint()
          ..color = stroke.fillAfterComplete!.withValues(alpha: fillAlpha)
          ..style = PaintingStyle.fill;
        canvas.drawPath(translatedPath, fillPaint);
      }

      final strokePaint = Paint()
        ..color = stroke.color.withValues(alpha: fadeOut * 0.92)
        ..strokeWidth = stroke.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final metrics = translatedPath.computeMetrics().toList();
      if (metrics.isNotEmpty) {
        final totalLen =
            metrics.fold<double>(0.0, (sum, m) => sum + m.length);
        final targetLen = totalLen * Curves.easeInOut.transform(localT);
        double drawnSoFar = 0.0;

        for (final m in metrics) {
          if (drawnSoFar + m.length <= targetLen) {
            canvas.drawPath(m.extractPath(0.0, m.length), strokePaint);
            drawnSoFar += m.length;
          } else {
            final rem = max(0.0, targetLen - drawnSoFar);
            if (rem > 0) {
              canvas.drawPath(m.extractPath(0.0, rem), strokePaint);
              if (stroke.showPencilActor && localT < 0.99) {
                final tangent = m.getTangentForOffset(rem);
                if (tangent != null) {
                  activeDoodlePencilTip = tangent.position;
                  activeDoodleLeadColor = stroke.color;
                }
              }
            }
            break;
          }
        }
      }
    }

    // 3. Hand-Drawn Paper Airplane Loop-de-Loop + Dashed Trajectory (Jackpot!)
    if (airplaneFlightPath != null && progress >= 0.14 && progress <= 0.92) {
      _paintPaperAirplaneLoop(canvas, center);
    }

    // 4. Scalloped Cedar-Wood Pencil Sharpener Shavings & Pink Eraser Crumbs
    for (final item in debris) {
      if (progress <= item.startTime) continue;
      final localT = ((progress - item.startTime) / (1.0 - item.startTime))
          .clamp(0.0, 1.0);
      if (localT >= 1.0) continue;

      final dt = localT * 0.85;
      final px = center.dx + item.origin.dx + item.vx * dt;
      final py = center.dy +
          item.origin.dy +
          item.vy * dt +
          0.5 * item.gravity * dt * dt;
      final rot = item.initialRotation + item.spin * dt;
      final fade = localT < 0.70
          ? 1.0
          : (1.0 - ((localT - 0.70) / 0.30)).clamp(0.0, 1.0);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(rot);
      if (item.isWoodShavingFan) {
        _drawCedarPencilShavingCurl(
          canvas,
          item.size,
          item.primaryColor,
          fade,
        );
      } else {
        // Pink rubber eraser crumb
        final crumbPaint = Paint()
          ..color = item.primaryColor.withValues(alpha: fade * 0.9)
          ..style = PaintingStyle.fill;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: item.size * 1.3,
              height: item.size * 0.8,
            ),
            const Radius.circular(2.2),
          ),
          crumbPaint,
        );
      }
      canvas.restore();
    }

    // 5. The Hero 3D Wooden Pencil Actor!
    //    - During t = 0.00 .. 0.28: Physically traces the oval loop around the scored cell!
    //    - During t = 0.28 .. 0.65 on Scratch: Flips 180° so its pink rubber eraser scrubs the cell!
    //    - During t = 0.28 .. 0.68 on Standard/Great/Jackpot: Follows activeDoodlePencilTip!
    if (progress < 0.28) {
      final u = Curves.easeOutCubic.transform((progress / 0.28).clamp(0.0, 1.0));
      const totalAngle = pi * 2.25;
      final startAngle = -pi * 0.6 + (circleSeed % 5) * 0.1;
      final angle = startAngle + u * totalAngle;
      const rx = 34.0;
      const ry = 15.0;
      final tipPos = Offset(
        center.dx + rx * cos(angle),
        center.dy + ry * sin(angle),
      );
      final wobble = sin(u * pi * 12) * 0.08;
      _drawWoodenPencil(
        canvas,
        targetPoint: tipPos,
        angleRadians: -pi * 0.28 + wobble,
        leadColor: circleColor,
        eraserDown: false,
        opacity: 1.0,
      );
    } else if (event.tier == ScoreCelebrationTier.scratch && progress < 0.62) {
      // Flip pencil 180° so the PINK ERASER END scrubs horizontally back-and-forth across the cell!
      final scrubU = ((progress - 0.28) / 0.34).clamp(0.0, 1.0);
      final fade = scrubU > 0.82 ? (1.0 - (scrubU - 0.82) / 0.18) : 1.0;
      final scrubX = center.dx + sin(scrubU * pi * 10) * 24.0;
      final scrubY = center.dy + cos(scrubU * pi * 5) * 3.0;
      final tilt = -pi * 0.35 + cos(scrubU * pi * 10) * 0.14;
      _drawWoodenPencil(
        canvas,
        targetPoint: Offset(scrubX, scrubY),
        angleRadians: tilt,
        leadColor: PencilPalette.redPencil,
        eraserDown: true,
        opacity: fade.clamp(0.0, 1.0),
      );
    } else if (activeDoodlePencilTip != null && progress < 0.72) {
      final fade = progress > 0.60 ? (1.0 - (progress - 0.60) / 0.12) : 1.0;
      final wobble = sin(progress * pi * 24) * 0.07;
      _drawWoodenPencil(
        canvas,
        targetPoint: activeDoodlePencilTip,
        angleRadians: -pi * 0.26 + wobble,
        leadColor: activeDoodleLeadColor,
        eraserDown: false,
        opacity: fade.clamp(0.0, 1.0),
      );
    }
  }

  /// Paints a wet fluorescent chisel-tip highlighter swipe across the cell (`t = 0.02 .. 0.32`).
  void _paintHighlighterSweep(Canvas canvas, Offset center) {
    final sweepU = Curves.easeOutCubic.transform(
      ((progress - 0.02) / 0.28).clamp(0.0, 1.0),
    );
    if (sweepU <= 0.0) return;

    final fade = progress < 0.72
        ? 1.0
        : (1.0 - ((progress - 0.72) / 0.28)).clamp(0.0, 1.0);
    const startX = -44.0;
    const endX = 46.0;
    final currentRightX = startX + (endX - startX) * sweepU;

    // Slanted chisel-tip parallelogram swatch
    final swatchPath = Path()
      ..moveTo(center.dx + startX + 5, center.dy - 14)
      ..lineTo(center.dx + currentRightX + 5, center.dy - 14)
      ..lineTo(center.dx + currentRightX - 5, center.dy + 14)
      ..lineTo(center.dx + startX - 5, center.dy + 14)
      ..close();

    final swatchColor = event.tier == ScoreCelebrationTier.jackpot
        ? const Color(0xFFFFE633)
        : const Color(0xFFB4F87E);
    final swatchPaint = Paint()
      ..color = swatchColor.withValues(alpha: 0.38 * fade)
      ..style = PaintingStyle.fill;
    canvas.drawPath(swatchPath, swatchPaint);

    // Draw the Chisel-Tip Highlighter Marker while it is actively swiping (progress < 0.32)
    if (progress < 0.32) {
      final markerFade =
          progress > 0.24 ? (1.0 - (progress - 0.24) / 0.08) : 1.0;
      _drawChiselHighlighterMarker(
        canvas,
        tipPoint: Offset(center.dx + currentRightX, center.dy),
        markerColor: swatchColor,
        opacity: markerFade.clamp(0.0, 1.0),
      );
    }
  }

  /// Paints a hand-drawn paper airplane (`✈️`) flying a loop-de-loop with a dashed pencil trail!
  void _paintPaperAirplaneLoop(Canvas canvas, Offset center) {
    final flightU = Curves.easeInOutCubic.transform(
      ((progress - 0.14) / 0.72).clamp(0.0, 1.0),
    );
    final fade = progress < 0.76
        ? 1.0
        : (1.0 - ((progress - 0.76) / 0.16)).clamp(0.0, 1.0);
    if (fade <= 0.01) return;

    final shiftedPath = airplaneFlightPath!.shift(center);
    final metrics = shiftedPath.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final currentDist = metric.length * flightU;

    // 1. Draw dashed hand-sketched pencil trajectory trail behind the paper airplane
    final dashPaint = Paint()
      ..color = PencilPalette.bluePencil.withValues(alpha: fade * 0.65)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashLen = 7.5;
    const gapLen = 6.0;
    double d = max(0.0, currentDist - 210.0);
    while (d < currentDist - 6.0) {
      final segEnd = min(currentDist - 6.0, d + dashLen);
      canvas.drawPath(metric.extractPath(d, segEnd), dashPaint);
      d += dashLen + gapLen;
    }

    // 2. Draw the folded paper airplane at the leading tangent!
    final tangent = metric.getTangentForOffset(currentDist);
    if (tangent == null) return;

    canvas.save();
    canvas.translate(tangent.position.dx, tangent.position.dy);
    canvas.rotate(-tangent.angle);

    final wingFill = Paint()
      ..color = const Color(0xFFFAF8F2).withValues(alpha: fade)
      ..style = PaintingStyle.fill;
    final underWingFill = Paint()
      ..color = const Color(0xFFD8E6F3).withValues(alpha: fade)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = PencilPalette.bluePencil.withValues(alpha: fade)
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    // Nose at (+16, 0), left/right wings swept back to (-14, -10) and (-14, +10)
    final upperWing = Path()
      ..moveTo(16, 0)
      ..lineTo(-14, -11)
      ..lineTo(-9, -2)
      ..close();
    final centerFold = Path()
      ..moveTo(16, 0)
      ..lineTo(-9, -2)
      ..lineTo(-11, 4)
      ..close();
    final lowerWing = Path()
      ..moveTo(16, 0)
      ..lineTo(-9, 1)
      ..lineTo(-14, 11)
      ..close();

    canvas.drawPath(centerFold, underWingFill);
    canvas.drawPath(upperWing, wingFill);
    canvas.drawPath(lowerWing, wingFill);
    canvas.drawPath(centerFold, linePaint);
    canvas.drawPath(upperWing, linePaint);
    canvas.drawPath(lowerWing, linePaint);

    canvas.restore();
  }

  /// Draws a scalloped cedar-wood & colored-core pencil sharpener shaving fan!
  void _drawCedarPencilShavingCurl(
    Canvas canvas,
    double r,
    Color leadColor,
    double alpha,
  ) {
    // Scalloped wood fan with colored pigment rim
    final woodPaint = Paint()
      ..color = const Color(0xFFEED3A2).withValues(alpha: alpha * 0.92)
      ..style = PaintingStyle.fill;
    final rimPaint = Paint()
      ..color = leadColor.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1
      ..strokeCap = StrokeCap.round;
    final outlinePaint = Paint()
      ..color = PencilPalette.graphiteDark.withValues(alpha: alpha * 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final fanPath = Path()
      ..moveTo(0, 0)
      ..lineTo(-r * 0.75, -r * 0.45)
      ..arcToPoint(
        Offset(r * 0.75, -r * 0.45),
        radius: Radius.circular(r * 0.95),
        clockwise: true,
      )
      ..close();

    canvas.drawPath(fanPath, woodPaint);
    canvas.drawPath(fanPath, outlinePaint);

    // Colored pencil pigment rim along the outer scalloped arc
    final rimPath = Path()
      ..moveTo(-r * 0.75, -r * 0.45)
      ..arcToPoint(
        Offset(r * 0.75, -r * 0.45),
        radius: Radius.circular(r * 0.95),
        clockwise: true,
      );
    canvas.drawPath(rimPath, rimPaint);
  }

  /// Draws a 3D Hand-Illustrated Wooden Pencil with its tip (or pink eraser if [eraserDown])
  /// touching [targetPoint].
  void _drawWoodenPencil(
    Canvas canvas, {
    required Offset targetPoint,
    required double angleRadians,
    required Color leadColor,
    required bool eraserDown,
    required double opacity,
  }) {
    if (opacity <= 0.01) return;

    canvas.save();
    canvas.translate(targetPoint.dx, targetPoint.dy);
    canvas.rotate(angleRadians);
    if (eraserDown) {
      // Flip pencil so the pink rubber eraser is at (0, 0) touching the paper!
      canvas.translate(0, -68);
      canvas.scale(1.0, -1.0);
    }

    // Drop shadow on the notebook page
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.14 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-3, -64, 13, 62),
        const Radius.circular(3),
      ),
      shadowPaint,
    );

    const halfW = 5.6;
    const coneH = 15.0;
    const shaftBottom = -coneH;
    const shaftTop = -54.0;
    const ferruleTop = -61.0;
    const eraserTop = -69.0;

    // 1. Cedar wood sharpened cone (0,0 -> (-halfW, -coneH) .. (+halfW, -coneH))
    final conePath = Path()
      ..moveTo(0, 0)
      ..lineTo(-halfW, shaftBottom)
      ..lineTo(halfW, shaftBottom)
      ..close();
    final woodPaint = Paint()
      ..color = const Color(0xFFF2D6A2).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(conePath, woodPaint);

    // 2. Colored/Graphite Lead Tip (0,0 -> -5.5px)
    final leadPath = Path()
      ..moveTo(0, 0)
      ..lineTo(-halfW * 0.36, -coneH * 0.36)
      ..lineTo(halfW * 0.36, -coneH * 0.36)
      ..close();
    final leadPaint = Paint()
      ..color = leadColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leadPath, leadPaint);

    // 3. Hexagonal Painted Wooden Shaft (classic yellow #F6C73B with 3D facet shading)
    final shaftPath = Path()
      ..moveTo(-halfW, shaftBottom)
      ..lineTo(-halfW, shaftTop)
      ..lineTo(halfW, shaftTop)
      ..lineTo(halfW, shaftBottom)
      ..close();
    final shaftPaint = Paint()
      ..color = const Color(0xFFF6C63C).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(shaftPath, shaftPaint);

    // Darker right facet on hexagonal shaft for 3D depth
    final rightFacetPaint = Paint()
      ..color = const Color(0xFFE0A81E).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      const Rect.fromLTRB(halfW * 0.25, shaftTop, halfW, shaftBottom),
      rightFacetPaint,
    );

    // 4. Silver Metallic Ferrule Band
    final ferruleRect =
        const Rect.fromLTRB(-halfW, ferruleTop, halfW, shaftTop);
    final ferrulePaint = Paint()
      ..color = const Color(0xFFD0D7DE).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(ferruleRect, ferrulePaint);

    // 5. Pink Rubber Eraser Cap
    final eraserRRect = RRect.fromRectAndCorners(
      const Rect.fromLTRB(-halfW, eraserTop, halfW, ferruleTop),
      topLeft: const Radius.circular(3.5),
      topRight: const Radius.circular(3.5),
    );
    final eraserPaint = Paint()
      ..color = const Color(0xFFF28FA0).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(eraserRRect, eraserPaint);

    // 6. Crisp hand-drawn graphite outlines & hexagonal facet ridges
    final outlinePaint = Paint()
      ..color = PencilPalette.graphiteDark.withValues(alpha: opacity)
      ..strokeWidth = 1.35
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(conePath, outlinePaint);
    canvas.drawRect(
      const Rect.fromLTRB(-halfW, shaftTop, halfW, shaftBottom),
      outlinePaint,
    );
    // Hexagonal vertical ridges
    canvas.drawLine(
      const Offset(-halfW * 0.3, shaftBottom),
      const Offset(-halfW * 0.3, shaftTop),
      outlinePaint..strokeWidth = 0.9,
    );
    canvas.drawLine(
      const Offset(halfW * 0.3, shaftBottom),
      const Offset(halfW * 0.3, shaftTop),
      outlinePaint..strokeWidth = 0.9,
    );
    canvas.drawRect(ferruleRect, outlinePaint..strokeWidth = 1.2);
    canvas.drawRRect(eraserRRect, outlinePaint);

    canvas.restore();
  }

  /// Draws a Chisel-Tip Fluorescent Highlighter Marker swiping across the scorecard.
  void _drawChiselHighlighterMarker(
    Canvas canvas, {
    required Offset tipPoint,
    required Color markerColor,
    required double opacity,
  }) {
    if (opacity <= 0.01) return;
    canvas.save();
    canvas.translate(tipPoint.dx, tipPoint.dy);
    canvas.rotate(pi * 0.18);

    final tipPaint = Paint()
      ..color = markerColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final bodyPaint = Paint()
      ..color = const Color(0xFFFFF066).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = PencilPalette.graphiteDark.withValues(alpha: opacity * 0.85)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    // Slanted chisel felt nib
    final nibPath = Path()
      ..moveTo(0, 10)
      ..lineTo(0, -10)
      ..lineTo(10, -12)
      ..lineTo(10, 8)
      ..close();
    canvas.drawPath(nibPath, tipPaint);
    canvas.drawPath(nibPath, outlinePaint);

    // Broad marker barrel
    final barrelRRect = RRect.fromRectAndRadius(
      const Rect.fromLTRB(10, -14, 54, 11),
      const Radius.circular(4),
    );
    canvas.drawRRect(barrelRRect, bodyPaint);
    canvas.drawRRect(barrelRRect, outlinePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LivingPencilNotebookPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.event.eventId != event.eventId;
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
