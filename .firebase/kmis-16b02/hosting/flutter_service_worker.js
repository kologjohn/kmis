'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "28c3f8618e626d2f33c0c579e86be401",
"version.json": "9c8682f2f2bcaeb59331b490f5de53bd",
"index.html": "cc8500219b0fcc57e5dadaecee9fa963",
"/": "cc8500219b0fcc57e5dadaecee9fa963",
"main.dart.js": "cdbc74bf4340ea07df5ea59c4824504c",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "000ba7f8a61a3d8d54dd1363494d481d",
"assets/AssetManifest.json": "155a296b0f91315f327c78e1d33d8ba7",
"assets/NOTICES": "67a41ea6d29a0c207317945b992fc2c4",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "596b7209cc7e273b6656223597ba1501",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "a3b245f42991baf38b117de9842800e2",
"assets/fonts/MaterialIcons-Regular.otf": "a6775d6d98bdf0611785bcdfb25db398",
"assets/assets/images/undraw_two-factor-authentication_8tds.png": "1b33f58dbb111dedc93131bd42510db7",
"assets/assets/images/undraw_notebook_8ihb.png": "ec6a0590e7faa4426923547ae5e2c3ac",
"assets/assets/images/undraw_book-lover_m9n3.png": "402da290ff11df68c7c2b53c8d77735e",
"assets/assets/images/WhatsApp%2520Image%25202025-09-13%2520at%25206.22.19%2520AM.jpeg": "7f76c971ed4e911f602d148b19b1719a",
"assets/assets/images/undraw_product-explainer_b7ft.png": "47857844f330fe38d003fc39f3b91397",
"assets/assets/images/undraw_election-day_puwv.png": "b0a91f2703a80647b8eacf08d748b732",
"assets/assets/images/bookwormlogo.jpg": "7c43ac6da545185d0925bf1b638fd8d0",
"assets/assets/images/site-stats_gfql.png": "7d4e1c66c2c5ae4c93719e7c6026c2dd",
"assets/assets/images/voting_animation.gif": "518a33c0560fa8ccf6a2bcd52327aabf",
"assets/assets/images/undraw_voting_3ygx.svg": "5369ad46576ec52fc3c7cf28e34a332d",
"assets/assets/images/logo.png": "f2bb63abddc789d45a207ba62a2d6550",
"assets/assets/images/undraw_access-account_aydp.png": "9569edc338f776b02c42adf7dd4baa81",
"assets/assets/images/kk.jpg": "556ff57806bd373f0800f64ab18b5538",
"assets/assets/images/undraw_certificate_cqps.png": "5155f046cc1921d80becbd33d6123238",
"assets/assets/images/google.png": "7d5174e7fd01c13d18f3df9f91ea2e19",
"assets/assets/images/undraw_voting_3ygx.png": "e6b655f5022e6ff5fc5dd05ef6ef9523",
"assets/assets/images/undraw_report_k55w.png": "c40654e952cf085f37c4531c264ac4da",
"assets/assets/images/undraw_online-survey_xq2g.png": "737a53eac5a19eb69cbf18a6999ed785",
"assets/assets/images/undraw_data_0ml2.png": "a49bc655d11219c30ab6f429bfffb83b",
"assets/assets/fonts/Roboto-Medium.ttf": "7d752fb726f5ece291e2e522fcecf86d",
"assets/assets/fonts/Roboto_SemiCondensed-ExtraLightItalic.ttf": "c5105f6fbcd6f492a2a6f99f92936d22",
"assets/assets/fonts/Roboto_Condensed-ExtraLightItalic.ttf": "2c2c1df1100801d8a4b345d27f302980",
"assets/assets/fonts/Roboto_SemiCondensed-BoldItalic.ttf": "becb41b38acfe0bb5d4101cde6db0029",
"assets/assets/fonts/Roboto_Condensed-ExtraBoldItalic.ttf": "17772988c821639e9fe36044d6931208",
"assets/assets/fonts/Roboto-Light.ttf": "25e374a16a818685911e36bee59a6ee4",
"assets/assets/fonts/Roboto_SemiCondensed-ThinItalic.ttf": "b1b3f970c13ebd8f93345d10d6ac3626",
"assets/assets/fonts/Roboto_SemiCondensed-ExtraLight.ttf": "83c6c6b25720032a079c86b8244ece58",
"assets/assets/fonts/Roboto_Condensed-Black.ttf": "b8e3ed03047190a170b330b99cb497cf",
"assets/assets/fonts/Roboto_SemiCondensed-SemiBoldItalic.ttf": "60a345becd1b883beef9d02bbb655af6",
"assets/assets/fonts/Roboto_SemiCondensed-SemiBold.ttf": "4cd0ff27a44b68f74262ec5d63d9f304",
"assets/assets/fonts/Roboto_SemiCondensed-ExtraBold.ttf": "cd66a60e5be720ca2c368e6b60348cd4",
"assets/assets/fonts/Roboto_SemiCondensed-BlackItalic.ttf": "cee6c277748569381168fa4873f17951",
"assets/assets/fonts/Roboto-Regular.ttf": "303c6d9e16168364d3bc5b7f766cfff4",
"assets/assets/fonts/Roboto_Condensed-Italic.ttf": "58ab0145561cf8b4782eea242cb30f5b",
"assets/assets/fonts/Roboto_Condensed-SemiBold.ttf": "e9bd6495779750596421effa84fdd4f5",
"assets/assets/fonts/Roboto-MediumItalic.ttf": "918982b4cec9e30df58aca1e12cf6445",
"assets/assets/fonts/Roboto_SemiCondensed-Medium.ttf": "ec198bede12e04919f81c2deabbfddfe",
"assets/assets/fonts/Roboto_SemiCondensed-Bold.ttf": "6176c398124c086287f8f2704e447d89",
"assets/assets/fonts/Roboto_SemiCondensed-LightItalic.ttf": "ee86d3beb5d7e6f711f0f12f09179d48",
"assets/assets/fonts/Roboto-ExtraBoldItalic.ttf": "80b61563f9e8f51aa379816e1c6016ef",
"assets/assets/fonts/Roboto_SemiCondensed-Thin.ttf": "4f2191b28015879bcd1836c2d03b9ac5",
"assets/assets/fonts/Roboto-SemiBoldItalic.ttf": "2d365b1721b9ba2ff4771393a0ce2e46",
"assets/assets/fonts/Roboto_SemiCondensed-Black.ttf": "4e83f16b2aae530ed5a9eea2c6fcba0e",
"assets/assets/fonts/Roboto_SemiCondensed-ExtraBoldItalic.ttf": "76b49fa5b22fb20fd69561f17237e80d",
"assets/assets/fonts/Roboto_SemiCondensed-Light.ttf": "7f35ecca19fa7286023e6d5d29d98fee",
"assets/assets/fonts/Roboto_SemiCondensed-MediumItalic.ttf": "4404af13d7c2b95be24b367e5dfaa726",
"assets/assets/fonts/Roboto-ExtraLightItalic.ttf": "41c80845424f35477f8ecadfb646a67d",
"assets/assets/fonts/Roboto_Condensed-ExtraBold.ttf": "e7921919c3021ad88323d48eb9294917",
"assets/assets/fonts/Roboto_Condensed-BlackItalic.ttf": "77716aa38d5bfb3b7a8707797e6d6d65",
"assets/assets/fonts/Roboto_Condensed-Regular.ttf": "6f1c323492d1266a46461cbc57101ad4",
"assets/assets/fonts/Roboto_Condensed-Bold.ttf": "5340a8744e1c9e34870f54f557d67b17",
"assets/assets/fonts/Roboto_Condensed-Medium.ttf": "b9f98617f7bc110311f054d264f43b58",
"assets/assets/fonts/Roboto_SemiCondensed-Italic.ttf": "5cae5cd3f40c671315aea0e55f8aa469",
"assets/assets/fonts/Roboto_Condensed-BoldItalic.ttf": "757801f54a84d6503d7bc9c56e763b75",
"assets/assets/fonts/Roboto-ExtraLight.ttf": "83e5ab4249b88f89ccf80e15a98b92f0",
"assets/assets/fonts/Roboto-ThinItalic.ttf": "dca165220aefe216510c6de8ae9578ff",
"assets/assets/fonts/Roboto_Condensed-SemiBoldItalic.ttf": "9f8f19b06543707a34bda741211fd833",
"assets/assets/fonts/Roboto_Condensed-Thin.ttf": "38ca91dbce841a3c3c20a3024a00fb93",
"assets/assets/fonts/Roboto-BoldItalic.ttf": "dc10ada6fd67b557d811d9a6d031c4de",
"assets/assets/fonts/Roboto_Condensed-ExtraLight.ttf": "cf9840bb59a0b4ef1f6441efde262ec0",
"assets/assets/fonts/Roboto_Condensed-ThinItalic.ttf": "66aeec1eb99fd707bbda2c23c0d88dbd",
"assets/assets/fonts/Roboto_Condensed-MediumItalic.ttf": "a887fedb5da68c3987dcaf272f685228",
"assets/assets/fonts/Roboto-ExtraBold.ttf": "27fd63e58793434ce14a41e30176a4de",
"assets/assets/fonts/Roboto-LightItalic.ttf": "00b6f1f0c053c61b8048a6dbbabecaa2",
"assets/assets/fonts/Roboto_SemiCondensed-Regular.ttf": "1a494bea2b882849db6c932aee6a4302",
"assets/assets/fonts/Roboto-SemiBold.ttf": "dae3c6eddbf79c41f922e4809ca9d09c",
"assets/assets/fonts/Roboto-Italic.ttf": "1fc3ee9d387437d060344e57a179e3dc",
"assets/assets/fonts/Roboto-BlackItalic.ttf": "792016eae54d22079ccf6f0760938b0a",
"assets/assets/fonts/Roboto-Bold.ttf": "dd5415b95e675853c6ccdceba7324ce7",
"assets/assets/fonts/Roboto-Thin.ttf": "1e6f2d32ab9876b49936181f9c0b8725",
"assets/assets/fonts/Roboto-Black.ttf": "dc44e38f98466ebcd6c013be9016fa1f",
"assets/assets/fonts/Roboto_Condensed-LightItalic.ttf": "d86a4886b06b3be02dd8c06db6c7b53d",
"assets/assets/fonts/Roboto_Condensed-Light.ttf": "0f3de38ef164b0a65a8a0a686e08bbff",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
