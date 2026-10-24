import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
export default defineConfig({
  base: "/explorer/",
  plugins: [react()],
  server: { proxy: { "/api": "http://127.0.0.1:8090" } },
  build: { chunkSizeWarningLimit: 1200 },
});
