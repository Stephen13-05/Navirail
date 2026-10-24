export type Point = [number, number, number];
export type Node = {
  id: string;
  station: string;
  floor: number;
  name: string;
  position: Point;
  category: string;
  checkpoint?: string;
};
export type Edge = {
  id: string;
  from: string;
  to: string;
  distance: number;
  type: "walk" | "stairs" | "lift";
  accessible: boolean;
  open: boolean;
};
export type RestrictedZone = {
  id: string;
  floor: number;
  minX: number;
  maxX: number;
  minZ: number;
  maxZ: number;
};
export type StationMap = {
  restrictedZones?: RestrictedZone[];
  station: string;
  version: number;
  status: "demonstration" | "verified";
  nodes: Node[];
  edges: Edge[];
};
export const stations = [
  {
    code: "MAS",
    name: "Chennai Central",
    local: "சென்னை சென்ட்ரல்",
    city: "Chennai, Tamil Nadu",
    map: "demonstration",
  },
  {
    code: "MS",
    name: "Chennai Egmore",
    local: "சென்னை எழும்பூர்",
    city: "Chennai, Tamil Nadu",
    map: null,
  },
  {
    code: "TBM",
    name: "Tambaram",
    local: "தாம்பரம்",
    city: "Tamil Nadu",
    map: null,
  },
  { code: "AVD", name: "Avadi", local: "ஆவடி", city: "Tamil Nadu", map: null },
  {
    code: "CGL",
    name: "Chengalpattu",
    local: "செங்கல்பட்டு",
    city: "Tamil Nadu",
    map: null,
  },
];
const nodes: Node[] = [];
const edges: Edge[] = [];
function node(
  id: string,
  name: string,
  position: Point,
  category = "Passage",
  checkpoint?: string,
) {
  nodes.push({
    id,
    station: "MAS",
    floor: position[1] > 0 ? 1 : 0,
    name,
    position,
    category,
    checkpoint,
  });
}
function edge(
  from: string,
  to: string,
  type: Edge["type"] = "walk",
  accessible = true,
) {
  const a = nodes.find((n) => n.id === from)!,
    b = nodes.find((n) => n.id === to)!;
  edges.push({
    id: `${from}:${to}`,
    from,
    to,
    distance: Math.hypot(...a.position.map((v, i) => v - b.position[i])) * 3,
    type,
    accessible,
    open: true,
  });
}
node("entrance", "Main Entrance", [0, 0, 43], "Entrance", "NR:MAS:entrance");
node("hall", "Main Concourse", [0, 0, 28], "Waiting Halls", "NR:MAS:hall");
edge("entrance", "hall");
node("west", "West Concourse", [-48, 0, 28]);
node("east", "East Concourse", [56, 0, 28]);
edge("hall", "west");
edge("hall", "east");
node("stairs", "West Staircase", [-48, 0, 12], "Stairs");
node("bridge-west", "West Footbridge", [-48, 6, -3], "Footbridge");
edge("west", "stairs");
edge("stairs", "bridge-west", "stairs", false);
node("lift-west", "West Lift", [-55, 0, 12], "Lifts");
node("lift-top", "West Lift · Upper", [-55, 6, 12], "Lifts");
edge("west", "lift-west");
edge("lift-west", "lift-top", "lift");
edge("lift-top", "bridge-west");
node("east-stairs", "East Staircase", [56, 0, 12], "Stairs");
node("bridge-east", "East Footbridge", [56, 6, -3], "Footbridge");
edge("east", "east-stairs");
edge("east-stairs", "bridge-east", "stairs", false);
for (let i = 1; i <= 7; i++) {
  const x = -42 + (i - 1) * 14;
  node(`b${i}`, `Footbridge · Platform ${i}`, [x, 6, -3], "Footbridge");
  node(`p${i}`, `Platform ${i}`, [x, 0, -16], "Platforms", `NR:MAS:p${i}`);
  node(`l${i}`, `Platform ${i} Lift`, [x + 3, 0, -3], "Lifts");
  node(`u${i}`, `Lift landing ${i}`, [x + 3, 6, -3]);
  edge(`b${i}`, `p${i}`, "stairs", false);
  edge(`b${i}`, `u${i}`);
  edge(`u${i}`, `l${i}`, "lift");
  edge(`l${i}`, `p${i}`);
  if (i > 1) edge(`b${i - 1}`, `b${i}`);
}
edge("bridge-west", "b1");
edge("b7", "bridge-east");
const facilities: [string, string, Point, string][] = [
  ["tickets", "Ticket Counters", [-28, 0, 35], "Ticket Counters"],
  ["food", "Food & Shops", [-32, 0, 22], "Food & Shops"],
  ["toilets", "Central Restrooms", [25, 0, 35], "Restrooms"],
  ["police", "Police Help Desk", [38, 0, 35], "Police Assistance"],
  ["medical", "Medical Assistance", [-40, 0, 35], "Medical"],
  ["office", "Railway Office", [36, 0, 22], "Railway Offices"],
  ["water", "Drinking Water", [18, 0, 22], "Drinking Water"],
  ["charge", "Charging Points", [-15, 0, 22], "Charging Points"],
  ["parking", "Station Parking", [26, 0, 48], "Parking"],
];
for (const [id, name, p, category] of facilities) {
  node(id, name, p, category);
  const junction = `j-${id}`;
  node(junction, `${name} junction`, [p[0], 0, 28]);
  if (id === "parking") {
    const corner = "parking-turn";
    node(corner, "Entrance forecourt", [0, 0, 48]);
    edge("entrance", corner);
    edge(corner, id);
    edge("hall", junction);
  } else {
    edge("hall", junction);
    edge(junction, id);
  }
}
export const demoMap: StationMap = {
  station: "MAS",
  version: 1,
  status: "demonstration",
  nodes,
  edges,
  restrictedZones: Array.from({ length: 7 }, (_, i) => ({
    id: "track-" + i,
    floor: 0,
    minX: -37 + i * 14,
    maxX: -33 + i * 14,
    minZ: -53,
    maxZ: 20,
  })),
};
export const categories = [
  "All facilities",
  "Platforms",
  "Ticket Counters",
  "Waiting Halls",
  "Restrooms",
  "Lifts",
  "Stairs",
  "Food & Shops",
  "Police Assistance",
  "Parking",
  "Medical",
  "Railway Offices",
  "Drinking Water",
  "Charging Points",
];
