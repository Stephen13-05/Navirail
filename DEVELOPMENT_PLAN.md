# NaviRail implementation status

The existing Flutter application is preserved. Its web 3D map page embeds the new module in `Frontend/station_explorer`; native builds retain their existing map page.

Implemented: React/Three.js demonstration station, connected routing with accessible paths and closures, restricted-track validation, animated passenger movement, facility filtering, starter station search, unavailable-map states, core journey translations, QR scanning/checkpoint updates, responsive light/dark UI, local authenticated draft editor, version publication/rollback, audit persistence, and routing/API tests.

The original Dart solver now rejects unknown and unreachable destinations. Its regression tests cover normal paths, disconnected nodes and closures. The obsolete starter counter test has been replaced with an app startup test.

This is the first working demonstration, not production deployment. See `Frontend/station_explorer/README.md` for exact setup, implemented behavior and outstanding data/infrastructure requirements.

## Latest verification

- Explorer: TypeScript + Vite production build passed; 11 routing and API tests passed.
- Flutter: all 6 tests passed. Analyzer reported 57 existing warnings/information items, no errors (run with non-fatal warnings/information).
- Browser: verified simulated arrival, closure rerouting through west lift, step-free routing and checkpoint location updates. Further browser checks became unavailable when local browser use was disabled in Work settings.
- Flutter web production build completed successfully with local web resources.
