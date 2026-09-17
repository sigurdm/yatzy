enum YatzyRuleRegion {
  euScandinavian, // +50p bonus, 1 Par & 2 Par, matching-dice sum on 3/4 of a kind, 15/20p straights, sum Full House
  usYahtzee, // +35p bonus, no 1/2 Pairs, all-dice sum on 3/4 of a kind, 25p Full House, 30p 4-straight, 40p 5-straight
}

enum YatzyGameVariant {
  mini4Dice, // 4 d6, 3 rolls, Par=2, EU rules
  classic5Dice, // 5 d6, 3 rolls, EU Scandinavian rules
  usYahtzee, // 5 d6, 3 rolls, US Yahtzee rules (35p bonus, 25p Full House, 30/40p Straights)
  maxi6Dice, // 6 d6, 3 rolls, 20 categories (incl. 3 Par, 5 Ens, Fuld Straight, Villa, Tårn)
  mega7Dice, // 7 d6, 4 rolls, 24 categories (incl. 6 Ens, Pyramide, Kun Lige/Ulige, Super Yatzy 75p)
  d8Fantasy, // 6 d8 (faces 1..8), 4 rolls, Upper 1s..8s + Royal Straight + Pyramide + Lige/Ulige + Super Yatzy
  rpgD20, // 5 d20 (faces 1..20), 4 rolls, Nat 20s & Royal Straight!
  turbo4Rolls, // 6 d6, 4 rolls, Maxi + Pyramide + Lige/Ulige + Super Yatzy
  oneShotHardcore, // 5 d6, 1 roll per turn (Hardcore One-Shot!)
}

class YatzyGameRules {
  final YatzyGameVariant variant;
  final YatzyRuleRegion region;
  final int diceCount; // 3..8 dice
  final int dieSides; // 4, 6, 8, 10, 12, or 20
  final int maxRolls; // 1..5 rolls per turn
  final int upperParCount; // 2, 3, or 4 of a kind
  final bool includeMaxiCategories;
  final bool includeMegaCategories;

  const YatzyGameRules({
    this.variant = YatzyGameVariant.classic5Dice,
    this.region = YatzyRuleRegion.euScandinavian,
    this.diceCount = 5,
    this.dieSides = 6,
    this.maxRolls = 3,
    this.upperParCount = 3,
    this.includeMaxiCategories = false,
    this.includeMegaCategories = false,
  });

  factory YatzyGameRules.fromVariant(
    YatzyGameVariant variant, {
    YatzyRuleRegion? customRegion,
    int? customUpperParCount,
    int? customMaxRolls,
    int? customDiceCount,
    int? customDieSides,
  }) {
    switch (variant) {
      case YatzyGameVariant.mini4Dice:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 4,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 3,
          upperParCount: customUpperParCount ?? 2,
          includeMaxiCategories: false,
          includeMegaCategories: false,
        );
      case YatzyGameVariant.classic5Dice:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 5,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 3,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: false,
          includeMegaCategories: false,
        );
      case YatzyGameVariant.usYahtzee:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.usYahtzee,
          diceCount: customDiceCount ?? 5,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 3,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: false,
          includeMegaCategories: false,
        );
      case YatzyGameVariant.maxi6Dice:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 6,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 3,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: true,
          includeMegaCategories: false,
        );
      case YatzyGameVariant.mega7Dice:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 7,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 4,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: true,
          includeMegaCategories: true,
        );
      case YatzyGameVariant.d8Fantasy:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 6,
          dieSides: customDieSides ?? 8,
          maxRolls: customMaxRolls ?? 4,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: true,
          includeMegaCategories: true,
        );
      case YatzyGameVariant.rpgD20:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 5,
          dieSides: customDieSides ?? 20,
          maxRolls: customMaxRolls ?? 4,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: false,
          includeMegaCategories: true,
        );
      case YatzyGameVariant.turbo4Rolls:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 6,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 4,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: true,
          includeMegaCategories: true,
        );
      case YatzyGameVariant.oneShotHardcore:
        return YatzyGameRules(
          variant: variant,
          region: customRegion ?? YatzyRuleRegion.euScandinavian,
          diceCount: customDiceCount ?? 5,
          dieSides: customDieSides ?? 6,
          maxRolls: customMaxRolls ?? 1,
          upperParCount: customUpperParCount ?? 3,
          includeMaxiCategories: false,
          includeMegaCategories: false,
        );
    }
  }

  YatzyGameRules copyWith({
    YatzyGameVariant? variant,
    YatzyRuleRegion? region,
    int? diceCount,
    int? dieSides,
    int? maxRolls,
    int? upperParCount,
    bool? includeMaxiCategories,
    bool? includeMegaCategories,
  }) {
    return YatzyGameRules(
      variant: variant ?? this.variant,
      region: region ?? this.region,
      diceCount: diceCount ?? this.diceCount,
      dieSides: dieSides ?? this.dieSides,
      maxRolls: maxRolls ?? this.maxRolls,
      upperParCount: upperParCount ?? this.upperParCount,
      includeMaxiCategories:
          includeMaxiCategories ?? this.includeMaxiCategories,
      includeMegaCategories:
          includeMegaCategories ?? this.includeMegaCategories,
    );
  }

  List<YatzyCategory> get activeCategories {
    return YatzyCategory.values.where((c) {
      if (c.isUpper) {
        if (dieSides == 20) {
          return c.upperFace! <= 10 || c.upperFace == 20;
        }
        return c.upperFace! <= dieSides;
      }
      if (region == YatzyRuleRegion.usYahtzee) {
        if (c == YatzyCategory.onePair || c == YatzyCategory.twoPairs) {
          return false;
        }
      }
      if (diceCount == 3) {
        if (c == YatzyCategory.twoPairs ||
            c == YatzyCategory.fourOfAKind ||
            c == YatzyCategory.fullHouse ||
            c == YatzyCategory.largeStraight) {
          return false;
        }
        if (c == YatzyCategory.evenOnly || c == YatzyCategory.oddOnly) {
          return true;
        }
      }
      if (diceCount == 4) {
        if (c == YatzyCategory.fourOfAKind || c == YatzyCategory.fullHouse) {
          return false;
        }
        if (c == YatzyCategory.evenOnly || c == YatzyCategory.oddOnly) {
          return true;
        }
      }
      if (c == YatzyCategory.royalStraight) {
        return dieSides >= 8 && (includeMegaCategories || diceCount >= 6);
      }
      if (c == YatzyCategory.sixOfAKind) {
        return includeMegaCategories && diceCount >= 6;
      }
      if (c.isMegaOnly) {
        return includeMegaCategories;
      }
      if (c.isMaxiOnly) {
        return includeMaxiCategories || diceCount >= 6;
      }
      return true;
    }).toList();
  }

  List<YatzyCategory> get upperCategories =>
      activeCategories.where((c) => c.isUpper).toList();

  List<YatzyCategory> get lowerCategories =>
      activeCategories.where((c) => !c.isUpper).toList();

  /// Sum of face values in the active upper section (21 for d6 1..6, 36 for d8 1..8).
  int get sumOfUpperFaces =>
      upperCategories.fold(0, (sum, c) => sum + c.upperFace!);

  /// Total par points in the upper section (e.g. 63 for 3×d6, 84 for 4×d6, 108 for 3×d8).
  int get upperParTotal => upperParCount * sumOfUpperFaces;

  /// Upper section bonus points (+50 for EU Scandinavian, +35 for US Yahtzee).
  int get upperBonusPoints =>
      region == YatzyRuleRegion.usYahtzee ? 35 : 50;
}

enum YatzyCategory {
  // Upper section (1..12 + Nat 20s)
  ones('Ones', '1s', 'Count 1s', true, 1, false, false),
  twos('Twos', '2s', 'Count 2s', true, 2, false, false),
  threes('Threes', '3s', 'Count 3s', true, 3, false, false),
  fours('Fours', '4s', 'Count 4s', true, 4, false, false),
  fives('Fives', '5s', 'Count 5s', true, 5, false, false),
  sixes('Sixes', '6s', 'Count 6s', true, 6, false, false),
  sevens('Sevens', '7s', 'Count 7s', true, 7, false, false),
  eights('Eights', '8s', 'Count 8s', true, 8, false, false),
  nines('Nines', '9s', 'Count 9s', true, 9, false, false),
  tens('Tens', '10s', 'Count 10s', true, 10, false, false),
  elevens('Elevens', '11s', 'Count 11s', true, 11, false, false),
  twelves('Twelves', '12s', 'Count 12s', true, 12, false, false),
  twenties('Nat 20s', 'Nat 20s', 'Count 20s (Critical Hit!)', true, 20, false, false),

  // Lower section
  onePair(
    'One Pair',
    '1 Pair',
    '2 of same kind (sum of those 2 dice)',
    false,
    null,
    false,
    false,
  ),
  twoPairs(
    'Two Pairs',
    '2 Pairs',
    '2 distinct pairs (sum of those 4 dice)',
    false,
    null,
    false,
    false,
  ),
  threePairs(
    'Three Pairs',
    '3 Pairs',
    '3 distinct pairs (sum of all 6 dice)',
    false,
    null,
    true,
    false,
  ),
  threeOfAKind(
    'Three of a Kind',
    '3 Kind',
    '3 of same kind (sum of those 3 dice)',
    false,
    null,
    false,
    false,
  ),
  fourOfAKind(
    'Four of a Kind',
    '4 Kind',
    '4 of same kind (sum of those 4 dice)',
    false,
    null,
    false,
    false,
  ),
  fiveOfAKind(
    'Five of a Kind',
    '5 Kind',
    '5 of same kind (sum of those 5 dice)',
    false,
    null,
    true,
    false,
  ),
  sixOfAKind(
    'Six of a Kind',
    '6 Kind',
    '6 of same kind (sum of those 6 dice)',
    false,
    null,
    false,
    true,
  ),
  smallStraight(
    'Small Straight',
    'Sm. Straight',
    '1-2-3-4-5 (15 points)',
    false,
    null,
    false,
    false,
  ),
  largeStraight(
    'Large Straight',
    'Lg. Straight',
    '2-3-4-5-6 (20 points)',
    false,
    null,
    false,
    false,
  ),
  fullStraight(
    'Full Straight',
    'Full Straight',
    '1-2-3-4-5-6 (21 points)',
    false,
    null,
    true,
    false,
  ),
  royalStraight(
    'Royal Straight',
    'Royal Str.',
    '6 consecutive faces e.g. 3-4-5-6-7-8 (30 points)',
    false,
    null,
    false,
    true,
  ),
  fullHouse(
    'Full House',
    'Full House',
    '3 of one kind + 2 of another (sum of 5 dice)',
    false,
    null,
    false,
    false,
  ),
  villa(
    'Villa (2×3 Kind)',
    'Villa',
    '3 of one kind + 3 of another (sum of 6 dice)',
    false,
    null,
    true,
    false,
  ),
  tower(
    'Tower (4+2 Kind)',
    'Tower',
    '4 of one kind + 2 of another (sum of 6 dice)',
    false,
    null,
    true,
    false,
  ),
  pyramid(
    'Pyramid (3+2+1)',
    'Pyramid',
    '3 of one + 2 of another + 1 of a third (sum of 6 dice)',
    false,
    null,
    false,
    true,
  ),
  evenOnly(
    'Even Only',
    'Even Only',
    'All dice show even numbers (sum of all dice)',
    false,
    null,
    false,
    true,
  ),
  oddOnly(
    'Odd Only',
    'Odd Only',
    'All dice show odd numbers (sum of all dice)',
    false,
    null,
    false,
    true,
  ),
  chance(
    'Chance',
    'Chance',
    'Any combination (sum of all dice)',
    false,
    null,
    false,
    false,
  ),
  yatzy(
    'Yatzy',
    'Yatzy',
    'All dice of same kind (50 points regardless of face)',
    false,
    null,
    false,
    false,
  ),
  superYatzy(
    'Super Yatzy',
    'Super Yatzy',
    'All dice of same kind (75 bonus points!)',
    false,
    null,
    false,
    true,
  );

  final String label;
  final String shortLabel;
  final String description;
  final bool isUpper;
  final int? upperFace;
  final bool isMaxiOnly;
  final bool isMegaOnly;

  const YatzyCategory(
    this.label,
    this.shortLabel,
    this.description,
    this.isUpper,
    this.upperFace,
    this.isMaxiOnly,
    this.isMegaOnly,
  );
}

class YatzyScorer {
  /// Computes the score to store and display for a given category and dice list.
  static int calculateScore(
    YatzyCategory category,
    List<int> dice, {
    int upperParCount = 3,
    YatzyRuleRegion region = YatzyRuleRegion.euScandinavian,
  }) {
    final counts = <int, int>{};
    for (final d in dice) {
      counts[d] = (counts[d] ?? 0) + 1;
    }

    if (category.isUpper) {
      final face = category.upperFace!;
      final count = counts[face] ?? 0;
      final rawPoints = count * face;
      final parPoints = upperParCount * face;
      return rawPoints - parPoints;
    }

    switch (category) {
      case YatzyCategory.onePair:
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 2) {
            return face * 2;
          }
        }
        return 0;

      case YatzyCategory.twoPairs:
        final pairs = <int>[];
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 2) {
            pairs.add(face);
          }
        }
        if (pairs.length >= 2) {
          return pairs[0] * 2 + pairs[1] * 2;
        }
        return 0;

      case YatzyCategory.threePairs:
        final pairs = <int>[];
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 2) {
            pairs.add(face);
          }
        }
        if (pairs.length >= 3) {
          return pairs[0] * 2 + pairs[1] * 2 + pairs[2] * 2;
        }
        return 0;

      case YatzyCategory.threeOfAKind:
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 3) {
            if (region == YatzyRuleRegion.usYahtzee) {
              return dice.fold(0, (sum, d) => sum + d);
            }
            return face * 3;
          }
        }
        return 0;

      case YatzyCategory.fourOfAKind:
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 4) {
            if (region == YatzyRuleRegion.usYahtzee) {
              return dice.fold(0, (sum, d) => sum + d);
            }
            return face * 4;
          }
        }
        return 0;

      case YatzyCategory.fiveOfAKind:
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 5) {
            return face * 5;
          }
        }
        return 0;

      case YatzyCategory.sixOfAKind:
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 6) {
            return face * 6;
          }
        }
        return 0;

      case YatzyCategory.smallStraight:
        if (dice.length == 3) {
          for (int start = 1; start <= 18; start++) {
            if ((counts[start] ?? 0) >= 1 &&
                (counts[start + 1] ?? 0) >= 1 &&
                (counts[start + 2] ?? 0) >= 1) {
              return 12;
            }
          }
          return 0;
        }
        if (region == YatzyRuleRegion.usYahtzee) {
          // US Yahtzee Small Straight: any 4 consecutive faces = 30 points
          for (int start = 1; start <= 17; start++) {
            if ((counts[start] ?? 0) >= 1 &&
                (counts[start + 1] ?? 0) >= 1 &&
                (counts[start + 2] ?? 0) >= 1 &&
                (counts[start + 3] ?? 0) >= 1) {
              return 30;
            }
          }
          return 0;
        }
        if (dice.length == 4) {
          if ((counts[1] ?? 0) >= 1 &&
              (counts[2] ?? 0) >= 1 &&
              (counts[3] ?? 0) >= 1 &&
              (counts[4] ?? 0) >= 1) {
            return 10;
          }
          if ((counts[2] ?? 0) >= 1 &&
              (counts[3] ?? 0) >= 1 &&
              (counts[4] ?? 0) >= 1 &&
              (counts[5] ?? 0) >= 1) {
            return 14;
          }
          return 0;
        }
        if ((counts[1] ?? 0) >= 1 &&
            (counts[2] ?? 0) >= 1 &&
            (counts[3] ?? 0) >= 1 &&
            (counts[4] ?? 0) >= 1 &&
            (counts[5] ?? 0) >= 1) {
          return 15;
        }
        return 0;

      case YatzyCategory.largeStraight:
        if (region == YatzyRuleRegion.usYahtzee) {
          // US Yahtzee Large Straight: any 5 consecutive faces = 40 points
          for (int start = 1; start <= 16; start++) {
            if ((counts[start] ?? 0) >= 1 &&
                (counts[start + 1] ?? 0) >= 1 &&
                (counts[start + 2] ?? 0) >= 1 &&
                (counts[start + 3] ?? 0) >= 1 &&
                (counts[start + 4] ?? 0) >= 1) {
              return 40;
            }
          }
          return 0;
        }
        if (dice.length == 4) {
          if ((counts[3] ?? 0) >= 1 &&
              (counts[4] ?? 0) >= 1 &&
              (counts[5] ?? 0) >= 1 &&
              (counts[6] ?? 0) >= 1) {
            return 18;
          }
          if ((counts[2] ?? 0) >= 1 &&
              (counts[3] ?? 0) >= 1 &&
              (counts[4] ?? 0) >= 1 &&
              (counts[5] ?? 0) >= 1) {
            return 14;
          }
          return 0;
        }
        // Standard 5 consecutive starting at 2..6 (20p), or higher on d8/d10/d12/d20
        for (int start = 16; start >= 2; start--) {
          if ((counts[start] ?? 0) >= 1 &&
              (counts[start + 1] ?? 0) >= 1 &&
              (counts[start + 2] ?? 0) >= 1 &&
              (counts[start + 3] ?? 0) >= 1 &&
              (counts[start + 4] ?? 0) >= 1) {
            return start * 5 + 10;
          }
        }
        return 0;

      case YatzyCategory.fullStraight:
        if ((counts[1] ?? 0) >= 1 &&
            (counts[2] ?? 0) >= 1 &&
            (counts[3] ?? 0) >= 1 &&
            (counts[4] ?? 0) >= 1 &&
            (counts[5] ?? 0) >= 1 &&
            (counts[6] ?? 0) >= 1) {
          return 21;
        }
        return 0;

      case YatzyCategory.royalStraight:
        // Any 6 consecutive faces -> 30 points
        for (int start = 15; start >= 1; start--) {
          bool ok = true;
          for (int offset = 0; offset < 6; offset++) {
            if ((counts[start + offset] ?? 0) < 1) {
              ok = false;
              break;
            }
          }
          if (ok) return 30;
        }
        return 0;

      case YatzyCategory.fullHouse:
        int best = 0;
        for (int faceA = 20; faceA >= 1; faceA--) {
          if ((counts[faceA] ?? 0) >= 3) {
            for (int faceB = 20; faceB >= 1; faceB--) {
              if (faceB != faceA && (counts[faceB] ?? 0) >= 2) {
                if (region == YatzyRuleRegion.usYahtzee) {
                  return 25;
                }
                final sum = faceA * 3 + faceB * 2;
                if (sum > best) best = sum;
              }
            }
          }
        }
        return best;

      case YatzyCategory.villa:
        final triples = <int>[];
        for (int face = 20; face >= 1; face--) {
          if ((counts[face] ?? 0) >= 3) {
            triples.add(face);
          }
        }
        if (triples.length >= 2) {
          return triples[0] * 3 + triples[1] * 3;
        }
        return 0;

      case YatzyCategory.tower:
        int best = 0;
        for (int faceA = 20; faceA >= 1; faceA--) {
          if ((counts[faceA] ?? 0) >= 4) {
            for (int faceB = 20; faceB >= 1; faceB--) {
              if (faceB != faceA && (counts[faceB] ?? 0) >= 2) {
                final sum = faceA * 4 + faceB * 2;
                if (sum > best) best = sum;
              }
            }
          }
        }
        return best;

      case YatzyCategory.pyramid:
        int best = 0;
        for (int faceA = 20; faceA >= 1; faceA--) {
          if ((counts[faceA] ?? 0) >= 3) {
            for (int faceB = 20; faceB >= 1; faceB--) {
              if (faceB != faceA && (counts[faceB] ?? 0) >= 2) {
                for (int faceC = 20; faceC >= 1; faceC--) {
                  if (faceC != faceA &&
                      faceC != faceB &&
                      (counts[faceC] ?? 0) >= 1) {
                    final sum = faceA * 3 + faceB * 2 + faceC;
                    if (sum > best) best = sum;
                  }
                }
              }
            }
          }
        }
        return best;

      case YatzyCategory.evenOnly:
        if (dice.isNotEmpty && dice.every((d) => d % 2 == 0)) {
          return dice.fold(0, (sum, d) => sum + d);
        }
        return 0;

      case YatzyCategory.oddOnly:
        if (dice.isNotEmpty && dice.every((d) => d % 2 != 0)) {
          return dice.fold(0, (sum, d) => sum + d);
        }
        return 0;

      case YatzyCategory.chance:
        return dice.fold(0, (sum, d) => sum + d);

      case YatzyCategory.yatzy:
        if (dice.isNotEmpty && counts.values.any((c) => c == dice.length)) {
          return 50;
        }
        return 0;

      case YatzyCategory.superYatzy:
        if (dice.isNotEmpty && counts.values.any((c) => c == dice.length)) {
          return 75;
        }
        return 0;

      default:
        return 0;
    }
  }

  /// Formats a score for display in a cell.
  static String formatScore(YatzyCategory category, int score) {
    if (category.isUpper) {
      if (score > 0) return '+$score';
      if (score == 0) return '0';
      return '$score';
    }
    return '$score';
  }
}

class PlayerScorecard {
  final String id;
  String name;
  final Map<YatzyCategory, int> scores;
  final YatzyGameRules rules;

  PlayerScorecard({
    required this.id,
    required this.name,
    this.rules = const YatzyGameRules(),
    Map<YatzyCategory, int>? scores,
  }) : scores = scores ?? {};

  PlayerScorecard copyWith({
    String? name,
    YatzyGameRules? rules,
    Map<YatzyCategory, int>? scores,
  }) {
    return PlayerScorecard(
      id: id,
      name: name ?? this.name,
      rules: rules ?? this.rules,
      scores: scores ?? Map<YatzyCategory, int>.from(this.scores),
    );
  }

  bool isFilled(YatzyCategory category) => scores.containsKey(category);

  bool get isComplete => scores.length == rules.activeCategories.length;

  /// Count of filled upper section categories.
  int get filledUpperCount =>
      rules.upperCategories.where((c) => scores.containsKey(c)).length;

  /// Sum of relative +/- scores for all filled upper categories.
  int get upperDiffSum {
    int sum = 0;
    for (final cat in rules.upperCategories) {
      if (scores.containsKey(cat)) {
        sum += scores[cat]!;
      }
    }
    return sum;
  }

  /// Actual raw points accumulated in the upper section so far.
  int get rawUpperPoints {
    int sum = 0;
    for (final cat in rules.upperCategories) {
      if (scores.containsKey(cat)) {
        final par = rules.upperParCount * cat.upperFace!;
        sum += par + scores[cat]!;
      }
    }
    return sum;
  }

  /// Whether the player has earned the upper section bonus (+50 EU / +35 US).
  bool get hasEarnedBonus {
    if (rawUpperPoints >= rules.upperParTotal) return true;
    if (filledUpperCount == rules.upperCategories.length &&
        upperDiffSum >= 0) {
      return true;
    }
    return false;
  }

  /// Whether the player can still mathematically earn the bonus.
  bool get canStillEarnBonus {
    if (hasEarnedBonus) return true;
    int maxRemainingRaw = 0;
    for (final cat in rules.upperCategories) {
      if (!scores.containsKey(cat)) {
        maxRemainingRaw += rules.diceCount * cat.upperFace!;
      }
    }
    return (rawUpperPoints + maxRemainingRaw) >= rules.upperParTotal;
  }

  /// Bonus points (50 for EU / 35 for US if earned, 0 otherwise).
  int get bonusPoints => hasEarnedBonus ? rules.upperBonusPoints : 0;

  /// Sum of all filled lower section categories.
  int get lowerSectionSum {
    int sum = 0;
    for (final cat in rules.lowerCategories) {
      if (scores.containsKey(cat)) {
        sum += scores[cat]!;
      }
    }
    return sum;
  }

  /// Grand Total: `parTotal + upperDiffSum + bonus + lowerSectionSum` when complete.
  int get grandTotal {
    if (filledUpperCount == rules.upperCategories.length) {
      return rules.upperParTotal + upperDiffSum + bonusPoints + lowerSectionSum;
    }
    return rawUpperPoints + bonusPoints + lowerSectionSum;
  }

  /// Formula directly using `parTotal + upper_diff_sum + bonus + lower_section` even mid-game.
  int get formulaGrandTotal =>
      rules.upperParTotal + upperDiffSum + bonusPoints + lowerSectionSum;
}

class DieState {
  final int value; // 1..8
  final bool isHeld;
  final double wobbleAngle;

  const DieState({
    required this.value,
    this.isHeld = false,
    this.wobbleAngle = 0.0,
  });

  DieState copyWith({
    int? value,
    bool? isHeld,
    double? wobbleAngle,
  }) {
    return DieState(
      value: value ?? this.value,
      isHeld: isHeld ?? this.isHeld,
      wobbleAngle: wobbleAngle ?? this.wobbleAngle,
    );
  }
}

class TurnUndoSnapshot {
  final int playerIndex;
  final YatzyCategory assignedCategory;
  final int assignedScore;
  final List<DieState> diceBeforeAssignment;
  final int rollsUsedBeforeAssignment;

  const TurnUndoSnapshot({
    required this.playerIndex,
    required this.assignedCategory,
    required this.assignedScore,
    required this.diceBeforeAssignment,
    required this.rollsUsedBeforeAssignment,
  });
}
