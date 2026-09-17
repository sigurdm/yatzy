import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import 'pencil_painters.dart';

class LanguageSelectorDialog extends StatelessWidget {
  final AppLocale currentLocale;
  final ValueChanged<AppLocale> onSelectLocale;
  final AppStrings strings;

  const LanguageSelectorDialog({
    super.key,
    required this.currentLocale,
    required this.onSelectLocale,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 580),
        child: PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperBg,
          doubleBorder: true,
          strokeWidth: 1.8,
          overshoot: 3.0,
          seed: 707,
          padding: const EdgeInsets.all(18),
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
                        Icons.language_rounded,
                        color: PencilPalette.graphiteDark,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        strings.languageDialogTitle,
                        style: GoogleFonts.patrickHand(
                          fontSize: 24,
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
              const Divider(color: PencilPalette.graphiteFaint, height: 14),
              // Grid of languages
              Flexible(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3.1,
                    ),
                    itemCount: AppLocale.values.length,
                    itemBuilder: (context, index) {
                      final loc = AppLocale.values[index];
                      final isSelected = loc == currentLocale;
                      return GestureDetector(
                        onTap: () {
                          onSelectLocale(loc);
                          Navigator.of(context).pop();
                        },
                        child: PencilBox(
                          borderColor: isSelected
                              ? PencilPalette.bluePencil
                              : PencilPalette.graphiteLight,
                          fillColor: isSelected
                              ? PencilPalette.yellowHighlighter
                                  .withValues(alpha: 0.45)
                              : PencilPalette.paperCard,
                          strokeWidth: isSelected ? 1.8 : 1.1,
                          seed: 900 + index,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              Text(
                                loc.flag,
                                style: const TextStyle(fontSize: 19),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  loc.nativeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.patrickHand(
                                    fontSize: 17,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: PencilPalette.graphiteDark,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 17,
                                  color: PencilPalette.bluePencil,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
