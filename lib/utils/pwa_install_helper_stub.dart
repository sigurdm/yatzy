import 'package:flutter/foundation.dart';

/// Stub implementation of [PwaInstallHelper] for non-web platforms and unit tests.
class PwaInstallHelper {
  static final ValueNotifier<int> stateVersion = ValueNotifier<int>(0);

  static void init() {}

  static bool get isStandalone => false;

  static bool get canPromptInstall => false;

  /// Returns `'ios'`, `'android'`, or `'desktop'`.
  static String get platform => 'desktop';

  static String get shareUrl => 'https://sigurdm.github.io/yatzy/';

  static Future<String> triggerInstall() async => 'unavailable';
}
