import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/pwa_install_helper.dart';
import 'pencil_painters.dart';

/// Hand-drawn notebook dialog that makes installing Pencily Yatzy as a
/// mobile web-backed app (PWA) effortless on iOS, Android, and Desktop:
/// - Offers 1-Tap Native Install (`beforeinstallprompt`) when supported.
/// - Displays a scannable hand-drawn QR code for switching from Desktop to Phone.
/// - Provides step-by-step visual instructions for iOS Safari ("Share -> Add to Home Screen")
///   and Android Chrome ("Install app / Add to Home screen").
class InstallAppDialog extends StatefulWidget {
  const InstallAppDialog({super.key});

  @override
  State<InstallAppDialog> createState() => _InstallAppDialogState();
}

class _InstallAppDialogState extends State<InstallAppDialog> {
  late String _selectedTab; // 'ios', 'android', or 'qr'
  bool _copiedUrl = false;
  String? _installOutcomeMessage;

  @override
  void initState() {
    super.initState();
    final platform = PwaInstallHelper.platform;
    if (platform == 'ios') {
      _selectedTab = 'ios';
    } else if (platform == 'android') {
      _selectedTab = 'android';
    } else {
      _selectedTab = 'qr';
    }
  }

  Future<void> _handleOneTapInstall() async {
    final result = await PwaInstallHelper.triggerInstall();
    if (!mounted) return;
    setState(() {
      if (result == 'accepted') {
        _installOutcomeMessage =
            'App installed! You can now launch Pencily Yatzy from your Home Screen.';
      } else if (result == 'dismissed') {
        _installOutcomeMessage =
            'Install prompt dismissed. You can also use your browser menu anytime.';
      }
    });
  }

  Future<void> _copyShareUrl(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    setState(() {
      _copiedUrl = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copiedUrl = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shareUrl = PwaInstallHelper.shareUrl;
    final canPrompt = PwaInstallHelper.canPromptInstall;
    final isStandalone = PwaInstallHelper.isStandalone;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: PencilBox(
          fillColor: PencilPalette.paperBg,
          borderColor: PencilPalette.graphiteDark,
          strokeWidth: 2.0,
          seed: 919,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dialog Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          PencilPalette.yellowHighlighter.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: PencilPalette.graphiteDark,
                        width: 1.4,
                      ),
                    ),
                    child: const Icon(
                      Icons.install_mobile_rounded,
                      color: PencilPalette.graphiteDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Install Mobile Web App',
                          style: GoogleFonts.patrickHand(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: PencilPalette.graphiteDark,
                            height: 1.05,
                          ),
                        ),
                        Text(
                          'Full-screen scorecard • Home screen icon • Works offline',
                          style: GoogleFonts.patrickHand(
                            fontSize: 13.5,
                            color: PencilPalette.graphiteMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: PencilPalette.graphiteDark,
                    ),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 1-Tap Native Browser Install Banner (when supported by Chrome/Edge/Android)
              if (canPrompt && !isStandalone) ...[
                GestureDetector(
                  onTap: _handleOneTapInstall,
                  child: PencilBox(
                    fillColor: const Color(0xFFEAF6EC),
                    borderColor: PencilPalette.greenPencil,
                    strokeWidth: 1.8,
                    seed: 404,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.download_for_offline_rounded,
                          color: PencilPalette.greenPencil,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1-Tap Install Ready!',
                                style: GoogleFonts.patrickHand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: PencilPalette.greenPencil,
                                  height: 1.05,
                                ),
                              ),
                              Text(
                                'Tap here to add Pencily Yatzy directly to your device.',
                                style: GoogleFonts.patrickHand(
                                  fontSize: 13.5,
                                  color: PencilPalette.graphiteDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PencilBox(
                          fillColor: PencilPalette.greenPencil,
                          borderColor: PencilPalette.graphiteDark,
                          strokeWidth: 1.3,
                          seed: 405,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          child: Text(
                            'Install Now',
                            style: GoogleFonts.patrickHand(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              if (_installOutcomeMessage != null) ...[
                PencilBox(
                  fillColor:
                      PencilPalette.yellowHighlighter.withValues(alpha: 0.4),
                  borderColor: PencilPalette.graphiteDark,
                  strokeWidth: 1.2,
                  seed: 409,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Text(
                    _installOutcomeMessage!,
                    style: GoogleFonts.patrickHand(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: PencilPalette.graphiteDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Platform Selector Tabs
              Row(
                children: [
                  Expanded(
                    child: _buildTabChip(
                      id: 'qr',
                      icon: Icons.qr_code_2_rounded,
                      label: 'Scan QR',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildTabChip(
                      id: 'ios',
                      icon: Icons.phone_iphone_rounded,
                      label: 'iPhone / iPad',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildTabChip(
                      id: 'android',
                      icon: Icons.phone_android_rounded,
                      label: 'Android',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Scrollable Tab Content
              Flexible(
                child: SingleChildScrollView(
                  child: _selectedTab == 'qr'
                      ? _buildQrSection(shareUrl)
                      : _selectedTab == 'ios'
                          ? _buildIosGuideSection(shareUrl)
                          : _buildAndroidGuideSection(shareUrl),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabChip({
    required String id,
    required IconData icon,
    required String label,
  }) {
    final selected = _selectedTab == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = id),
      child: PencilBox(
        fillColor: selected
            ? PencilPalette.yellowHighlighter.withValues(alpha: 0.65)
            : PencilPalette.paperCard,
        borderColor:
            selected ? PencilPalette.bluePencil : PencilPalette.graphiteLight,
        strokeWidth: selected ? 1.7 : 1.1,
        seed: id.hashCode,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? PencilPalette.bluePencil
                  : PencilPalette.graphiteMedium,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.patrickHand(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? PencilPalette.bluePencil
                      : PencilPalette.graphiteMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrSection(String shareUrl) {
    return Column(
      children: [
        PencilBox(
          fillColor: PencilPalette.paperCard,
          borderColor: PencilPalette.graphiteDark,
          strokeWidth: 1.5,
          seed: 701,
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(
                'Scan with your phone camera to open & install:',
                textAlign: TextAlign.center,
                style: GoogleFonts.patrickHand(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: PencilPalette.graphiteDark,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: PencilBox(
                  fillColor: Colors.white,
                  borderColor: PencilPalette.graphiteDark,
                  strokeWidth: 1.8,
                  seed: 702,
                  padding: const EdgeInsets.all(12),
                  child: NotebookQrCodeWidget(
                    data: shareUrl,
                    size: 168,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      shareUrl,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.patrickHand(
                        fontSize: 14,
                        color: PencilPalette.bluePencil,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _copyShareUrl(shareUrl),
                    child: PencilBox(
                      fillColor: _copiedUrl
                          ? const Color(0xFFEAF6EC)
                          : PencilPalette.yellowHighlighter
                              .withValues(alpha: 0.45),
                      borderColor: _copiedUrl
                          ? PencilPalette.greenPencil
                          : PencilPalette.graphiteDark,
                      strokeWidth: 1.2,
                      seed: 703,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _copiedUrl
                                ? Icons.check_rounded
                                : Icons.copy_rounded,
                            size: 14,
                            color: _copiedUrl
                                ? PencilPalette.greenPencil
                                : PencilPalette.graphiteDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _copiedUrl ? 'Copied!' : 'Copy Link',
                            style: GoogleFonts.patrickHand(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: _copiedUrl
                                  ? PencilPalette.greenPencil
                                  : PencilPalette.graphiteDark,
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
        const SizedBox(height: 8),
        _buildBenefitsCard(),
      ],
    );
  }

  Widget _buildIosGuideSection(String shareUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepCard(
          stepNumber: '1',
          icon: Icons.ios_share_rounded,
          iconColor: PencilPalette.bluePencil,
          title: 'Tap the Share button in Safari',
          subtitle:
              'Look for the square-with-up-arrow icon at the bottom (iPhone) or top-right (iPad) of Safari.',
        ),
        const SizedBox(height: 8),
        _buildStepCard(
          stepNumber: '2',
          icon: Icons.add_box_outlined,
          iconColor: PencilPalette.greenPencil,
          title: 'Tap "Add to Home Screen"',
          subtitle:
              'Scroll down the share sheet menu and choose "Add to Home Screen" (+).',
        ),
        const SizedBox(height: 8),
        _buildStepCard(
          stepNumber: '3',
          icon: Icons.check_circle_outline_rounded,
          iconColor: PencilPalette.redPencil,
          title: 'Tap "Add" in the top-right corner',
          subtitle:
              'Pencily Yatzy will appear on your Home Screen with its custom notebook icon and launch full-screen without browser bars!',
        ),
        const SizedBox(height: 8),
        _buildBenefitsCard(),
      ],
    );
  }

  Widget _buildAndroidGuideSection(String shareUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepCard(
          stepNumber: '1',
          icon: Icons.more_vert_rounded,
          iconColor: PencilPalette.bluePencil,
          title: 'Tap "Install Now" above or the Browser Menu (⋮)',
          subtitle:
              'In Chrome, Edge, or Samsung Internet, tap the 3-dot menu in the top-right corner.',
        ),
        const SizedBox(height: 8),
        _buildStepCard(
          stepNumber: '2',
          icon: Icons.install_mobile_rounded,
          iconColor: PencilPalette.greenPencil,
          title: 'Select "Install app" or "Add to Home screen"',
          subtitle:
              'Confirm the prompt to install Pencily Yatzy as a standalone web-backed app.',
        ),
        const SizedBox(height: 8),
        _buildStepCard(
          stepNumber: '3',
          icon: Icons.rocket_launch_outlined,
          iconColor: PencilPalette.redPencil,
          title: 'Launch from your Home Screen or App Drawer',
          subtitle:
              'Opens full-screen like a native app and caches assets so you can play offline anytime.',
        ),
        const SizedBox(height: 8),
        _buildBenefitsCard(),
      ],
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return PencilBox(
      fillColor: PencilPalette.paperCard,
      borderColor: PencilPalette.graphiteDark,
      strokeWidth: 1.3,
      seed: stepNumber.hashCode + title.hashCode,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PencilPalette.yellowHighlighter.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: PencilPalette.graphiteDark,
                width: 1.4,
              ),
            ),
            child: Text(
              stepNumber,
              style: GoogleFonts.patrickHand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: PencilPalette.graphiteDark,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.patrickHand(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: PencilPalette.graphiteDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.patrickHand(
                    fontSize: 14,
                    color: PencilPalette.graphiteMedium,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return PencilBox(
      fillColor: const Color(0xFFF3F8FC),
      borderColor: PencilPalette.bluePencil,
      strokeWidth: 1.2,
      seed: 991,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.offline_bolt_outlined,
            color: PencilPalette.bluePencil,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Why install? Hides browser URL bars for more scorecard room, adds a Pencily Yatzy home-screen icon, and works offline on flights or road trips!',
              style: GoogleFonts.patrickHand(
                fontSize: 13.5,
                color: PencilPalette.graphiteDark,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a real, camera-scannable ISO/IEC 18004 QR Code (Version 4-L, 33x33)
/// in dark graphite ink on notebook paper.
class NotebookQrCodeWidget extends StatelessWidget {
  final String data;
  final double size;

  const NotebookQrCodeWidget({
    super.key,
    required this.data,
    this.size = 168,
  });

  @override
  Widget build(BuildContext context) {
    final matrix = _QrMatrixGenerator.encode(data);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NotebookQrPainter(matrix: matrix),
      ),
    );
  }
}

class _NotebookQrPainter extends CustomPainter {
  final List<List<bool>> matrix;

  const _NotebookQrPainter({required this.matrix});

  @override
  void paint(Canvas canvas, Size size) {
    final n = matrix.length;
    if (n == 0) return;
    final quietZone = 2;
    final totalModules = n + quietZone * 2;
    final cellSize = size.width / totalModules;

    final paint = Paint()
      ..color = PencilPalette.graphiteDark
      ..style = PaintingStyle.fill;

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (matrix[r][c]) {
          final rect = Rect.fromLTWH(
            (c + quietZone) * cellSize,
            (r + quietZone) * cellSize,
            cellSize + 0.35,
            cellSize + 0.35,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.16)),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookQrPainter oldDelegate) =>
      oldDelegate.matrix != matrix;
}

/// Self-contained ISO/IEC 18004 Version 4-L (33x33 modules, 80 data bytes,
/// 20 Reed-Solomon EC codewords, up to 78 UTF-8 bytes) QR Code Matrix encoder.
class _QrMatrixGenerator {
  static const int _size = 33; // Version 4 (21 + 4*3 = 33)
  static const int _dataCodewords = 80;
  static const int _ecCodewords = 20;

  // Precomputed Reed-Solomon generator polynomial for 20 EC codewords in GF(256) (0x11D)
  static const List<int> _rsGenerator20 = [
    1,
    152,
    185,
    240,
    5,
    111,
    99,
    6,
    220,
    112,
    150,
    69,
    36,
    187,
    22,
    228,
    198,
    121,
    121,
    165,
    174,
  ];

  static List<List<bool>> encode(String text) {
    var bytes = utf8.encode(text);
    if (bytes.length > 78) {
      bytes = bytes.sublist(0, 78);
    }

    // 1. Build 80 data codewords (Byte mode 0100 + 8-bit length + payload + terminator + pad bytes)
    final bits = <int>[];
    void addBits(int val, int len) {
      for (var i = len - 1; i >= 0; i--) {
        bits.add((val >> i) & 1);
      }
    }

    addBits(0x4, 4); // Byte mode indicator (0100)
    addBits(bytes.length, 8);
    for (final b in bytes) {
      addBits(b, 8);
    }
    // Terminator (up to 4 zero bits)
    final maxBits = _dataCodewords * 8;
    for (var i = 0; i < 4 && bits.length < maxBits; i++) {
      bits.add(0);
    }
    while (bits.length % 8 != 0) {
      bits.add(0);
    }
    final dataCw = <int>[];
    for (var i = 0; i < bits.length; i += 8) {
      var b = 0;
      for (var j = 0; j < 8; j++) {
        b = (b << 1) | bits[i + j];
      }
      dataCw.add(b);
    }
    const padBytes = [0xEC, 0x11];
    var padIdx = 0;
    while (dataCw.length < _dataCodewords) {
      dataCw.add(padBytes[padIdx % 2]);
      padIdx++;
    }

    // 2. Compute 20 Reed-Solomon error correction codewords over GF(256)
    final ecCw = _computeReedSolomon(dataCw);
    final allCodewords = <int>[...dataCw, ...ecCw];

    // 3. Initialize 33x33 grid & reserved function module map
    final modules = List.generate(_size, (_) => List.filled(_size, false));
    final isFunction = List.generate(_size, (_) => List.filled(_size, false));

    void setFunctionModule(int r, int c, bool dark) {
      if (r < 0 || r >= _size || c < 0 || c >= _size) return;
      modules[r][c] = dark;
      isFunction[r][c] = true;
    }

    // Finder patterns (7x7) + separators at (0,0), (0, _size-7), (_size-7, 0)
    void placeFinder(int topR, int leftC) {
      for (var dr = -1; dr <= 7; dr++) {
        for (var dc = -1; dc <= 7; dc++) {
          final r = topR + dr;
          final c = leftC + dc;
          if (r < 0 || r >= _size || c < 0 || c >= _size) continue;
          final inOuter = dr >= 0 && dr <= 6 && dc >= 0 && dc <= 6;
          final onBorder = dr == 0 || dr == 6 || dc == 0 || dc == 6;
          final inCenter = dr >= 2 && dr <= 4 && dc >= 2 && dc <= 4;
          setFunctionModule(r, c, inOuter && (onBorder || inCenter));
        }
      }
    }

    placeFinder(0, 0);
    placeFinder(0, _size - 7);
    placeFinder(_size - 7, 0);

    // Alignment pattern (5x5) centered at (26, 26) for Version 4
    const alignCenter = 26;
    for (var dr = -2; dr <= 2; dr++) {
      for (var dc = -2; dc <= 2; dc++) {
        final dist = dr.abs() > dc.abs() ? dr.abs() : dc.abs();
        setFunctionModule(
          alignCenter + dr,
          alignCenter + dc,
          dist == 2 || dist == 0,
        );
      }
    }

    // Timing patterns along row 6 and col 6
    for (var i = 8; i < _size - 8; i++) {
      setFunctionModule(6, i, i % 2 == 0);
      setFunctionModule(i, 6, i % 2 == 0);
    }

    // Dark module and format information reservation
    setFunctionModule(_size - 8, 8, true);
    for (var i = 0; i < 9; i++) {
      if (!isFunction[8][i]) setFunctionModule(8, i, false);
      if (!isFunction[i][8]) setFunctionModule(i, 8, false);
    }
    for (var i = 0; i < 8; i++) {
      if (!isFunction[8][_size - 1 - i]) {
        setFunctionModule(8, _size - 1 - i, false);
      }
      if (!isFunction[_size - 1 - i][8]) {
        setFunctionModule(_size - 1 - i, 8, false);
      }
    }

    // 4. Place data + EC bits in standard upward/downward 2-column zigzag
    var bitIndex = 0;
    final totalDataBits = allCodewords.length * 8;
    var upward = true;
    for (var rightCol = _size - 1; rightCol >= 1; rightCol -= 2) {
      if (rightCol == 6) rightCol = 5; // Skip vertical timing column
      for (var step = 0; step < _size; step++) {
        final r = upward ? (_size - 1 - step) : step;
        for (var dc = 0; dc < 2; dc++) {
          final c = rightCol - dc;
          if (!isFunction[r][c]) {
            var bit = false;
            if (bitIndex < totalDataBits) {
              final cw = allCodewords[bitIndex >> 3];
              bit = ((cw >> (7 - (bitIndex & 7))) & 1) == 1;
              bitIndex++;
            }
            // Apply Mask Pattern 0: (r + c) % 2 == 0
            if ((r + c) % 2 == 0) {
              bit = !bit;
            }
            modules[r][c] = bit;
          }
        }
      }
      upward = !upward;
    }

    // 5. Write 15-bit Format Information for Level L (01) + Mask 0 (000) -> 0x77C4
    const formatBits = 0x77C4;
    bool fmtBit(int idx) => ((formatBits >> idx) & 1) == 1;

    // Around top-left finder
    const tlCols = [8, 8, 8, 8, 8, 8, 8, 8, 7, 5, 4, 3, 2, 1, 0];
    const tlRows = [0, 1, 2, 3, 4, 5, 7, 8, 8, 8, 8, 8, 8, 8, 8];
    for (var i = 0; i < 15; i++) {
      modules[tlRows[i]][tlCols[i]] = fmtBit(i);
    }
    // Bottom-left & top-right format copies
    for (var i = 0; i < 7; i++) {
      modules[_size - 1 - i][8] = fmtBit(i);
    }
    for (var i = 7; i < 15; i++) {
      modules[8][_size - 15 + i] = fmtBit(i);
    }

    return modules;
  }

  static List<int> _computeReedSolomon(List<int> data) {
    final exp = List<int>.filled(512, 0);
    final log = List<int>.filled(256, 0);
    var x = 1;
    for (var i = 0; i < 255; i++) {
      exp[i] = x;
      log[x] = i;
      x <<= 1;
      if ((x & 0x100) != 0) x ^= 0x11D;
    }
    for (var i = 255; i < 512; i++) {
      exp[i] = exp[i - 255];
    }

    int gfMul(int a, int b) {
      if (a == 0 || b == 0) return 0;
      return exp[log[a] + log[b]];
    }

    final rem = List<int>.filled(_ecCodewords, 0);
    for (final byte in data) {
      final factor = byte ^ rem[0];
      for (var i = 0; i < _ecCodewords - 1; i++) {
        rem[i] = rem[i + 1] ^ gfMul(_rsGenerator20[i + 1], factor);
      }
      rem[_ecCodewords - 1] = gfMul(_rsGenerator20[_ecCodewords], factor);
    }
    return rem;
  }
}
