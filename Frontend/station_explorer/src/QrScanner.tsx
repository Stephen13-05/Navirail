import { useEffect, useRef, useState } from "react";
import type { IScannerControls } from "@zxing/browser";
export default function QrScanner({
  onCode,
}: {
  onCode: (code: string) => void;
}) {
  const video = useRef<HTMLVideoElement>(null),
    controls = useRef<IScannerControls | null>(null),
    generation = useRef(0);
  const [active, setActive] = useState(false),
    [error, setError] = useState("");
  useEffect(
    () => () => {
      generation.current++;
      controls.current?.stop();
    },
    [],
  );
  async function start() {
    setError("");
    setActive(true);
    const attempt = ++generation.current;
    try {
      const { BrowserQRCodeReader } = await import("@zxing/browser");
      if (attempt !== generation.current) return;
      const reader = new BrowserQRCodeReader();
      const scanning = await reader.decodeFromVideoDevice(
        undefined,
        video.current!,
        (result, _error, control) => {
          if (result) {
            control.stop();
            generation.current++;
            setActive(false);
            onCode(result.getText());
          }
        },
      );
      if (attempt !== generation.current) scanning.stop();
      else controls.current = scanning;
    } catch {
      if (attempt === generation.current) {
        setActive(false);
        setError(
          "Camera unavailable or permission denied. Enter the checkpoint payload below instead.",
        );
      }
    }
  }
  return (
    <div className="qr-scanner">
      <video ref={video} muted playsInline hidden={!active} />
      <button
        className="primary"
        onClick={() => {
          if (active) {
            generation.current++;
            controls.current?.stop();
            setActive(false);
          } else start();
        }}
      >
        {active ? "Stop camera" : "Scan QR with camera"}
      </button>
      {error && <p role="alert">{error}</p>}
    </div>
  );
}
