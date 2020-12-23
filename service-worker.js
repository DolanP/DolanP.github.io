importScripts("/precache-manifest.c55eb1241ede5f836b0e83d12102d127.js", "/workbox-v4.3.1/workbox-sw.js");
workbox.setConfig({modulePathPrefix: "/workbox-v4.3.1"});
/* eslint-disable no-undef */

// Detailed logging is very useful during development
//workbox.setConfig({ debug: true });

//TODO: typescript service-worker?

workbox.precaching.precacheAndRoute(self.__precacheManifest || []);

workbox.routing.registerNavigationRoute(
  workbox.precaching.getCacheKeyForURL("index.html"),
  {
    blacklist: [
      /^\/css\//,
      /^\/css-woff2\//,
      /^\/fonts\//,
      /^\/img\//,
      /^\/js\//,
      /^\/workbox-v4.3.1\//,
    ],
  }
);

addEventListener("message", (event) => {
  if (event.data && event.data.type === "SKIP_WAITING") {
    console.log(`service-worker.js receiving SKIP_WAITING message`)
    skipWaiting();
  }
});

//console.log("service-worker.js: service worker updated");

