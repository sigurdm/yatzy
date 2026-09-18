import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatzee/l10n/app_strings.dart';
import 'package:yatzee/main.dart';
import 'package:yatzee/models/yatzy_models.dart';
import 'package:yatzee/models/yatzy_strategy_solver.dart';

void main() {
  group('5-Dice, 6-Dice, 7-Dice & d8 Yatzy Scoring Rules', () {
    test('Upper section scores +/- relative to par (3 or 4 of a kind, incl. d8 7s and 8s)', () {
      expect(YatzyScorer.calculateScore(YatzyCategory.fives, [5, 5, 5, 5, 2], upperParCount: 3), 5);
      expect(YatzyScorer.calculateScore(YatzyCategory.fives, [5, 5, 5, 2, 3], upperParCount: 3), 0);
      expect(YatzyScorer.calculateScore(YatzyCategory.fives, [5, 5, 2, 3, 4], upperParCount: 3), -5);

      // d8 Sevens & Eights
      expect(YatzyScorer.calculateScore(YatzyCategory.sevens, [7, 7, 7, 7, 2, 1], upperParCount: 3), 7);
      expect(YatzyScorer.calculateScore(YatzyCategory.eights, [8, 8, 8, 2, 1, 4], upperParCount: 3), 0);
    });

    test('Maxi, Mega & d8 Special Combinations (Villa, Tower, Pyramid, Royal Straight, Even/Odd, Super Yatzy)', () {
      // Villa (2 x 3 of a kind)
      expect(YatzyScorer.calculateScore(YatzyCategory.villa, [6, 6, 6, 4, 4, 4]), 30);
      expect(YatzyScorer.calculateScore(YatzyCategory.villa, [6, 6, 6, 6, 6, 6]), 0);

      // Tower (4 + 2 of a kind)
      expect(YatzyScorer.calculateScore(YatzyCategory.tower, [5, 5, 5, 5, 3, 3]), 26);

      // Pyramid (3 + 2 + 1 distinct faces)
      expect(YatzyScorer.calculateScore(YatzyCategory.pyramid, [6, 6, 6, 5, 5, 4]), 32);
      expect(YatzyScorer.calculateScore(YatzyCategory.pyramid, [6, 6, 6, 5, 5, 5]), 0);

      // Royal Straight (6 consecutive on d8, e.g. 3..8 = 30p)
      expect(YatzyScorer.calculateScore(YatzyCategory.royalStraight, [3, 4, 5, 6, 7, 8]), 30);
      expect(YatzyScorer.calculateScore(YatzyCategory.royalStraight, [1, 2, 3, 4, 5, 8]), 0);

      // Even Only & Odd Only
      expect(YatzyScorer.calculateScore(YatzyCategory.evenOnly, [2, 4, 6, 8, 2, 4]), 26);
      expect(YatzyScorer.calculateScore(YatzyCategory.evenOnly, [2, 4, 6, 8, 2, 3]), 0);
      expect(YatzyScorer.calculateScore(YatzyCategory.oddOnly, [1, 3, 5, 7, 3, 1]), 20);

      // Six of a Kind
      expect(YatzyScorer.calculateScore(YatzyCategory.sixOfAKind, [7, 7, 7, 7, 7, 7, 2]), 42);

      // Yatzy (50p on 5xd6, 120p on 6xd8 scaled) vs Super Yatzy (75p on 5xd6, 180p on 6xd8 scaled)
      expect(YatzyScorer.calculateScore(YatzyCategory.yatzy, [6, 6, 6, 6, 6]), 50);
      expect(YatzyScorer.calculateScore(YatzyCategory.yatzy, [8, 8, 8, 8, 8, 8]), 120);
      expect(YatzyScorer.calculateScore(YatzyCategory.superYatzy, [8, 8, 8, 8, 8, 8]), 180);
    });
    test('4-Dice Mini-Yatzy scoring (Par=2 in upper section, 4-dice straights, 4-of-a-kind Yatzy)', () {
      // Par = 2 for 4 dice
      expect(YatzyScorer.calculateScore(YatzyCategory.sixes, [6, 6, 3, 2], upperParCount: 2), 0);
      expect(YatzyScorer.calculateScore(YatzyCategory.sixes, [6, 6, 6, 2], upperParCount: 2), 6);
      expect(YatzyScorer.calculateScore(YatzyCategory.sixes, [6, 3, 2, 1], upperParCount: 2), -6);

      // 4-Dice Small Straight (1-2-3-4 = 10p) & Large Straight (3-4-5-6 = 18p)
      expect(YatzyScorer.calculateScore(YatzyCategory.smallStraight, [1, 2, 3, 4]), 10);
      expect(YatzyScorer.calculateScore(YatzyCategory.largeStraight, [3, 4, 5, 6]), 18);
      expect(YatzyScorer.calculateScore(YatzyCategory.smallStraight, [2, 3, 4, 5]), 14);

      // 4-Dice Yatzy (all 4 dice equal = 50p)
      expect(YatzyScorer.calculateScore(YatzyCategory.yatzy, [4, 4, 4, 4]), 50);
    });

    test('US Yahtzee rule style and RPG d20 scoring', () {
      final usRules = YatzyGameRules.fromVariant(YatzyGameVariant.usYahtzee);
      expect(usRules.region, YatzyRuleRegion.usYahtzee);
      expect(usRules.upperBonusPoints, 35);
      expect(usRules.activeCategories.contains(YatzyCategory.onePair), false);
      expect(usRules.activeCategories.contains(YatzyCategory.twoPairs), false);

      // US 3 of a Kind & 4 of a Kind sum ALL dice
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.threeOfAKind,
          [5, 5, 5, 6, 4],
          region: YatzyRuleRegion.usYahtzee,
        ),
        25,
      );
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.fourOfAKind,
          [4, 4, 4, 4, 6],
          region: YatzyRuleRegion.usYahtzee,
        ),
        22,
      );
      // US Full House = fixed 25p
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.fullHouse,
          [1, 1, 1, 2, 2],
          region: YatzyRuleRegion.usYahtzee,
        ),
        25,
      );
      // US Small Straight (4 sequential) = fixed 30p, Large Straight (5 sequential) = fixed 40p
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.smallStraight,
          [2, 3, 4, 5, 2],
          region: YatzyRuleRegion.usYahtzee,
        ),
        30,
      );
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.largeStraight,
          [2, 3, 4, 5, 6],
          region: YatzyRuleRegion.usYahtzee,
        ),
        40,
      );

      // RPG d20 Nat 20s scoring (Par = 3*20 = 60p)
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.twenties,
          [20, 20, 20, 15, 8],
          upperParCount: 3,
        ),
        0,
      );
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.twenties,
          [20, 20, 20, 20, 8],
          upperParCount: 3,
        ),
        20,
      );
    });
  });

  group('Multi-language localization (12 languages)', () {
    test('All 12 locales provide non-empty translations for all categories, rules, and 6 game variants with explanations', () {
      expect(AppLocale.values.length, 12);
      for (final locale in AppLocale.values) {
        final s = AppStrings(locale);
        expect(s.scorecardTitle.isNotEmpty, true);
        expect(s.rulesSections.length, 4);
        for (final cat in YatzyCategory.values) {
          expect(s.categoryLabel(cat).isNotEmpty, true);
          expect(s.categoryDescription(cat).isNotEmpty, true);
        }
        for (final variant in YatzyGameVariant.values) {
          expect(s.variantTitle(variant).isNotEmpty, true);
          expect(s.variantShortName(variant).isNotEmpty, true);
          expect(s.variantSpecsBadge(variant).isNotEmpty, true);
          expect(s.variantExplanation(variant).isNotEmpty, true);
        }
        expect(s.scalePointsSettingLabel.isNotEmpty, true);
        expect(s.scalePointsOptionLabel(true).isNotEmpty, true);
        expect(s.scalePointsOptionLabel(false).isNotEmpty, true);
      }
    });

    test('Dynamic point scaling scales Upper Bonus, Yatzy, and Straights appropriately', () {
      // Classic 5xd6 EU
      final classic = YatzyGameRules.fromVariant(YatzyGameVariant.classic5Dice);
      expect(classic.upperBonusPoints, 50);
      expect(classic.yatzyBasePoints, 50);
      expect(classic.superYatzyBasePoints, 75);

      // d4 Pyramid (4xd4, Par=2) -> scaled vs fixed
      final d4Scaled = YatzyGameRules.fromVariant(
        YatzyGameVariant.mini4Dice,
        customDieSides: 4,
        customScalePointsWithDice: true,
      );
      expect(d4Scaled.upperBonusPoints, 15);
      expect(d4Scaled.yatzyBasePoints, 30);

      final d4Fixed = YatzyGameRules.fromVariant(
        YatzyGameVariant.mini4Dice,
        customDieSides: 4,
        customScalePointsWithDice: false,
      );
      expect(d4Fixed.upperBonusPoints, 50);
      expect(d4Fixed.yatzyBasePoints, 50);

      // d20 Hero (5xd20, Par=3) -> scaled vs fixed
      final d20Scaled = YatzyGameRules.fromVariant(
        YatzyGameVariant.rpgD20,
        customScalePointsWithDice: true,
      );
      expect(d20Scaled.upperBonusPoints, 180);
      expect(d20Scaled.yatzyBasePoints, 170);
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.yatzy,
          [20, 20, 20, 20, 20],
          rules: d20Scaled,
        ),
        170,
      );
      // Small straight 16-17-18-19-20 on d20 scores sum of 16+17+18+19+20 = 90
      expect(
        YatzyScorer.calculateScore(
          YatzyCategory.smallStraight,
          [16, 17, 18, 19, 20],
          rules: d20Scaled,
        ),
        90,
      );
    });

    test('YatzyStrategySolver computes exact optimal holds and strategic category rankings', () {
      const rules = YatzyGameRules();
      final player = PlayerScorecard(id: 'p1', name: 'Test', rules: rules);

      // Roll 1 with three 6s and two low dice: [6, 6, 6, 1, 2]
      final diceRoll1 = [
        const DieState(value: 6),
        const DieState(value: 6),
        const DieState(value: 6),
        const DieState(value: 1),
        const DieState(value: 2),
      ];

      final advice1 = YatzyStrategySolver.analyzeTurn(
        rules: rules,
        player: player,
        dice: diceRoll1,
        rollsUsed: 1,
      );

      // Optimal hold should keep the three 6s ([6, 6, 6])
      expect(advice1.optimalHold, isNotNull);
      expect(advice1.optimalHold!.heldFaces, equals([6, 6, 6]));

      // On final roll (Roll 3) with four 6s ([6, 6, 6, 6, 2]), scoring Sixes (+6 above Par + huge bonus EV boost)
      // should rank #1 ahead of Four of a Kind or Chance
      final diceRoll3 = [
        const DieState(value: 6),
        const DieState(value: 6),
        const DieState(value: 6),
        const DieState(value: 6),
        const DieState(value: 2),
      ];
      final advice3 = YatzyStrategySolver.analyzeTurn(
        rules: rules,
        player: player,
        dice: diceRoll3,
        rollsUsed: 3,
      );
      expect(advice3.bestCategoryNow.category, equals(YatzyCategory.sixes));
      expect(advice3.bestCategoryNow.bonusEvDelta, greaterThan(5.0));
    });
  });

  testWidgets('Turn highlight retention, Undo button, and Game Variant Dropdown with explanations work on mobile screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PencilyYatzyApp());
    expect(find.text('YATZY'), findsOneWidget);
    expect(find.text('5×d6'), findsOneWidget);

    // Undo button is always visible (in header and dice tray)
    expect(find.text('Fortryd'), findsWidgets);

    // Assign a score on Player 1's Ones row
    final onesCell = find.byKey(const Key('open_cell_ones_0'));
    await tester.ensureVisible(onesCell);
    await tester.tap(onesCell);
    await tester.pumpAndSettle();

    // After scoring, dice roll immediately for Player 2 (Kast 1/3), AND the latest score stays highlighted!
    expect(find.text('Kast 1/3'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text('Fortryd (1)'), findsWidgets);

    // Tap Undo (Fortryd (1)) to undo the turn
    await tester.tap(find.text('Fortryd (1)').first);
    await tester.pumpAndSettle();
    expect(find.text('Fortryd'), findsWidgets);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

    // Re-score on Ones row -> dice roll immediately for Player 2 and highlight stays
    await tester.tap(find.byKey(const Key('open_cell_ones_0')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    // Verify that holding a die does not change the Roll button's layout size
    final rollButtonFinder = find.byKey(const Key('roll_button'));
    final sizeBeforeHold = tester.getSize(rollButtonFinder);
    await tester.tap(find.text('hold').first);
    await tester.pumpAndSettle();
    final sizeAfterHold = tester.getSize(rollButtonFinder);
    expect(sizeAfterHold, equals(sizeBeforeHold));

    // Press Roll (to roll Roll 2/3) and verify the highlight clears once the dice are rolled again
    await tester.tap(rollButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

    // Open Game Variant Dropdown via top header chip
    await tester.tap(find.text('5×d6'));
    await tester.pumpAndSettle();

    // Verify dropdown modal opens showing variant titles and explanations
    expect(find.text('Vælg Spilvariant'), findsOneWidget);
    expect(find.text('Mini-Yatzy (4 terninger)'), findsOneWidget);

    // Select Mini-Yatzy (4 terninger) from dropdown
    await tester.tap(find.text('Mini-Yatzy (4 terninger)'));
    await tester.pumpAndSettle();
    expect(find.text('4×d6'), findsOneWidget);
  });

  testWidgets('Desktop layout: selecting dice never changes Roll button or die widget size', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PencilyYatzyApp());
    final rollButtonFinder = find.byKey(const Key('roll_button'));
    final sizeInitial = tester.getSize(rollButtonFinder);

    // Hold 1st die ("Kast alle 5" -> "Kast 4 terninger")
    await tester.tap(find.text('hold').first);
    await tester.pumpAndSettle();
    expect(tester.getSize(rollButtonFinder), equals(sizeInitial));

    // Hold all dice ("Alle holdt")
    await tester.tap(find.text('Hold alle'));
    await tester.pumpAndSettle();
    expect(tester.getSize(rollButtonFinder), equals(sizeInitial));
  });
}
