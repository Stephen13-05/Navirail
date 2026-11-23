import fs from 'node:fs';

const vercelConfig = JSON.parse(fs.readFileSync('vercel.json', 'utf8'));
const rewrites = vercelConfig.rewrites;

function testPath(urlPath) {
  for (const rule of rewrites) {
    // Vercel regex syntax conversion for testing
    // source: "/explorer/((?!assets/|.*\\..*).*)$"
    const regex = new RegExp('^' + rule.source.replace(/\//g, '\\/') + '$');
    if (regex.test(urlPath)) {
      return { path: urlPath, matchedRule: rule.source, destination: rule.destination };
    }
  }
  return { path: urlPath, matchedRule: null, destination: 'Direct file serve (static)' };
}

const testUrls = [
  // 1. Root & SPA routes
  '/',
  '/home',
  '/station_selection',
  
  // 2. Flutter assets (must NOT be intercepted by SPA rewrite)
  '/main.dart.js',
  '/flutter.js',
  '/flutter_bootstrap.js',
  '/assets/assets/map/map.json',
  '/assets/assets/image/3dmap.jpg',
  '/canvaskit/canvaskit.wasm',
  '/canvaskit/canvaskit.js',
  '/icons/Icon-192.png',
  '/favicon.png',

  // 3. Explorer routes (must be rewritten to /explorer/index.html)
  '/explorer',
  '/explorer/',
  '/explorer/subroute',

  // 4. Explorer assets (must NOT be intercepted by /explorer/ rewrites)
  '/explorer/assets/index-DHxXvxF_.js',
  '/explorer/assets/index-B1cDWJtI.css',
  '/explorer/assets/StationScene-D_1qUFpu.js',
  '/explorer/assets/model.glb',
  '/explorer/assets/texture.png'
];

console.log('--- Vercel Rewrites Test ---');
for (const u of testUrls) {
  const res = testPath(u);
  console.log(`URL: ${u.padEnd(45)} => ${res.destination}`);
}
