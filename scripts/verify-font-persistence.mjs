import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, "..");

const fontManifestPath = path.join(rootDir, "Frontend/navirail_app/build/web/assets/FontManifest.json");
const fontFilePath = path.join(rootDir, "Frontend/navirail_app/build/web/assets/assets/fonts/fallback/Roboto-Regular.ttf");
const sourceFontPath = path.join(rootDir, "Frontend/navirail_app/assets/fonts/fallback/Roboto-Regular.ttf");

console.log("Checking permanent source font file...");
if (!fs.existsSync(sourceFontPath)) {
  console.error("FAIL: Source font file does not exist:", sourceFontPath);
  process.exit(1);
}
console.log("PASS: Source font file exists, size:", fs.statSync(sourceFontPath).size);

console.log("Checking generated FontManifest.json...");
if (!fs.existsSync(fontManifestPath)) {
  console.error("FAIL: FontManifest.json does not exist:", fontManifestPath);
  process.exit(1);
}
const manifestContent = JSON.parse(fs.readFileSync(fontManifestPath, "utf8"));
console.log("PASS: FontManifest.json loaded:", JSON.stringify(manifestContent));

const robotoEntry = manifestContent.find((entry) => entry.family === "Roboto");
if (!robotoEntry || !robotoEntry.fonts || !robotoEntry.fonts.length) {
  console.error("FAIL: Roboto family missing from FontManifest.json");
  process.exit(1);
}
const declaredAsset = robotoEntry.fonts[0].asset;
console.log("PASS: Declared asset in manifest:", declaredAsset);

console.log("Checking generated font file on disk...");
if (!fs.existsSync(fontFilePath)) {
  console.error("FAIL: Build output font file does not exist:", fontFilePath);
  process.exit(1);
}
const fontStat = fs.statSync(fontFilePath);
console.log("PASS: Build output font file exists, size:", fontStat.size);

// Flutter web asset resolution:
// When Flutter requests an asset declared as "assets/fonts/fallback/Roboto-Regular.ttf"
// in FontManifest.json, it requests it relative to the assets/ base path, i.e.:
// GET /assets/assets/fonts/fallback/Roboto-Regular.ttf
// Verify that the file path corresponds exactly:
const expectedRelativePath = path.join(rootDir, "Frontend/navirail_app/build/web/assets", declaredAsset);
if (!fs.existsSync(expectedRelativePath)) {
  console.error("FAIL: Expected relative path does not exist:", expectedRelativePath);
  process.exit(1);
}
console.log("PASS: Expected relative path exists on disk:", expectedRelativePath);

console.log("\nALL FONT ASSET INTEGRITY CHECKS PASSED SUCCESSFULLY!");
