import express from "express";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import {
  randomBytes,
  scryptSync,
  timingSafeEqual,
  randomUUID,
} from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { z } from "zod";
import { demoMap, stations, type StationMap } from "../src/data";
import { validateMap, findRoute } from "../src/routing";
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const dataDir = path.resolve(
  process.env.NAVIRAIL_DATA_DIR || path.join(root, ".local"),
);
fs.mkdirSync(dataDir, { recursive: true });
const storeFile = path.join(dataDir, "maps.json");
const schema = z.object({
  restrictedZones: z
    .array(
      z.object({
        id: z.string(),
        floor: z.number().int(),
        minX: z.number().finite(),
        maxX: z.number().finite(),
        minZ: z.number().finite(),
        maxZ: z.number().finite(),
      }),
    )
    .max(1000)
    .optional(),
  station: z.literal("MAS"),
  version: z.number().int().positive(),
  status: z.literal("demonstration"),
  nodes: z
    .array(
      z.object({
        id: z.string().min(1).max(80),
        name: z.string().min(1).max(100),
        station: z.literal("MAS"),
        floor: z.number().int().min(0).max(10),
        position: z.tuple([
          z.number().finite(),
          z.number().finite(),
          z.number().finite(),
        ]),
        category: z.string().max(60),
        checkpoint: z.string().max(100).optional(),
      }),
    )
    .min(1)
    .max(3000),
  edges: z
    .array(
      z.object({
        id: z.string().min(1).max(180),
        from: z.string(),
        to: z.string(),
        distance: z.number().positive().finite(),
        type: z.enum(["walk", "stairs", "lift"]),
        accessible: z.boolean(),
        open: z.boolean(),
      }),
    )
    .max(10000),
});
export type Store = {
  draft: StationMap;
  versions: StationMap[];
  published: number;
  audit: { at: string; action: string; actor: string; version: number }[];
};
let state: Store = fs.existsSync(storeFile)
  ? JSON.parse(fs.readFileSync(storeFile, "utf8"))
  : {
      draft: structuredClone(demoMap),
      versions: [structuredClone(demoMap)],
      published: 1,
      audit: [],
    };
function save(action: string) {
  state.audit.push({
    at: new Date().toISOString(),
    action,
    actor: "local-admin",
    version: state.published,
  });
  if (fs.existsSync(storeFile))
    fs.copyFileSync(storeFile, storeFile + ".backup");
  fs.writeFileSync(storeFile + ".tmp", JSON.stringify(state, null, 2));
  fs.renameSync(storeFile + ".tmp", storeFile);
}
const credentialsFile = path.join(dataDir, "admin-password.txt");
let password = process.env.NAVIRAIL_ADMIN_PASSWORD;
if (!password) {
  if (fs.existsSync(credentialsFile))
    password = fs.readFileSync(credentialsFile, "utf8").trim();
  else {
    password = randomBytes(24).toString("base64url");
    fs.writeFileSync(credentialsFile, password, { mode: 0o600 });
  }
}
const salt = randomBytes(16),
  passwordHash = scryptSync(password, salt, 64);
const sessions = new Map<string, number>();
export const app = express();
app.disable("x-powered-by");
app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'wasm-unsafe-eval'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", "data:", "blob:"],
        fontSrc: ["'self'", "data:", "https://fonts.gstatic.com"],
        connectSrc: ["'self'", "https://fonts.gstatic.com"],
        workerSrc: ["'self'", "blob:"],
        frameSrc: ["'self'"],
        upgradeInsecureRequests: null,
      },
    },
    crossOriginEmbedderPolicy: false,
  }),
);
app.use(
  "/api",
  rateLimit({
    windowMs: 60000,
    limit: 150,
    standardHeaders: "draft-8",
    legacyHeaders: false,
  }),
);
app.use(express.json({ limit: "2mb" }));
app.use("/api", (req, res, next) => {
  if (!["GET", "HEAD", "OPTIONS"].includes(req.method)) {
    const origin = req.get("origin");
    if (
      origin &&
      ![
        "http://127.0.0.1:8090",
        "http://localhost:8090",
        "http://127.0.0.1:5173",
        "http://localhost:5173",
        "http://127.0.0.1:8080",
        "http://localhost:8080",
      ].includes(origin)
    ) {
      res.status(403).json({ error: "Origin not allowed" });
      return;
    }
  }
  next();
});
app.get("/api/health", (_, res) =>
  res.json({ status: "ok", storage: "local-file", mapStatus: "demonstration" }),
);
app.get("/api/stations", (req, res) => {
  const q = String(req.query.q || "").toLowerCase();
  res.json(
    stations.filter((s) => `${s.name} ${s.code}`.toLowerCase().includes(q)),
  );
});
app.get("/api/stations/:code/map", (req, res) => {
  if (req.params.code !== "MAS") {
    res.status(404).json({ error: "Detailed Indoor Map Not Available" });
    return;
  }
  res.json(state.versions.find((v) => v.version === state.published));
});
app.post("/api/route", (req, res) => {
  const parsed = z
    .object({
      station: z.literal("MAS"),
      start: z.string(),
      destination: z.string(),
      accessible: z.boolean().default(false),
    })
    .safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid routing request" });
    return;
  }
  const { start, destination, accessible } = parsed.data;
  const route = findRoute(
    state.versions.find((v) => v.version === state.published)!,
    start,
    destination,
    accessible,
  );
  if (!route) {
    res.status(404).json({ error: "No permitted route" });
    return;
  }
  res.json(route);
});
app.post(
  "/api/admin/login",
  rateLimit({ windowMs: 15 * 60000, limit: 10 }),
  (req, res) => {
    const candidate =
      typeof req.body?.password === "string" ? req.body.password : "";
    if (
      candidate.length > 256 ||
      !timingSafeEqual(scryptSync(candidate, salt, 64), passwordHash)
    ) {
      res.status(401).json({ error: "Invalid administrator password" });
      return;
    }
    const token = randomBytes(32).toString("hex");
    sessions.set(token, Date.now() + 3600000);
    res.cookie("navirail_admin", token, {
      httpOnly: true,
      sameSite: "strict",
      secure: false,
      maxAge: 3600000,
      path: "/api/admin",
    });
    res.json({ role: "admin" });
  },
);
app.use("/api/admin", (req, res, next) => {
  const token = (req.headers.cookie || "")
    .split(";")
    .map((s) => s.trim())
    .find((s) => s.startsWith("navirail_admin="))
    ?.split("=")[1];
  if (!token || !sessions.has(token) || sessions.get(token)! < Date.now()) {
    res.status(401).json({ error: "Administrator sign-in required" });
    return;
  }
  next();
});
app.post("/api/admin/logout", (req, res) => {
  const token = (req.headers.cookie || "")
    .split(";")
    .map((s) => s.trim())
    .find((s) => s.startsWith("navirail_admin="))
    ?.split("=")[1];
  if (token) sessions.delete(token);
  res.clearCookie("navirail_admin", { path: "/api/admin" });
  res.json({ ok: true });
});
app.get("/api/admin/maps", (_, res) => res.json(state));
app.put("/api/admin/draft", (req, res) => {
  const result = schema.safeParse(req.body);
  if (!result.success) {
    res
      .status(400)
      .json({ error: "Invalid map schema", details: result.error.issues });
    return;
  }
  const errors = validateMap(result.data);
  if (errors.length) {
    res.status(400).json({ error: errors.join("\n") });
    return;
  }
  state.draft = result.data;
  save("Saved draft");
  res.json(state);
});
app.post("/api/admin/validate", (_, res) => {
  const errors = validateMap(state.draft);
  const unreachable = state.draft.nodes
    .filter((n) => !findRoute(state.draft, "entrance", n.id))
    .map((n) => n.name);
  res.json({
    errors,
    unreachable,
    accessibleUnreachable: state.draft.nodes
      .filter((n) => !findRoute(state.draft, "entrance", n.id, true))
      .map((n) => n.name),
  });
});
app.post("/api/admin/publish", (_, res) => {
  const errors = validateMap(state.draft);
  if (errors.length || !state.draft.nodes.some((n) => n.id === "entrance")) {
    res
      .status(400)
      .json({ error: "Map must have a valid network and entrance" });
    return;
  }
  const disconnected = state.draft.nodes.some(
    (n) => !findRoute(state.draft, "entrance", n.id),
  );
  if (disconnected) {
    res
      .status(400)
      .json({
        error:
          "Disconnected nodes: validate and repair the draft before publication",
      });
    return;
  }
  const version = Math.max(...state.versions.map((v) => v.version)) + 1;
  const map = { ...structuredClone(state.draft), version };
  state.versions.push(map);
  state.published = version;
  state.draft = structuredClone(map);
  save("Published demonstration map");
  res.json(map);
});
app.post("/api/admin/rollback", (req, res) => {
  const version = req.body?.version;
  const selected = state.versions.find((v) => v.version === version);
  if (!selected) {
    res.status(400).json({ error: "Unknown map version" });
    return;
  }
  state.published = version;
  save("Rolled back published map");
  res.json(selected);
});
app.post(
  "/api/admin/models",
  express.raw({ type: "model/gltf-binary", limit: "15mb" }),
  (req, res) => {
    const buffer = req.body;
    if (
      !Buffer.isBuffer(buffer) ||
      buffer.length < 20 ||
      buffer.readUInt32LE(0) !== 0x46546c67 ||
      buffer.readUInt32LE(4) !== 2 ||
      buffer.readUInt32LE(8) !== buffer.length
    ) {
      res
        .status(400)
        .json({ error: "Upload a valid GLB 2.0 file, maximum 15 MB" });
      return;
    }
    try {
      const len = buffer.readUInt32LE(12);
      if (len > buffer.length - 20 || buffer.readUInt32LE(16) !== 0x4e4f534a)
        throw Error();
      const gltf = JSON.parse(
        buffer
          .subarray(20, 20 + len)
          .toString("utf8")
          .trim(),
      );
      if (
        [...(gltf.buffers || []), ...(gltf.images || [])].some(
          (v: { uri?: string }) => v.uri && !v.uri.startsWith("data:"),
        )
      )
        throw Error();
      const name = randomUUID() + ".glb";
      fs.mkdirSync(path.join(dataDir, "models"), { recursive: true });
      fs.writeFileSync(path.join(dataDir, "models", name), buffer);
      save("Imported GLB for draft review");
      res.json({ url: `/api/admin/model/${name}` });
    } catch {
      res
        .status(400)
        .json({
          error:
            "Malformed GLB or external asset references; upload a self-contained model",
        });
    }
  },
);
app.get("/api/admin/model/:name", (req, res) => {
  if (!/^[a-f0-9-]+\.glb$/.test(req.params.name)) {
    res.sendStatus(400);
    return;
  }
  res.sendFile(path.join(dataDir, "models", req.params.name));
});
app.use("/explorer", express.static(path.join(root, "dist")));
app.use("/", express.static(path.resolve(root, "../navirail_app/build/web")));
app.use(
  (
    err: Error,
    _req: express.Request,
    res: express.Response,
    _next: express.NextFunction,
  ) => {
    res
      .status(400)
      .json({
        error:
          err.message === "request entity too large"
            ? "Upload exceeds size limit"
            : "Request could not be processed",
      });
  },
);
if (process.env.NODE_ENV !== "test")
  app.listen(8090, "127.0.0.1", () =>
    console.log(
      "NaviRail: http://127.0.0.1:8090/explorer/\nLocal admin password: " +
        credentialsFile,
    ),
  );
