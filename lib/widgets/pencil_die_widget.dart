import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/yatzy_models.dart';
import '../models/yatzy_strategy_solver.dart';
import 'pencil_painters.dart';

class PencilDiceTray extends StatelessWidget {
  final List<DieState> dice;
  final int dieSides;
  final int rollsUsed;
  final int maxRolls;
  final bool isRolling;
  final ValueChanged<int> onToggleHold;
  final VoidCallback onRoll;
  final VoidCallback? onHoldAllToggle;
  final VoidCallback? onUndo;
  final int undoCount;
  final String activePlayerName;
  final AppStrings strings;
  final TurnCoachAdvice? coachAdvice;
  final VoidCallback? onApplyOptimalHold;
  final ValueChanged<List<int>>? onSelectHoldIndices;
  final ValueChanged<YatzyCategory>? onSelectCoachCategory;
  final VoidCallback? onOpenCoachGuide;
  final YatzyGameRules? rules;

  const PencilDiceTray({
    super.key,
    required this.dice,
    this.dieSides = 6,
    required this.rollsUsed,
    this.maxRolls = 3,
    required this.isRolling,
    required this.onToggleHold,
    required this.onRoll,
    this.onHoldAllToggle,
    this.onUndo,
    this.undoCount = 0,
    required this.activePlayerName,
    required this.strings,
    this.coachAdvice,
    this.onApplyOptimalHold,
    this.onSelectHoldIndices,
    this.onSelectCoachCategory,
    this.onOpenCoachGuide,
    this.rules,
  });

  @override
  Widget build(BuildContext context) {
    final rollsLeft = maxRolls - rollsUsed;
    final unheldCount = dice.where((d) => !d.isHeld).length;
    final canRoll =
        (rollsUsed == 0 || (rollsLeft > 0 && unheldCount > 0)) && !isRolling;
    final allHeld = dice.every((d) => d.isHeld);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 560;
        final count = dice.length;
        double dieSize;
        double dieSpacing;
        if (isMobile) {
          if (count <= 4) {
            dieSize = 52.0;
            dieSpacing = 8.0;
          } else if (count == 5) {
            dieSize = 46.0;
            dieSpacing = 7.0;
          } else if (count == 6) {
            dieSize = 39.0;
            dieSpacing = 4.0;
          } else if (count == 7) {
            dieSize = 33.5;
            dieSpacing = 2.0;
          } else {
            dieSize = 38.0;
            dieSpacing = 6.0;
          }
        } else {
          if (count <= 4) {
            dieSize = 66.0;
            dieSpacing = 14.0;
          } else if (count == 5) {
            dieSize = 64.0;
            dieSpacing = 14.0;
          } else if (count == 6) {
            dieSize = 56.0;
            dieSpacing = 10.0;
          } else if (count == 7) {
            dieSize = 49.0;
            dieSpacing = 8.0;
          } else {
            dieSize = 44.0;
            dieSpacing = 6.0;
          }
        }

        return PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperCard,
          hasPencilShading: true,
          shadingOpacity: 0.06,
          strokeWidth: 1.6,
          overshoot: 3.0,
          seed: 77,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 16,
            vertical: isMobile ? 8 : 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top info row: Active player's turn, Roll counter badge, Undo & Hold All
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: PencilPalette.graphiteDark,
                      ),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isMobile ? 135 : 220,
                        ),
                        child: Text(
                          strings.playersTurn(activePlayerName),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.patrickHand(
                            fontSize: isMobile ? 16.5 : 20.5,
                            fontWeight: FontWeight.bold,
                            color: PencilPalette.graphiteDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: rollsUsed == 0
                              ? const Color(0xFFEAF6EC)
                              : PencilPalette.yellowHighlighter,
                          borderRadius: BorderRadius.circular(4),
                          border: rollsUsed == 0
                              ? Border.all(
                                  color: PencilPalette.greenPencil,
                                  width: 1.0,
                                )
                              : null,
                        ),
                        child: Text(
                          strings.rollCount(rollsUsed, maxRolls),
                          style: GoogleFonts.patrickHand(
                            fontSize: isMobile ? 13.0 : 15.5,
                            fontWeight: FontWeight.bold,
                            color: rollsUsed == 0
                                ? PencilPalette.greenPencil
                                : PencilPalette.graphiteDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Explicit Undo button in Dice Tray
                      if (onUndo != null)
                        Tooltip(
                          message: strings.undoTooltip(undoCount),
                          child: GestureDetector(
                            onTap: onUndo,
                            child: PencilBox(
                              borderColor: undoCount > 0
                                  ? PencilPalette.orangePencil
                                  : PencilPalette.graphiteLight,
                              fillColor: undoCount > 0
                                  ? const Color(0xFFFFF4E6)
                                  : PencilPalette.paperBg,
                              strokeWidth: undoCount > 0 ? 1.4 : 1.0,
                              seed: 912,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 6 : 8,
                                vertical: 2,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.undo_rounded,
                                    size: 14,
                                    color: undoCount > 0
                                        ? PencilPalette.orangePencil
                                        : PencilPalette.graphiteLight,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    strings.undoTurnWithCount(undoCount),
                                    style: GoogleFonts.patrickHand(
                                      fontSize: isMobile ? 12.5 : 14.5,
                                      fontWeight: undoCount > 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: undoCount > 0
                                          ? PencilPalette.orangePencil
                                          : PencilPalette.graphiteLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (onHoldAllToggle != null && rollsUsed > 0) ...[
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: isMobile ? 96 : 112,
                          ),
                          child: TextButton.icon(
                            onPressed: isRolling ? null : onHoldAllToggle,
                            style: TextButton.styleFrom(
                              foregroundColor: PencilPalette.bluePencil,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: Icon(
                              allHeld
                                  ? Icons.lock_open_rounded
                                  : Icons.lock_outline,
                              size: 14,
                            ),
                            label: Text(
                              allHeld
                                  ? strings.releaseAllDice
                                  : strings.holdAllDice,
                              style: GoogleFonts.patrickHand(
                                fontSize: isMobile ? 12.5 : 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 6 : 10),

              if (isMobile) ...[
                if (dice.length > 7)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: dieSpacing,
                    runSpacing: 6,
                    children: [
                      for (int i = 0; i < dice.length; i++)
                        PencilSingleDieWidget(
                          index: i,
                          die: dice[i],
                          dieSides: dieSides,
                          dieSize: dieSize,
                          isRolling: isRolling && !dice[i].isHeld,
                          waitingForFirstRoll: rollsUsed == 0,
                          isCoachRecommendedHold: coachAdvice != null &&
                              rollsUsed > 0 &&
                              !coachAdvice!.shouldScoreNow &&
                              (coachAdvice!.optimalHold?.holdIndices
                                      .contains(i) ??
                                  false),
                          onTap: () =>
                              rollsUsed == 0 ? onRoll() : onToggleHold(i),
                          strings: strings,
                        ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < dice.length; i++)
                        PencilSingleDieWidget(
                          index: i,
                          die: dice[i],
                          dieSides: dieSides,
                          dieSize: dieSize,
                          isRolling: isRolling && !dice[i].isHeld,
                          waitingForFirstRoll: rollsUsed == 0,
                          isCoachRecommendedHold: coachAdvice != null &&
                              rollsUsed > 0 &&
                              !coachAdvice!.shouldScoreNow &&
                              (coachAdvice!.optimalHold?.holdIndices
                                      .contains(i) ??
                                  false),
                          onTap: () =>
                              rollsUsed == 0 ? onRoll() : onToggleHold(i),
                          strings: strings,
                        ),
                    ],
                  ),
                const SizedBox(height: 8),
                // Compact full-width Roll button on mobile
                Row(
                  children: [
                    Expanded(
                      child: _buildSketchyRollButton(
                        canRoll,
                        rollsUsed,
                        rollsLeft,
                        unheldCount,
                        allHeld,
                        isMobile: true,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Desktop / Tablet: Dice + Roll button in a single row/wrap
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: dieSpacing,
                  runSpacing: 12,
                  children: [
                    for (int i = 0; i < dice.length; i++)
                      PencilSingleDieWidget(
                        index: i,
                        die: dice[i],
                        dieSides: dieSides,
                        dieSize: dieSize,
                        isRolling: isRolling && !dice[i].isHeld,
                        waitingForFirstRoll: rollsUsed == 0,
                        isCoachRecommendedHold: coachAdvice != null &&
                            rollsUsed > 0 &&
                            !coachAdvice!.shouldScoreNow &&
                            (coachAdvice!.optimalHold?.holdIndices
                                    .contains(i) ??
                                false),
                        onTap: () =>
                            rollsUsed == 0 ? onRoll() : onToggleHold(i),
                        strings: strings,
                      ),
                    const SizedBox(width: 6),
                    _buildSketchyRollButton(
                      canRoll,
                      rollsUsed,
                      rollsLeft,
                      unheldCount,
                      allHeld,
                      isMobile: false,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  strings.trayHelperNote(rollsUsed, rollsLeft, maxRolls),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.patrickHand(
                    fontSize: 14.5,
                    color: rollsUsed == 0
                        ? PencilPalette.greenPencil
                        : (rollsLeft > 0
                            ? PencilPalette.graphiteMedium
                            : PencilPalette.redPencil),
                    fontWeight: (rollsUsed == 0 || rollsLeft <= 0)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
              if (coachAdvice != null && rollsUsed > 0) ...[
                SizedBox(height: isMobile ? 6 : 8),
                _buildCoachAdviceBanner(coachAdvice!, isMobile: isMobile),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoachAdviceBanner(
    TurnCoachAdvice advice, {
    required bool isMobile,
  }) {
    final bestNow = advice.bestCategoryNow;
    final bestNowName = strings.categoryLabel(bestNow.category, rules: rules);
    final bestNowFormatted = YatzyScorer.formatScore(
      bestNow.category,
      bestNow.immediateScore,
    );
    final targetNames = advice.targetCategories
        .map((c) => strings.categoryLabel(c, rules: rules))
        .join(' / ');

    final hasMoreRolls = rollsUsed < maxRolls && advice.optimalHold != null;
    final topHolds = advice.holdAlternatives.take(3).toList();
    final topCats = advice.categoryRankings.take(3).toList();
    final bestStratEv = hasMoreRolls
        ? advice.optimalHold!.expectedStrategicValue
        : bestNow.strategicNetValue;

    return PencilBox(
      borderColor: PencilPalette.greenPencil,
      fillColor: const Color(0xFFF6FBE9),
      hasPencilShading: true,
      shadingOpacity: 0.10,
      strokeWidth: 1.4,
      seed: 917,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 5 : 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasMoreRolls) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    strings.coachHoldRecommendation(
                      heldFaces: advice.optimalHold!.heldFaces,
                      expectedPoints: advice.optimalHold!.expectedTurnPoints,
                      shouldScoreNow: advice.shouldScoreNow,
                      bestCategoryName: bestNowName,
                      bestCategoryScore: bestNowFormatted,
                      targetNames: targetNames,
                    ),
                    style: GoogleFonts.patrickHand(
                      fontSize: isMobile ? 13.5 : 15.0,
                      fontWeight: FontWeight.bold,
                      color: PencilPalette.graphiteDark,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if (advice.isCurrentHoldOptimal || advice.shouldScoreNow)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: PencilPalette.greenPencil.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: PencilPalette.greenPencil,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      strings.coachOptimalBadge,
                      style: GoogleFonts.patrickHand(
                        fontSize: isMobile ? 12.0 : 13.0,
                        fontWeight: FontWeight.bold,
                        color: PencilPalette.greenPencil,
                      ),
                    ),
                  )
                else if (onApplyOptimalHold != null)
                  GestureDetector(
                    onTap: onApplyOptimalHold,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: PencilPalette.yellowHighlighter.withValues(
                            alpha: 0.65,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: PencilPalette.bluePencil,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_fix_high,
                              size: 13,
                              color: PencilPalette.bluePencil,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              strings.coachApplyHoldButton,
                              style: GoogleFonts.patrickHand(
                                fontSize: isMobile ? 12.5 : 13.5,
                                fontWeight: FontWeight.bold,
                                color: PencilPalette.bluePencil,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (onOpenCoachGuide != null) ...[
                  const SizedBox(width: 5),
                  _buildHowCoachWorksChip(isMobile),
                ],
              ],
            ),
            if (!advice.isCurrentHoldOptimal &&
                advice.currentHold != null &&
                !advice.shouldScoreNow) ...[
              const SizedBox(height: 2),
              Text(
                strings.coachCurrentHoldComparison(
                  curFaces: advice.currentHold!.heldFaces,
                  curEvPoints: advice.currentHold!.expectedTurnPoints,
                  deltaStrategicEv: advice.currentHold!.expectedStrategicValue -
                      advice.optimalHold!.expectedStrategicValue,
                ),
                style: GoogleFonts.patrickHand(
                  fontSize: isMobile ? 12.0 : 13.0,
                  fontWeight: FontWeight.w600,
                  color: PencilPalette.redPencil,
                  height: 1.05,
                ),
              ),
            ],
            if (topHolds.length > 1) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 5,
                runSpacing: 3,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    strings.coachHoldAlternativesLabel,
                    style: GoogleFonts.patrickHand(
                      fontSize: isMobile ? 11.5 : 12.5,
                      fontWeight: FontWeight.bold,
                      color: PencilPalette.graphiteMedium,
                    ),
                  ),
                  for (int i = 0; i < topHolds.length; i++)
                    _buildHoldAlternativeChip(
                      rank: i + 1,
                      alt: topHolds[i],
                      deltaEv: topHolds[i].expectedStrategicValue - bestStratEv,
                      isMobile: isMobile,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 4),
          ],
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSelectCoachCategory != null
                      ? () => onSelectCoachCategory!(bestNow.category)
                      : null,
                  child: MouseRegion(
                    cursor: onSelectCoachCategory != null
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: Text(
                      strings.coachCategoryRecommendation(
                        categoryName: bestNowName,
                        scoreFormatted: bestNowFormatted,
                        bonusDelta: bestNow.bonusEvDelta,
                        netStrategicValue: bestNow.strategicNetValue,
                        isFinalRoll: !hasMoreRolls,
                      ),
                      style: GoogleFonts.patrickHand(
                        fontSize: isMobile ? 13.0 : 14.5,
                        fontWeight:
                            !hasMoreRolls ? FontWeight.bold : FontWeight.w600,
                        color: PencilPalette.greenPencil,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
              if (!hasMoreRolls && onOpenCoachGuide != null) ...[
                const SizedBox(width: 6),
                _buildHowCoachWorksChip(isMobile),
              ],
            ],
          ),
          if (topCats.length > 1) ...[
            const SizedBox(height: 3),
            Wrap(
              spacing: 5,
              runSpacing: 3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  strings.coachCategoryAlternativesLabel,
                  style: GoogleFonts.patrickHand(
                    fontSize: isMobile ? 11.5 : 12.5,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteMedium,
                  ),
                ),
                for (int i = 0; i < topCats.length; i++)
                  _buildCategoryAlternativeChip(
                    rank: i + 1,
                    eval: topCats[i],
                    deltaEv:
                        topCats[i].strategicNetValue - bestNow.strategicNetValue,
                    isMobile: isMobile,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHowCoachWorksChip(bool isMobile) {
    return GestureDetector(
      key: const Key('open_coach_guide_button'),
      onTap: onOpenCoachGuide,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FA),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: PencilPalette.bluePencil,
              width: 1.1,
            ),
          ),
          child: Text(
            strings.coachHowItWorksButton,
            style: GoogleFonts.patrickHand(
              fontSize: isMobile ? 11.5 : 12.5,
              fontWeight: FontWeight.bold,
              color: PencilPalette.bluePencil,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoldAlternativeChip({
    required int rank,
    required HoldStrategyEvaluation alt,
    required double deltaEv,
    required bool isMobile,
  }) {
    final isBest = rank == 1;
    final deltaStr = isBest
        ? 'EV ${alt.expectedStrategicValue >= 0 ? "+" : ""}${alt.expectedStrategicValue.toStringAsFixed(1)} ★'
        : '${deltaEv >= 0 ? "+" : ""}${deltaEv.toStringAsFixed(1)} EV';
    final holdShort = strings.coachFormatHoldShort(
      alt.heldFaces,
      rules?.diceCount ?? dice.length,
    );
    final label =
        '#$rank $holdShort (~${alt.expectedTurnPoints.toStringAsFixed(1)}p · $deltaStr)';

    return GestureDetector(
      onTap: onSelectHoldIndices != null
          ? () => onSelectHoldIndices!(alt.holdIndices)
          : null,
      child: MouseRegion(
        cursor: onSelectHoldIndices != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
          decoration: BoxDecoration(
            color: isBest ? const Color(0xFFE5F6E8) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isBest
                  ? PencilPalette.greenPencil
                  : PencilPalette.graphiteFaint,
              width: isBest ? 1.1 : 0.9,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.patrickHand(
              fontSize: isMobile ? 11.5 : 12.5,
              fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
              color: isBest
                  ? PencilPalette.greenPencil
                  : PencilPalette.graphiteDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAlternativeChip({
    required int rank,
    required CategoryStrategyEvaluation eval,
    required double deltaEv,
    required bool isMobile,
  }) {
    final isBest = rank == 1;
    final catName = strings.categoryLabel(eval.category, rules: rules);
    final scoreFormatted = YatzyScorer.formatScore(
      eval.category,
      eval.immediateScore,
    );
    final evStr = isBest
        ? 'EV ${eval.strategicNetValue >= 0 ? "+" : ""}${eval.strategicNetValue.toStringAsFixed(1)} ★'
        : '${deltaEv >= 0 ? "+" : ""}${deltaEv.toStringAsFixed(1)} EV';
    final label = '#$rank $catName ($scoreFormatted · $evStr)';

    return GestureDetector(
      onTap: onSelectCoachCategory != null
          ? () => onSelectCoachCategory!(eval.category)
          : null,
      child: MouseRegion(
        cursor: onSelectCoachCategory != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
          decoration: BoxDecoration(
            color: isBest ? const Color(0xFFE5F6E8) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isBest
                  ? PencilPalette.greenPencil
                  : PencilPalette.graphiteFaint,
              width: isBest ? 1.1 : 0.9,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.patrickHand(
              fontSize: isMobile ? 11.5 : 12.5,
              fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
              color: isBest
                  ? PencilPalette.greenPencil
                  : PencilPalette.graphiteDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSketchyRollButton(
    bool canRoll,
    int rollsUsed,
    int rollsLeft,
    int unheldCount,
    bool allHeld, {
    required bool isMobile,
  }) {
    final label = strings.rollButtonLabel(
      rollsUsed: rollsUsed,
      rollsLeft: rollsLeft,
      allHeld: allHeld,
      unheldCount: unheldCount,
      totalDiceCount: dice.length,
    );
    final subtext = strings.rollButtonSubtext(
      rollsUsed: rollsUsed,
      rollsLeft: rollsLeft,
      maxRolls: maxRolls,
      allHeld: allHeld,
    );

    final isStartTurn = rollsUsed == 0;
    final borderColor = !canRoll
        ? PencilPalette.graphiteLight
        : (isStartTurn ? PencilPalette.greenPencil : PencilPalette.bluePencil);
    final fillColor = !canRoll
        ? PencilPalette.paperDarker
        : (isStartTurn ? const Color(0xFFEAF6EC) : const Color(0xFFEAF2F8));

    return SizedBox(
      key: const Key('roll_button'),
      width: isMobile ? double.infinity : 228,
      height: isMobile ? 54 : 62,
      child: MouseRegion(
        cursor: canRoll ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: canRoll ? onRoll : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: canRoll ? 1.0 : 0.55,
            child: PencilBox(
              borderColor: borderColor,
              fillColor: fillColor,
              hasPencilShading: true,
              shadingOpacity: canRoll ? 0.16 : 0.08,
              strokeWidth: canRoll ? 1.8 : 1.2,
              overshoot: 2.2,
              seed: 303,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 5 : 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.casino_outlined,
                    color: borderColor,
                    size: isMobile ? 20 : 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: isMobile
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Text(
                            label,
                            maxLines: 1,
                            style: GoogleFonts.patrickHand(
                              fontSize: isMobile ? 17.5 : 20,
                              fontWeight: FontWeight.bold,
                              height: 1.05,
                              color: borderColor,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: isMobile
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Text(
                            subtext,
                            maxLines: 1,
                            style: GoogleFonts.patrickHand(
                              fontSize: isMobile ? 12.5 : 13,
                              height: 1.05,
                              color: PencilPalette.graphiteMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PencilSingleDieWidget extends StatefulWidget {
  final int index;
  final DieState die;
  final int dieSides;
  final double dieSize;
  final bool isRolling;
  final bool waitingForFirstRoll;
  final bool isCoachRecommendedHold;
  final VoidCallback onTap;
  final AppStrings strings;

  const PencilSingleDieWidget({
    super.key,
    required this.index,
    required this.die,
    this.dieSides = 6,
    this.dieSize = 64.0,
    required this.isRolling,
    this.waitingForFirstRoll = false,
    this.isCoachRecommendedHold = false,
    required this.onTap,
    required this.strings,
  });

  @override
  State<PencilSingleDieWidget> createState() => _PencilSingleDieWidgetState();
}

class _PencilSingleDieWidgetState extends State<PencilSingleDieWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _animatedFace = 1;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _animatedFace = widget.die.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..addListener(() {
        if (widget.isRolling && _controller.isAnimating) {
          setState(() {
            _animatedFace = _rng.nextInt(widget.dieSides) + 1;
          });
        }
      });
  }

  @override
  void didUpdateWidget(covariant PencilSingleDieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _controller.repeat(reverse: true);
    } else if (!widget.isRolling && oldWidget.isRolling) {
      _controller.stop();
      _controller.reset();
      setState(() {
        _animatedFace = widget.die.value;
      });
    } else if (!widget.isRolling) {
      _animatedFace = widget.die.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = widget.isRolling ? _animatedFace : widget.die.value;
    final isHeld = widget.die.isHeld;
    final size = widget.dieSize;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double angle = widget.die.wobbleAngle;
            double dy = isHeld ? -3.0 : 0.0;
            if (widget.isRolling) {
              angle += sin(_controller.value * pi * 4) * 0.25;
              dy += sin(_controller.value * pi * 2) * -5.0;
            }
            return Transform.translate(
              offset: Offset(0, dy),
              child: Transform.rotate(
                angle: angle,
                child: child,
              ),
            );
          },
          child: SizedBox(
            width: size + 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Hand-drawn die canvas (d6 cube or d8 octahedron)
                    SizedBox(
                      width: size,
                      height: size,
                      child: CustomPaint(
                        painter: _PencilDiePainter(
                          faceValue: displayValue,
                          dieSides: widget.dieSides,
                          isHeld: isHeld,
                          seed: (widget.index + 1) * 31 + displayValue * 7,
                        ),
                      ),
                    ),
                    // Red colored-pencil circle loop around held die
                    if (isHeld)
                      Positioned(
                        left: -5,
                        right: -5,
                        top: -5,
                        bottom: -5,
                        child: CustomPaint(
                          painter: PencilCirclePainter(
                            color: PencilPalette.redPencil,
                            strokeWidth: 2.1,
                            seed: widget.index * 19 + 5,
                          ),
                        ),
                      ),
                    // Strategy Coach recommended hold star badge
                    if (widget.isCoachRecommendedHold &&
                        !widget.waitingForFirstRoll)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 17,
                          height: 17,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3B0),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: PencilPalette.greenPencil,
                              width: 1.3,
                            ),
                          ),
                          child: const Text(
                            '★',
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.0,
                              fontWeight: FontWeight.bold,
                              color: PencilPalette.greenPencil,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                // Pencil label below die ("HOLDT" vs "hold" or "klar")
                SizedBox(
                  width: size + 8,
                  height: 20,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0.5,
                      ),
                      decoration: isHeld
                          ? BoxDecoration(
                              color:
                                  PencilPalette.redPencil.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(3),
                            )
                          : null,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isHeld)
                              const Icon(
                                Icons.push_pin,
                                size: 10,
                                color: PencilPalette.redPencil,
                              ),
                            if (isHeld) const SizedBox(width: 2),
                            Text(
                              isHeld
                                  ? widget.strings.dieHeldBadge
                                  : widget.strings.dieHoldHint,
                              style: GoogleFonts.patrickHand(
                                fontSize: size < 42
                                    ? 10.5
                                    : (size < 55 ? 11.5 : 13),
                                fontWeight:
                                    isHeld ? FontWeight.bold : FontWeight.normal,
                                color: isHeld
                                    ? PencilPalette.redPencil
                                    : PencilPalette.graphiteLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PencilDiePainter extends CustomPainter {
  final int faceValue;
  final int dieSides;
  final bool isHeld;
  final int seed;

  const _PencilDiePainter({
    required this.faceValue,
    this.dieSides = 6,
    required this.isHeld,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dieSides == 4) {
      _paintD4Tetrahedron(canvas, size);
    } else if (dieSides == 8) {
      _paintD8Octahedron(canvas, size);
    } else if (dieSides == 10) {
      _paintD10Decahedron(canvas, size);
    } else if (dieSides == 12) {
      _paintD12Dodecahedron(canvas, size);
    } else if (dieSides == 20 || faceValue > 12) {
      _paintD20Icosahedron(canvas, size);
    } else if (faceValue > 6) {
      _paintD8Octahedron(canvas, size);
    } else {
      _paintD6Cube(canvas, size);
    }
  }

  void _paintD6Cube(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Paper fill for the die face
    final bgPaint = Paint()
      ..color = isHeld ? const Color(0xFFFFF9F2) : PencilPalette.paperCard
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(2), const Radius.circular(7)),
      bgPaint,
    );

    // 2. Subtle pencil shading along bottom and right edge for 3D sketch depth
    final shadeDepth = size.width * 0.18;
    final shadePath = Path()
      ..moveTo(size.width - shadeDepth, 3)
      ..lineTo(size.width - 3, 3)
      ..lineTo(size.width - 3, size.height - 3)
      ..lineTo(3, size.height - 3)
      ..lineTo(3, size.height - shadeDepth)
      ..close();
    canvas.save();
    canvas.clipPath(shadePath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: PencilPalette.graphiteMedium,
      spacing: 4.0,
      opacity: 0.22,
      seed: seed,
    );
    canvas.restore();

    // 3. Hand-drawn double-stroke pencil outline
    final strokeColor =
        isHeld ? PencilPalette.redPencil : PencilPalette.graphiteDark;
    const inset = 2.5;
    final tl = const Offset(inset, inset);
    final tr = Offset(size.width - inset, inset);
    final br = Offset(size.width - inset, size.height - inset);
    final bl = Offset(inset, size.height - inset);

    PencilDrawingUtils.drawPencilLine(
      canvas,
      tl,
      tr,
      color: strokeColor,
      strokeWidth: 1.6,
      overshoot: 1.8,
      seed: seed + 1,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      tr,
      br,
      color: strokeColor,
      strokeWidth: 1.6,
      overshoot: 1.8,
      seed: seed + 2,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      br,
      bl,
      color: strokeColor,
      strokeWidth: 1.6,
      overshoot: 1.8,
      seed: seed + 3,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      bl,
      tl,
      color: strokeColor,
      strokeWidth: 1.6,
      overshoot: 1.8,
      seed: seed + 4,
    );

    // 4. Draw pencily pips (1..6)
    final pipOffsets = _getPipOffsets(faceValue, size);
    final scale = size.width / 64.0;
    for (int i = 0; i < pipOffsets.length; i++) {
      _drawPencilPip(canvas, pipOffsets[i], scale);
    }
  }

  void _paintD8Octahedron(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    // 3D Octahedron (double square pyramid) projection:
    // Top apex, bottom apex, two front equatorial vertices (forming the upward
    // central triangle face where the rolled numeral sits), and two back/side
    // equatorial vertices (forming the side diamond wings).
    final top = Offset(w * 0.50, h * 0.04);
    final upperRight = Offset(w * 0.91, h * 0.35);
    final frontRight = Offset(w * 0.85, h * 0.65);
    final bottom = Offset(w * 0.50, h * 0.96);
    final frontLeft = Offset(w * 0.15, h * 0.65);
    final upperLeft = Offset(w * 0.09, h * 0.35);

    // Outer 6-vertex diamond crystal silhouette
    final outerPts = <Offset>[
      top,
      upperRight,
      frontRight,
      bottom,
      frontLeft,
      upperLeft,
    ];
    final outerPath = Path()..addPolygon(outerPts, true);

    // 1. Base paper fill for the octahedron
    final bgPaint = Paint()
      ..color = isHeld ? const Color(0xFFFFF9F2) : const Color(0xFFEEF5FA)
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, bgPaint);

    // Brighter highlight fill on the main front-facing equilateral triangle (top -> frontRight -> frontLeft)
    final mainFacePath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(frontRight.dx, frontRight.dy)
      ..lineTo(frontLeft.dx, frontLeft.dy)
      ..close();
    final mainFacePaint = Paint()
      ..color = isHeld ? const Color(0xFFFFFCF7) : const Color(0xFFF7FBFE)
      ..style = PaintingStyle.fill;
    canvas.drawPath(mainFacePath, mainFacePaint);

    // 2. 3D Facet pencil shading:
    // Left side facets (top -> frontLeft -> upperLeft and upperLeft -> frontLeft -> bottom)
    final leftFlankPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(frontLeft.dx, frontLeft.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(upperLeft.dx, upperLeft.dy)
      ..close();
    canvas.save();
    canvas.clipPath(leftFlankPath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: PencilPalette.bluePencil,
      spacing: 4.8,
      opacity: 0.12,
      seed: seed + 1,
    );
    canvas.restore();

    // Right side facets (top -> upperRight -> frontRight and frontRight -> upperRight -> bottom)
    final rightFlankPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(upperRight.dx, upperRight.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(frontRight.dx, frontRight.dy)
      ..close();
    canvas.save();
    canvas.clipPath(rightFlankPath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: PencilPalette.bluePencil,
      spacing: 4.2,
      opacity: 0.19,
      seed: seed + 2,
    );
    canvas.restore();

    // Bottom pyramid front facet (frontLeft -> frontRight -> bottom) - deeper shadow underneath equator
    final bottomFacetPath = Path()
      ..moveTo(frontLeft.dx, frontLeft.dy)
      ..lineTo(frontRight.dx, frontRight.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..close();
    canvas.save();
    canvas.clipPath(bottomFacetPath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: PencilPalette.bluePencil,
      spacing: 3.6,
      opacity: 0.25,
      seed: seed + 3,
    );
    canvas.restore();

    // 3. Hand-drawn outer octahedral silhouette edges
    final strokeColor =
        isHeld ? PencilPalette.redPencil : PencilPalette.bluePencil;
    for (int i = 0; i < outerPts.length; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        outerPts[i],
        outerPts[(i + 1) % outerPts.length],
        color: strokeColor,
        strokeWidth: 1.65,
        overshoot: 1.4,
        seed: seed + i + 10,
      );
    }

    // 4. Inner 3D octahedral ridge lines framing the central equilateral triangle face
    // Left ridge (top -> frontLeft)
    PencilDrawingUtils.drawPencilLine(
      canvas,
      top,
      frontLeft,
      color: strokeColor.withValues(alpha: 0.82),
      strokeWidth: 1.35,
      overshoot: 1.0,
      seed: seed + 16,
    );
    // Right ridge (top -> frontRight)
    PencilDrawingUtils.drawPencilLine(
      canvas,
      top,
      frontRight,
      color: strokeColor.withValues(alpha: 0.82),
      strokeWidth: 1.35,
      overshoot: 1.0,
      seed: seed + 17,
    );
    // Horizontal equatorial ridge (frontLeft -> frontRight)
    PencilDrawingUtils.drawPencilLine(
      canvas,
      frontLeft,
      frontRight,
      color: strokeColor.withValues(alpha: 0.88),
      strokeWidth: 1.45,
      overshoot: 1.0,
      seed: seed + 18,
    );

    // 5. Draw bold RPG numeral (1..8) centered inside the front equilateral triangle face
    _drawCenteredDieNumeral(
      canvas,
      size,
      strokeColor,
      fontSizeFactor: 0.42,
      yOffsetFactor: -0.06,
    );
  }

  void _paintD4Tetrahedron(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    // 3 vertices of a triangular pyramid (tetrahedron)
    final top = Offset(w * 0.5, h * 0.08);
    final bl = Offset(w * 0.08, h * 0.88);
    final br = Offset(w * 0.92, h * 0.88);
    final center = Offset(w * 0.5, h * 0.62);

    final polyPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();

    final bgPaint = Paint()
      ..color = isHeld ? const Color(0xFFFFF9F2) : const Color(0xFFF3FAF4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(polyPath, bgPaint);

    // Subtle shading on right facet
    final rightFacet = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.save();
    canvas.clipPath(rightFacet);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: PencilPalette.greenPencil,
      spacing: 4.5,
      opacity: 0.16,
      seed: seed,
    );
    canvas.restore();

    final strokeColor =
        isHeld ? PencilPalette.redPencil : PencilPalette.greenPencil;

    // Outer triangle outline
    final pts = [top, br, bl];
    for (int i = 0; i < 3; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        pts[i],
        pts[(i + 1) % 3],
        color: strokeColor,
        strokeWidth: 1.7,
        overshoot: 1.5,
        seed: seed + i + 20,
      );
    }

    // Inner ridge lines from center to vertices
    for (int i = 0; i < 3; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        center,
        pts[i],
        color: strokeColor.withValues(alpha: 0.55),
        strokeWidth: 1.1,
        overshoot: 0.8,
        seed: seed + i + 25,
      );
    }

    // Center numeral (1..4)
    _drawCenteredDieNumeral(
      canvas,
      size,
      strokeColor,
      fontSizeFactor: 0.44,
      yOffsetFactor: 0.10,
    );
  }

  void _paintD10Decahedron(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    // Kite crystal shape (decahedron)
    final top = Offset(w * 0.5, h * 0.05);
    final rightShoulder = Offset(w * 0.92, h * 0.38);
    final rightHip = Offset(w * 0.78, h * 0.72);
    final bottom = Offset(w * 0.5, h * 0.95);
    final leftHip = Offset(w * 0.22, h * 0.72);
    final leftShoulder = Offset(w * 0.08, h * 0.38);

    final pts = [
      top,
      rightShoulder,
      rightHip,
      bottom,
      leftHip,
      leftShoulder,
    ];
    final polyPath = Path()..addPolygon(pts, true);

    final bgPaint = Paint()
      ..color = isHeld ? const Color(0xFFFFF9F2) : const Color(0xFFF6F2FA)
      ..style = PaintingStyle.fill;
    canvas.drawPath(polyPath, bgPaint);

    // Shade lower half
    canvas.save();
    canvas.clipPath(polyPath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: const Color(0xFF5D467E),
      spacing: 4.5,
      opacity: 0.14,
      seed: seed,
    );
    canvas.restore();

    final strokeColor =
        isHeld ? PencilPalette.redPencil : const Color(0xFF4A356B);

    for (int i = 0; i < pts.length; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        pts[i],
        pts[(i + 1) % pts.length],
        color: strokeColor,
        strokeWidth: 1.6,
        overshoot: 1.3,
        seed: seed + i + 30,
      );
    }

    // Horizontal equatorial crystal ridge
    PencilDrawingUtils.drawPencilLine(
      canvas,
      leftShoulder,
      rightShoulder,
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.1,
      overshoot: 0.8,
      seed: seed + 38,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      top,
      bottom,
      color: strokeColor.withValues(alpha: 0.35),
      strokeWidth: 1.0,
      overshoot: 0.5,
      seed: seed + 39,
    );

    _drawCenteredDieNumeral(
      canvas,
      size,
      strokeColor,
      fontSizeFactor: 0.42,
    );
  }

  void _paintD12Dodecahedron(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;
    final rOuter = size.width * 0.46;
    final rInner = size.width * 0.25;

    final outerPts = <Offset>[];
    final innerPts = <Offset>[];
    for (int i = 0; i < 5; i++) {
      final angle = -pi / 2 + i * (2 * pi / 5);
      outerPts.add(Offset(cx + rOuter * cos(angle), cy + rOuter * sin(angle)));
      innerPts.add(Offset(cx + rInner * cos(angle), cy + rInner * sin(angle)));
    }

    final polyPath = Path()..addPolygon(outerPts, true);
    final bgPaint = Paint()
      ..color = isHeld ? const Color(0xFFFFF9F2) : const Color(0xFFFAF6EE)
      ..style = PaintingStyle.fill;
    canvas.drawPath(polyPath, bgPaint);

    canvas.save();
    canvas.clipPath(polyPath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: PencilPalette.graphiteMedium,
      spacing: 4.5,
      opacity: 0.14,
      seed: seed,
    );
    canvas.restore();

    final strokeColor =
        isHeld ? PencilPalette.redPencil : PencilPalette.graphiteDark;

    // Outer pentagon
    for (int i = 0; i < 5; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        outerPts[i],
        outerPts[(i + 1) % 5],
        color: strokeColor,
        strokeWidth: 1.6,
        overshoot: 1.3,
        seed: seed + i + 40,
      );
      // Inner pentagon
      PencilDrawingUtils.drawPencilLine(
        canvas,
        innerPts[i],
        innerPts[(i + 1) % 5],
        color: strokeColor.withValues(alpha: 0.5),
        strokeWidth: 1.1,
        overshoot: 0.8,
        seed: seed + i + 45,
      );
      // Radial strut
      PencilDrawingUtils.drawPencilLine(
        canvas,
        innerPts[i],
        outerPts[i],
        color: strokeColor.withValues(alpha: 0.45),
        strokeWidth: 1.0,
        overshoot: 0.5,
        seed: seed + i + 50,
      );
    }

    _drawCenteredDieNumeral(
      canvas,
      size,
      strokeColor,
      fontSizeFactor: 0.38,
    );
  }

  void _paintD20Icosahedron(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;
    final rOuter = size.width * 0.47;
    final rInner = size.width * 0.27;

    // Regular hexagon outer outline
    final outerPts = <Offset>[];
    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * (pi / 3);
      outerPts.add(Offset(cx + rOuter * cos(angle), cy + rOuter * sin(angle)));
    }

    // Equilateral inner triangle (pointing up)
    final triPts = <Offset>[
      Offset(cx, cy - rInner),
      Offset(cx + rInner * cos(pi / 6), cy + rInner * sin(pi / 6)),
      Offset(cx - rInner * cos(pi / 6), cy + rInner * sin(pi / 6)),
    ];

    final polyPath = Path()..addPolygon(outerPts, true);
    final isNat20 = faceValue == 20;
    final bgPaint = Paint()
      ..color = isHeld
          ? const Color(0xFFFFF9F2)
          : (isNat20 ? const Color(0xFFFFF7E2) : const Color(0xFFFAF2F3))
      ..style = PaintingStyle.fill;
    canvas.drawPath(polyPath, bgPaint);

    canvas.save();
    canvas.clipPath(polyPath);
    PencilDrawingUtils.drawPencilShading(
      canvas,
      rect,
      color: isNat20 ? const Color(0xFFD49E2A) : PencilPalette.redPencil,
      spacing: 4.5,
      opacity: isNat20 ? 0.22 : 0.12,
      seed: seed,
    );
    canvas.restore();

    final strokeColor =
        isHeld ? PencilPalette.redPencil : const Color(0xFF7B2B31);

    // Draw outer hexagon edges
    for (int i = 0; i < 6; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        outerPts[i],
        outerPts[(i + 1) % 6],
        color: strokeColor,
        strokeWidth: 1.65,
        overshoot: 1.4,
        seed: seed + i + 60,
      );
    }

    // Draw inner equilateral triangle
    for (int i = 0; i < 3; i++) {
      PencilDrawingUtils.drawPencilLine(
        canvas,
        triPts[i],
        triPts[(i + 1) % 3],
        color: strokeColor.withValues(alpha: 0.6),
        strokeWidth: 1.2,
        overshoot: 0.8,
        seed: seed + i + 66,
      );
    }

    // Struts connecting inner triangle to outer hexagon vertices
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[0],
      outerPts[0],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 70,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[0],
      outerPts[1],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 71,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[0],
      outerPts[5],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 72,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[1],
      outerPts[2],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 73,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[1],
      outerPts[3],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 74,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[2],
      outerPts[3],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 75,
    );
    PencilDrawingUtils.drawPencilLine(
      canvas,
      triPts[2],
      outerPts[4],
      color: strokeColor.withValues(alpha: 0.45),
      strokeWidth: 1.0,
      seed: seed + 76,
    );

    _drawCenteredDieNumeral(
      canvas,
      size,
      strokeColor,
      fontSizeFactor: faceValue >= 10 ? 0.36 : 0.42,
      yOffsetFactor: 0.04,
    );
  }

  void _drawCenteredDieNumeral(
    Canvas canvas,
    Size size,
    Color color, {
    double fontSizeFactor = 0.40,
    double yOffsetFactor = 0.0,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$faceValue',
        style: GoogleFonts.patrickHand(
          fontSize: (size.width * fontSizeFactor).clamp(13.0, 28.0),
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width * 0.5 - textPainter.width / 2,
        size.height * (0.5 + yOffsetFactor) - textPainter.height / 2,
      ),
    );
  }

  List<Offset> _getPipOffsets(int value, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final left = size.width * 0.27;
    final right = size.width * 0.73;
    final top = size.height * 0.29;
    final bottom = size.height * 0.73;

    switch (value) {
      case 1:
        return [Offset(cx, cy)];
      case 2:
        return [Offset(left, top), Offset(right, bottom)];
      case 3:
        return [Offset(left, top), Offset(cx, cy), Offset(right, bottom)];
      case 4:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      case 5:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(cx, cy),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      case 6:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(left, cy),
          Offset(right, cy),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      case 7:
        return [
          Offset(left, top),
          Offset(right, top),
          Offset(left, cy),
          Offset(cx, cy),
          Offset(right, cy),
          Offset(left, bottom),
          Offset(right, bottom),
        ];
      case 8:
        return [
          Offset(left, top),
          Offset(cx, top),
          Offset(right, top),
          Offset(left, cy),
          Offset(right, cy),
          Offset(left, bottom),
          Offset(cx, bottom),
          Offset(right, bottom),
        ];
      default:
        return [Offset(cx, cy)];
    }
  }

  void _drawPencilPip(
    Canvas canvas,
    Offset center,
    double scale, {
    Color color = PencilPalette.graphiteDark,
  }) {
    final radius = (faceValue == 1 ? 5.6 : 4.2) * scale;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.88)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2.0,
        height: radius * 1.85,
      ),
      fillPaint,
    );

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.0 * scale
      ..style = PaintingStyle.stroke;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 0.3 * scale, center.dy - 0.2 * scale),
        width: radius * 2.1,
        height: radius * 1.95,
      ),
      strokePaint,
    );

    final highlightPaint = Paint()
      ..color = PencilPalette.paperCard.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.22,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PencilDiePainter oldDelegate) =>
      oldDelegate.faceValue != faceValue ||
      oldDelegate.dieSides != dieSides ||
      oldDelegate.isHeld != isHeld ||
      oldDelegate.seed != seed;
}
