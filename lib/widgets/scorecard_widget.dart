import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/yatzy_models.dart';
import '../models/yatzy_strategy_solver.dart';
import 'pencil_painters.dart';

class PencilScorecardWidget extends StatefulWidget {
  final List<PlayerScorecard> players;
  final int activePlayerIndex;
  final int? lastScoredPlayerIndex;
  final YatzyCategory? lastScoredCategory;
  final List<int> currentDiceValues;
  final bool canAssignScore;
  final void Function(YatzyCategory category) onSelectCategory;
  final AppStrings strings;
  final YatzyGameRules rules;
  final TurnCoachAdvice? coachAdvice;

  const PencilScorecardWidget({
    super.key,
    required this.players,
    required this.activePlayerIndex,
    this.lastScoredPlayerIndex,
    this.lastScoredCategory,
    required this.currentDiceValues,
    required this.canAssignScore,
    required this.onSelectCategory,
    required this.strings,
    required this.rules,
    this.coachAdvice,
  });

  @override
  State<PencilScorecardWidget> createState() => _PencilScorecardWidgetState();
}

class _PencilScorecardWidgetState extends State<PencilScorecardWidget> {
  final ScrollController _horizontalScrollController = ScrollController();
  double _lastPlayerColWidth = 90.0;

  @override
  void didUpdateWidget(covariant PencilScorecardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activePlayerIndex != oldWidget.activePlayerIndex) {
      _scrollToActivePlayer();
    }
  }

  void _scrollToActivePlayer() {
    if (!_horizontalScrollController.hasClients) return;
    final targetOffset = (widget.activePlayerIndex * _lastPlayerColWidth) - 40.0;
    final clamped = targetOffset.clamp(
      0.0,
      _horizontalScrollController.position.maxScrollExtent,
    );
    _horizontalScrollController.animateTo(
      clamped,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PencilBox(
      borderColor: PencilPalette.graphiteDark,
      fillColor: PencilPalette.paperCard,
      strokeWidth: 1.8,
      overshoot: 3.5,
      seed: 105,
      doubleBorder: true,
      padding: const EdgeInsets.all(5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 560;
          final double categoryColWidth = isMobile ? 132.0 : 195.0;
          final double minPlayerColWidth = isMobile ? 78.0 : 94.0;
          final double rowHeight = isMobile ? 38.0 : 44.0;
          final double headerHeight = isMobile ? 48.0 : 54.0;
          final double bannerHeight = isMobile ? 26.0 : 28.0;
          final double subtotalHeight = isMobile ? 38.0 : 42.0;
          final double grandTotalHeight = isMobile ? 48.0 : 52.0;

          final availableRightWidth =
              (constraints.maxWidth - categoryColWidth - 4).clamp(
            minPlayerColWidth,
            double.infinity,
          );
          final double playerColWidth =
              (availableRightWidth / widget.players.length)
                  .clamp(minPlayerColWidth, double.infinity);
          _lastPlayerColWidth = playerColWidth;

          final double totalPlayersWidth =
              playerColWidth * widget.players.length;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sticky Left Column (Categories & Labels)
              SizedBox(
                width: categoryColWidth,
                child: _buildLeftCategoryColumn(
                  categoryColWidth: categoryColWidth,
                  isMobile: isMobile,
                  headerHeight: headerHeight,
                  bannerHeight: bannerHeight,
                  rowHeight: rowHeight,
                  subtotalHeight: subtotalHeight,
                  grandTotalHeight: grandTotalHeight,
                ),
              ),

              // Horizontally Scrollable Right Columns (Players 1..N)
              Expanded(
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalPlayersWidth,
                    child: _buildRightPlayerColumns(
                      playerColWidth: playerColWidth,
                      totalPlayersWidth: totalPlayersWidth,
                      isMobile: isMobile,
                      headerHeight: headerHeight,
                      bannerHeight: bannerHeight,
                      rowHeight: rowHeight,
                      subtotalHeight: subtotalHeight,
                      grandTotalHeight: grandTotalHeight,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeftCategoryColumn({
    required double categoryColWidth,
    required bool isMobile,
    required double headerHeight,
    required double bannerHeight,
    required double rowHeight,
    required double subtotalHeight,
    required double grandTotalHeight,
  }) {
    final s = widget.strings;
    final rules = widget.rules;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header cell
        Container(
          height: headerHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
          child: Text(
            s.scorecardTitle,
            style: GoogleFonts.patrickHand(
              fontSize: isMobile ? 16.5 : 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: PencilPalette.graphiteDark,
            ),
          ),
        ),
        _buildSketchyDivider(width: categoryColWidth, thickness: 2.0, seed: 11),

        // 2. Upper Section Banner Left
        Container(
          height: bannerHeight,
          width: categoryColWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.7),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
          child: Text(
            isMobile
                ? s.upperSectionBannerMobile
                : s.upperSectionBanner(rules.upperParCount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.patrickHand(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.bold,
              color: PencilPalette.graphiteMedium,
            ),
          ),
        ),
        _buildSketchyDivider(width: categoryColWidth, thickness: 1.2, seed: 12),

        // 3. Upper Categories
        for (final cat in rules.upperCategories) ...[
          _buildCategoryLabelCell(cat, categoryColWidth, rowHeight, isMobile),
          _buildSketchyDivider(
            width: categoryColWidth,
            thickness: 0.8,
            seed: 20 + cat.index,
            faint: true,
          ),
        ],

        // 4. Upper Subtotal (± sum)
        _buildSketchyDivider(width: categoryColWidth, thickness: 1.6, seed: 30),
        Container(
          height: subtotalHeight,
          width: categoryColWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.35),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.pointsAboveBonusTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.patrickHand(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: PencilPalette.graphiteDark,
                  height: 1.05,
                ),
              ),
              if (!isMobile)
                Text(
                  s.pointsAboveBonusSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.patrickHand(
                    fontSize: 11.5,
                    color: PencilPalette.graphiteMedium,
                    height: 1.0,
                  ),
                ),
            ],
          ),
        ),
        _buildSketchyDivider(
          width: categoryColWidth,
          thickness: 1.0,
          seed: 31,
          faint: true,
        ),

        // 5. Bonus Row (50p)
        Container(
          height: subtotalHeight,
          width: categoryColWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.35),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.upperBonusTitle(widget.rules.upperBonusPoints),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.patrickHand(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: PencilPalette.graphiteDark,
                  height: 1.05,
                ),
              ),
              if (!isMobile)
                Text(
                  s.upperBonusSub(widget.rules.upperBonusPoints),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.patrickHand(
                    fontSize: 11.5,
                    color: PencilPalette.graphiteMedium,
                    height: 1.0,
                  ),
                ),
            ],
          ),
        ),
        _buildSketchyDivider(width: categoryColWidth, thickness: 2.0, seed: 32),

        // 6. Lower Section Banner Left
        Container(
          height: bannerHeight,
          width: categoryColWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.7),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
          child: Text(
            isMobile
                ? s.lowerSectionBannerMobile
                : s.lowerSectionBanner(rules.diceCount, rules.dieSides),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.patrickHand(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.bold,
              color: PencilPalette.graphiteMedium,
            ),
          ),
        ),
        _buildSketchyDivider(width: categoryColWidth, thickness: 1.2, seed: 33),

        // 7. Lower Categories
        for (final cat in rules.lowerCategories) ...[
          _buildCategoryLabelCell(cat, categoryColWidth, rowHeight, isMobile),
          _buildSketchyDivider(
            width: categoryColWidth,
            thickness: 0.8,
            seed: 40 + cat.index,
            faint: true,
          ),
        ],

        // 8. Grand Total Left
        _buildSketchyDivider(width: categoryColWidth, thickness: 2.2, seed: 90),
        Container(
          height: grandTotalHeight,
          width: categoryColWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.grandTotalTitle,
                style: GoogleFonts.patrickHand(
                  fontSize: isMobile ? 16 : 18.5,
                  fontWeight: FontWeight.bold,
                  color: PencilPalette.graphiteDark,
                  height: 1.05,
                ),
              ),
              Text(
                s.grandTotalSub(rules.upperParTotal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.patrickHand(
                  fontSize: isMobile ? 10.5 : 11.5,
                  color: PencilPalette.graphiteMedium,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightPlayerColumns({
    required double playerColWidth,
    required double totalPlayersWidth,
    required bool isMobile,
    required double headerHeight,
    required double bannerHeight,
    required double rowHeight,
    required double subtotalHeight,
    required double grandTotalHeight,
  }) {
    final s = widget.strings;
    final rules = widget.rules;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header Row for Players
        SizedBox(
          height: headerHeight,
          child: Row(
            children: [
              for (int i = 0; i < widget.players.length; i++)
                _buildPlayerHeaderCell(i, playerColWidth, headerHeight, isMobile),
            ],
          ),
        ),
        _buildSketchyDivider(width: totalPlayersWidth, thickness: 2.0, seed: 11),

        // 2. Upper Section Banner Right
        Container(
          height: bannerHeight,
          width: totalPlayersWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.7),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            isMobile ? s.upperSectionBanner(rules.upperParCount) : '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.patrickHand(
              fontSize: 11.5,
              color: PencilPalette.graphiteMedium,
            ),
          ),
        ),
        _buildSketchyDivider(width: totalPlayersWidth, thickness: 1.2, seed: 12),

        // 3. Upper Category Score Cells
        for (final cat in rules.upperCategories) ...[
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                for (int i = 0; i < widget.players.length; i++)
                  _buildScoreCell(cat, i, playerColWidth, rowHeight, isMobile),
              ],
            ),
          ),
          _buildSketchyDivider(
            width: totalPlayersWidth,
            thickness: 0.8,
            seed: 20 + cat.index,
            faint: true,
          ),
        ],

        // 4. Upper Subtotal (± sum) Cells
        _buildSketchyDivider(width: totalPlayersWidth, thickness: 1.6, seed: 30),
        Container(
          height: subtotalHeight,
          color: PencilPalette.paperDarker.withValues(alpha: 0.35),
          child: Row(
            children: [
              for (int i = 0; i < widget.players.length; i++)
                _buildUpperDiffPlayerCell(
                  widget.players[i],
                  i == widget.activePlayerIndex,
                  playerColWidth,
                  subtotalHeight,
                ),
            ],
          ),
        ),
        _buildSketchyDivider(
          width: totalPlayersWidth,
          thickness: 1.0,
          seed: 31,
          faint: true,
        ),

        // 5. Bonus Row Cells
        Container(
          height: subtotalHeight,
          color: PencilPalette.paperDarker.withValues(alpha: 0.35),
          child: Row(
            children: [
              for (int i = 0; i < widget.players.length; i++)
                _buildBonusPlayerCell(
                  widget.players[i],
                  i == widget.activePlayerIndex,
                  playerColWidth,
                  subtotalHeight,
                ),
            ],
          ),
        ),
        _buildSketchyDivider(width: totalPlayersWidth, thickness: 2.0, seed: 32),

        // 6. Lower Section Banner Right
        Container(
          height: bannerHeight,
          width: totalPlayersWidth,
          color: PencilPalette.paperDarker.withValues(alpha: 0.7),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            isMobile
                ? s.lowerSectionBanner(rules.diceCount, rules.dieSides)
                : '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.patrickHand(
              fontSize: 11.5,
              color: PencilPalette.graphiteMedium,
            ),
          ),
        ),
        _buildSketchyDivider(width: totalPlayersWidth, thickness: 1.2, seed: 33),

        // 7. Lower Category Score Cells
        for (final cat in rules.lowerCategories) ...[
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                for (int i = 0; i < widget.players.length; i++)
                  _buildScoreCell(cat, i, playerColWidth, rowHeight, isMobile),
              ],
            ),
          ),
          _buildSketchyDivider(
            width: totalPlayersWidth,
            thickness: 0.8,
            seed: 40 + cat.index,
            faint: true,
          ),
        ],

        // 8. Grand Total Right Cells
        _buildSketchyDivider(width: totalPlayersWidth, thickness: 2.2, seed: 90),
        Container(
          height: grandTotalHeight,
          color: PencilPalette.paperDarker.withValues(alpha: 0.8),
          child: Row(
            children: [
              for (int i = 0; i < widget.players.length; i++)
                _buildGrandTotalPlayerCell(
                  widget.players[i],
                  i == widget.activePlayerIndex,
                  playerColWidth,
                  grandTotalHeight,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryLabelCell(
    YatzyCategory category,
    double width,
    double height,
    bool isMobile,
  ) {
    final s = widget.strings;
    final label = s.categoryLabel(category, rules: widget.rules);
    final desc = s.categoryDescription(
      category,
      upperParCount: widget.rules.upperParCount,
      diceCount: widget.rules.diceCount,
      rules: widget.rules,
    );

    return Tooltip(
      message: desc,
      waitDuration: const Duration(milliseconds: 250),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.patrickHand(
                fontSize: isMobile ? 15 : 17,
                fontWeight: FontWeight.bold,
                color: PencilPalette.graphiteDark,
                height: 1.05,
              ),
            ),
            if (!isMobile)
              Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.patrickHand(
                  fontSize: 11.5,
                  color: PencilPalette.graphiteLight,
                  height: 1.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHeaderCell(
    int playerIdx,
    double width,
    double height,
    bool isMobile,
  ) {
    final player = widget.players[playerIdx];
    final isActive = playerIdx == widget.activePlayerIndex;
    final totalCats = widget.rules.activeCategories.length;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? PencilPalette.yellowHighlighter : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive)
                const Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.edit,
                    size: 13,
                    color: PencilPalette.redPencil,
                  ),
                ),
              Flexible(
                child: Text(
                  player.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.patrickHand(
                    fontSize: isMobile ? 15.5 : 18,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? PencilPalette.graphiteDark
                        : PencilPalette.graphiteMedium,
                    height: 1.05,
                  ),
                ),
              ),
            ],
          ),
          Text(
            widget.strings.filledCount(player.scores.length, totalCats),
            style: GoogleFonts.patrickHand(
              fontSize: 11,
              color: PencilPalette.graphiteLight,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCell(
    YatzyCategory category,
    int playerIdx,
    double width,
    double height,
    bool isMobile,
  ) {
    final player = widget.players[playerIdx];
    final isActivePlayer = playerIdx == widget.activePlayerIndex;
    final isFilled = player.isFilled(category);

    if (isFilled) {
      final score = player.scores[category]!;
      final formatted = YatzyScorer.formatScore(category, score);
      final isLastScored = playerIdx == widget.lastScoredPlayerIndex &&
          category == widget.lastScoredCategory;

      Color textColor = PencilPalette.graphiteDark;
      if (isLastScored) {
        textColor = PencilPalette.greenPencil;
      } else if (category.isUpper) {
        if (score > 0) {
          textColor = PencilPalette.greenPencil;
        } else if (score < 0) {
          textColor = PencilPalette.redPencil;
        }
      } else if (score == 0) {
        textColor = PencilPalette.graphiteLight;
      }

      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLastScored
              ? const Color(0xFFDDF5E3)
              : (isActivePlayer
                  ? PencilPalette.yellowHighlighter.withValues(alpha: 0.12)
                  : Colors.transparent),
          border: Border(
            left: BorderSide(
              color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
              width: 1.0,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (isLastScored)
              Positioned(
                left: 6,
                right: 6,
                top: 3,
                bottom: 3,
                child: CustomPaint(
                  painter: PencilCirclePainter(
                    color: PencilPalette.greenPencil,
                    strokeWidth: 2.2,
                    seed: category.index * 17 + playerIdx * 5,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatted,
                  style: GoogleFonts.patrickHand(
                    fontSize: isLastScored
                        ? (isMobile ? 19.5 : 22)
                        : (isMobile ? 18 : 20),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (isLastScored) ...[
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 13,
                    color: PencilPalette.greenPencil,
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    }

    // Open cell for active player
    if (isActivePlayer && widget.canAssignScore) {
      final previewScore = YatzyScorer.calculateScore(
        category,
        widget.currentDiceValues,
        upperParCount: widget.rules.upperParCount,
        region: widget.rules.region,
        rules: widget.rules,
      );
      final formattedPreview = YatzyScorer.formatScore(category, previewScore);
      final isPositivePreview =
          category.isUpper ? previewScore >= 0 : previewScore > 0;

      final isCoachRecommended = widget.coachAdvice != null &&
          widget.coachAdvice!.categoryRankings.isNotEmpty &&
          widget.coachAdvice!.bestCategoryNow.category == category;

      return _InteractivePreviewCell(
        key: Key('open_cell_${category.name}_$playerIdx'),
        width: width,
        height: height,
        formattedPreview: formattedPreview,
        isPositivePreview: isPositivePreview,
        isUpper: category.isUpper,
        previewScore: previewScore,
        isCoachRecommended: isCoachRecommended,
        onTap: () => widget.onSelectCategory(category),
      );
    }

    // Empty cell for inactive player
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        '·',
        style: GoogleFonts.patrickHand(
          fontSize: 18,
          color: PencilPalette.graphiteFaint,
        ),
      ),
    );
  }

  Widget _buildUpperDiffPlayerCell(
    PlayerScorecard player,
    bool isActive,
    double width,
    double height,
  ) {
    final diff = player.upperDiffSum;
    final formatted = diff > 0 ? '+$diff' : '$diff';
    Color color = PencilPalette.graphiteDark;
    if (diff > 0) color = PencilPalette.greenPencil;
    if (diff < 0) color = PencilPalette.redPencil;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive
            ? PencilPalette.yellowHighlighter.withValues(alpha: 0.18)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatted,
            style: GoogleFonts.patrickHand(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 3),
          if (player.filledUpperCount > 0)
            Icon(
              diff >= 0
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_rounded,
              size: 13,
              color: color.withValues(alpha: 0.75),
            ),
        ],
      ),
    );
  }

  Widget _buildBonusPlayerCell(
    PlayerScorecard player,
    bool isActive,
    double width,
    double height,
  ) {
    final earned = player.hasEarnedBonus;
    final allUpperFilled =
        player.filledUpperCount == widget.rules.upperCategories.length;

    final text = widget.strings.bonusStatusText(
      earned: earned,
      allUpperFilled: allUpperFilled,
      canStillEarn: player.canStillEarnBonus,
      upperDiffSum: player.upperDiffSum,
      bonusPoints: widget.rules.upperBonusPoints,
    );

    Color textColor;
    if (earned) {
      textColor = PencilPalette.greenPencil;
    } else if (allUpperFilled || !player.canStillEarnBonus) {
      textColor = PencilPalette.graphiteLight;
    } else {
      textColor = PencilPalette.graphiteMedium;
    }

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive
            ? PencilPalette.yellowHighlighter.withValues(alpha: 0.18)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.patrickHand(
          fontSize: earned ? 18 : 13,
          fontWeight: earned ? FontWeight.bold : FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildGrandTotalPlayerCell(
    PlayerScorecard player,
    bool isActive,
    double width,
    double height,
  ) {
    final diffStr = player.upperDiffSum >= 0
        ? '+${player.upperDiffSum}'
        : '${player.upperDiffSum}';
    final tooltipText = widget.strings.grandTotalTooltip(
      parTotal: widget.rules.upperParTotal,
      allUpperFilled:
          player.filledUpperCount == widget.rules.upperCategories.length,
      diffStr: diffStr,
      rawUpperPoints: player.rawUpperPoints,
      bonusPoints: player.bonusPoints,
      lowerSum: player.lowerSectionSum,
      grandTotal: player.grandTotal,
    );

    return Tooltip(
      message: tooltipText,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? PencilPalette.yellowHighlighter.withValues(alpha: 0.35)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${player.grandTotal}',
              style: GoogleFonts.patrickHand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: PencilPalette.bluePencil,
                height: 1.0,
              ),
            ),
            if (player.filledUpperCount < 6 && player.scores.isNotEmpty)
              Text(
                'par ${widget.rules.upperParTotal}: ${player.formulaGrandTotal}',
                style: GoogleFonts.patrickHand(
                  fontSize: 10.5,
                  color: PencilPalette.graphiteMedium,
                  height: 1.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSketchyDivider({
    required double width,
    required double thickness,
    required int seed,
    bool faint = false,
  }) {
    return SizedBox(
      height: thickness + 2,
      width: width,
      child: CustomPaint(
        painter: _HorizontalPencilDividerPainter(
          strokeWidth: thickness,
          color: faint
              ? PencilPalette.graphiteFaint.withValues(alpha: 0.55)
              : PencilPalette.graphiteDark,
          seed: seed,
          doubleStroke: !faint && thickness >= 1.5,
        ),
      ),
    );
  }
}

class _HorizontalPencilDividerPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final int seed;
  final bool doubleStroke;

  const _HorizontalPencilDividerPainter({
    required this.strokeWidth,
    required this.color,
    required this.seed,
    required this.doubleStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    PencilDrawingUtils.drawPencilLine(
      canvas,
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      color: color,
      strokeWidth: strokeWidth,
      overshoot: 1.5,
      seed: seed,
      doubleStroke: doubleStroke,
    );
  }

  @override
  bool shouldRepaint(covariant _HorizontalPencilDividerPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.color != color ||
      oldDelegate.seed != seed;
}

class _InteractivePreviewCell extends StatefulWidget {
  final double width;
  final double height;
  final String formattedPreview;
  final bool isPositivePreview;
  final bool isUpper;
  final int previewScore;
  final bool isCoachRecommended;
  final VoidCallback onTap;

  const _InteractivePreviewCell({
    super.key,
    required this.width,
    required this.height,
    required this.formattedPreview,
    required this.isPositivePreview,
    required this.isUpper,
    required this.previewScore,
    this.isCoachRecommended = false,
    required this.onTap,
  });

  @override
  State<_InteractivePreviewCell> createState() =>
      _InteractivePreviewCellState();
}

class _InteractivePreviewCellState extends State<_InteractivePreviewCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color previewColor = PencilPalette.graphiteLight;
    if (_isHovered) {
      previewColor = PencilPalette.bluePencil;
    } else if (widget.isCoachRecommended) {
      previewColor = PencilPalette.greenPencil;
    } else if (widget.isUpper) {
      if (widget.previewScore > 0) {
        previewColor = PencilPalette.greenPencil.withValues(alpha: 0.65);
      } else if (widget.previewScore < 0) {
        previewColor = PencilPalette.redPencil.withValues(alpha: 0.6);
      } else {
        previewColor = PencilPalette.graphiteMedium.withValues(alpha: 0.65);
      }
    } else if (widget.previewScore > 0) {
      previewColor = PencilPalette.bluePencil.withValues(alpha: 0.65);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isHovered
                ? PencilPalette.yellowHighlighter.withValues(alpha: 0.55)
                : (widget.isCoachRecommended
                    ? const Color(0xFFE5F6E8)
                    : PencilPalette.yellowHighlighter.withValues(alpha: 0.18)),
            border: Border(
              left: BorderSide(
                color: PencilPalette.graphiteFaint.withValues(alpha: 0.6),
                width: 1.0,
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isHovered || widget.isCoachRecommended)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: CustomPaint(
                      painter: PencilBoxPainter(
                        borderColor: _isHovered
                            ? PencilPalette.bluePencil
                            : PencilPalette.greenPencil,
                        strokeWidth: _isHovered ? 1.2 : 1.4,
                        overshoot: 1.2,
                        seed: 88,
                      ),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isCoachRecommended) ...[
                    const Text(
                      '★',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: PencilPalette.greenPencil,
                      ),
                    ),
                    const SizedBox(width: 2),
                  ],
                  Text(
                    widget.formattedPreview,
                    style: GoogleFonts.patrickHand(
                      fontSize: _isHovered ? 19 : 17.5,
                      fontWeight: (_isHovered || widget.isCoachRecommended)
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontStyle: (_isHovered || widget.isCoachRecommended)
                          ? FontStyle.normal
                          : FontStyle.italic,
                      color: previewColor,
                    ),
                  ),
                  if (_isHovered) ...[
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.check,
                      size: 13,
                      color: PencilPalette.bluePencil,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
