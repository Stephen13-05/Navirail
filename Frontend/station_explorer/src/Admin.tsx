import { useState, useEffect } from "react";
import { demoMap, type StationMap } from "./data";
import { findRoute, validateMap } from "./routing";
import NetworkEditor from "./NetworkEditor";
type Store = {
  draft: StationMap;
  versions: StationMap[];
  published: number;
  audit: { at: string; action: string; actor: string; version: number }[];
};
export default function Admin({
  onPublished,
}: {
  onPublished: (m: StationMap) => void;
}) {
  const [signed, setSigned] = useState(false),
    [password, setPassword] = useState(""),
    [text, setText] = useState(JSON.stringify(demoMap, null, 2)),
    [store, setStore] = useState<Store | null>(null),
    [message, setMessage] = useState(""),
    [goal, setGoal] = useState("p5"),
    [accessible, setAccessible] = useState(false),
    [busy, setBusy] = useState(false);
  async function request(url: string, method = "GET", body?: unknown) {
    const r = await fetch("/api/admin/" + url, {
      method,
      headers: { "Content-Type": "application/json" },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    const data = await r.json();
    if (!r.ok) throw Error(data.error || "Request failed");
    return data;
  }
  async function refresh() {
    const data = await request("maps");
    setStore(data);
    setText(JSON.stringify(data.draft, null, 2));
    setSigned(true);
  }
  useEffect(() => {
    refresh().catch(() => {});
  }, []);
  async function act(fn: () => Promise<void>) {
    setBusy(true);
    try {
      await fn();
    } catch (e) {
      setMessage(e instanceof Error ? e.message : "Request failed");
    } finally {
      setBusy(false);
    }
  }
  if (!signed)
    return (
      <>
        <h2>Map administration</h2>
        <p>
          Sign in to edit draft pedestrian networks, validate routes, and
          publish or roll back demonstration map versions.
        </p>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            act(async () => {
              await request("login", "POST", { password });
              setPassword("");
              await refresh();
              setMessage("");
            });
          }}
        >
          <label>
            Administrator password
            <input
              type="password"
              autoComplete="current-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </label>
          <small>
            Local setup: the server creates .local/admin-password.txt. This
            password is never included in the browser bundle.
          </small>
          <button className="primary" disabled={busy}>
            Sign in
          </button>
        </form>
        {message && <p role="alert">{message}</p>}
      </>
    );
  let parsedMap: StationMap | null = null;
  try {
    const parsed = JSON.parse(text);
    if (!validateMap(parsed).length) parsedMap = parsed;
  } catch {}
  return (
    <>
      <h2>Station map builder</h2>
      <p>
        MAS · demonstration data only. Edit station nodes, floor assignments,
        facilities and connections in the versioned draft below. Published maps
        remain unchanged until publication.
      </p>
      <div className="admin-toolbar">
        <button
          disabled={busy}
          onClick={() =>
            act(async () => {
              const map = JSON.parse(text);
              const errors = validateMap(map);
              if (errors.length) throw Error(errors.join("\n"));
              const data = await request("draft", "PUT", map);
              setStore(data);
              setMessage("Draft saved. Published map unchanged.");
            })
          }
        >
          Save draft
        </button>
        <button
          disabled={busy}
          onClick={() =>
            act(async () => {
              const map = JSON.parse(text) as StationMap;
              const errors = validateMap(map);
              const unreachable = map.nodes
                .filter((n) => !findRoute(map, "entrance", n.id))
                .map((n) => n.name);
              setMessage(
                errors.length
                  ? errors.join("\n")
                  : `Network validation: ${unreachable.length ? "Unreachable: " + unreachable.join(", ") : "all nodes connected"}`,
              );
            })
          }
        >
          Validate network
        </button>
        <button
          disabled={busy}
          onClick={() =>
            act(async () => {
              await request("draft", "PUT", JSON.parse(text));
              const map = await request("publish", "POST", {});
              onPublished(map);
              await refresh();
              setMessage(`Published demonstration version ${map.version}.`);
            })
          }
        >
          Publish demonstration
        </button>
        <button
          disabled={busy}
          onClick={() =>
            act(async () => {
              await request("logout", "POST", {});
              setSigned(false);
            })
          }
        >
          Sign out
        </button>
      </div>
      {parsedMap && (
        <NetworkEditor
          map={parsedMap}
          onChange={(m) => setText(JSON.stringify(m, null, 2))}
        />
      )}
      <label>
        Draft map JSON
        <textarea
          spellCheck={false}
          className="admin-editor"
          value={text}
          onChange={(e) => setText(e.target.value)}
        />
      </label>
      <div className="admin-grid">
        <div>
          <h3>Preview a route</h3>
          <label>
            Destination node
            <input value={goal} onChange={(e) => setGoal(e.target.value)} />
          </label>
          <label className="toggle-row">
            Step-free
            <input
              type="checkbox"
              checked={accessible}
              onChange={(e) => setAccessible(e.target.checked)}
            />
            <span className="switch" />
          </label>
          <button
            className="primary"
            onClick={() =>
              act(async () => {
                const route = findRoute(
                  JSON.parse(text),
                  "entrance",
                  goal,
                  accessible,
                );
                setMessage(
                  route
                    ? `${Math.round(route.distance)} m: ${route.nodes.map((n) => n.name).join(" → ")}`
                    : "No permitted route",
                );
              })
            }
          >
            Test route
          </button>
        </div>
        <div>
          <h3>Published versions</h3>
          <select
            aria-label="Roll back to version"
            value={store?.published || 1}
            onChange={(e) =>
              act(async () => {
                const map = await request("rollback", "POST", {
                  version: Number(e.target.value),
                });
                onPublished(map);
                await refresh();
                setMessage("Published version restored; draft retained.");
              })
            }
          >
            {store?.versions.map((v) => (
              <option key={v.version} value={v.version}>
                Version {v.version}
                {v.version === store.published ? " · current" : ""}
              </option>
            ))}
          </select>
          <label>
            Import self-contained GLB
            <input
              type="file"
              accept=".glb"
              onChange={(e) => {
                const file = e.target.files?.[0];
                if (!file) return;
                act(async () => {
                  const r = await fetch("/api/admin/models", {
                    method: "POST",
                    headers: { "Content-Type": "model/gltf-binary" },
                    body: file,
                  });
                  const data = await r.json();
                  if (!r.ok) throw Error(data.error);
                  setMessage(
                    "GLB stored for review: " +
                      data.url +
                      "\nAlignment and verified map association are required before passenger publication.",
                  );
                });
              }}
            />
          </label>
        </div>
      </div>
      {message && (
        <div className="admin-message" role="status">
          {message}
        </div>
      )}
      <h3>Audit history</h3>
      <div className="audit-list">
        {store?.audit
          .slice()
          .reverse()
          .map((a, i) => (
            <div key={i}>
              {new Date(a.at).toLocaleString()} · {a.actor} · {a.action} · v
              {a.version}
            </div>
          ))}
        {!store?.audit.length && "No changes recorded."}
      </div>
    </>
  );
}
