import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'l10n/app_strings.dart';
import 'models/yatzy_models.dart';
import 'models/yatzy_strategy_solver.dart';
import 'widgets/coach_guide_dialog.dart';
import 'widgets/game_over_dialog.dart';
import 'widgets/game_variant_picker_dialog.dart';
import 'widgets/language_selector_dialog.dart';
import 'widgets/pencil_die_widget.dart';
import 'widgets/pencil_painters.dart';
import 'widgets/player_setup_dialog.dart';
import 'widgets/rules_dialog.dart';
import 'widgets/score_celebration_overlay.dart';
import 'widgets/scorecard_widget.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const PencilyYatzyApp());
}

class PencilyYatzyApp extends StatelessWidget {
  const PencilyYatzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatzy (N-Spillere • 5, 6, 7 & d8 Terninger)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: PencilPalette.paperBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PencilPalette.bluePencil,
          surface: PencilPalette.paperBg,
        ),
        textTheme: GoogleFonts.patrickHandTextTheme(),
        useMaterial3: true,
      ),
      home: const YatzyGameScreen(),
    );
  }
}

class YatzyGameScreen extends StatefulWidget {
  const YatzyGameScreen({super.key});

  @override
  State<YatzyGameScreen> createState() => _YatzyGameScreenState();
}

class _YatzyGameScreenState extends State<YatzyGameScreen> {
  final Random _rng = Random();

  AppLocale _locale = AppLocale.da;
  AppStrings get _strings => AppStrings(_locale);

  YatzyGameRules _rules = const YatzyGameRules(
    variant: YatzyGameVariant.classic5Dice,
    diceCount: 5,
    dieSides: 6,
    maxRolls: 3,
    upperParCount: 3,
  );

  List<PlayerScorecard> _players = [];
  int _activePlayerIndex = 0;

  List<DieState> _dice = [];
  int _rollsUsed = 0;
  bool _isRolling = false;
  bool _coachModeEnabled = false;

  int? _lastScoredPlayerIndex;
  YatzyCategory? _lastScoredCategory;
  ScoreCelebrationEvent? _lastScoreCelebration;
  int _celebrationEventCounter = 0;

  final List<TurnUndoSnapshot> _undoStack = [];

  @override
  void initState() {
    super.initState();
    _initNewGame(['Spiller 1', 'Spiller 2'], _rules);
  }

  void _setLocale(AppLocale newLocale) {
    if (_locale == newLocale) return;
    setState(() {
      final oldStrings = _strings;
      _locale = newLocale;
      final newStrings = _strings;

      for (int i = 0; i < _players.length; i++) {
        if (oldStrings.isDefaultPlayerName(_players[i].name, i)) {
          _players[i].name = newStrings.defaultPlayerName(i);
        }
      }
    });
  }

  void _openLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => LanguageSelectorDialog(
        currentLocale: _locale,
        onSelectLocale: _setLocale,
        strings: _strings,
      ),
    );
  }

  /// Opens a dropdown dialog listing all 6 Yatzy game variants with explanations.
  Future<void> _openGameVariantDropdown() async {
    final chosen = await GameVariantPickerDialog.show(
      context,
      currentVariant: _rules.variant,
      strings: _strings,
    );
    if (chosen != null && chosen != _rules.variant) {
      final nextRules = YatzyGameRules.fromVariant(chosen);
      _initNewGame(_players.map((p) => p.name).toList(), nextRules);
    }
  }

  void _initNewGame(List<String> playerNames, YatzyGameRules rules) {
    setState(() {
      _rules = rules;
      _players = [
        for (int i = 0; i < playerNames.length; i++)
          PlayerScorecard(
            id: 'player_$i',
            name: playerNames[i],
            rules: rules,
          ),
      ];
      _activePlayerIndex = 0;
      _lastScoredPlayerIndex = null;
      _lastScoredCategory = null;
      _lastScoreCelebration = null;
      _undoStack.clear();
      _startTurnWithAutoRoll(animate: false);
    });
  }

  /// Performs Roll 1 at the start of a brand-new game.
  void _startTurnWithAutoRoll({bool animate = true}) {
    final count = _rules.diceCount;
    final sides = _rules.dieSides;
    final rolledDice = List<DieState>.generate(
      count,
      (i) => DieState(
        value: _rng.nextInt(sides) + 1,
        isHeld: false,
        wobbleAngle: (_rng.nextDouble() - 0.5) * 0.14,
      ),
    );

    if (!animate) {
      setState(() {
        _dice = rolledDice;
        _rollsUsed = 1;
        _isRolling = false;
      });
      return;
    }

    setState(() {
      _dice = List<DieState>.generate(
        count,
        (i) => (i < _dice.length ? _dice[i] : rolledDice[i])
            .copyWith(isHeld: false),
      );
      _isRolling = true;
      _rollsUsed = 1;
    });

    Timer(const Duration(milliseconds: 360), () {
      if (!mounted) return;
      setState(() {
        _dice = rolledDice;
        _isRolling = false;
      });
    });
  }

  /// Rolls unheld dice (or rolls all dice if `_rollsUsed == 0` at start of turn).
  /// Also clears `_lastScoredPlayerIndex` / `_lastScoredCategory` once the dice are rolled!
  void _rollUnheldDice() {
    if (_isRolling || _rollsUsed >= _rules.maxRolls) return;

    final isFirstRollOfTurn = _rollsUsed == 0;
    final hasUnheld = isFirstRollOfTurn || _dice.any((d) => !d.isHeld);
    if (!hasUnheld) return;

    final sides = _rules.dieSides;

    setState(() {
      _isRolling = true;
      // Clear the previous turn's highlighted score once the new dice roll begins!
      _lastScoredPlayerIndex = null;
      _lastScoredCategory = null;
      _lastScoreCelebration = null;
    });

    Timer(const Duration(milliseconds: 360), () {
      if (!mounted) return;
      setState(() {
        _dice = [
          for (final d in _dice)
            (!isFirstRollOfTurn && d.isHeld)
                ? d
                : DieState(
                    value: _rng.nextInt(sides) + 1,
                    isHeld: false,
                    wobbleAngle: (_rng.nextDouble() - 0.5) * 0.14,
                  ),
        ];
        _rollsUsed += 1;
        _isRolling = false;
      });
    });
  }

  void _toggleDieHold(int dieIndex) {
    if (_isRolling || _rollsUsed == 0) return;
    setState(() {
      final current = _dice[dieIndex];
      _dice[dieIndex] = current.copyWith(
        isHeld: !current.isHeld,
        wobbleAngle: (_rng.nextDouble() - 0.5) * 0.12,
      );
    });
  }

  void _toggleHoldAll() {
    if (_isRolling || _rollsUsed == 0) return;
    final allHeld = _dice.every((d) => d.isHeld);
    setState(() {
      _dice = [
        for (final d in _dice) d.copyWith(isHeld: !allHeld),
      ];
    });
  }

  void _toggleCoachMode() {
    setState(() {
      _coachModeEnabled = !_coachModeEnabled;
    });
  }

  void _applyOptimalHold(List<int> holdIndices) {
    if (_isRolling || _rollsUsed == 0) return;
    final holdSet = holdIndices.toSet();
    setState(() {
      _dice = [
        for (int i = 0; i < _dice.length; i++)
          _dice[i].copyWith(isHeld: holdSet.contains(i)),
      ];
    });
  }

  void _assignCategoryScore(YatzyCategory category) {
    if (_isRolling || _rollsUsed == 0) return;
    final currentPlayer = _players[_activePlayerIndex];
    if (currentPlayer.isFilled(category)) return;

    final diceValues = _dice.map((d) => d.value).toList();
    final score = YatzyScorer.calculateScore(
      category,
      diceValues,
      upperParCount: _rules.upperParCount,
      region: _rules.region,
      rules: _rules,
    );

    final scoredPlayerIdx = _activePlayerIndex;
    final hadBonusBefore = currentPlayer.hasEarnedBonus;

    _undoStack.add(
      TurnUndoSnapshot(
        playerIndex: scoredPlayerIdx,
        assignedCategory: category,
        assignedScore: score,
        diceBeforeAssignment: List<DieState>.from(_dice),
        rollsUsedBeforeAssignment: _rollsUsed,
      ),
    );

    setState(() {
      currentPlayer.scores[category] = score;
      final justEarnedBonus = !hadBonusBefore && currentPlayer.hasEarnedBonus;
      _celebrationEventCounter++;
      _lastScoredPlayerIndex = scoredPlayerIdx;
      _lastScoredCategory = category;
      _lastScoreCelebration = ScoreCelebrationEvent.fromScore(
        eventId: _celebrationEventCounter,
        playerIdx: scoredPlayerIdx,
        category: category,
        displayScore: score,
        rules: _rules,
        justEarnedBonus: justEarnedBonus,
      );
    });

    final allComplete = _players.every((p) => p.isComplete);
    if (allComplete) {
      _showGameOverDialog();
      return;
    }

    int nextIndex = (_activePlayerIndex + 1) % _players.length;
    int safety = 0;
    while (_players[nextIndex].isComplete && safety < _players.length) {
      nextIndex = (nextIndex + 1) % _players.length;
      safety++;
    }

    // Roll immediately for the next player while keeping the latest score highlighted!
    setState(() {
      _activePlayerIndex = nextIndex;
    });
    _startTurnWithAutoRoll(animate: true);
  }

  void _undoLastTurn() {
    if (_isRolling) return;
    if (_undoStack.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: PencilPalette.graphiteDark,
          duration: const Duration(seconds: 2),
          content: Text(
            _strings.nothingToUndoMessage,
            style: GoogleFonts.patrickHand(fontSize: 17, color: Colors.white),
          ),
        ),
      );
      return;
    }

    final snapshot = _undoStack.removeLast();

    setState(() {
      _activePlayerIndex = snapshot.playerIndex;
      _players[_activePlayerIndex].scores.remove(snapshot.assignedCategory);
      _dice = List<DieState>.from(snapshot.diceBeforeAssignment);
      _rollsUsed = snapshot.rollsUsedBeforeAssignment;
      _lastScoreCelebration = null;
      if (_undoStack.isNotEmpty) {
        _lastScoredPlayerIndex = _undoStack.last.playerIndex;
        _lastScoredCategory = _undoStack.last.assignedCategory;
      } else {
        _lastScoredPlayerIndex = null;
        _lastScoredCategory = null;
      }
    });

    final catLabel = _strings.categoryLabel(snapshot.assignedCategory);
    final playerName = _players[snapshot.playerIndex].name;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PencilPalette.graphiteDark,
        duration: const Duration(seconds: 2),
        content: Text(
          _strings.undidCategoryForPlayer(catLabel, playerName),
          style: GoogleFonts.patrickHand(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }

  void _openPlayerSetupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => PlayerSetupDialog(
        initialPlayerNames: _players.map((p) => p.name).toList(),
        initialRules: _rules,
        strings: _strings,
        onApply: (names, newRules, resetScores) {
          final structureChanged = newRules.variant != _rules.variant ||
              newRules.diceCount != _rules.diceCount ||
              newRules.dieSides != _rules.dieSides ||
              newRules.maxRolls != _rules.maxRolls;
          if (resetScores || structureChanged) {
            _initNewGame(names, newRules);
          } else {
            setState(() {
              _rules = newRules;
              final updated = <PlayerScorecard>[];
              for (int i = 0; i < names.length; i++) {
                if (i < _players.length) {
                  updated.add(
                    _players[i].copyWith(name: names[i], rules: newRules),
                  );
                } else {
                  updated.add(
                    PlayerScorecard(
                      id: 'player_$i',
                      name: names[i],
                      rules: newRules,
                    ),
                  );
                }
              }
              _players = updated;
              if (_activePlayerIndex >= _players.length) {
                _activePlayerIndex = 0;
              }
            });
          }
        },
      ),
    );
  }

  void _openRulesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => RulesDialog(
        strings: _strings,
        onOpenCoachGuide: () => _openCoachGuideDialog(),
      ),
    );
  }

  void _openCoachGuideDialog([TurnCoachAdvice? existingAdvice]) {
    final isGameComplete = _players.every((p) => p.isComplete);
    final activePlayer = _players[_activePlayerIndex];
    final advice = existingAdvice ??
        ((_rollsUsed > 0 && !isGameComplete && !_isRolling)
            ? YatzyStrategySolver.analyzeTurn(
                rules: _rules,
                player: activePlayer,
                dice: _dice,
                rollsUsed: _rollsUsed,
              )
            : null);
    CoachGuideDialog.show(
      context,
      strings: _strings,
      rules: _rules,
      currentAdvice: advice,
      onSelectHoldIndices: _applyOptimalHold,
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => GameOverDialog(
        players: _players,
        strings: _strings,
        onRematch: () {
          _initNewGame(_players.map((p) => p.name).toList(), _rules);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final activePlayer = _players[_activePlayerIndex];
    final currentDiceValues = _dice.map((d) => d.value).toList();
    final isGameComplete = _players.every((p) => p.isComplete);

    final horizontalPad = isMobile ? 12.0 : 44.0;

    final TurnCoachAdvice? coachAdvice =
        (_coachModeEnabled && _rollsUsed > 0 && !isGameComplete && !_isRolling)
            ? YatzyStrategySolver.analyzeTurn(
                rules: _rules,
                player: activePlayer,
                dice: _dice,
                rollsUsed: _rollsUsed,
              )
            : null;

    return Scaffold(
      backgroundColor: PencilPalette.paperBg,
      body: CustomPaint(
        painter: PaperBackgroundPainter(
          lineSpacing: 28.0,
          showMarginLine: true,
          marginLineOffset: isMobile ? 9.0 : 34.0,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Compact Sketch Header Bar
              _buildSketchHeader(isGameComplete, isMobile, horizontalPad),

              // 2. Pinned Dice Tray at Top (Always accessible while scrolling scorecard!)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPad,
                  isMobile ? 6 : 8,
                  isMobile ? 10 : 16,
                  isMobile ? 6 : 10,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: PencilDiceTray(
                      dice: _dice,
                      dieSides: _rules.dieSides,
                      rollsUsed: _rollsUsed,
                      maxRolls: _rules.maxRolls,
                      isRolling: _isRolling,
                      onToggleHold: _toggleDieHold,
                      onRoll: _rollUnheldDice,
                      onHoldAllToggle: _toggleHoldAll,
                      onUndo: _undoLastTurn,
                      undoCount: _undoStack.length,
                      activePlayerName: activePlayer.name,
                      strings: _strings,
                      coachAdvice: coachAdvice,
                      onApplyOptimalHold: coachAdvice?.optimalHold != null
                          ? () => _applyOptimalHold(
                                coachAdvice!.optimalHold!.holdIndices,
                              )
                          : null,
                      onSelectHoldIndices: _applyOptimalHold,
                      onSelectCoachCategory: _assignCategoryScore,
                      onOpenCoachGuide: () =>
                          _openCoachGuideDialog(coachAdvice),
                      rules: _rules,
                    ),
                  ),
                ),
              ),

              // 3. Vertically Scrollable Multi-Player Scorecard Below
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPad,
                    2,
                    isMobile ? 10 : 16,
                    24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: PencilScorecardWidget(
                        players: _players,
                        activePlayerIndex: _activePlayerIndex,
                        lastScoredPlayerIndex: _lastScoredPlayerIndex,
                        lastScoredCategory: _lastScoredCategory,
                        lastScoreCelebration: _lastScoreCelebration,
                        currentDiceValues: currentDiceValues,
                        canAssignScore:
                            _rollsUsed > 0 && !isGameComplete && !_isRolling,
                        onSelectCategory: _assignCategoryScore,
                        strings: _strings,
                        rules: _rules,
                        coachAdvice: coachAdvice,
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

  Widget _buildSketchHeader(
    bool isGameComplete,
    bool isMobile,
    double leftPad,
  ) {
    final s = _strings;
    final hasUndo = _undoStack.isNotEmpty;

    return Container(
      padding: EdgeInsets.fromLTRB(leftPad, 7, isMobile ? 8 : 18, 7),
      decoration: BoxDecoration(
        color: PencilPalette.paperBg.withValues(alpha: 0.94),
        border: const Border(
          bottom: BorderSide(
            color: PencilPalette.graphiteMedium,
            width: 1.5,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          // Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.create_rounded,
                color: PencilPalette.graphiteDark,
                size: 21,
              ),
              const SizedBox(width: 4),
              Text(
                'YATZY',
                style: GoogleFonts.patrickHand(
                  fontSize: isMobile ? 22 : 29,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: PencilPalette.graphiteDark,
                  height: 1.0,
                ),
              ),
            ],
          ),

          // Game Variant Dropdown Button (opens variant picker with explanations)
          GestureDetector(
            onTap: _openGameVariantDropdown,
            child: Tooltip(
              message: s.switchDiceTooltip,
              child: PencilBox(
                borderColor: PencilPalette.bluePencil,
                fillColor:
                    PencilPalette.yellowHighlighter.withValues(alpha: 0.45),
                strokeWidth: 1.3,
                seed: 808,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.casino_outlined,
                      size: 14,
                      color: PencilPalette.bluePencil,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      s.diceModeChipLabel(_rules),
                      style: GoogleFonts.patrickHand(
                        fontSize: isMobile ? 13.5 : 15,
                        fontWeight: FontWeight.bold,
                        color: PencilPalette.bluePencil,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 18,
                      color: PencilPalette.bluePencil,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Strategy Coach / Expected Best Score (EV) Toggle Button
          Tooltip(
            message: s.coachButtonTooltip(_coachModeEnabled),
            child: _HeaderPencilButton(
              icon: _coachModeEnabled
                  ? Icons.psychology_alt_rounded
                  : Icons.school_outlined,
              label: s.coachButtonLabel,
              color: _coachModeEnabled
                  ? PencilPalette.greenPencil
                  : PencilPalette.graphiteMedium,
              fillColor: _coachModeEnabled
                  ? const Color(0xFFEAF6EC)
                  : PencilPalette.paperCard,
              onTap: _toggleCoachMode,
              compact: isMobile,
            ),
          ),

          if (_coachModeEnabled)
            Tooltip(
              message: s.coachGuideTitle,
              child: _HeaderPencilButton(
                icon: Icons.auto_stories_outlined,
                label: s.coachHowItWorksButton,
                color: PencilPalette.bluePencil,
                fillColor: const Color(0xFFE8F1FA),
                onTap: () => _openCoachGuideDialog(),
                compact: isMobile,
              ),
            ),

          // ALWAYS VISIBLE Undo button in header bar
          Tooltip(
            message: s.undoTooltip(_undoStack.length),
            child: _HeaderPencilButton(
              icon: Icons.undo_rounded,
              label: s.undoTurnWithCount(_undoStack.length),
              color: hasUndo
                  ? PencilPalette.orangePencil
                  : PencilPalette.graphiteLight,
              fillColor: hasUndo
                  ? const Color(0xFFFFF4E6)
                  : PencilPalette.paperCard,
              onTap: _undoLastTurn,
              compact: isMobile,
            ),
          ),

          _HeaderPencilButton(
            icon: Icons.tune_rounded,
            label: isMobile
                ? s.playersButtonMobile
                : s.playersButton(_players.length),
            color: PencilPalette.bluePencil,
            onTap: _openPlayerSetupDialog,
            compact: isMobile,
          ),

          _HeaderPencilButton(
            icon: Icons.help_outline_rounded,
            label: s.rulesButton,
            color: PencilPalette.graphiteDark,
            onTap: _openRulesDialog,
            compact: isMobile,
          ),

          if (isGameComplete)
            _HeaderPencilButton(
              icon: Icons.emoji_events_outlined,
              label: s.standingsButton,
              color: PencilPalette.greenPencil,
              onTap: _showGameOverDialog,
              compact: isMobile,
            ),

          _HeaderPencilButton(
            icon: Icons.language_rounded,
            label: '${_locale.flag} ${_locale.code}',
            color: PencilPalette.graphiteMedium,
            onTap: _openLanguageDialog,
            compact: isMobile,
          ),
        ],
      ),
    );
  }
}

class _HeaderPencilButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? fillColor;
  final VoidCallback onTap;
  final bool compact;

  const _HeaderPencilButton({
    required this.icon,
    required this.label,
    required this.color,
    this.fillColor,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: PencilBox(
          borderColor: color,
          fillColor: fillColor ?? PencilPalette.paperCard,
          strokeWidth: 1.2,
          overshoot: 1.5,
          seed: label.hashCode,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 7 : 10,
            vertical: compact ? 3 : 4.5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: compact ? 13.5 : 15.5, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.patrickHand(
                  fontSize: compact ? 14.0 : 15.5,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
