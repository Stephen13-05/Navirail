import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const srcDir = path.join(root, "Frontend", "station_explorer", "dist");
const targetDir = path.join(root, "Frontend", "navirail_app", "build", "web", "explorer");

if (!fs.existsSync(srcDir)) {
  console.error("Source directory does not exist: " + srcDir);
  process.exit(1);
}

fs.mkdirSync(targetDir, { recursive: true });
fs.cpSync(srcDir, targetDir, { recursive: true, force: true });
console.log(`Successfully copied Station Explorer build (${srcDir}) to Flutter web directory (${targetDir})`);
