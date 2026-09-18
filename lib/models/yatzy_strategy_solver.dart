import 'dart:math';
import 'yatzy_models.dart';

/// Strategic evaluation of assigning the current dice to a specific [YatzyCategory].
class CategoryStrategyEvaluation {
  final YatzyCategory category;

  /// Score displayed on the scorecard (for upper section, this is +/- relative to Par).
  final int immediateScore;

  /// Raw points contributed toward the player's total score (before bonus).
  final int rawPointsContribution;

  /// Expected raw points this category would yield on a future turn if kept open.
  final double expectedFuturePoints;

  /// Change in Expected Upper Bonus points (+50p / +35p) resulting from this move.
  final double bonusEvDelta;

  /// Net strategic value (advantage over average future turn + bonus impact).
  /// Higher is better. The category with the highest [strategicNetValue] is the optimal choice.
  final double strategicNetValue;

  const CategoryStrategyEvaluation({
    required this.category,
    required this.immediateScore,
    required this.rawPointsContribution,
    required this.expectedFuturePoints,
    required this.bonusEvDelta,
    required this.strategicNetValue,
  });
}

/// Evaluation of a specific hold choice (subset of dice kept) when rolls remain.
class HoldStrategyEvaluation {
  /// Sorted face values of the dice held (e.g., `[6, 6]`).
  final List<int> heldFaces;

  /// Indices (`0 .. diceCount-1`) in the current dice list that should be held.
  final List<int> holdIndices;

  /// Expected strategic net value after optimal play on remaining rolls.
  final double expectedStrategicValue;

  /// Expected turn points (raw points + bonus EV impact) after optimal play on remaining rolls.
  final double expectedTurnPoints;

  const HoldStrategyEvaluation({
    required this.heldFaces,
    required this.holdIndices,
    required this.expectedStrategicValue,
    required this.expectedTurnPoints,
  });
}

/// Complete real-time coaching recommendation for the current player's turn.
class TurnCoachAdvice {
  /// Ranked list of all open categories for the current dice (index 0 is best).
  final List<CategoryStrategyEvaluation> categoryRankings;

  /// The #1 strategically best category to score if stopping right now.
  CategoryStrategyEvaluation get bestCategoryNow => categoryRankings.first;

  /// Optimal dice hold for the next roll (if `rollsRemaining > 0`).
  final HoldStrategyEvaluation? optimalHold;

  /// Evaluation of the player's currently selected hold (if `rollsRemaining > 0`).
  final HoldStrategyEvaluation? currentHold;

  /// Ranked list of distinct hold choices (unique held face multisets) from best to worst EV.
  final List<HoldStrategyEvaluation> holdAlternatives;

  /// True if the player's currently held dice multiset matches the optimal hold multiset.
  final bool isCurrentHoldOptimal;

  /// True if the player should stop rolling and score immediately (keeping all dice is optimal).
  final bool shouldScoreNow;

  /// Primary target categories that the optimal hold is aiming for.
  final List<YatzyCategory> targetCategories;

  /// Estimated probability (0.0 .. 1.0) of earning the Upper Section Bonus before this turn.
  final double currentBonusProbability;

  const TurnCoachAdvice({
    required this.categoryRankings,
    required this.optimalHold,
    required this.currentHold,
    this.holdAlternatives = const [],
    required this.isCurrentHoldOptimal,
    required this.shouldScoreNow,
    required this.targetCategories,
    required this.currentBonusProbability,
  });

  /// Returns the strategic evaluation for [category] if it is currently open.
  CategoryStrategyEvaluation? evaluationFor(YatzyCategory category) {
    for (int i = 0; i < categoryRankings.length; i++) {
      if (categoryRankings[i].category == category) {
        return categoryRankings[i];
      }
    }
    return null;
  }

  /// Returns the 1-based rank (1 = best) of [category] among open categories, or null if filled.
  int? rankOf(YatzyCategory category) {
    for (int i = 0; i < categoryRankings.length; i++) {
      if (categoryRankings[i].category == category) {
        return i + 1;
      }
    }
    return null;
  }

  /// Returns the strategic EV difference (`<= 0.0`) of [category] compared to [bestCategoryNow].
  double deltaVsBestCategory(YatzyCategory category) {
    if (categoryRankings.isEmpty) return 0.0;
    final eval = evaluationFor(category);
    if (eval == null) return 0.0;
    return eval.strategicNetValue - bestCategoryNow.strategicNetValue;
  }
}

/// Cached multiset transition graph for exact Within-Turn Backward Induction.
class _MultisetTransitionTable {
  final int diceCount;
  final int dieSides;

  /// All sorted multisets of size [diceCount] with faces `1..dieSides`.
  final List<List<int>> fullStates;

  /// Map from canonical integer key of a multiset to its index in [fullStates] or [heldStates].
  final Map<int, int> fullStateIndexMap;

  /// All sorted sub-multisets of size `0..diceCount`.
  final List<List<int>> heldStates;
  final Map<int, int> heldStateIndexMap;

  /// For each full state index `s`, list of unique held state indices `h` that can be formed from `s`.
  final List<List<int>> fullToHeldIndices;

  /// For each held state index `h`, list of `(targetFullStateIndex, probability)` transitions when rolling `diceCount - |h|` dice.
  final List<List<({int fullIdx, double prob})>> heldTransitions;

  _MultisetTransitionTable({
    required this.diceCount,
    required this.dieSides,
    required this.fullStates,
    required this.fullStateIndexMap,
    required this.heldStates,
    required this.heldStateIndexMap,
    required this.fullToHeldIndices,
    required this.heldTransitions,
  });

  static int encodeSortedMultiset(List<int> sortedFaces) {
    int hash = sortedFaces.length;
    for (int i = 0; i < sortedFaces.length; i++) {
      hash = hash * 23 + sortedFaces[i];
    }
    return hash;
  }
}

class YatzyStrategySolver {
  static final Map<String, _MultisetTransitionTable> _tableCache = {};

  /// Computes complete real-time strategy advice for the active player's current turn.
  static TurnCoachAdvice analyzeTurn({
    required YatzyGameRules rules,
    required PlayerScorecard player,
    required List<DieState> dice,
    required int rollsUsed,
  }) {
    final openCategories = rules.activeCategories
        .where((c) => !player.isFilled(c))
        .toList();

    final currentFaces = dice.map((d) => d.value).toList();
    final rollsRemaining = max(0, rules.maxRolls - rollsUsed);

    final currentDiffSum = player.upperDiffSum;
    final openUpperFaces = openCategories
        .where((c) => c.isUpper)
        .map((c) => c.upperFace!)
        .toList();

    final bonusProbBefore = estimateBonusProbability(
      currentDiffSum: currentDiffSum,
      openUpperFaces: openUpperFaces,
      rules: rules,
    );

    // 1. Evaluate all open categories for the current dice
    final rankings = evaluateCategoriesForDice(
      dice: currentFaces,
      openCategories: openCategories,
      currentDiffSum: currentDiffSum,
      openUpperFaces: openUpperFaces,
      bonusProbBefore: bonusProbBefore,
      rules: rules,
    );

    if (rollsRemaining == 0 || openCategories.isEmpty) {
      return TurnCoachAdvice(
        categoryRankings: rankings,
        optimalHold: null,
        currentHold: null,
        holdAlternatives: const [],
        isCurrentHoldOptimal: true,
        shouldScoreNow: true,
        targetCategories: rankings.take(2).map((e) => e.category).toList(),
        currentBonusProbability: bonusProbBefore,
      );
    }

    // 2. Compute optimal hold and current hold EV across remaining rolls
    final holdResult = _solveOptimalHold(
      dice: dice,
      rollsRemaining: rollsRemaining,
      openCategories: openCategories,
      currentDiffSum: currentDiffSum,
      openUpperFaces: openUpperFaces,
      bonusProbBefore: bonusProbBefore,
      rules: rules,
    );

    final optimalHold = holdResult.optimalHold;
    final currentHold = holdResult.currentHold;
    final holdAlternatives = holdResult.holdAlternatives;

    final sortedOptFaces = List<int>.from(optimalHold.heldFaces)..sort();
    final sortedCurFaces = List<int>.from(currentHold.heldFaces)..sort();
    bool sameHold = sortedOptFaces.length == sortedCurFaces.length;
    if (sameHold) {
      for (int i = 0; i < sortedOptFaces.length; i++) {
        if (sortedOptFaces[i] != sortedCurFaces[i]) {
          sameHold = false;
          break;
        }
      }
    }

    // If holding all dice (or if optimal hold EV is no better than immediate best category), recommend scoring now
    final bestNowVal = rankings.first.strategicNetValue;
    final shouldScoreNow = optimalHold.heldFaces.length == dice.length ||
        (optimalHold.expectedStrategicValue - bestNowVal) <= 0.05;

    final targets = _identifyTargetCategories(
      heldFaces: optimalHold.heldFaces,
      openCategories: openCategories,
      rankings: rankings,
      shouldScoreNow: shouldScoreNow,
      rules: rules,
    );

    return TurnCoachAdvice(
      categoryRankings: rankings,
      optimalHold: optimalHold,
      currentHold: currentHold,
      holdAlternatives: holdAlternatives,
      isCurrentHoldOptimal: sameHold,
      shouldScoreNow: shouldScoreNow,
      targetCategories: targets,
      currentBonusProbability: bonusProbBefore,
    );
  }

  /// Evaluates and ranks all open categories for a given dice roll.
  static List<CategoryStrategyEvaluation> evaluateCategoriesForDice({
    required List<int> dice,
    required List<YatzyCategory> openCategories,
    required int currentDiffSum,
    required List<int> openUpperFaces,
    required double bonusProbBefore,
    required YatzyGameRules rules,
  }) {
    final evaluations = <CategoryStrategyEvaluation>[];
    final totalOpen = openCategories.length;
    final gameProgress = 1.0 - (totalOpen / rules.activeCategories.length);

    for (final cat in openCategories) {
      final immediateScore = YatzyScorer.calculateScore(
        cat,
        dice,
        upperParCount: rules.upperParCount,
        region: rules.region,
        rules: rules,
      );

      final int rawPoints;
      if (cat.isUpper) {
        final parScore = rules.upperParCount * cat.upperFace!;
        rawPoints = parScore + immediateScore;
      } else {
        rawPoints = immediateScore;
      }

      final expectedFuture = expectedFutureRawPoints(
        cat,
        rules,
        gameProgress: gameProgress,
      );

      double bonusEvDelta = 0.0;
      if (cat.isUpper) {
        final newDiffSum = currentDiffSum + immediateScore;
        final remainingUpper =
            openUpperFaces.where((f) => f != cat.upperFace).toList();
        final bonusProbAfter = estimateBonusProbability(
          currentDiffSum: newDiffSum,
          openUpperFaces: remainingUpper,
          rules: rules,
        );
        bonusEvDelta =
            rules.upperBonusPoints * (bonusProbAfter - bonusProbBefore);
      }

      final strategicNetValue =
          (rawPoints - expectedFuture) + bonusEvDelta;

      evaluations.add(
        CategoryStrategyEvaluation(
          category: cat,
          immediateScore: immediateScore,
          rawPointsContribution: rawPoints,
          expectedFuturePoints: expectedFuture,
          bonusEvDelta: bonusEvDelta,
          strategicNetValue: strategicNetValue,
        ),
      );
    }

    evaluations.sort((a, b) {
      final cmp = b.strategicNetValue.compareTo(a.strategicNetValue);
      if (cmp != 0) return cmp;
      return b.rawPointsContribution.compareTo(a.rawPointsContribution);
    });

    return evaluations;
  }

  /// Estimates probability (0.0 .. 1.0) of earning the Upper Section Bonus.
  static double estimateBonusProbability({
    required int currentDiffSum,
    required List<int> openUpperFaces,
    required YatzyGameRules rules,
  }) {
    if (openUpperFaces.isEmpty) {
      return currentDiffSum >= 0 ? 1.0 : 0.0;
    }

    // Maximum possible gain from remaining upper categories
    int maxPossibleGain = 0;
    double expectedRemainingDrift = 0.0;
    double varianceSum = 0.0;

    final extraDiceOverPar = max(1, rules.diceCount - rules.upperParCount);
    for (final face in openUpperFaces) {
      maxPossibleGain += extraDiceOverPar * face;
      // On average under optimal play, high faces (4,5,6) drift slightly positive while 1,2 drift slightly negative
      final driftFactor =
          ((face / rules.dieSides) - 0.42) * 0.45 * (rules.maxRolls / 3.0);
      expectedRemainingDrift += face * driftFactor;
      varianceSum += (face * face) * 1.25;
    }

    if (currentDiffSum + maxPossibleGain < 0) {
      return 0.0;
    }

    final sigma = max(3.2, sqrt(varianceSum));
    final z = (currentDiffSum + expectedRemainingDrift) / sigma;

    // Logistic approximation to normal cumulative distribution
    return 1.0 / (1.0 + exp(-1.702 * z));
  }

  /// Expected baseline raw points for a category on a future turn.
  static double expectedFutureRawPoints(
    YatzyCategory cat,
    YatzyGameRules rules, {
    double gameProgress = 0.5,
  }) {
    final s = rules.dieSides.toDouble();
    final n = rules.diceCount.toDouble();
    final rollFactor = 0.85 + 0.15 * (rules.maxRolls / 3.0);
    // Late in the game, opportunity cost shrinks slightly as fewer turns remain
    final horizonFactor = 0.72 + 0.28 * (1.0 - gameProgress * 0.55);

    if (cat.isUpper) {
      final face = cat.upperFace!.toDouble();
      final parScore = rules.upperParCount * face;
      // Higher upper faces have higher expected future score relative to Par
      final drift = (face / s - 0.45) * face * 0.55 * rollFactor;
      return max(0.0, (parScore + drift) * horizonFactor);
    }

    switch (cat) {
      case YatzyCategory.onePair:
        return (1.78 * s) * rollFactor * horizonFactor;
      case YatzyCategory.twoPairs:
        return (2.92 * s) * rollFactor * horizonFactor;
      case YatzyCategory.threePairs:
        return (3.75 * s) * rollFactor * horizonFactor;
      case YatzyCategory.threeOfAKind:
        if (rules.region == YatzyRuleRegion.usYahtzee) {
          return (3.50 * s) * rollFactor * horizonFactor;
        }
        return (2.25 * s) * rollFactor * horizonFactor;
      case YatzyCategory.fourOfAKind:
        if (rules.region == YatzyRuleRegion.usYahtzee) {
          return (2.30 * s) * rollFactor * horizonFactor;
        }
        return (1.92 * s) * rollFactor * horizonFactor;
      case YatzyCategory.fiveOfAKind:
        return (1.75 * s) * rollFactor * horizonFactor;
      case YatzyCategory.sixOfAKind:
        return (1.35 * s) * rollFactor * horizonFactor;
      case YatzyCategory.smallStraight:
        if (rules.region == YatzyRuleRegion.usYahtzee) {
          return 0.80 * rules.usSmallStraightPoints * horizonFactor;
        }
        final base = n == 4 ? 10.0 : (n == 3 ? 6.0 : 15.0 * (s / 6.0));
        return 0.62 * base * rollFactor * horizonFactor;
      case YatzyCategory.largeStraight:
        if (rules.region == YatzyRuleRegion.usYahtzee) {
          return 0.54 * rules.usLargeStraightPoints * horizonFactor;
        }
        final base = n == 4 ? 14.0 : 20.0 * (s / 6.0);
        return 0.48 * base * rollFactor * horizonFactor;
      case YatzyCategory.fullStraight:
        return 0.46 * 21.0 * (s / 6.0) * rollFactor * horizonFactor;
      case YatzyCategory.royalStraight:
        return 0.44 * 30.0 * (s / 8.0) * rollFactor * horizonFactor;
      case YatzyCategory.fullHouse:
        if (rules.region == YatzyRuleRegion.usYahtzee) {
          return 0.74 * rules.usFullHousePoints * horizonFactor;
        }
        return (2.48 * s) * rollFactor * horizonFactor;
      case YatzyCategory.villa:
        return (2.30 * s) * rollFactor * horizonFactor;
      case YatzyCategory.tower:
        return (2.10 * s) * rollFactor * horizonFactor;
      case YatzyCategory.pyramid:
        return (2.55 * s) * rollFactor * horizonFactor;
      case YatzyCategory.evenOnly:
        return (2.05 * s) * rollFactor * horizonFactor;
      case YatzyCategory.oddOnly:
        return (1.85 * s) * rollFactor * horizonFactor;
      case YatzyCategory.chance:
        // Chance has a premium opportunity cost early in the game because it rescues failed high rolls
        final earlyGuard = 1.0 + 0.18 * (1.0 - gameProgress);
        return (0.65 * n * s) * earlyGuard * horizonFactor;
      case YatzyCategory.yatzy:
        return 0.34 * rules.yatzyBasePoints * rollFactor * horizonFactor;
      case YatzyCategory.superYatzy:
        return 0.22 * rules.superYatzyBasePoints * rollFactor * horizonFactor;
      default:
        return 10.0;
    }
  }

  static ({
    HoldStrategyEvaluation optimalHold,
    HoldStrategyEvaluation currentHold,
    List<HoldStrategyEvaluation> holdAlternatives,
  }) _solveOptimalHold({
    required List<DieState> dice,
    required int rollsRemaining,
    required List<YatzyCategory> openCategories,
    required int currentDiffSum,
    required List<int> openUpperFaces,
    required double bonusProbBefore,
    required YatzyGameRules rules,
  }) {
    final n = dice.length;
    final s = rules.dieSides;

    // Use exact multiset backward induction when state space is tractable (<= 500 states, e.g. 3..6 d6 or 3..5 d4 or 3..4 d8)
    final numMultisets = _binomial(n + s - 1, n);
    if (numMultisets <= 500) {
      final table = _getOrBuildTransitionTable(n, s);
      final numFull = table.fullStates.length;
      final numHeld = table.heldStates.length;

      // V_0(D): Strategic value & raw turn points for every full state D
      var stateStrategicVal = List<double>.filled(numFull, 0.0);
      var stateRawPoints = List<double>.filled(numFull, 0.0);

      for (int idx = 0; idx < numFull; idx++) {
        final evals = evaluateCategoriesForDice(
          dice: table.fullStates[idx],
          openCategories: openCategories,
          currentDiffSum: currentDiffSum,
          openUpperFaces: openUpperFaces,
          bonusProbBefore: bonusProbBefore,
          rules: rules,
        );
        final best = evals.first;
        stateStrategicVal[idx] = best.strategicNetValue;
        stateRawPoints[idx] =
            best.rawPointsContribution + best.bonusEvDelta;
      }

      var heldStrategicVal = List<double>.filled(numHeld, 0.0);
      var heldRawPoints = List<double>.filled(numHeld, 0.0);

      // Backward induction for t = 1 .. rollsRemaining
      for (int step = 1; step <= rollsRemaining; step++) {
        for (int hIdx = 0; hIdx < numHeld; hIdx++) {
          double sumStrat = 0.0;
          double sumRaw = 0.0;
          final transitions = table.heldTransitions[hIdx];
          for (int k = 0; k < transitions.length; k++) {
            final tr = transitions[k];
            sumStrat += tr.prob * stateStrategicVal[tr.fullIdx];
            sumRaw += tr.prob * stateRawPoints[tr.fullIdx];
          }
          heldStrategicVal[hIdx] = sumStrat;
          heldRawPoints[hIdx] = sumRaw;
        }

        if (step < rollsRemaining) {
          final nextStateStrat = List<double>.filled(numFull, -1e9);
          final nextStateRaw = List<double>.filled(numFull, 0.0);
          for (int fIdx = 0; fIdx < numFull; fIdx++) {
            final subHelds = table.fullToHeldIndices[fIdx];
            double bestS = -1e9;
            double bestR = 0.0;
            for (int k = 0; k < subHelds.length; k++) {
              final hIdx = subHelds[k];
              if (heldStrategicVal[hIdx] > bestS) {
                bestS = heldStrategicVal[hIdx];
                bestR = heldRawPoints[hIdx];
              }
            }
            nextStateStrat[fIdx] = bestS;
            nextStateRaw[fIdx] = bestR;
          }
          stateStrategicVal = nextStateStrat;
          stateRawPoints = nextStateRaw;
        }
      }

      // Now evaluate all 2^n subsets of the player's actual dice order
      return _evaluateActualDiceSubsets(
        dice: dice,
        lookupHeldEv: (sortedHeld) {
          final key = _MultisetTransitionTable.encodeSortedMultiset(sortedHeld);
          final hIdx = table.heldStateIndexMap[key]!;
          return (
            strategic: heldStrategicVal[hIdx],
            rawPoints: heldRawPoints[hIdx],
          );
        },
      );
    }

    // Fallback for huge RPG state spaces (e.g. 6xd8 or 5xd20):
    // Evaluate distinct held multisets of the current dice directly using deterministic sampling
    final memo = <int, ({double strategic, double rawPoints})>{};
    return _evaluateActualDiceSubsets(
      dice: dice,
      lookupHeldEv: (sortedHeld) {
        final key = _MultisetTransitionTable.encodeSortedMultiset(sortedHeld);
        final cached = memo[key];
        if (cached != null) return cached;

        final k = n - sortedHeld.length;
        if (k == 0) {
          final evals = evaluateCategoriesForDice(
            dice: sortedHeld,
            openCategories: openCategories,
            currentDiffSum: currentDiffSum,
            openUpperFaces: openUpperFaces,
            bonusProbBefore: bonusProbBefore,
            rules: rules,
          );
          final best = evals.first;
          final res = (
            strategic: best.strategicNetValue,
            rawPoints: best.rawPointsContribution + best.bonusEvDelta,
          );
          memo[key] = res;
          return res;
        }

        // Deterministic quasi-random sample of outcomes for k rolled dice
        const sampleCount = 96;
        double sumStrat = 0.0;
        double sumRaw = 0.0;
        final sampleDice = List<int>.filled(n, 1);
        for (int i = 0; i < sortedHeld.length; i++) {
          sampleDice[i] = sortedHeld[i];
        }
        for (int sim = 0; sim < sampleCount; sim++) {
          int seedVal = sim * 1103515245 + 12345 + key;
          for (int d = sortedHeld.length; d < n; d++) {
            seedVal = (seedVal * 1664525 + 1013904223) & 0x7FFFFFFF;
            sampleDice[d] = (seedVal % s) + 1;
          }
          final evals = evaluateCategoriesForDice(
            dice: sampleDice,
            openCategories: openCategories,
            currentDiffSum: currentDiffSum,
            openUpperFaces: openUpperFaces,
            bonusProbBefore: bonusProbBefore,
            rules: rules,
          );
          final best = evals.first;
          sumStrat += best.strategicNetValue;
          sumRaw += best.rawPointsContribution + best.bonusEvDelta;
        }
        final res = (
          strategic: sumStrat / sampleCount,
          rawPoints: sumRaw / sampleCount,
        );
        memo[key] = res;
        return res;
      },
    );
  }

  static ({
    HoldStrategyEvaluation optimalHold,
    HoldStrategyEvaluation currentHold,
    List<HoldStrategyEvaluation> holdAlternatives,
  }) _evaluateActualDiceSubsets({
    required List<DieState> dice,
    required ({double strategic, double rawPoints}) Function(
      List<int> sortedHeld,
    ) lookupHeldEv,
  }) {
    final n = dice.length;
    final totalMasks = 1 << n;

    HoldStrategyEvaluation? bestHold;
    HoldStrategyEvaluation? currentHold;
    final uniqueByMultiset = <int, HoldStrategyEvaluation>{};

    int currentMask = 0;
    for (int i = 0; i < n; i++) {
      if (dice[i].isHeld) {
        currentMask |= (1 << i);
      }
    }

    for (int mask = 0; mask < totalMasks; mask++) {
      final indices = <int>[];
      final faces = <int>[];
      for (int i = 0; i < n; i++) {
        if ((mask & (1 << i)) != 0) {
          indices.add(i);
          faces.add(dice[i].value);
        }
      }
      final sortedFaces = List<int>.from(faces)..sort();
      final ev = lookupHeldEv(sortedFaces);

      final evaluation = HoldStrategyEvaluation(
        heldFaces: sortedFaces,
        holdIndices: indices,
        expectedStrategicValue: ev.strategic,
        expectedTurnPoints: ev.rawPoints,
      );

      if (mask == currentMask) {
        currentHold = evaluation;
      }

      final multisetKey =
          _MultisetTransitionTable.encodeSortedMultiset(sortedFaces);
      // Prefer the evaluation that matches currentMask if equivalent multiset, else keep first
      if (!uniqueByMultiset.containsKey(multisetKey) || mask == currentMask) {
        uniqueByMultiset[multisetKey] = evaluation;
      }

      if (bestHold == null ||
          evaluation.expectedStrategicValue >
              bestHold.expectedStrategicValue + 1e-6 ||
          ((evaluation.expectedStrategicValue -
                          bestHold.expectedStrategicValue)
                      .abs() <=
                  1e-6 &&
              evaluation.heldFaces.length > bestHold.heldFaces.length)) {
        bestHold = evaluation;
      }
    }

    final alternatives = uniqueByMultiset.values.toList()
      ..sort((a, b) {
        final cmp =
            b.expectedStrategicValue.compareTo(a.expectedStrategicValue);
        if (cmp != 0) return cmp;
        return b.heldFaces.length.compareTo(a.heldFaces.length);
      });

    return (
      optimalHold: bestHold!,
      currentHold: currentHold!,
      holdAlternatives: alternatives,
    );
  }

  static List<YatzyCategory> _identifyTargetCategories({
    required List<int> heldFaces,
    required List<YatzyCategory> openCategories,
    required List<CategoryStrategyEvaluation> rankings,
    required bool shouldScoreNow,
    required YatzyGameRules rules,
  }) {
    if (shouldScoreNow || heldFaces.isEmpty) {
      return rankings.take(2).map((e) => e.category).toList();
    }

    final counts = <int, int>{};
    for (final f in heldFaces) {
      counts[f] = (counts[f] ?? 0) + 1;
    }

    final targets = <YatzyCategory>[];

    // Check if holding matching dice (pair/triple/quad)
    int bestRepeatFace = 0;
    int maxRepeatCount = 0;
    counts.forEach((face, cnt) {
      if (cnt > maxRepeatCount || (cnt == maxRepeatCount && face > bestRepeatFace)) {
        maxRepeatCount = cnt;
        bestRepeatFace = face;
      }
    });

    if (maxRepeatCount >= 2) {
      // Check if upper category for bestRepeatFace is open
      for (final c in openCategories) {
        if (c.isUpper && c.upperFace == bestRepeatFace) {
          targets.add(c);
          break;
        }
      }
      // Also check matching lower categories
      final lowerCandidates = [
        if (maxRepeatCount >= 3) YatzyCategory.yatzy,
        if (maxRepeatCount >= 3) YatzyCategory.fourOfAKind,
        YatzyCategory.threeOfAKind,
        YatzyCategory.fullHouse,
        YatzyCategory.twoPairs,
        YatzyCategory.onePair,
      ];
      for (final lc in lowerCandidates) {
        if (openCategories.contains(lc) && !targets.contains(lc)) {
          targets.add(lc);
          if (targets.length >= 2) break;
        }
      }
    } else {
      // Holding distinct faces -> likely targeting a Straight or high upper face
      if (heldFaces.length >= 3) {
        for (final sc in [
          YatzyCategory.largeStraight,
          YatzyCategory.smallStraight,
          YatzyCategory.fullStraight,
          YatzyCategory.royalStraight,
        ]) {
          if (openCategories.contains(sc)) {
            targets.add(sc);
            if (targets.length >= 2) break;
          }
        }
      }
      if (targets.isEmpty) {
        final highestFace = heldFaces.last;
        for (final c in openCategories) {
          if (c.isUpper && c.upperFace == highestFace) {
            targets.add(c);
            break;
          }
        }
      }
    }

    for (final r in rankings) {
      if (targets.length >= 2) break;
      if (!targets.contains(r.category)) {
        targets.add(r.category);
      }
    }

    return targets;
  }

  static _MultisetTransitionTable _getOrBuildTransitionTable(
    int diceCount,
    int dieSides,
  ) {
    final cacheKey = '${diceCount}_$dieSides';
    final existing = _tableCache[cacheKey];
    if (existing != null) return existing;

    final fullStates = <List<int>>[];
    final fullStateIndexMap = <int, int>{};

    void genFull(int startFace, List<int> current) {
      if (current.length == diceCount) {
        final copy = List<int>.unmodifiable(current);
        final idx = fullStates.length;
        fullStates.add(copy);
        fullStateIndexMap[_MultisetTransitionTable.encodeSortedMultiset(copy)] =
            idx;
        return;
      }
      for (int f = startFace; f <= dieSides; f++) {
        current.add(f);
        genFull(f, current);
        current.removeLast();
      }
    }

    genFull(1, []);

    final heldStates = <List<int>>[];
    final heldStateIndexMap = <int, int>{};

    void genHeld(int targetLen, int startFace, List<int> current) {
      if (current.length == targetLen) {
        final copy = List<int>.unmodifiable(current);
        final idx = heldStates.length;
        heldStates.add(copy);
        heldStateIndexMap[_MultisetTransitionTable.encodeSortedMultiset(copy)] =
            idx;
        return;
      }
      for (int f = startFace; f <= dieSides; f++) {
        current.add(f);
        genHeld(targetLen, f, current);
        current.removeLast();
      }
    }

    for (int len = 0; len <= diceCount; len++) {
      genHeld(len, 1, []);
    }

    // For each full state, find all unique held sub-multisets
    final fullToHeldIndices = List<List<int>>.generate(fullStates.length, (fIdx) {
      final state = fullStates[fIdx];
      final uniqueHeldSet = <int>{};
      final totalMasks = 1 << diceCount;
      for (int mask = 0; mask < totalMasks; mask++) {
        final sub = <int>[];
        for (int i = 0; i < diceCount; i++) {
          if ((mask & (1 << i)) != 0) {
            sub.add(state[i]);
          }
        }
        final key = _MultisetTransitionTable.encodeSortedMultiset(sub);
        uniqueHeldSet.add(heldStateIndexMap[key]!);
      }
      return uniqueHeldSet.toList(growable: false);
    });

    // Factored multinomial probabilities for rolling m = diceCount - |held| dice
    final fact = List<int>.filled(diceCount + 1, 1);
    for (int i = 2; i <= diceCount; i++) {
      fact[i] = fact[i - 1] * i;
    }

    final heldTransitions = List<List<({int fullIdx, double prob})>>.generate(
      heldStates.length,
      (hIdx) {
        final held = heldStates[hIdx];
        final m = diceCount - held.length;
        if (m == 0) {
          final key = _MultisetTransitionTable.encodeSortedMultiset(held);
          return [(fullIdx: fullStateIndexMap[key]!, prob: 1.0)];
        }

        final outcomes = <({int fullIdx, double prob})>[];
        final totalOutcomes = pow(dieSides, m).toDouble();

        void genRoll(int startFace, List<int> roll, List<int> faceCounts) {
          if (roll.length == m) {
            int denom = 1;
            for (int f = 1; f <= dieSides; f++) {
              if (faceCounts[f] > 1) {
                denom *= fact[faceCounts[f]];
              }
            }
            final ways = fact[m] ~/ denom;
            final prob = ways / totalOutcomes;

            final combined = <int>[...held, ...roll]..sort();
            final fullKey =
                _MultisetTransitionTable.encodeSortedMultiset(combined);
            outcomes.add((
              fullIdx: fullStateIndexMap[fullKey]!,
              prob: prob,
            ));
            return;
          }

          for (int f = startFace; f <= dieSides; f++) {
            roll.add(f);
            faceCounts[f]++;
            genRoll(f, roll, faceCounts);
            faceCounts[f]--;
            roll.removeLast();
          }
        }

        genRoll(1, [], List<int>.filled(dieSides + 1, 0));
        return outcomes;
      },
    );

    final table = _MultisetTransitionTable(
      diceCount: diceCount,
      dieSides: dieSides,
      fullStates: fullStates,
      fullStateIndexMap: fullStateIndexMap,
      heldStates: heldStates,
      heldStateIndexMap: heldStateIndexMap,
      fullToHeldIndices: fullToHeldIndices,
      heldTransitions: heldTransitions,
    );
    _tableCache[cacheKey] = table;
    return table;
  }

  static int _binomial(int n, int k) {
    if (k < 0 || k > n) return 0;
    if (k == 0 || k == n) return 1;
    int res = 1;
    final kk = k < (n - k) ? k : (n - k);
    for (int i = 1; i <= kk; i++) {
      res = res * (n - i + 1) ~/ i;
    }
    return res;
  }
}
