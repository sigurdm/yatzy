import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/yatzy_models.dart';
import 'pencil_painters.dart';

class GameVariantPickerDialog extends StatelessWidget {
  final YatzyGameVariant currentVariant;
  final AppStrings strings;

  const GameVariantPickerDialog({
    super.key,
    required this.currentVariant,
    required this.strings,
  });

  static Future<YatzyGameVariant?> show(
    BuildContext context, {
    required YatzyGameVariant currentVariant,
    required AppStrings strings,
  }) {
    return showDialog<YatzyGameVariant>(
      context: context,
      builder: (ctx) => GameVariantPickerDialog(
        currentVariant: currentVariant,
        strings: strings,
      ),
    );
  }

  IconData _iconForVariant(YatzyGameVariant variant) {
    switch (variant) {
      case YatzyGameVariant.mini4Dice:
        return Icons.filter_4_rounded;
      case YatzyGameVariant.classic5Dice:
        return Icons.casino_outlined;
      case YatzyGameVariant.usYahtzee:
        return Icons.flag_outlined;
      case YatzyGameVariant.maxi6Dice:
        return Icons.grid_view_rounded;
      case YatzyGameVariant.mega7Dice:
        return Icons.auto_awesome_outlined;
      case YatzyGameVariant.d8Fantasy:
        return Icons.diamond_outlined;
      case YatzyGameVariant.rpgD20:
        return Icons.hexagon_outlined;
      case YatzyGameVariant.turbo4Rolls:
        return Icons.bolt_rounded;
      case YatzyGameVariant.oneShotHardcore:
        return Icons.whatshot_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 680),
        child: PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperBg,
          hasPencilShading: true,
          shadingOpacity: 0.05,
          strokeWidth: 2.2,
          overshoot: 3.5,
          seed: 719,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dialog Header
              Row(
                children: [
                  const Icon(
                    Icons.casino_outlined,
                    color: PencilPalette.bluePencil,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.selectGameTypeDialogTitle,
                          style: GoogleFonts.patrickHand(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: PencilPalette.graphiteDark,
                            height: 1.05,
                          ),
                        ),
                        Text(
                          strings.selectGameTypeDialogSubtitle,
                          style: GoogleFonts.patrickHand(
                            fontSize: 15,
                            color: PencilPalette.graphiteMedium,
                          ),
                        ),
                      ],
                    ),
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
              const SizedBox(height: 12),

              // Variant Cards List
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: YatzyGameVariant.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final variant = YatzyGameVariant.values[index];
                    final isSelected = variant == currentVariant;

                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(variant),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: PencilBox(
                          borderColor: isSelected
                              ? PencilPalette.bluePencil
                              : PencilPalette.graphiteMedium,
                          fillColor: isSelected
                              ? const Color(0xFFEAF2F8)
                              : PencilPalette.paperCard,
                          hasPencilShading: isSelected,
                          shadingOpacity: isSelected ? 0.14 : 0.0,
                          strokeWidth: isSelected ? 2.0 : 1.3,
                          overshoot: 2.0,
                          seed: 800 + index * 13,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _iconForVariant(variant),
                                    size: 20,
                                    color: isSelected
                                        ? PencilPalette.bluePencil
                                        : PencilPalette.graphiteDark,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      strings.variantShortName(variant),
                                      style: GoogleFonts.patrickHand(
                                        fontSize: 19.5,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? PencilPalette.bluePencil
                                            : PencilPalette.graphiteDark,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? PencilPalette.bluePencil
                                              .withValues(alpha: 0.14)
                                          : PencilPalette.yellowHighlighter
                                              .withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isSelected
                                            ? PencilPalette.bluePencil
                                            : PencilPalette.graphiteLight,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      strings.variantSpecsBadge(variant),
                                      style: GoogleFonts.patrickHand(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? PencilPalette.bluePencil
                                            : PencilPalette.graphiteDark,
                                      ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 20,
                                      color: PencilPalette.bluePencil,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                strings.variantExplanation(variant),
                                style: GoogleFonts.patrickHand(
                                  fontSize: 15,
                                  height: 1.25,
                                  color: PencilPalette.graphiteDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
