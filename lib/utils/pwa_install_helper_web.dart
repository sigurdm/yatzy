import 'dart:js_interop';
import 'package:flutter/foundation.dart';

@JS('window.pencilyPwa')
external _PencilyPwaJS? get _pencilyPwa;

extension type _PencilyPwaJS._(JSObject _) implements JSObject {
  external bool canPromptInstall();
  external JSPromise<JSString> triggerInstall();
  external bool isStandalone();
  external String getPlatform();
  external String getShareUrl();
  external void onStateChanged(JSFunction callback);
}

/// Web implementation of [PwaInstallHelper] bridging to `window.pencilyPwa` in `index.html`.
class PwaInstallHelper {
  static final ValueNotifier<int> stateVersion = ValueNotifier<int>(0);
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    try {
      _pencilyPwa?.onStateChanged(
        (() {
          stateVersion.value++;
        }).toJS,
      );
    } catch (_) {}
  }

  static bool get isStandalone {
    try {
      return _pencilyPwa?.isStandalone() ?? false;
    } catch (_) {
      return false;
    }
  }

  static bool get canPromptInstall {
    try {
      return _pencilyPwa?.canPromptInstall() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Returns `'ios'`, `'android'`, or `'desktop'`.
  static String get platform {
    try {
      return _pencilyPwa?.getPlatform() ?? 'desktop';
    } catch (_) {
      return 'desktop';
    }
  }

  static String get shareUrl {
    try {
      final url = _pencilyPwa?.getShareUrl();
      if (url != null && url.isNotEmpty) return url;
    } catch (_) {}
    return 'https://sigurdm.github.io/yatzy/';
  }

  static Future<String> triggerInstall() async {
    try {
      final pwa = _pencilyPwa;
      if (pwa == null) return 'unavailable';
      final jsRes = await pwa.triggerInstall().toDart;
      stateVersion.value++;
      return jsRes.toDart;
    } catch (_) {
      return 'error';
    }
  }
}
