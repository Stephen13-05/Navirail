import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import type { AddressInfo } from "node:net";
process.env.NODE_ENV = "test";
process.env.NAVIRAIL_DATA_DIR = fs.mkdtempSync(
  path.join(os.tmpdir(), "navirail-test-"),
);
process.env.NAVIRAIL_ADMIN_PASSWORD = "test-only-password";
const { app } = await import("../server/index");
test("API protects draft editing, validates data, publishes and rolls back", async () => {
  const server = app.listen(0, "127.0.0.1");
  await new Promise<void>((resolve) => server.once("listening", resolve));
  const base = `http://127.0.0.1:${(server.address() as AddressInfo).port}`;
  try {
    let r = await fetch(base + "/api/admin/maps");
    assert.equal(r.status, 401);
    r = await fetch(base + "/api/stations/MS/map");
    assert.equal(r.status, 404);
    r = await fetch(base + "/api/admin/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ password: "test-only-password" }),
    });
    assert.equal(r.status, 200);
    const cookie = r.headers.get("set-cookie")!.split(";")[0];
    const headers = { "Content-Type": "application/json", cookie };
    r = await fetch(base + "/api/admin/maps", { headers });
    const state = await r.json();
    assert.equal(state.published, 1);
    r = await fetch(base + "/api/admin/draft", {
      method: "PUT",
      headers,
      body: JSON.stringify({ ...state.draft, status: "verified" }),
    });
    assert.equal(r.status, 400);
    const draft = structuredClone(state.draft);
    draft.nodes.find((n: { id: string }) => n.id === "tickets").name =
      "Updated ticket counter";
    r = await fetch(base + "/api/admin/draft", {
      method: "PUT",
      headers,
      body: JSON.stringify(draft),
    });
    assert.equal(r.status, 200);
    let published = await (await fetch(base + "/api/stations/MAS/map")).json();
    assert.equal(
      published.nodes.find((n: { id: string }) => n.id === "tickets").name,
      "Ticket Counters",
    );
    r = await fetch(base + "/api/admin/publish", {
      method: "POST",
      headers,
      body: "{}",
    });
    assert.equal(r.status, 200);
    published = await r.json();
    assert.equal(published.version, 2);
    assert.equal(
      published.nodes.find((n: { id: string }) => n.id === "tickets").name,
      "Updated ticket counter",
    );
    r = await fetch(base + "/api/admin/rollback", {
      method: "POST",
      headers,
      body: JSON.stringify({ version: 1 }),
    });
    assert.equal(r.status, 200);
    assert.equal((await r.json()).version, 1);
    r = await fetch(base + "/api/admin/draft", {
      method: "PUT",
      headers: { ...headers, origin: "https://untrusted.example" },
      body: JSON.stringify(draft),
    });
    assert.equal(r.status, 403);
    r = await fetch(base + "/api/admin/models", {
      method: "POST",
      headers: { cookie, "Content-Type": "model/gltf-binary" },
      body: "not-a-model",
    });
    assert.equal(r.status, 400);
    r = await fetch(base + "/api/admin/logout", {
      method: "POST",
      headers,
      body: "{}",
    });
    assert.equal(r.status, 200);
    r = await fetch(base + "/api/admin/maps", { headers });
    assert.equal(r.status, 401);
  } finally {
    await new Promise<void>((resolve, reject) =>
      server.close((err) => (err ? reject(err) : resolve())),
    );
  }
});
