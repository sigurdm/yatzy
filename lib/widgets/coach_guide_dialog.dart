import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/yatzy_models.dart';
import '../models/yatzy_strategy_solver.dart';
import 'pencil_painters.dart';

class CoachGuideDialog extends StatelessWidget {
  final AppStrings strings;
  final YatzyGameRules rules;
  final TurnCoachAdvice? currentAdvice;
  final ValueChanged<List<int>>? onSelectHoldIndices;

  const CoachGuideDialog({
    super.key,
    required this.strings,
    required this.rules,
    this.currentAdvice,
    this.onSelectHoldIndices,
  });

  static Future<void> show(
    BuildContext context, {
    required AppStrings strings,
    required YatzyGameRules rules,
    TurnCoachAdvice? currentAdvice,
    ValueChanged<List<int>>? onSelectHoldIndices,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => CoachGuideDialog(
        strings: strings,
        rules: rules,
        currentAdvice: currentAdvice,
        onSelectHoldIndices: onSelectHoldIndices,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = strings;
    final sections = s.coachGuideSections(rules);
    final advice = currentAdvice;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 740),
        child: PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperBg,
          hasPencilShading: true,
          shadingOpacity: 0.08,
          strokeWidth: 2.0,
          seed: 941,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.psychology_alt_rounded,
                    color: PencilPalette.greenPencil,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.coachGuideTitle,
                          style: GoogleFonts.patrickHand(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: PencilPalette.graphiteDark,
                            height: 1.05,
                          ),
                        ),
                        Text(
                          s.coachGuideSubtitle,
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            color: PencilPalette.graphiteMedium,
                            height: 1.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: PencilPalette.graphiteDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Highlighted Mathematical Formula Banner
              PencilBox(
                borderColor: PencilPalette.greenPencil,
                fillColor: const Color(0xFFF3FAEB),
                strokeWidth: 1.4,
                seed: 942,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Strategic EV(c)  =  Raw Points(c)  −  Opportunity Cost(c)  +  Δ Upper Bonus EV(c)',
                      style: GoogleFonts.patrickHand(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: PencilPalette.greenPencil,
                      ),
                    ),
                    if (advice != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        'Upper Bonus (+${rules.upperBonusPoints}p) Probability right now: ${(advice.currentBonusProbability * 100).toStringAsFixed(1)}%',
                        style: GoogleFonts.patrickHand(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.bluePencil,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Scrollable body with Live Comparison Tables + 4 Explanatory Sections
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (advice != null) ...[
                        Text(
                          s.coachLiveTableTitle,
                          style: GoogleFonts.patrickHand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: PencilPalette.bluePencil,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (advice.holdAlternatives.isNotEmpty) ...[
                          _buildHoldAlternativesTable(context, advice, s),
                          const SizedBox(height: 10),
                        ],
                        if (advice.categoryRankings.isNotEmpty) ...[
                          _buildCategoryRankingsTable(advice, s),
                          const SizedBox(height: 14),
                        ],
                        const Divider(color: PencilPalette.graphiteFaint),
                        const SizedBox(height: 6),
                      ],

                      for (final sec in sections) ...[
                        Text(
                          sec.title,
                          style: GoogleFonts.patrickHand(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            color: PencilPalette.bluePencil,
                          ),
                        ),
                        const SizedBox(height: 4),
                        for (final bullet in sec.bullets)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6,
                              bottom: 5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: GoogleFonts.patrickHand(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold,
                                    color: PencilPalette.greenPencil,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    bullet,
                                    style: GoogleFonts.patrickHand(
                                      fontSize: 15.0,
                                      color: PencilPalette.graphiteDark,
                                      height: 1.18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: PencilBox(
                    borderColor: PencilPalette.bluePencil,
                    fillColor: const Color(0xFFEAF2F8),
                    strokeWidth: 1.6,
                    seed: 949,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    child: Text(
                      s.inspectScorecard,
                      style: GoogleFonts.patrickHand(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: PencilPalette.bluePencil,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoldAlternativesTable(
    BuildContext context,
    TurnCoachAdvice advice,
    AppStrings s,
  ) {
    final topHolds = advice.holdAlternatives.take(5).toList();
    final bestStrat = topHolds.first.expectedStrategicValue;

    return PencilBox(
      borderColor: PencilPalette.bluePencil,
      fillColor: PencilPalette.paperCard,
      strokeWidth: 1.2,
      seed: 945,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.coachHoldAlternativesLabel,
            style: GoogleFonts.patrickHand(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: PencilPalette.graphiteDark,
            ),
          ),
          const SizedBox(height: 4),
          for (int i = 0; i < topHolds.length; i++)
            Builder(
              builder: (context) {
                final h = topHolds[i];
                final isBest = i == 0;
                final delta = h.expectedStrategicValue - bestStrat;
                final deltaStr =
                    isBest ? '★ BEST' : '${delta.toStringAsFixed(1)} EV';
                final holdDesc = s.coachFormatHoldShort(
                  h.heldFaces,
                  rules.diceCount,
                );
                final stratSign = h.expectedStrategicValue >= 0 ? '+' : '';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          isBest ? '★ #1' : '#${i + 1}',
                          style: GoogleFonts.patrickHand(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isBest
                                ? PencilPalette.greenPencil
                                : PencilPalette.graphiteMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          holdDesc,
                          style: GoogleFonts.patrickHand(
                            fontSize: 14.5,
                            fontWeight:
                                isBest ? FontWeight.bold : FontWeight.normal,
                            color: PencilPalette.graphiteDark,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '~${h.expectedTurnPoints.toStringAsFixed(1)}p',
                          style: GoogleFonts.patrickHand(
                            fontSize: 14,
                            color: PencilPalette.bluePencil,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'EV: $stratSign${h.expectedStrategicValue.toStringAsFixed(1)}',
                          style: GoogleFonts.patrickHand(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isBest
                                ? PencilPalette.greenPencil
                                : PencilPalette.graphiteDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 68,
                        child: Text(
                          deltaStr,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isBest
                                ? PencilPalette.greenPencil
                                : PencilPalette.redPencil,
                          ),
                        ),
                      ),
                      if (onSelectHoldIndices != null) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            onSelectHoldIndices!(h.holdIndices);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: PencilPalette.yellowHighlighter.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: PencilPalette.bluePencil,
                                width: 0.9,
                              ),
                            ),
                            child: Text(
                              'Use',
                              style: GoogleFonts.patrickHand(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: PencilPalette.bluePencil,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryRankingsTable(TurnCoachAdvice advice, AppStrings s) {
    final rankings = advice.categoryRankings;
    final bestVal = rankings.first.strategicNetValue;

    return PencilBox(
      borderColor: PencilPalette.graphiteMedium,
      fillColor: PencilPalette.paperCard,
      strokeWidth: 1.2,
      seed: 946,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  s.coachCategoryAlternativesLabel,
                  style: GoogleFonts.patrickHand(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteDark,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Score (Raw)',
                  style: GoogleFonts.patrickHand(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Opp. Cost',
                  style: GoogleFonts.patrickHand(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Bonus Δ',
                  style: GoogleFonts.patrickHand(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Net EV (Δ)',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.patrickHand(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteDark,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: PencilPalette.graphiteFaint, height: 8),
          for (int i = 0; i < rankings.length; i++)
            Builder(
              builder: (context) {
                final eval = rankings[i];
                final isBest = i == 0;
                final delta = eval.strategicNetValue - bestVal;
                final catName = s.categoryLabel(eval.category, rules: rules);
                final scoreStr = YatzyScorer.formatScore(
                  eval.category,
                  eval.immediateScore,
                );
                final bonusSign = eval.bonusEvDelta >= 0 ? '+' : '';
                final netSign = eval.strategicNetValue >= 0 ? '+' : '';
                final deltaStr =
                    isBest ? '★' : '(${delta.toStringAsFixed(1)})';

                return Container(
                  color: isBest
                      ? const Color(0xFFEAF6EC)
                      : (i % 2 == 1
                          ? PencilPalette.paperDarker.withValues(alpha: 0.25)
                          : Colors.transparent),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.5,
                    horizontal: 3,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${isBest ? "★ " : ""}${i + 1}. $catName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.patrickHand(
                            fontSize: 14.0,
                            fontWeight:
                                isBest ? FontWeight.bold : FontWeight.normal,
                            color: isBest
                                ? PencilPalette.greenPencil
                                : PencilPalette.graphiteDark,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '$scoreStr (${eval.rawPointsContribution}p)',
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            color: PencilPalette.graphiteDark,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '-${eval.expectedFuturePoints.toStringAsFixed(1)}p',
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            color: PencilPalette.graphiteMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          eval.bonusEvDelta.abs() < 0.05
                              ? '—'
                              : '$bonusSign${eval.bonusEvDelta.toStringAsFixed(1)}p',
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            fontWeight: eval.bonusEvDelta.abs() >= 1.0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: eval.bonusEvDelta > 0
                                ? PencilPalette.greenPencil
                                : (eval.bonusEvDelta < 0
                                    ? PencilPalette.redPencil
                                    : PencilPalette.graphiteLight),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '$netSign${eval.strategicNetValue.toStringAsFixed(1)} $deltaStr',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            fontWeight:
                                isBest ? FontWeight.bold : FontWeight.w600,
                            color: isBest
                                ? PencilPalette.greenPencil
                                : (delta > -3.0
                                    ? PencilPalette.bluePencil
                                    : PencilPalette.graphiteMedium),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
