import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/yatzy_models.dart';
import 'game_variant_picker_dialog.dart';
import 'pencil_painters.dart';

class PlayerSetupDialog extends StatefulWidget {
  final List<String> initialPlayerNames;
  final YatzyGameRules initialRules;
  final void Function(
    List<String> newNames,
    YatzyGameRules newRules,
    bool resetScores,
  ) onApply;
  final AppStrings strings;

  const PlayerSetupDialog({
    super.key,
    required this.initialPlayerNames,
    required this.initialRules,
    required this.onApply,
    required this.strings,
  });

  @override
  State<PlayerSetupDialog> createState() => _PlayerSetupDialogState();
}

class _PlayerSetupDialogState extends State<PlayerSetupDialog> {
  late List<TextEditingController> _controllers;
  late YatzyGameVariant _selectedVariant;
  late YatzyRuleRegion _selectedRegion;
  late int _selectedDiceCount;
  late int _selectedDieSides;
  late int _selectedMaxRolls;
  late int _selectedUpperParCount;

  @override
  void initState() {
    super.initState();
    _controllers = widget.initialPlayerNames
        .map((name) => TextEditingController(text: name))
        .toList();
    _selectedVariant = widget.initialRules.variant;
    _selectedRegion = widget.initialRules.region;
    _selectedDiceCount = widget.initialRules.diceCount;
    _selectedDieSides = widget.initialRules.dieSides;
    _selectedMaxRolls = widget.initialRules.maxRolls;
    _selectedUpperParCount = widget.initialRules.upperParCount;
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectPresetVariant(YatzyGameVariant variant) {
    final preset = YatzyGameRules.fromVariant(variant);
    setState(() {
      _selectedVariant = variant;
      _selectedRegion = preset.region;
      _selectedDiceCount = preset.diceCount;
      _selectedDieSides = preset.dieSides;
      _selectedMaxRolls = preset.maxRolls;
      _selectedUpperParCount = preset.upperParCount;
    });
  }

  void _addPlayer() {
    setState(() {
      final num = _controllers.length;
      _controllers.add(
        TextEditingController(text: widget.strings.defaultPlayerName(num)),
      );
    });
  }

  void _removePlayer(int index) {
    if (_controllers.length <= 1) return;
    setState(() {
      final c = _controllers.removeAt(index);
      c.dispose();
    });
  }

  List<String> _getCleanNames() {
    final names = <String>[];
    for (int i = 0; i < _controllers.length; i++) {
      final raw = _controllers[i].text.trim();
      names.add(
        raw.isEmpty ? widget.strings.defaultPlayerName(i) : raw,
      );
    }
    return names;
  }

  YatzyGameRules _buildSelectedRules() {
    return YatzyGameRules.fromVariant(
      _selectedVariant,
      customRegion: _selectedRegion,
      customDiceCount: _selectedDiceCount,
      customDieSides: _selectedDieSides,
      customMaxRolls: _selectedMaxRolls,
      customUpperParCount: _selectedUpperParCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final currentBuilt = _buildSelectedRules();
    final rulesChanged = currentBuilt.variant != widget.initialRules.variant ||
        currentBuilt.region != widget.initialRules.region ||
        currentBuilt.diceCount != widget.initialRules.diceCount ||
        currentBuilt.dieSides != widget.initialRules.dieSides ||
        currentBuilt.maxRolls != widget.initialRules.maxRolls ||
        currentBuilt.upperParCount != widget.initialRules.upperParCount;

    final sumOfFaces = _selectedDieSides == 20
        ? 41
        : (_selectedDieSides * (_selectedDieSides + 1)) ~/ 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 720),
        child: PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperBg,
          doubleBorder: true,
          strokeWidth: 1.8,
          overshoot: 3.0,
          seed: 55,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        color: PencilPalette.graphiteDark,
                        size: 23,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.playersDialogTitle,
                        style: GoogleFonts.patrickHand(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.graphiteDark,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: PencilPalette.graphiteDark,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: PencilPalette.graphiteFaint, height: 10),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Game Variant Dropdown with Explanation Card
                      Text(
                        s.gameVariantLabel,
                        style: GoogleFonts.patrickHand(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.bluePencil,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildVariantDropdownButton(s),
                      const SizedBox(height: 6),
                      PencilBox(
                        borderColor: PencilPalette.graphiteLight,
                        fillColor: PencilPalette.yellowHighlighter
                            .withValues(alpha: 0.25),
                        strokeWidth: 1.1,
                        seed: 391,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 17,
                                color: PencilPalette.bluePencil,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                s.variantExplanation(_selectedVariant),
                                style: GoogleFonts.patrickHand(
                                  fontSize: 14.5,
                                  height: 1.25,
                                  color: PencilPalette.graphiteDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 2. Customize Knobs (Dice Count, Die Sides, Rolls per Turn)
                      Text(
                        s.customRulesSectionLabel,
                        style: GoogleFonts.patrickHand(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.bluePencil,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Rule Style: EU / Scandinavian vs US / Yahtzee
                      Text(
                        s.ruleRegionSettingLabel,
                        style: GoogleFonts.patrickHand(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.graphiteDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      for (final reg in YatzyRuleRegion.values) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: _buildChipChoice(
                            label: s.ruleRegionOptionLabel(reg),
                            selected: _selectedRegion == reg,
                            onTap: () => setState(() {
                              _selectedRegion = reg;
                            }),
                            seed: 580 + reg.index,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),

                      // Dice Count: 3, 4, 5, 6, 7, 8
                      Row(
                        children: [
                          SizedBox(
                            width: 115,
                            child: Text(
                              s.diceCountSettingLabel,
                              style: GoogleFonts.patrickHand(
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                                color: PencilPalette.graphiteDark,
                              ),
                            ),
                          ),
                          for (final cnt in [3, 4, 5, 6, 7, 8]) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: _buildChipChoice(
                                  label: '$cnt',
                                  selected: _selectedDiceCount == cnt,
                                  onTap: () => setState(() {
                                    _selectedDiceCount = cnt;
                                    if (cnt <= 4) {
                                      _selectedUpperParCount = 2;
                                    }
                                  }),
                                  seed: 600 + cnt,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Die Sides: d4, d6, d8, d10, d12, d20
                      Text(
                        s.dieSidesSettingLabel,
                        style: GoogleFonts.patrickHand(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.graphiteDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final sides in [4, 6, 8, 10, 12, 20])
                            SizedBox(
                              width: 155,
                              child: _buildChipChoice(
                                label: s.dieSidesOptionLabel(sides),
                                selected: _selectedDieSides == sides,
                                onTap: () => setState(() {
                                  _selectedDieSides = sides;
                                }),
                                seed: 620 + sides,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Max Rolls: 1, 2, 3, 4, 5
                      Text(
                        s.maxRollsSettingLabel,
                        style: GoogleFonts.patrickHand(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.graphiteDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          for (final r in [1, 2, 3, 4, 5]) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: _buildChipChoice(
                                  label: r == 1 ? '1r!' : '${r}r',
                                  selected: _selectedMaxRolls == r,
                                  onTap: () => setState(() {
                                    _selectedMaxRolls = r;
                                    if (r == 1) {
                                      _selectedUpperParCount = 2;
                                    }
                                  }),
                                  seed: 640 + r,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),

                      // 3. Upper Section Par Setting (± around 2, 3, or 4 of a kind)
                      Text(
                        s.upperParSettingLabel,
                        style: GoogleFonts.patrickHand(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.bluePencil,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _buildParOption(2, sumOfFaces, s),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildParOption(3, sumOfFaces, s),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildParOption(4, sumOfFaces, s),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(
                        color: PencilPalette.graphiteFaint,
                        height: 10,
                      ),

                      // 4. Players Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${s.playersSectionLabel} (${_controllers.length})',
                            style: GoogleFonts.patrickHand(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: PencilPalette.bluePencil,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addPlayer,
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: const Icon(
                              Icons.person_add_alt_1,
                              size: 17,
                              color: PencilPalette.bluePencil,
                            ),
                            label: Text(
                              s.addAnotherPlayer,
                              style: GoogleFonts.patrickHand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: PencilPalette.bluePencil,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controllers.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 28,
                                child: Text(
                                  '#${index + 1}',
                                  style: GoogleFonts.patrickHand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: PencilPalette.graphiteMedium,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: PencilBox(
                                  borderColor: PencilPalette.graphiteMedium,
                                  fillColor: PencilPalette.paperCard,
                                  strokeWidth: 1.2,
                                  seed: 200 + index,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextField(
                                    controller: _controllers[index],
                                    style: GoogleFonts.patrickHand(
                                      fontSize: 17,
                                      color: PencilPalette.graphiteDark,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: s.defaultPlayerName(index),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_controllers.length > 1)
                                IconButton(
                                  tooltip: s.removePlayerTooltip,
                                  onPressed: () => _removePlayer(index),
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    size: 20,
                                    color: PencilPalette.redPencil,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Action Buttons
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 10,
                runSpacing: 8,
                children: [
                  if (!rulesChanged)
                    TextButton(
                      onPressed: () {
                        final names = _getCleanNames();
                        widget.onApply(names, _buildSelectedRules(), false);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        s.updateNamesOnly,
                        style: GoogleFonts.patrickHand(
                          fontSize: 16.5,
                          color: PencilPalette.graphiteMedium,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      final names = _getCleanNames();
                      widget.onApply(names, _buildSelectedRules(), true);
                      Navigator.of(context).pop();
                    },
                    child: PencilBox(
                      borderColor: PencilPalette.greenPencil,
                      fillColor: const Color(0xFFEAF6EC),
                      hasPencilShading: true,
                      strokeWidth: 1.8,
                      seed: 999,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: PencilPalette.greenPencil,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            s.startNewGame,
                            style: GoogleFonts.patrickHand(
                              fontSize: 18.5,
                              fontWeight: FontWeight.bold,
                              color: PencilPalette.greenPencil,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariantDropdownButton(AppStrings s) {
    return GestureDetector(
      onTap: () async {
        final chosen = await GameVariantPickerDialog.show(
          context,
          currentVariant: _selectedVariant,
          strings: s,
        );
        if (chosen != null) {
          _selectPresetVariant(chosen);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: PencilBox(
          borderColor: PencilPalette.bluePencil,
          fillColor: const Color(0xFFEAF2F8),
          hasPencilShading: true,
          shadingOpacity: 0.12,
          strokeWidth: 1.8,
          seed: 310 + _selectedVariant.index,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            children: [
              const Icon(
                Icons.casino_outlined,
                size: 20,
                color: PencilPalette.bluePencil,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.variantShortName(_selectedVariant),
                  style: GoogleFonts.patrickHand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.bluePencil,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: PencilPalette.yellowHighlighter.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: PencilPalette.bluePencil,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  s.variantSpecsBadge(_selectedVariant),
                  style: GoogleFonts.patrickHand(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: PencilPalette.graphiteDark,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_drop_down_circle_outlined,
                size: 20,
                color: PencilPalette.bluePencil,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChipChoice({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required int seed,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: PencilBox(
        borderColor: selected
            ? PencilPalette.bluePencil
            : PencilPalette.graphiteLight,
        fillColor: selected
            ? PencilPalette.yellowHighlighter.withValues(alpha: 0.4)
            : PencilPalette.paperCard,
        strokeWidth: selected ? 1.7 : 1.0,
        seed: seed,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.patrickHand(
              fontSize: 14.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected
                  ? PencilPalette.bluePencil
                  : PencilPalette.graphiteDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParOption(int parCount, int sumOfFaces, AppStrings s) {
    final isSelected = _selectedUpperParCount == parCount;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUpperParCount = parCount;
        });
      },
      child: PencilBox(
        borderColor: isSelected
            ? PencilPalette.bluePencil
            : PencilPalette.graphiteLight,
        fillColor: isSelected
            ? PencilPalette.yellowHighlighter.withValues(alpha: 0.4)
            : PencilPalette.paperCard,
        strokeWidth: isSelected ? 1.7 : 1.1,
        seed: 410 + parCount,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              size: 16,
              color: isSelected
                  ? PencilPalette.bluePencil
                  : PencilPalette.graphiteLight,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                s.upperParOptionLabel(parCount, sumOfFaces: sumOfFaces),
                style: GoogleFonts.patrickHand(
                  fontSize: 14.0,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: PencilPalette.graphiteDark,
                  height: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
