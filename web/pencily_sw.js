'use strict';

// Pencily Yatzy offline-first service worker.
//
// Flutter's own generated `flutter_service_worker.js` is deprecated: as of recent
// Flutter releases it is a stub that simply unregisters itself and has no `fetch`
// handler. Chrome requires an active service worker WITH a `fetch` handler before it
// fires `beforeinstallprompt`, so without this file the game is not installable as a
// mobile web app on Android/Chrome and would not work offline. This worker provides:
//   - Precaching of the app shell on install.
//   - Network-first navigation (so new releases are picked up immediately) with an
//     offline fallback to the cached index.html.
//   - Stale-while-revalidate for all same-origin assets (main.dart.js, CanvasKit
//     wasm, fonts, icons), so the game boots instantly and stays up to date.

const CACHE_VERSION =
    new URL(self.location.href).searchParams.get('v') || 'dev';
const CACHE_NAME = `pencily-yatzy-${CACHE_VERSION}`;
const CACHE_PREFIX = 'pencily-yatzy-';

/// Minimal app shell precached during install so the very first offline launch works.
const APP_SHELL = [
  './',
  'index.html',
  'flutter_bootstrap.js',
  'manifest.json',
  'favicon.png',
  'icons/Icon-192.png',
  'icons/Icon-512.png',
  'icons/apple-touch-icon.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    // allSettled: a single missing asset must never block installation.
    await Promise.allSettled(
      APP_SHELL.map((url) => cache.add(new Request(url, {cache: 'reload'}))),
    );
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(
      keys
        .filter((key) => key.startsWith(CACHE_PREFIX) && key !== CACHE_NAME)
        .map((key) => caches.delete(key)),
    );
    await self.clients.claim();
  })());
});

self.addEventListener('message', (event) => {
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
  }
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  // Navigation requests: network-first so a freshly deployed build is picked up,
  // falling back to the cached shell when the device is offline.
  if (request.mode === 'navigate') {
    event.respondWith((async () => {
      try {
        const fresh = await fetch(request);
        const cache = await caches.open(CACHE_NAME);
        cache.put('index.html', fresh.clone());
        return fresh;
      } catch (_) {
        const cache = await caches.open(CACHE_NAME);
        const cached =
            (await cache.match('index.html')) || (await cache.match('./'));
        return cached || Response.error();
      }
    })());
    return;
  }

  // Assets: stale-while-revalidate for instant boots plus background updates.
  event.respondWith((async () => {
    const cache = await caches.open(CACHE_NAME);
    const cached = await cache.match(request);
    const networked = fetch(request)
      .then((response) => {
        if (response && response.status === 200 && response.type === 'basic') {
          cache.put(request, response.clone());
        }
        return response;
      })
      .catch(() => null);
    return cached || (await networked) || Response.error();
  })());
});
