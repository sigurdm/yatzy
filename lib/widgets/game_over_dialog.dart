import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/yatzy_models.dart';
import 'pencil_painters.dart';

class GameOverDialog extends StatelessWidget {
  final List<PlayerScorecard> players;
  final VoidCallback onRematch;
  final AppStrings strings;

  const GameOverDialog({
    super.key,
    required this.players,
    required this.onRematch,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List<PlayerScorecard>.from(players)
      ..sort((a, b) => b.grandTotal.compareTo(a.grandTotal));

    final highestScore = sortedPlayers.first.grandTotal;
    final winners =
        sortedPlayers.where((p) => p.grandTotal == highestScore).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: PencilBox(
          borderColor: PencilPalette.graphiteDark,
          fillColor: PencilPalette.paperBg,
          doubleBorder: true,
          strokeWidth: 2.0,
          overshoot: 3.5,
          seed: 444,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trophy & Winner Header
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(84, 84),
                    painter: PencilCirclePainter(
                      color: PencilPalette.orangePencil,
                      strokeWidth: 2.4,
                      seed: 12,
                    ),
                  ),
                  const Icon(
                    Icons.emoji_events_outlined,
                    size: 46,
                    color: PencilPalette.orangePencil,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                winners.length > 1
                    ? strings.tieHeader(winners.map((w) => w.name).join(' & '))
                    : strings.winnerHeader(winners.first.name),
                textAlign: TextAlign.center,
                style: GoogleFonts.patrickHand(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: PencilPalette.graphiteDark,
                ),
              ),
              Text(
                strings.finalStandingsSub,
                style: GoogleFonts.patrickHand(
                  fontSize: 17,
                  color: PencilPalette.graphiteMedium,
                ),
              ),
              const SizedBox(height: 16),

              // Standings Table
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: sortedPlayers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final player = sortedPlayers[index];
                    final isWinner = player.grandTotal == highestScore;
                    final diffStr = player.upperDiffSum >= 0
                        ? '+${player.upperDiffSum}'
                        : '${player.upperDiffSum}';

                    return PencilBox(
                      borderColor: isWinner
                          ? PencilPalette.orangePencil
                          : PencilPalette.graphiteMedium,
                      fillColor: isWinner
                          ? PencilPalette.yellowHighlighter.withValues(alpha: 0.35)
                          : PencilPalette.paperCard,
                      strokeWidth: isWinner ? 1.8 : 1.2,
                      seed: 500 + index,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '#${index + 1}',
                            style: GoogleFonts.patrickHand(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: isWinner
                                  ? PencilPalette.orangePencil
                                  : PencilPalette.graphiteMedium,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: GoogleFonts.patrickHand(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: PencilPalette.graphiteDark,
                                  ),
                                ),
                                Text(
                                  strings.playerBreakdownLine(
                                    player.rules.upperParTotal,
                                    diffStr,
                                    player.bonusPoints,
                                    player.lowerSectionSum,
                                  ),
                                  style: GoogleFonts.patrickHand(
                                    fontSize: 13.5,
                                    color: PencilPalette.graphiteMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${player.grandTotal} p',
                            style: GoogleFonts.patrickHand(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: PencilPalette.bluePencil,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      strings.inspectScorecard,
                      style: GoogleFonts.patrickHand(
                        fontSize: 18,
                        color: PencilPalette.graphiteMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onRematch();
                    },
                    child: PencilBox(
                      borderColor: PencilPalette.greenPencil,
                      fillColor: const Color(0xFFEAF6EC),
                      hasPencilShading: true,
                      strokeWidth: 1.8,
                      seed: 777,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.replay_rounded,
                            color: PencilPalette.greenPencil,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            strings.playAgainRematch,
                            style: GoogleFonts.patrickHand(
                              fontSize: 19,
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
}
