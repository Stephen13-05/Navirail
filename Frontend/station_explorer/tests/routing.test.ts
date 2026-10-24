import test from "node:test";
import assert from "node:assert/strict";
import { demoMap } from "../src/data";
import {
  findRoute,
  validateMap,
  positionAlong,
  checkpointFix,
} from "../src/routing";
test("demo graph is valid and all destinations are connected", () => {
  assert.deepEqual(validateMap(demoMap), []);
  for (const node of demoMap.nodes)
    assert.ok(findRoute(demoMap, "entrance", node.id), node.id);
});
test("Platform 5 route uses connected paths and a mapped floor transition", () => {
  const route = findRoute(demoMap, "entrance", "p5")!;
  assert.ok(route);
  assert.equal(route.nodes[0].id, "entrance");
  assert.equal(route.nodes.at(-1)!.id, "p5");
  assert.ok(route.edges.some((e) => e.type === "stairs"));
  for (let i = 0; i < route.edges.length; i++) {
    const e = route.edges[i];
    assert.ok([e.from, e.to].includes(route.nodes[i].id));
    assert.ok([e.from, e.to].includes(route.nodes[i + 1].id));
  }
});
test("step-free routes contain no stairs", () => {
  const route = findRoute(demoMap, "entrance", "p5", true)!;
  assert.ok(route);
  assert.ok(route.edges.every((e) => e.accessible && e.type !== "stairs"));
  assert.ok(route.edges.some((e) => e.type === "lift"));
});
test("closure reroutes rather than crossing a blocked edge", () => {
  const normal = findRoute(demoMap, "entrance", "p1")!;
  const closed = normal.edges.find((e) => e.type === "stairs")!.id;
  const alternate = findRoute(demoMap, "entrance", "p1", false, [closed])!;
  assert.ok(alternate);
  assert.ok(alternate.edges.every((e) => e.id !== closed));
  assert.notDeepEqual(
    normal.nodes.map((n) => n.id),
    alternate.nodes.map((n) => n.id),
  );
});
test("unknown and disconnected nodes do not yield fabricated routes", () => {
  assert.equal(findRoute(demoMap, "unknown", "p5"), null);
  assert.equal(findRoute(demoMap, "entrance", "unknown"), null);
  const map = structuredClone(demoMap);
  map.edges = map.edges.filter((e) => e.from !== "p5" && e.to !== "p5");
  assert.equal(findRoute(map, "entrance", "p5"), null);
});
test("station isolation and walk-only floor transitions are rejected", () => {
  const map = structuredClone(demoMap);
  map.nodes[0].station = "MS";
  assert.equal(findRoute(map, "entrance", "p5"), null);
  const other = structuredClone(demoMap);
  other.edges.find((e) => e.type === "stairs")!.type = "walk";
  assert.ok(validateMap(other).some((e) => e.includes("floor transition")));
});
test("checkpoint updates validate station and preserve freshness", () => {
  assert.equal(checkpointFix(demoMap, "NR:MS:p5"), null);
  assert.deepEqual(checkpointFix(demoMap, "NR:MAS:p5", 100), {
    node: "p5",
    source: "qr",
    timestamp: 100,
    accuracyMeters: null,
  });
  const fix = checkpointFix(demoMap, "NR:MAS:hall")!;
  assert.equal(findRoute(demoMap, fix.node, "p5")!.nodes[0].id, "hall");
});
test("movement interpolates on a path and clamps at arrival", () => {
  const route = findRoute(demoMap, "entrance", "p5")!;
  assert.deepEqual(positionAlong(route, 0).position, route.nodes[0].position);
  const half = positionAlong(route, route.edges[0].distance / 2);
  assert.equal(half.index, 0);
  assert.equal(half.arrived, false);
  assert.deepEqual(
    positionAlong(route, route.distance + 100).position,
    route.nodes.at(-1)!.position,
  );
  assert.equal(positionAlong(route, route.distance).arrived, true);
});
test("same origin and destination produces a stationary route", () => {
  const route = findRoute(demoMap, "p5", "p5")!;
  assert.equal(route.distance, 0);
  assert.equal(positionAlong(route, 0).arrived, true);
});
test("restricted railway tracks reject an accidental crossing", () => {
  const map = structuredClone(demoMap);
  map.edges.push({
    id: "unsafe",
    from: "p1",
    to: "p2",
    distance: 42,
    type: "walk",
    accessible: true,
    open: true,
  });
  assert.ok(validateMap(map).some((e) => e.includes("restricted zone")));
  assert.equal(findRoute(map, "entrance", "p5"), null);
});
