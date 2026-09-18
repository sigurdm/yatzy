{{flutter_js}}
{{flutter_build_config}}

// Intentionally loaded WITHOUT `serviceWorkerSettings`: Flutter's built-in
// `flutter_service_worker.js` is deprecated and only unregisters itself, which leaves
// the app without a `fetch` handler and therefore not installable as a PWA.
// Pencily Yatzy registers its own offline-first worker (`pencily_sw.js`) below.
_flutter.loader.load();

if ('serviceWorker' in navigator) {
  window.addEventListener('load', function () {
    navigator.serviceWorker
      .register('pencily_sw.js?v=__BUILD_ID__')
      .catch(function (error) {
        console.warn('Pencily Yatzy service worker registration failed:', error);
      });
  });
}
