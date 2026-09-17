import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import 'pencil_painters.dart';

class RulesDialog extends StatelessWidget {
  final AppStrings strings;

  const RulesDialog({
    super.key,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final sections = strings.rulesSections;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 640),
        child: PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperBg,
          doubleBorder: true,
          strokeWidth: 1.8,
          overshoot: 3.0,
          seed: 666,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          color: PencilPalette.graphiteDark,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strings.rulesDialogTitle,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.patrickHand(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: PencilPalette.graphiteDark,
                            ),
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
              const Divider(color: PencilPalette.graphiteFaint),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < sections.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        _sectionTitle(sections[i].title),
                        for (final bullet in sections[i].bullets)
                          _bullet(bullet),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: GoogleFonts.patrickHand(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: PencilPalette.bluePencil,
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 6),
      child: Text(
        '• $text',
        style: GoogleFonts.patrickHand(
          fontSize: 15.5,
          color: PencilPalette.graphiteDark,
          height: 1.25,
        ),
      ),
    );
  }
}
