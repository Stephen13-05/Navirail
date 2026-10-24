import { Suspense, useEffect, useRef, useState } from "react";
import { Canvas, useFrame, useThree } from "@react-three/fiber";
import { OrbitControls, Html, Line, useGLTF } from "@react-three/drei";
import * as THREE from "three";
import type { OrbitControls as OrbitType } from "three-stdlib";
import type { Node, Point, StationMap } from "./data";
import type { Route } from "./routing";
export type SceneProps = {
  map: StationMap;
  route: Route | null;
  position: Point;
  selected: string;
  onSelect: (id: string) => void;
  view: "2D" | "3D";
  floor: string;
  roof: boolean;
  command: { type: string; tick: number };
  filter: string;
  modelUrl?: string;
};
function Box({
  p,
  s,
  c,
  onClick,
  opacity = 1,
}: {
  p: Point;
  s: Point;
  c: string;
  onClick?: () => void;
  opacity?: number;
}) {
  const [hover, setHover] = useState(false);
  return (
    <mesh
      position={p}
      castShadow
      receiveShadow
      onClick={
        onClick
          ? (e) => {
              e.stopPropagation();
              onClick();
            }
          : undefined
      }
      onPointerOver={onClick ? () => setHover(true) : undefined}
      onPointerOut={() => setHover(false)}
    >
      <boxGeometry args={s} />
      <meshStandardMaterial
        color={hover ? "#9bd4ff" : c}
        roughness={0.75}
        transparent={opacity < 1}
        opacity={opacity}
      />
    </mesh>
  );
}
function Tree({ x, z }: { x: number; z: number }) {
  return (
    <group position={[x, 0, z]}>
      <Box p={[0, 1, 0]} s={[0.6, 2, 0.6]} c="#947a65" />
      <mesh position={[0, 3, 0]} castShadow>
        <icosahedronGeometry args={[2, 1]} />
        <meshStandardMaterial color="#6b9c7d" />
      </mesh>
    </group>
  );
}
function Controls({
  view,
  command,
  selected,
  map,
}: Pick<SceneProps, "view" | "command" | "selected" | "map">) {
  const controls = useRef<OrbitType>(null);
  const { camera, size } = useThree();
  const fit = Math.max(1, 1.15 / (size.width / size.height));
  useEffect(() => {
    if (!controls.current) return;
    camera.position
      .set(
        view === "2D" ? 0 : 106,
        view === "2D" ? 150 : 102,
        view === "2D" ? 0.01 : 125,
      )
      .multiplyScalar(fit);
    controls.current.target.set(0, 0, 4);
    controls.current.update();
  }, [view, camera, fit]);
  useEffect(() => {
    const c = controls.current;
    if (!c) return;
    if (command.type === "reset") {
      camera.position
        .set(
          view === "2D" ? 0 : 106,
          view === "2D" ? 150 : 102,
          view === "2D" ? 0.01 : 125,
        )
        .multiplyScalar(fit);
      c.target.set(0, 0, 4);
    }
    if (command.type === "in" || command.type === "out") {
      camera.position
        .sub(c.target)
        .multiplyScalar(command.type === "in" ? 0.8 : 1.25)
        .add(c.target);
    }
    if (command.type === "rotate") {
      const v = camera.position.clone().sub(c.target);
      v.applyAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI / 6);
      camera.position.copy(c.target).add(v);
    }
    c.update();
  }, [command, camera, view]);
  useEffect(() => {
    const n = map.nodes.find((n) => n.id === selected);
    const c = controls.current;
    if (!c || !n) return;
    const target = new THREE.Vector3(...n.position);
    target.multiplyScalar(0.35);
    const offset = camera.position.clone().sub(c.target);
    c.target.copy(target);
    camera.position.copy(target).add(offset);
    c.update();
  }, [selected, map, camera]);
  return (
    <OrbitControls
      ref={controls}
      makeDefault
      enableRotate={view === "3D"}
      minDistance={35}
      maxDistance={260}
      maxPolarAngle={Math.PI / 2.15}
      enableDamping
    />
  );
}
function RouteLine({ route }: { route: Route }) {
  const dot = useRef<THREE.Mesh>(null);
  useFrame(({ clock }) => {
    if (!dot.current) return;
    const t = (clock.elapsedTime * 0.2) % 1;
    let d = t * route.distance;
    for (let i = 0; i < route.edges.length; i++) {
      if (d < route.edges[i].distance) {
        const a = route.nodes[i].position,
          b = route.nodes[i + 1].position,
          f = d / route.edges[i].distance;
        dot.current.position.set(
          a[0] + (b[0] - a[0]) * f,
          a[1] + (b[1] - a[1]) * f + 1,
          b[2] * f + a[2] * (1 - f),
        );
        return;
      }
      d -= route.edges[i].distance;
    }
  });
  if (route.nodes.length < 2) return null;
  const pts = route.nodes.map(
    (n) => [n.position[0], n.position[1] + 0.7, n.position[2]] as Point,
  );
  return (
    <>
      <Line
        points={pts}
        color="#99dcff"
        lineWidth={13}
        transparent
        opacity={0.45}
      />
      <Line points={pts} color="#087aff" lineWidth={5} />
      <Line
        points={pts.map((p) => [p[0], p[1] + 0.05, p[2]]) as Point[]}
        color="white"
        lineWidth={1.5}
        dashed
        dashSize={1.3}
        gapSize={1}
      />
      <mesh ref={dot}>
        <sphereGeometry args={[0.65, 12, 12]} />
        <meshBasicMaterial color="white" />
      </mesh>
    </>
  );
}
function ImportedModel({ url }: { url: string }) {
  const gltf = useGLTF(url);
  return <primitive object={gltf.scene} />;
}
function Model(props: SceneProps) {
  const { map, route, position, selected, onSelect, floor, roof, filter } =
    props;
  return (
    <>
      <color attach="background" args={["#e8f0f2"]} />
      <ambientLight intensity={1.4} />
      <directionalLight
        position={[30, 80, 40]}
        intensity={2.2}
        castShadow
        shadow-mapSize={[1024, 1024]}
        shadow-camera-left={-90}
        shadow-camera-right={90}
        shadow-camera-top={90}
        shadow-camera-bottom={-90}
      />
      <Box p={[0, -1, 0]} s={[124, 2, 114]} c="#cbd8d1" />
      <Box p={[0, 0.05, 29]} s={[106, 0.25, 23]} c="#eee6d4" />
      <Box p={[0, 0.05, 46]} s={[118, 0.25, 14]} c="#d8dfe0" />
      {Array.from({ length: 7 }, (_, i) => {
        const x = -42 + i * 14,
          id = `p${i + 1}`;
        return (
          <group key={id}>
            <Box
              p={[x, 0, -13]}
              s={[7, 0.65, 62]}
              c={selected === id ? "#a6d7ff" : "#e5ddc9"}
              onClick={() => onSelect(id)}
            />
            <Box p={[x - 3.15, 0.4, -13]} s={[0.25, 0.1, 62]} c="#e5ba57" />
            <Box p={[x + 3.15, 0.4, -13]} s={[0.25, 0.1, 62]} c="#e5ba57" />
            {[-1.5, 1.5].map((dx) => (
              <Box
                key={dx}
                p={[x + 7 + dx, 0.15, -16]}
                s={[0.16, 0.2, 75]}
                c="#79888b"
              />
            ))}
            {Array.from({ length: 26 }, (_, j) => (
              <Box
                key={j}
                p={[x + 7, 0.03, -50 + j * 2.8]}
                s={[4, 0.15, 0.45]}
                c="#98a09b"
              />
            ))}
            {floor !== "1" &&
              i < 6 &&
              Array.from({ length: 4 }, (_, j) => (
                <group key={j}>
                  <Box
                    p={[x + 7, 1.7, -36 + j * 11]}
                    s={[3.4, 3, 10]}
                    c={i % 2 === 0 ? "#e5ecee" : "#bde1ee"}
                  />
                  <Box
                    p={[x + 7, 1.1, -36 + j * 11]}
                    s={[3.5, 0.65, 10]}
                    c={i % 2 === 0 ? "#bf6264" : "#397bba"}
                  />
                  <Box
                    p={[x + 5.25, 2.2, -36 + j * 11]}
                    s={[0.1, 0.8, 8]}
                    c="#354e62"
                  />
                  <Box
                    p={[x + 8.75, 2.2, -36 + j * 11]}
                    s={[0.1, 0.8, 8]}
                    c="#354e62"
                  />
                </group>
              ))}
            {roof && floor !== "1" && (
              <>
                <Box p={[x, 5.4, -29]} s={[8, 0.4, 29]} c="#9aaeb9" />
                {[-39, -22].map((z) => (
                  <Box
                    key={z}
                    p={[x, 2.8, z]}
                    s={[0.4, 5.5, 0.4]}
                    c="#7d8e98"
                  />
                ))}
              </>
            )}
            {floor !== "0" && (
              <>
                {Array.from({ length: 12 }, (_, j) => (
                  <Box
                    key={j}
                    p={[x, 6 - j * 0.46, -3 - j * 1.05]}
                    s={[2.4, 0.5, 1.15]}
                    c="#c0cccd"
                  />
                ))}
                <Box
                  p={[x + 3, 3, -3]}
                  s={[2, 6, 2.4]}
                  c="#6fbbd2"
                  opacity={0.75}
                />
              </>
            )}
            <Html position={[x, roof ? 7 : 1, -29]} center distanceFactor={145}>
              <button
                className={`map-label platform ${selected === id ? "selected" : ""}`}
                onClick={() => onSelect(id)}
              >
                P{i + 1}
              </button>
            </Html>
          </group>
        );
      })}
      {floor !== "0" && (
        <>
          <Box p={[0, 5.8, -3]} s={[112, 0.5, 5]} c="#e2e9ed" />
          <Box
            p={[0, 6.6, -5.4]}
            s={[112, 1.2, 0.16]}
            c="#9ab9cb"
            opacity={0.7}
          />
          <Box
            p={[0, 6.6, -0.6]}
            s={[112, 1.2, 0.16]}
            c="#9ab9cb"
            opacity={0.7}
          />
          {[-48, 56].map((x) => (
            <group key={x}>
              {Array.from({ length: 16 }, (_, j) => (
                <Box
                  key={j}
                  p={[x, 6 - j * 0.36, -3 + j * 0.95]}
                  s={[3, 0.4, 1.1]}
                  c="#bfcacc"
                />
              ))}
            </group>
          ))}
          <Box p={[-55, 3, 12]} s={[3, 6, 3]} c="#64b6d1" opacity={0.8} />
        </>
      )}
      <Box p={[-23, 3, 40]} s={[36, 6, 5]} c="#bc6b59" />
      <Box p={[23, 3, 40]} s={[36, 6, 5]} c="#bc6b59" />
      <Box p={[0, 10, 40]} s={[7, 8, 6]} c="#c27a63" />
      <Box p={[0, 14.3, 40]} s={[9, 1, 8]} c="#f4dfbf" />
      <mesh position={[0, 17, 40]} rotation={[0, Math.PI / 4, 0]} castShadow>
        <coneGeometry args={[5, 5, 4]} />
        <meshStandardMaterial color="#93574c" />
      </mesh>
      <Html position={[0, 11, 43.2]} center>
        <div className="clock-face">◷</div>
      </Html>
      {[-38, -30, -22, -14, 14, 22, 30, 38].map((x) => (
        <Box key={x} p={[x, 3.3, 42.6]} s={[2, 3, 0.1]} c="#f4dfbf" />
      ))}
      {map.nodes
        .filter(
          (n) =>
            ![
              "Passage",
              "Platforms",
              "Entrance",
              "Footbridge",
              "Stairs",
              "Lifts",
            ].includes(n.category),
        )
        .map((n) => (
          <group key={n.id}>
            <Box
              p={[n.position[0], 1.5, n.position[2]]}
              s={[5, 3, 4]}
              c={
                n.category === "Restrooms"
                  ? "#78c1b2"
                  : n.category === "Food & Shops"
                    ? "#e9af6b"
                    : "#a4bacd"
              }
              onClick={() => onSelect(n.id)}
            />
            {((filter === "All facilities" &&
              ["hall", "tickets", "food", "toilets"].includes(n.id)) ||
              n.category === filter ||
              n.id === selected) && (
              <Html
                position={[n.position[0], 4, n.position[2]]}
                center
                distanceFactor={150}
              >
                <button
                  className={`map-label ${selected === n.id ? "selected" : ""}`}
                  onClick={() => onSelect(n.id)}
                >
                  {n.name}
                </button>
              </Html>
            )}
          </group>
        ))}
      {[-57, 57].flatMap((x) =>
        [-42, -25, 0, 27, 45].map((z) => (
          <Tree key={`${x}:${z}`} x={x} z={z} />
        )),
      )}
      {route && <RouteLine route={route} />}
      <mesh position={[position[0], position[1] + 1.5, position[2]]}>
        <sphereGeometry args={[1, 20, 20]} />
        <meshStandardMaterial
          color="#087aff"
          emissive="#087aff"
          emissiveIntensity={0.3}
        />
      </mesh>
      <Html position={[position[0], position[1] + 4, position[2]]} center>
        <span className="you-marker">● You are here</span>
      </Html>
      {props.modelUrl && (
        <Suspense fallback={null}>
          <ImportedModel url={props.modelUrl} />
        </Suspense>
      )}
      <Controls {...props} />
    </>
  );
}
export default function StationScene(props: SceneProps) {
  return (
    <Canvas
      shadows
      dpr={[1, 1.5]}
      camera={{ position: [106, 102, 125], fov: 43, near: 0.1, far: 600 }}
      gl={{ antialias: true, powerPreference: "low-power" }}
    >
      <Model {...props} />
    </Canvas>
  );
}
export function FlatMap({
  map,
  route,
  position,
  selected,
  onSelect,
}: SceneProps) {
  const project = (p: Point) => [p[0] + 62, p[2] + 56];
  return (
    <svg
      className="flat-map"
      viewBox="0 0 124 114"
      role="img"
      aria-label="Schematic demonstration station map"
    >
      <rect width="124" height="114" fill="#e6eeea" />
      {Array.from({ length: 7 }, (_, i) => (
        <g
          key={i}
          onClick={() => onSelect(`p${i + 1}`)}
          style={{ cursor: "pointer" }}
        >
          <rect
            x={16 + i * 14}
            y="12"
            width="7"
            height="62"
            fill={selected === `p${i + 1}` ? "#87c6ff" : "#d6ccb4"}
          />
          <text x={19.5 + i * 14} y="30" textAnchor="middle" fontSize="3">
            P{i + 1}
          </text>
        </g>
      ))}
      <rect x="6" y="50" width="112" height="5" fill="#b9ccd9" />
      {map.edges
        .filter((e) => e.open)
        .map((e) => {
          const a = project(map.nodes.find((n) => n.id === e.from)!.position),
            b = project(map.nodes.find((n) => n.id === e.to)!.position);
          return (
            <line
              key={e.id}
              x1={a[0]}
              y1={a[1]}
              x2={b[0]}
              y2={b[1]}
              stroke="#c5d2cd"
              strokeWidth=".6"
            />
          );
        })}
      {route && (
        <polyline
          points={route.nodes
            .map((n) => project(n.position).join(","))
            .join(" ")}
          fill="none"
          stroke="#087aff"
          strokeWidth="1.3"
        />
      )}
      {map.nodes
        .filter((n) => n.category !== "Passage")
        .map((n) => {
          const p = project(n.position);
          return (
            <circle
              key={n.id}
              cx={p[0]}
              cy={p[1]}
              r="1.2"
              fill={selected === n.id ? "#ef5769" : "#7593a6"}
              onClick={() => onSelect(n.id)}
            >
              <title>{n.name}</title>
            </circle>
          );
        })}
      <circle
        cx={project(position)[0]}
        cy={project(position)[1]}
        r="2"
        fill="#087aff"
        stroke="white"
        strokeWidth=".7"
      />
    </svg>
  );
}
