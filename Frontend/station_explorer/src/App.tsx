import {
  Component,
  lazy,
  Suspense,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import {
  TrainFront,
  Search,
  Navigation,
  MapPin,
  Box,
  Layers,
  Ticket,
  Utensils,
  Accessibility,
  CircleHelp,
  ParkingCircle,
  ShieldCheck,
  Droplets,
  Zap,
  Building2,
  HeartPulse,
  ArrowUpRight,
  ArrowUp,
  RotateCcw,
  Plus,
  Minus,
  Crosshair,
  Moon,
  Sun,
  ChevronRight,
  X,
  Play,
  Square,
  ScanLine,
  Footprints,
  Clock,
  Route as RouteIcon,
  Settings2,
  DoorOpen,
  Eye,
  EyeOff,
  PanelLeftClose,
  Menu,
  ExternalLink,
  MoveUpRight,
  ArrowUpDown,
  Check,
  Info,
} from "lucide-react";
import { demoMap, stations, categories, type StationMap } from "./data";
import {
  findRoute,
  positionAlong,
  checkpointFix,
  type LocationFix,
} from "./routing";
import type { SceneProps } from "./StationScene";
import Admin from "./Admin";
import QrScanner from "./QrScanner";
import "./style.css";
const StationScene = lazy(() => import("./StationScene"));
const FlatMap = lazy(() =>
  import("./StationScene").then((m) => ({ default: m.FlatMap })),
);
class SceneBoundary extends Component<
  { children: ReactNode; fallback: ReactNode },
  { failed: boolean }
> {
  state = { failed: false };
  static getDerivedStateFromError() {
    return { failed: true };
  }
  render() {
    return this.state.failed ? this.props.fallback : this.props.children;
  }
}
const iconFor = (s: string) =>
  s === "Platforms"
    ? TrainFront
    : s === "Ticket Counters"
      ? Ticket
      : s === "Food & Shops"
        ? Utensils
        : s === "Restrooms"
          ? Accessibility
          : s === "Parking"
            ? ParkingCircle
            : s === "Police Assistance"
              ? ShieldCheck
              : s === "Medical"
                ? HeartPulse
                : s === "Drinking Water"
                  ? Droplets
                  : s === "Charging Points"
                    ? Zap
                    : s === "Railway Offices"
                      ? Building2
                      : s === "Lifts"
                        ? ArrowUpDown
                        : s === "Stairs"
                          ? MoveUpRight
                          : MapPin;
const words = {
  EN: {
    explore: "Station Explorer",
    search: "Search station or code",
    navigate: "Navigate",
    navigation: "Your journey",
    from: "From",
    to: "To",
    start: "Start demonstration",
    stop: "Stop navigation",
    facilities: "Explore facilities",
    demo: "Demonstration map",
    access: "Step-free route",
    directions: "Step-by-step directions",
  },
  TA: {
    explore: "நிலைய வழிகாட்டி",
    search: "நிலையம் அல்லது குறியீடு",
    navigate: "வழிகாட்டு",
    navigation: "உங்கள் பயணம்",
    from: "தொடக்கம்",
    to: "இலக்கு",
    start: "மாதிரி பயணம் தொடங்கு",
    stop: "நிறுத்து",
    facilities: "வசதிகளை ஆராயுங்கள்",
    demo: "மாதிரி வரைபடம்",
    access: "படிக்கட்டு இல்லாத வழி",
    directions: "படிப்படியான வழிகாட்டுதல்",
  },
  HI: {
    explore: "स्टेशन एक्सप्लोरर",
    search: "स्टेशन या कोड खोजें",
    navigate: "रास्ता दिखाएँ",
    navigation: "आपकी यात्रा",
    from: "से",
    to: "तक",
    start: "डेमो शुरू करें",
    stop: "रोकें",
    facilities: "सुविधाएँ खोजें",
    demo: "प्रदर्शन मानचित्र",
    access: "सीढ़ी रहित मार्ग",
    directions: "चरणबद्ध निर्देश",
  },
};
export default function App() {
  const params = new URLSearchParams(window.location.search);
  const embedded = params.get("embedded") === "1";
  const [activeTab, setActiveTab] = useState("navigation");
  const [station, setStation] = useState(params.get("station") || "MAS"),
    [search, setSearch] = useState(""),
    [searchOpen, setSearchOpen] = useState(false),
    [destination, setDestination] = useState("p5"),
    [start, setStart] = useState("entrance"),
    [filter, setFilter] = useState("All facilities"),
    [facilitySearch, setFacilitySearch] = useState(""),
    [accessible, setAccessible] = useState(false),
    [blocked, setBlocked] = useState(false),
    [view, setView] = useState<"2D" | "3D">("3D"),
    [floor, setFloor] = useState("all"),
    [roof, setRoof] = useState(true),
    [command, setCommand] = useState({ type: "reset", tick: 0 }),
    [running, setRunning] = useState(false),
    [meters, setMeters] = useState(0),
    [dark, setDark] = useState(false),
    [language, setLanguage] = useState<keyof typeof words>("EN"),
    [modal, setModal] = useState(""),
    [checkpoint, setCheckpoint] = useState("NR:MAS:entrance"),
    [notice, setNotice] = useState(""),
    [sidebar, setSidebar] = useState(false),
    [fix, setFix] = useState<LocationFix>({
      node: "entrance",
      source: "simulation",
      timestamp: Date.now(),
      accuracyMeters: null,
    }),
    [map, setMap] = useState<StationMap>(demoMap),
    [mapError, setMapError] = useState(""),
    [now, setNow] = useState(Date.now());
  const t = words[language],
    current = (stations.find((s) => s.code === station) || {code:station,name:station,local:"",city:"",map:null}),
    hasMap = station === "MAS";
  useEffect(() => {
    fetch("/api/stations/MAS/map")
      .then((r) => {
        if (!r.ok) throw Error("Map service unavailable");
        return r.json();
      })
      .then(setMap)
      .catch(() =>
        setMapError("Using bundled demonstration · map service offline"),
      );
  }, []);
  useEffect(() => {
    const timer = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(timer);
  }, []);
  const closed = useMemo(
    () => (blocked ? ["stairs:bridge-west", "east-stairs:bridge-east"] : []),
    [blocked],
  );
  const route = useMemo(
    () =>
      hasMap ? findRoute(map, start, destination, accessible, closed) : null,
    [map, start, destination, accessible, closed, hasMap],
  );
  useEffect(() => {
    setRunning(false);
    setMeters(0);
  }, [route]);
  useEffect(() => {
    if (!running || !route) return;
    let last = performance.now();
    const timer = setInterval(() => {
      const time = performance.now(),
        delta = (time - last) / 1000;
      last = time;
      setMeters((m) => Math.min(route.distance, m + delta * 18));
    }, 80);
    return () => clearInterval(timer);
  }, [running, route]);
  useEffect(() => {
    if (running && route && meters >= route.distance) {
      setRunning(false);
      setNotice("You have arrived at " + route.nodes.at(-1)!.name);
    }
  }, [meters, route, running]);
  const point = route ? positionAlong(route, meters) : null;
  const position = point?.position ??
    map.nodes.find((n) => n.id === start)?.position ?? [0, 0, 43];
  const facilities = map.nodes.filter(
    (n) =>
      !["Passage", "Footbridge"].includes(n.category) &&
      !n.id.startsWith("u") &&
      n.id !== "lift-top",
  );
  const visible = facilities.filter(
    (n) =>
      (filter === "All facilities" || n.category === filter) &&
      n.name.toLowerCase().includes(facilitySearch.toLowerCase()),
  );
  const selected = map.nodes.find((n) => n.id === destination);
  const cmd = (type: string) => setCommand((c) => ({ type, tick: c.tick + 1 }));
  const choose = (id: string) => {
    setDestination(id);
    setActiveTab("navigation");
    setNotice("");
  };
  const setOrigin = (id: string) => {
    setStart(id);
    setFix({
      node: id,
      source: "simulation",
      timestamp: Date.now(),
      accuracyMeters: null,
    });
  };
  const changeStation = (code: string) => {
    setStation(code);
    setSearch("");
    setSearchOpen(false);
    setRunning(false);
    setMeters(0);
    setNotice("");
  };
  const props: SceneProps = {
    map,
    route,
    position: position as SceneProps["position"],
    selected: destination,
    onSelect: choose,
    view,
    floor,
    roof,
    command,
    filter,
  };
  const toggleClosure = () => {
    if (route && point && meters > 0)
      setOrigin(
        route.nodes[point.arrived ? route.nodes.length - 1 : point.index].id,
      );
    setBlocked((b) => !b);
    setNotice(
      "Route recalculated from the last reached demonstration checkpoint.",
    );
  };
  return (
    <div className={`app ${dark ? "dark" : ""} ${embedded ? "embedded" : ""} tab-${activeTab}`}>
      <header className="topbar">
        <button
          className="mobile-menu icon-button"
          aria-label="Toggle sidebar"
          onClick={() => setSidebar(!sidebar)}
        >
          <Menu size={22} />
        </button>
        <a className="brand" href="/explorer/">
          <span className="brand-icon">
            <TrainFront size={26} />
          </span>
          <span>
            NaviRail<small>Every step, connected.</small>
          </span>
        </a>
        <div className="station-search">
          <Search size={19} />
          <input
            aria-label="Search station"
            placeholder={t.search}
            value={searchOpen ? search : `${current.name} (${current.code})`}
            onFocus={() => setSearchOpen(true)}
            onChange={(e) => setSearch(e.target.value)}
          />
          {searchOpen && (
            <>
              <button
                className="icon-button"
                aria-label="Close station search"
                onClick={() => setSearchOpen(false)}
              >
                <X size={16} />
              </button>
              <div className="search-results">
                {stations
                  .filter((s) =>
                    `${s.name} ${s.code}`
                      .toLowerCase()
                      .includes(search.toLowerCase()),
                  )
                  .map((s) => (
                    <button key={s.code} onClick={() => changeStation(s.code)}>
                      <MapPin size={18} />
                      <span>
                        {s.name}
                        <small>
                          {s.city} ·{" "}
                          {s.map
                            ? "Demonstration available"
                            : "Indoor map unavailable"}
                        </small>
                      </span>
                      <b>{s.code}</b>
                    </button>
                  ))}
                {!stations.some((s) =>
                  `${s.name} ${s.code}`
                    .toLowerCase()
                    .includes(search.toLowerCase()),
                ) && <p>No supported stations found.</p>}
              </div>
            </>
          )}
        </div>
        <div className="destination-top">
          <TrainFront size={18} />
          <select
            aria-label="Destination"
            value={destination}
            disabled={!hasMap}
            onChange={(e) => choose(e.target.value)}
          >
            {facilities.map((n) => (
              <option key={n.id} value={n.id}>
                {n.name}
              </option>
            ))}
          </select>
        </div>
        <button
          className="primary top-navigate"
          disabled={!route}
          onClick={() => {
            setNotice(
              "Route ready. Start the demonstration to simulate your journey.",
            );
            document
              .querySelector(".journey")
              ?.scrollIntoView({ behavior: "smooth", block: "nearest" });
          }}
        >
          <Navigation size={17} />
          {t.navigate}
        </button>
        <div className="top-spacer" />
        <select
          className="language"
          aria-label="Language"
          value={language}
          onChange={(e) => setLanguage(e.target.value as keyof typeof words)}
        >
          <option>EN</option>
          <option>TA</option>
          <option>HI</option>
        </select>
        <button
          className="icon-button theme"
          aria-label="Toggle theme"
          onClick={() => setDark(!dark)}
        >
          {dark ? <Sun size={19} /> : <Moon size={19} />}
        </button>
      </header>
      <aside className={`sidebar ${sidebar ? "open" : ""}`}>
        <div className="sidebar-label">DISCOVER</div>
        <button
          className="nav-item active"
          onClick={() => {
            setFilter("All facilities"); setActiveTab("explorer");
            setSidebar(false);
            cmd("reset");
          }}
        >
          <Box size={20} />
          {t.explore}
        </button>
        <button className="nav-item" onClick={() => setSearchOpen(true)}>
          <MapPin size={20} />
          Select station
        </button>
        <div className="sidebar-label">AT THE STATION</div>
        {[
          "Platforms",
          "Ticket Counters",
          "Food & Shops",
          "Restrooms",
          "Parking",
          "Police Assistance",
        ].map((category) => {
          const Icon = iconFor(category);
          return (
            <button
              key={category}
              className={`nav-item ${filter === category ? "chosen" : ""}`}
              onClick={() => {
                setFilter(category); setActiveTab("facilities");
                setSidebar(false);
              }}
            >
              <Icon size={19} />
              {category}
            </button>
          );
        })}
        <button
          className="nav-item"
          onClick={() => {
            setAccessible(!accessible);
            setNotice(
              accessible
                ? "Standard route selected."
                : "Step-free routing uses mapped lifts.",
            );
          }}
        >
          <Accessibility size={20} />
          Accessibility{accessible && <Check size={14} />}
        </button>
        <button className="nav-item" onClick={() => setModal("help")}>
          <CircleHelp size={20} />
          Help & assistance
        </button>
        <div className="sidebar-bottom">
          <div className="station-card">
            <div className="station-card-art">
              <TrainFront size={40} />
              <span>MAS</span>
            </div>
            <strong>{current.name}</strong>
            <small>{current.local}</small>
            <span className="station-code">
              {current.code} <span>Southern Railway</span>
            </span>
            <button onClick={() => setSearchOpen(true)}>
              <ArrowUpDown size={14} />
              Change station
            </button>
          </div>
          <a className="nav-item legacy-link" href="/" target="_top">
            <ExternalLink size={16} />
            Original NaviRail app
          </a>
          <button className="nav-item" onClick={() => setModal("admin")}>
            <Settings2 size={16} />
            Map administration
          </button>
        </div>
      </aside>
      <main>
        <div className="workspace-heading">
          <div>
            <span className="eyebrow">STATION EXPLORER</span>
            <h1>
              {current.name}
              <span>{current.code}</span>
            </h1>
            <p>
              {current.city} <span> / </span> Find your way, at your pace.
            </p>
          </div>
          <div className="location-status">
            <span className="status-dot" />{" "}
            {fix.source === "qr" ? "QR checkpoint" : "Demo positioning"}
            <small>
              {fix.source === "qr"
                ? `Last fix ${Math.floor((now - fix.timestamp) / 1000)}s ago · no continuous tracking`
                : "Simulated location · not live tracking"}
            </small>
          </div>
        </div>
        <div className="explorer-tabs" role="tablist" aria-label="Station sections">{[["explorer","Station Explorer"],["navigation","3D Navigation"],["facilities","Facilities"]].map(([id,label])=><button key={id} role="tab" aria-selected={activeTab===id} onClick={()=>setActiveTab(id)}>{label}</button>)}</div>
        <div className="workspace">
          <section className="map-section" aria-label="Station map">
            {hasMap && (
              <div className="map-top">
                <span className="demo-badge">
                  <Info size={13} />
                  {t.demo}
                </span>
                <span className="map-version">MAS / v{map.version}</span>
              </div>
            )}
            {hasMap ? (
              <div className="scene">
                <Suspense
                  fallback={
                    <div className="loading">
                      <span className="spinner" />
                      Loading station scene…
                    </div>
                  }
                >
                  <SceneBoundary
                    fallback={
                      <>
                        <span className="fallback-note">
                          3D unavailable · showing schematic map
                        </span>
                        <FlatMap {...props} />
                      </>
                    }
                  >
                    <StationScene {...props} />
                  </SceneBoundary>
                </Suspense>
              </div>
            ) : (
              <div className="unavailable">
                <MapPin size={46} />
                <h2>{current.name}</h2>
                <p>Detailed Indoor Map Not Available</p>
                <span>
                  Verified indoor geometry and walking-network data have not
                  been provided for {current.code}.
                </span>
                <button
                  className="primary"
                  onClick={() => changeStation("MAS")}
                >
                  Explore Chennai Central demo
                </button>
              </div>
            )}
            {hasMap && (
              <>
                <div className="map-caption">
                  <span className="tiny-dot" />
                  SCHEMATIC DIGITAL TWIN
                  <small>
                    Illustrative layout · not for real-world wayfinding
                  </small>
                </div>
                <div className="compass">
                  <span>N</span>
                  <Navigation size={24} fill="#12334c" />
                </div>
                <div className="floor-control">
                  <Layers size={17} />
                  {[
                    ["all", "All"],
                    ["1", "1"],
                    ["0", "G"],
                  ].map(([v, l]) => (
                    <button
                      key={v}
                      className={floor === v ? "active" : ""}
                      onClick={() => setFloor(v)}
                      title={
                        v === "all"
                          ? "All floors"
                          : v === "1"
                            ? "Footbridge"
                            : "Ground floor"
                      }
                    >
                      {l}
                    </button>
                  ))}
                </div>
                <div className="map-controls">
                  <button onClick={() => setView(view === "3D" ? "2D" : "3D")}>
                    {view === "3D" ? "2D" : "3D"}
                  </button>
                  <button aria-label="Zoom in" onClick={() => cmd("in")}>
                    <Plus size={19} />
                  </button>
                  <button aria-label="Zoom out" onClick={() => cmd("out")}>
                    <Minus size={19} />
                  </button>
                  <button
                    aria-label="Rotate map"
                    onClick={() => cmd("rotate")}
                    disabled={view === "2D"}
                  >
                    <RotateCcw size={18} />
                  </button>
                  <button
                    aria-label="Reset camera"
                    onClick={() => cmd("reset")}
                  >
                    <Crosshair size={19} />
                  </button>
                  <button
                    aria-label="Toggle roofs"
                    onClick={() => setRoof(!roof)}
                  >
                    {roof ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </>
            )}
          </section>
          <aside className="journey">
            <div className="panel-title">
              <span className="round-icon">
                <Navigation size={17} />
              </span>
              <h2>{t.navigation}</h2>
              <span className="demo-mini">DEMO</span>
            </div>
            <div className="route-inputs">
              <label>
                <span className="origin-dot" />
                <span>
                  {t.from}
                  <select
                    aria-label="Starting location"
                    disabled={!hasMap}
                    value={start}
                    onChange={(e) => setOrigin(e.target.value)}
                  >
                    {facilities.map((n) => (
                      <option key={n.id} value={n.id}>
                        {n.name}
                      </option>
                    ))}
                  </select>
                </span>
              </label>
              <div className="dotted-line" />
              <label>
                <MapPin className="destination-pin" size={21} />
                <span>
                  {t.to}
                  <select
                    aria-label="Route destination"
                    disabled={!hasMap}
                    value={destination}
                    onChange={(e) => choose(e.target.value)}
                  >
                    {facilities.map((n) => (
                      <option key={n.id} value={n.id}>
                        {n.name}
                      </option>
                    ))}
                  </select>
                </span>
              </label>
            </div>
            <label className="toggle-row">
              <Accessibility size={17} />
              {t.access}
              <input
                type="checkbox"
                checked={accessible}
                onChange={(e) => setAccessible(e.target.checked)}
              />
              <span className="switch" />
            </label>
            {route ? (
              <>
                <div className="route-stats">
                  <div>
                    <Footprints size={24} />
                    <span>
                      <strong>
                        {Math.max(
                          0,
                          Math.ceil(
                            (route.seconds *
                              (1 -
                                (route.distance
                                  ? meters / route.distance
                                  : 1))) /
                              60,
                          ),
                        )}{" "}
                        min
                      </strong>
                      <small>Approx. walking time</small>
                    </span>
                  </div>
                  <div>
                    <RouteIcon size={23} />
                    <span>
                      <strong>
                        {Math.round(Math.max(0, route.distance - meters))} m
                      </strong>
                      <small>{meters ? "Remaining" : "Demo distance"}</small>
                    </span>
                  </div>
                </div>
                <button
                  className="primary start-button"
                  disabled={route.distance === 0}
                  onClick={() => {
                    if (!running && meters >= route.distance) setMeters(0);
                    setRunning(!running);
                    setNotice("");
                  }}
                >
                  {running ? (
                    <Square size={16} />
                  ) : (
                    <Play size={16} fill="currentColor" />
                  )}
                  {running ? t.stop : t.start}
                </button>
                <div className="progress">
                  <span
                    style={{
                      width: `${route.distance ? (meters / route.distance) * 100 : 100}%`,
                    }}
                  />
                </div>
                <div className="directions-heading">
                  <h3>{t.directions}</h3>
                  <span>{running ? "18 m/s demo" : "Simulation"}</span>
                </div>
                <ol className="directions">
                  {route.nodes.map((n, i) => (
                    <li
                      key={`${n.id}-${i}`}
                      className={point?.index === i ? "current" : ""}
                    >
                      <span
                        className={`step-icon ${i === route.nodes.length - 1 ? "end" : ""}`}
                      >
                        {i === 0 ? (
                          <MapPin size={17} />
                        ) : i === route.nodes.length - 1 ? (
                          <Check size={17} />
                        ) : route.edges[i - 1]?.type === "lift" ? (
                          <ArrowUpDown size={17} />
                        ) : (
                          <ArrowUpRight size={17} />
                        )}
                      </span>
                      <div>
                        <strong>
                          {i === 0
                            ? "Start at " + n.name
                            : i === route.nodes.length - 1
                              ? "Reach " + n.name
                              : route.edges[i - 1]?.type === "stairs"
                                ? "Take stairs to " + n.name
                                : route.edges[i - 1]?.type === "lift"
                                  ? "Take lift to " + n.name
                                  : "Continue to " + n.name}
                        </strong>
                        <small>
                          {n.floor === 1 ? "Footbridge level" : "Ground floor"}
                          {i > 0 &&
                            ` · ${Math.round(route.edges[i - 1].distance)} m`}
                        </small>
                      </div>
                    </li>
                  ))}
                </ol>
              </>
            ) : (
              <p className="empty-route">
                {hasMap
                  ? "No permitted route available. Change the starting point or route settings."
                  : "Indoor navigation is unavailable for this station."}
              </p>
            )}
            <div className="journey-tools">
              <button disabled={!hasMap} onClick={() => setModal("checkpoint")}>
                <ScanLine size={16} />
                QR checkpoint
              </button>
              <button
                disabled={!hasMap}
                className={blocked ? "closure-active" : ""}
                onClick={toggleClosure}
              >
                <RouteIcon size={16} />
                {blocked ? "Reopen stairs" : "Simulate closure"}
              </button>
            </div>
          </aside>
        </div>
        <section className="facilities">
          <div className="facilities-heading">
            <div>
              <h2>{t.facilities}</h2>
              <span>Everything you need, a few steps away.</span>
            </div>
            <label className="facility-search">
              <Search size={15} />
              <input
                aria-label="Search facilities"
                placeholder="Find a facility"
                value={facilitySearch}
                onChange={(e) => setFacilitySearch(e.target.value)}
              />
            </label>
          </div>
          <div className="category-strip">
            {categories.map((category) => {
              const Icon = iconFor(category);
              return (
                <button
                  disabled={!hasMap}
                  key={category}
                  className={filter === category ? "active" : ""}
                  onClick={() => setFilter(category)}
                >
                  <Icon size={17} />
                  {category}
                </button>
              );
            })}
          </div>
          <div className="facility-results">
            {hasMap &&
              visible.map((n) => {
                const Icon = iconFor(n.category);
                return (
                  <button
                    className={`facility-card ${n.id === destination ? "selected" : ""}`}
                    key={n.id}
                    onClick={() => choose(n.id)}
                  >
                    <span className="facility-icon">
                      <Icon size={20} />
                    </span>
                    <span>
                      <strong>{n.name}</strong>
                      <small>
                        {n.floor === 1 ? "Footbridge level" : "Ground floor"} ·{" "}
                        {n.category}
                      </small>
                    </span>
                    <ChevronRight size={16} />
                  </button>
                );
              })}
            {hasMap && !visible.length && (
              <p>No facilities match this search.</p>
            )}
            {!hasMap && (
              <p>
                Facilities will appear when an approved indoor map is available.
              </p>
            )}
          </div>
        </section>
        <footer>
          <span>
            <ShieldCheck size={13} />
            Demonstration only · no verified architectural data
          </span>
          <span>{mapError || "NaviRail · Chennai prototype"}</span>
        </footer>
      </main>
      {notice && (
        <div className="toast" role="status">
          <Info size={18} />
          {notice}
          <button
            className="icon-button"
            aria-label="Dismiss notification"
            onClick={() => setNotice("")}
          >
            <X size={16} />
          </button>
        </div>
      )}
      {modal && (
        <div className="modal-backdrop" onClick={() => setModal("")}>
          <section
            className={`modal ${modal === "admin" ? "admin-modal" : ""}`}
            role="dialog"
            aria-modal="true"
            aria-label={modal}
            onClick={(e) => e.stopPropagation()}
          >
            <button
              className="modal-close icon-button"
              aria-label="Close dialog"
              onClick={() => setModal("")}
            >
              <X size={20} />
            </button>
            {modal === "checkpoint" ? (
              <>
                <span className="round-icon">
                  <ScanLine />
                </span>
                <h2>Update your checkpoint</h2>
                <p>
                  Enter the payload from a NaviRail QR checkpoint. A scan
                  records one location fix; it does not continuously track you.
                </p>
                <QrScanner
                  onCode={(code) => {
                    setCheckpoint(code);
                    const next = checkpointFix(map, code);
                    if (!next) {
                      setNotice("Unknown QR checkpoint. Location unchanged.");
                      return;
                    }
                    setFix(next);
                    setStart(next.node);
                    setMeters(0);
                    setRunning(false);
                    setModal("");
                    setNotice("QR checkpoint updated. Route recalculated.");
                  }}
                />
                <label>
                  Checkpoint payload
                  <input
                    value={checkpoint}
                    onChange={(e) => setCheckpoint(e.target.value)}
                  />
                </label>
                <small>
                  Demo examples: NR:MAS:entrance, NR:MAS:hall, NR:MAS:p5
                </small>
                <button
                  className="primary"
                  onClick={() => {
                    const next = checkpointFix(map, checkpoint);
                    if (!next) {
                      setNotice(
                        "Unknown checkpoint. Your current location has not changed.",
                      );
                      return;
                    }
                    setFix(next);
                    setStart(next.node);
                    setMeters(0);
                    setRunning(false);
                    setModal("");
                    setNotice("Checkpoint updated. Route recalculated.");
                  }}
                >
                  Use checkpoint
                </button>
              </>
            ) : modal === "admin" ? (
              <Admin
                onPublished={(m) => {
                  setMap(m);
                  setNotice("Published demonstration map loaded.");
                }}
              />
            ) : (
              <>
                <h2>Find your way with NaviRail</h2>
                <p>
                  Select a station and destination, then start the
                  demonstration. Drag the map to rotate, right-drag to pan, and
                  scroll to zoom. On touch screens, drag to rotate and pinch to
                  zoom.
                </p>
                <h3>What this prototype represents</h3>
                <p>
                  The station geometry, distances, facilities and passenger
                  movement are illustrative. No verified indoor map or live
                  train feed is connected.
                </p>
                <h3>Accessible navigation</h3>
                <p>
                  Step-free mode excludes stairs and uses the lifts in the
                  demonstration graph. Closure simulation blocks the west
                  staircase and recalculates a connected route.
                </p>
                <a className="primary" href="/" target="_top">
                  Open existing NaviRail screens <ExternalLink size={16} />
                </a>
              </>
            )}
          </section>
        </div>
      )}
    </div>
  );
}


