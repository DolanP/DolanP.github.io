importScripts("/precache-manifest.97e48b8b30d0b492e9ecd0c647ab9830.js", "/workbox-v4.3.1/workbox-sw.js");
workbox.setConfig({modulePathPrefix: "/workbox-v4.3.1"});
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
    skipWaiting();
  }
});

console.log("service-worker.js: service worker updated");

