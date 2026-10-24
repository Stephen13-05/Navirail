import { useState } from "react";
import { categories, type StationMap, type Node, type Edge } from "./data";
export default function NetworkEditor({
  map,
  onChange,
}: {
  map: StationMap;
  onChange: (m: StationMap) => void;
}) {
  const [selected, setSelected] = useState("entrance"),
    [mode, setMode] = useState<"select" | "place" | "connect">("select"),
    [floor, setFloor] = useState(0),
    [linkFrom, setLinkFrom] = useState(""),
    [edgeType, setEdgeType] = useState<Edge["type"]>("walk");
  const node = map.nodes.find((n) => n.id === selected);
  function updateNode(patch: Partial<Node>) {
    onChange({
      ...map,
      nodes: map.nodes.map((n) => (n.id === selected ? { ...n, ...patch } : n)),
    });
  }
  function select(id: string) {
    if (mode === "connect") {
      if (!linkFrom) {
        setLinkFrom(id);
        return;
      }
      if (linkFrom === id) {
        setLinkFrom("");
        return;
      }
      const a = map.nodes.find((n) => n.id === linkFrom)!,
        b = map.nodes.find((n) => n.id === id)!;
      const edge: Edge = {
        id: `${linkFrom}:${id}:${Date.now()}`,
        from: linkFrom,
        to: id,
        distance: Math.max(
          1,
          Math.hypot(...a.position.map((v, i) => v - b.position[i])) * 3,
        ),
        type: edgeType,
        accessible: edgeType !== "stairs",
        open: true,
      };
      onChange({ ...map, edges: [...map.edges, edge] });
      setLinkFrom("");
    } else setSelected(id);
  }
  return (
    <div className="network-editor">
      <div className="admin-toolbar">
        {(["select", "place", "connect"] as const).map((m) => (
          <button
            className={m === mode ? "editor-active" : ""}
            key={m}
            onClick={() => {
              setMode(m);
              setLinkFrom("");
            }}
          >
            {m === "select"
              ? "Edit facility"
              : m === "place"
                ? "Place facility"
                : "Draw connection"}
          </button>
        ))}
        <select
          aria-label="Editor floor"
          value={floor}
          onChange={(e) => setFloor(Number(e.target.value))}
        >
          <option value={0}>Ground floor</option>
          <option value={1}>Footbridge</option>
        </select>
        {mode === "connect" && (
          <select
            aria-label="Connection type"
            value={edgeType}
            onChange={(e) => setEdgeType(e.target.value as Edge["type"])}
          >
            <option value="walk">Walkway</option>
            <option value="stairs">Stairs</option>
            <option value="lift">Lift</option>
          </select>
        )}
      </div>
      <small>
        {mode === "place"
          ? "Click an empty position to place a facility."
          : mode === "connect"
            ? linkFrom
              ? "Select the second endpoint. Change floors to connect a lift or stairs."
              : "Select two endpoints to draw a pedestrian connection."
            : "Select a marker to edit its details. Red paths are closed."}
      </small>
      <svg
        className="network-canvas"
        viewBox="-65 -60 130 120"
        aria-label="Draft pedestrian network"
        onClick={(e) => {
          if (mode !== "place") return;
          const svg = e.currentTarget;
          const pt = svg.createSVGPoint();
          pt.x = e.clientX;
          pt.y = e.clientY;
          const p = pt.matrixTransform(svg.getScreenCTM()!.inverse());
          const id = "facility-" + Date.now();
          onChange({
            ...map,
            nodes: [
              ...map.nodes,
              {
                id,
                station: map.station,
                name: "New facility",
                floor,
                position: [Math.round(p.x), floor * 6, Math.round(p.y)],
                category: "Waiting Halls",
              },
            ],
          });
          setSelected(id);
          setMode("select");
        }}
      >
        <rect x="-65" y="-60" width="130" height="120" fill="#eef3f8" />
        {map.edges.map((e) => {
          const a = map.nodes.find((n) => n.id === e.from),
            b = map.nodes.find((n) => n.id === e.to);
          if (!a || !b || (a.floor !== floor && b.floor !== floor)) return null;
          return (
            <line
              key={e.id}
              x1={a.position[0]}
              y1={a.position[2]}
              x2={b.position[0]}
              y2={b.position[2]}
              stroke={
                !e.open ? "#e36b70" : e.type === "lift" ? "#8d6cd4" : "#8daac1"
              }
              strokeWidth={e.open ? 0.5 : 1}
              strokeDasharray={e.type === "walk" ? undefined : "1,1"}
            />
          );
        })}
        {map.nodes
          .filter((n) => n.floor === floor)
          .map((n) => (
            <g
              key={n.id}
              onClick={(e) => {
                e.stopPropagation();
                select(n.id);
              }}
              style={{ cursor: "pointer" }}
            >
              <circle
                cx={n.position[0]}
                cy={n.position[2]}
                r={n.id === selected || n.id === linkFrom ? 2 : 1.3}
                fill={
                  n.id === selected
                    ? "#0969ff"
                    : n.id === linkFrom
                      ? "#00a588"
                      : "#52768f"
                }
              />
              <title>{n.name}</title>
              {n.category !== "Passage" && (
                <text
                  x={n.position[0] + 2}
                  y={n.position[2] - 2}
                  fontSize="2"
                  fill="#34536c"
                >
                  {n.name}
                </text>
              )}
            </g>
          ))}
      </svg>
      {node && (
        <div className="admin-grid">
          <label>
            Facility name
            <input
              value={node.name}
              onChange={(e) => updateNode({ name: e.target.value })}
            />
          </label>
          <label>
            Category
            <select
              value={node.category}
              onChange={(e) => updateNode({ category: e.target.value })}
            >
              {[
                "Entrance",
                "Passage",
                "Footbridge",
                ...categories.slice(1),
              ].map((c) => (
                <option key={c}>{c}</option>
              ))}
            </select>
          </label>
          <label>
            Checkpoint payload
            <input
              value={node.checkpoint || ""}
              onChange={(e) =>
                updateNode({ checkpoint: e.target.value || undefined })
              }
            />
          </label>
          <label>
            Coordinates (x, height, z)
            <div className="coordinate-inputs">
              {node.position.map((v, i) => (
                <input
                  key={i}
                  type="number"
                  aria-label={["X coordinate", "Height", "Z coordinate"][i]}
                  value={v}
                  onChange={(e) => {
                    const position = [...node.position] as Node["position"];
                    position[i] = Number(e.target.value);
                    updateNode({ position, floor: position[1] > 0 ? 1 : 0 });
                  }}
                />
              ))}
            </div>
          </label>
        </div>
      )}
      <details>
        <summary>Pathway availability ({map.edges.length} connections)</summary>
        <div className="edge-list">
          {map.edges.map((e) => (
            <label key={e.id}>
              <input
                type="checkbox"
                checked={e.open}
                onChange={(event) =>
                  onChange({
                    ...map,
                    edges: map.edges.map((item) =>
                      item.id === e.id
                        ? { ...item, open: event.target.checked }
                        : item,
                    ),
                  })
                }
              />
              {e.from} → {e.to} · {e.type} · {Math.round(e.distance)} m
            </label>
          ))}
        </div>
      </details>
    </div>
  );
}
