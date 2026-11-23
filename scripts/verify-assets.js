import fs from 'node:fs';
import path from 'node:path';

const flutterDir = path.join('Frontend', 'navirail_app', 'build', 'web');
const flutterIndex = path.join(flutterDir, 'index.html');
const flutterJs = path.join(flutterDir, 'flutter.js');
const flutterBootstrap = path.join(flutterDir, 'flutter_bootstrap.js');
const mainDartJs = path.join(flutterDir, 'main.dart.js');

console.log('--- 1. Flutter Web Build Verification ---');
console.log('flutterDir exists:', fs.existsSync(flutterDir));
console.log('index.html exists:', fs.existsSync(flutterIndex));
console.log('flutter.js exists:', fs.existsSync(flutterJs));
console.log('flutter_bootstrap.js exists:', fs.existsSync(flutterBootstrap));
console.log('main.dart.js exists:', fs.existsSync(mainDartJs));
if (fs.existsSync(mainDartJs)) {
  const stat = fs.statSync(mainDartJs);
  console.log('main.dart.js size:', (stat.size / 1024 / 1024).toFixed(2), 'MB');
}

// 2. Explorer index.html asset references
const explorerIndex = path.join(flutterDir, 'explorer', 'index.html');
console.log('\n--- 2. Explorer index.html Verification ---');
console.log('explorer index.html exists:', fs.existsSync(explorerIndex));
const explorerHtml = fs.readFileSync(explorerIndex, 'utf8');
console.log('Content:\n', explorerHtml);

// 3. Verify all assets exist
console.log('\n--- 3. Asset Existence Verification ---');
const regex = /(?:src|href)="([^"]+)"/g;
let match;
const assetPaths = [];
while ((match = regex.exec(explorerHtml)) !== null) {
  assetPaths.push(match[1]);
}
console.log('Referenced assets in explorer index.html:', assetPaths);
for (const p of assetPaths) {
  const cleanPath = p.replace(/^\/explorer\//, '');
  const diskPath = path.join(flutterDir, 'explorer', cleanPath);
  console.log('Asset', p, '-> on disk:', diskPath, fs.existsSync(diskPath) ? 'EXISTS (OK)' : 'MISSING (FAIL)');
}

const assetsDir = path.join(flutterDir, 'explorer', 'assets');
const allExplorerAssets = fs.readdirSync(assetsDir);
console.log('All files in explorer/assets:', allExplorerAssets);

// Check referenced chunks inside JS files
for (const assetFile of allExplorerAssets) {
  if (assetFile.endsWith('.js')) {
    const fullAssetPath = path.join(assetsDir, assetFile);
    const content = fs.readFileSync(fullAssetPath, 'utf8');
    for (const otherAsset of allExplorerAssets) {
      if (otherAsset !== assetFile && content.includes(otherAsset)) {
        console.log(`Chunk reference verified: ${assetFile} references ${otherAsset} (PRESENT ON DISK)`);
      }
    }
  }
}
