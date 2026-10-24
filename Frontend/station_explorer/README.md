# NaviRail station explorer

A React / TypeScript / React Three Fiber module embedded in the existing Flutter web application. The original Flutter screens remain in place. This is a **demonstration**, not a verified Chennai Central indoor navigation product.

## Run locally

From `Frontend/station_explorer`:

```powershell
npm ci
npm run build
npm start
```

Open http://127.0.0.1:8090/explorer/. The server also serves the original Flutter web build at `/`. For frontend development, keep the server running and use `npm run dev` (Vite proxies API requests to port 8090).

To rebuild Flutter, run `flutter pub get` and `flutter build web --no-web-resources-cdn` from `Frontend/navirail_app`. The web map page embeds `/explorer/`; native targets retain the original map screen. The local server serves the explorer build separately so a Flutter rebuild does not delete it.

## Working demonstration

- Search the five-station starter catalog. MAS has an explicitly labeled schematic; other stations show an unavailable-map state.
- Choose a starting facility and destination. Platform 5 is selected initially.
- Rotate, pan, zoom, reset, switch to top-down view, hide roofs, or isolate the bridge/ground presentation.
- Route with Dijkstra over explicit pedestrian edges, including floor transitions. Step-free routes exclude stairs. Railway track rectangles reject accidental ground-level crossings.
- Start a demonstration at accelerated speed (18 m/s). The passenger marker and distance remaining update until arrival. Walking estimates use normal pedestrian speeds; simulated speed is labeled separately.
- Simulate entrance stair closures and recalculate through lifts. Mid-journey rerouting uses the last reached graph checkpoint rather than claiming precise continuous positioning.
- Scan a QR checkpoint with the camera, or enter its payload. Examples: `NR:MAS:entrance`, `NR:MAS:hall`, `NR:MAS:p5`. Camera access starts only after pressing the scan button. QR fixes carry a timestamp and are not presented as continuous tracking.
- Search/filter facilities, choose light/dark appearance, and switch core journey labels between English, Tamil and Hindi. Facility names and secondary copy currently remain English.
- If WebGL fails, use the SVG schematic fallback.

## Local map administration

Open **Map administration**. The server creates a random local password at `.local/admin-password.txt`, or accepts `NAVIRAIL_ADMIN_PASSWORD` from the environment. Credentials are not bundled in the client. Sessions expire after one hour, use HttpOnly/SameSite cookies, and all admin endpoints enforce authentication. Login/API rate limits, origin checks, schema validation and upload limits are enabled.

The visual editor places and edits facilities, connects pedestrian nodes across the two prototype floors, changes pathway availability, and previews routes. The JSON editor exposes the complete draft, including restricted zones. Save draft, validate connectivity, publish a demonstration version, and roll back the published pointer. Audit events and version snapshots persist to `.local/maps.json`; each save retains the previous file as `.backup`. GLB import accepts self-contained GLB 2.0 files up to 15 MB and stores them for review; model alignment and publication association are not automated.

Only demonstration maps can be published. Verified status is rejected by the API. Do not deploy this development administration service publicly as a production identity system.

## Validation

```powershell
npm test
npm run build
```

Tests cover graph connectivity, step-free routing, closures, unknown destinations, station/floor isolation, restricted tracks, checkpoint freshness, interpolated movement, authentication, draft isolation, publication, rollback, origin rejection and invalid uploads. Flutter regression tests live in the existing app's `test` directory.

## Deliberate limits

- Geometry, facilities, distances, station locations within the model and routes are illustrative. No architectural verification is claimed.
- The starter station catalog is bundled; there is no national railway master database or live train feed.
- BLE/Wi-Fi providers have a typed integration contract; no hardware provider is connected. GPS is not used as precise indoor positioning.
- Local JSON persistence supports a single development server. Production needs PostgreSQL/PostGIS migrations, organizational identity and roles, transactional/concurrent editing, operational backups and approved map review.
- Verified floor-plan ingestion, GLB alignment, arbitrary multi-floor geometry, a production geospatial editor, and full UI translations remain future integration work.
- The existing native Flutter map remains unchanged; the new explorer integration targets Flutter web.

## Reference APIs

- React Three Fiber: https://r3f.docs.pmnd.rs/getting-started/installation
- Drei controls: https://drei.docs.pmnd.rs/controls/introduction
- QR reader: https://github.com/zxing-js/browser

## In-app sections
The existing Home quick action is now named 3D Navigation. It opens the explorer inside the Flutter page, with Station Explorer, 3D Navigation and Facilities sub-tabs. Station selection is passed into the embedded explorer. Embedded mode hides the duplicate sidebar and branding. Selecting a facility switches to its navigation tab.
