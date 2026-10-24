import type { StationMap, Node, Edge, Point } from "./data";
export type Route = {
  nodes: Node[];
  edges: Edge[];
  distance: number;
  seconds: number;
};
function intersectsRectangle(
  a: Point,
  b: Point,
  z: { minX: number; maxX: number; minZ: number; maxZ: number },
): boolean {
  let low = 0,
    high = 1;
  for (const [axis, min, max] of [
    [0, z.minX, z.maxX],
    [2, z.minZ, z.maxZ],
  ]) {
    const delta = b[axis] - a[axis];
    if (delta === 0) {
      if (a[axis] < min || a[axis] > max) return false;
      continue;
    }
    const t1 = (min - a[axis]) / delta,
      t2 = (max - a[axis]) / delta;
    low = Math.max(low, Math.min(t1, t2));
    high = Math.min(high, Math.max(t1, t2));
    if (low > high) return false;
  }
  return true;
}
export function validateMap(map: StationMap): string[] {
  const errors: string[] = [];
  const ids = new Set<string>();
  for (const n of map.nodes) {
    if (ids.has(n.id)) errors.push(`Duplicate node: ${n.id}`);
    ids.add(n.id);
    if (n.station !== map.station) errors.push(`Wrong station: ${n.id}`);
    if (n.position.length !== 3 || n.position.some((v) => !Number.isFinite(v)))
      errors.push(`Invalid position: ${n.id}`);
    if (!Number.isInteger(n.floor)) errors.push(`Invalid floor: ${n.id}`);
  }
  const edgeIds = new Set<string>();
  for (const e of map.edges) {
    if (edgeIds.has(e.id)) errors.push(`Duplicate edge: ${e.id}`);
    edgeIds.add(e.id);
    const a = map.nodes.find((n) => n.id === e.from),
      b = map.nodes.find((n) => n.id === e.to);
    if (!a || !b) {
      errors.push(`Unknown endpoint: ${e.id}`);
      continue;
    }
    if (!Number.isFinite(e.distance) || e.distance <= 0)
      errors.push(`Invalid distance: ${e.id}`);
    if (a.floor !== b.floor && e.type === "walk")
      errors.push(`Unmapped floor transition: ${e.id}`);
    if (e.type === "stairs" && e.accessible)
      errors.push(`Stairs marked accessible: ${e.id}`);
  }
  for (const zone of map.restrictedZones || []) {
    if (zone.minX >= zone.maxX || zone.minZ >= zone.maxZ) {
      errors.push(`Invalid restricted zone: ${zone.id}`);
      continue;
    }
    for (const edge of map.edges) {
      const a = map.nodes.find((n) => n.id === edge.from),
        b = map.nodes.find((n) => n.id === edge.to);
      if (
        a &&
        b &&
        a.floor === zone.floor &&
        b.floor === zone.floor &&
        intersectsRectangle(a.position, b.position, zone)
      )
        errors.push(`Path crosses restricted zone: ${edge.id}`);
    }
  }
  return errors;
}
export function findRoute(
  map: StationMap,
  start: string,
  goal: string,
  accessible = false,
  closed: string[] = [],
): Route | null {
  if (validateMap(map).length) return null;
  const byId = new Map(map.nodes.map((n) => [n.id, n]));
  if (!byId.has(start) || !byId.has(goal)) return null;
  const dist = new Map(map.nodes.map((n) => [n.id, Infinity]));
  dist.set(start, 0);
  const previous = new Map<string, { node: string; edge: Edge }>();
  const pending = new Set(byId.keys());
  while (pending.size) {
    const current = [...pending].reduce((a, b) =>
      dist.get(a)! < dist.get(b)! ? a : b,
    );
    if (!Number.isFinite(dist.get(current)!)) break;
    pending.delete(current);
    if (current === goal) break;
    for (const e of map.edges) {
      if (!e.open || closed.includes(e.id) || (accessible && !e.accessible))
        continue;
      const next = e.from === current ? e.to : e.to === current ? e.from : null;
      if (!next || !pending.has(next)) continue;
      const d = dist.get(current)! + e.distance;
      if (d < dist.get(next)!) {
        dist.set(next, d);
        previous.set(next, { node: current, edge: e });
      }
    }
  }
  if (!Number.isFinite(dist.get(goal)!)) return null;
  const nodes = [byId.get(goal)!],
    edges: Edge[] = [];
  let id = goal;
  while (id !== start) {
    const p = previous.get(id);
    if (!p) return null;
    nodes.unshift(byId.get(p.node)!);
    edges.unshift(p.edge);
    id = p.node;
  }
  const distance = dist.get(goal)!;
  return {
    nodes,
    edges,
    distance,
    seconds:
      distance / (accessible ? 0.9 : 1.25) +
      edges.filter((e) => e.type === "lift").length * 20,
  };
}
export function positionAlong(
  route: Route,
  meters: number,
): { position: Point; index: number; arrived: boolean } {
  let remaining = Math.max(0, meters);
  for (let i = 0; i < route.edges.length; i++) {
    const e = route.edges[i];
    if (remaining < e.distance) {
      const t = remaining / e.distance,
        a = route.nodes[i].position,
        b = route.nodes[i + 1].position;
      return {
        position: a.map((v, j) => v + (b[j] - v) * t) as Point,
        index: i,
        arrived: false,
      };
    }
    remaining -= e.distance;
  }
  return {
    position: route.nodes.at(-1)!.position,
    index: Math.max(0, route.edges.length - 1),
    arrived: true,
  };
}
export type LocationFix = {
  node: string;
  source: "qr" | "simulation" | "indoor";
  timestamp: number;
  accuracyMeters: number | null;
};
export function checkpointFix(
  map: StationMap,
  code: string,
  now = Date.now(),
): LocationFix | null {
  const n = map.nodes.find((n) => n.checkpoint === code.trim());
  return n
    ? { node: n.id, source: "qr", timestamp: now, accuracyMeters: null }
    : null;
}
export interface IndoorPositionProvider {
  subscribe(onFix: (fix: LocationFix) => void): () => void;
}
