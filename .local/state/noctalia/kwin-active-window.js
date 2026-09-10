
const BUS = "dev.noctalia.KWinActiveWindow";
const PATH = "/dev/noctalia/KWinActiveWindow";
const IFACE = "dev.noctalia.KWinActiveWindow";
const RECORD_SEP = "\x1f";
const FIELD_SEP = "\x1e";

function windowUuid(window) {
  if (!window || window.internalId === undefined) {
    return "";
  }
  return String(window.internalId);
}

function notify(window) {
  try {
    if (!window) {
      callDBus(BUS, PATH, IFACE, "notifyActiveWindow", "", "", "");
      return;
    }
    if (!shouldTrack(window)) {
      return;
    }
    const caption = window.caption || "";
    const resourceClass = window.resourceClass || "";
    callDBus(BUS, PATH, IFACE, "notifyActiveWindow", caption, resourceClass, windowUuid(window));
  } catch (error) {
    print("noctalia-active-window notify failed: " + error);
  }
}

function isNoctaliaShellSurface(window) {
  const resourceClass = (window.resourceClass || "").toLowerCase();
  if (resourceClass === "noctalia") {
    return true;
  }
  const caption = (window.caption || "").toLowerCase();
  return caption === "noctalia" && resourceClass === "";
}

function shouldTrack(window) {
  if (!window) {
    return false;
  }
  if (window.skipTaskbar) {
    return false;
  }
  if (window.dock || window.desktopWindow || window.tooltip || window.notification) {
    return false;
  }
  if (!window.normalWindow) {
    return false;
  }
  if (window.dialog || window.splash || window.utility || window.dropdownMenu || window.popupMenu) {
    return false;
  }
  if (isNoctaliaShellSurface(window)) {
    return false;
  }
  return true;
}

function canonicalDesktopId(desktop) {
  if (!desktop) {
    return "";
  }
  const id = desktop.id !== undefined && desktop.id !== null ? String(desktop.id) : "";
  if (!id) {
    return "";
  }
  try {
    const ids = virtualDesktopInfo.desktopIds;
    if (!ids || ids.length === 0) {
      return id;
    }
    for (let i = 0; i < ids.length; ++i) {
      if (String(ids[i]) === id) {
        return String(ids[i]);
      }
    }
    const asNum = parseInt(id, 10);
    if (!isNaN(asNum) && asNum > 0 && asNum <= ids.length) {
      return String(ids[asNum - 1]);
    }
  } catch (error) {
  }
  return id;
}

function desktopIdsFor(window) {
  if (!window) {
    return "";
  }
  if (window.onAllDesktops) {
    return "*";
  }
  const desktops = window.desktops;
  if (!desktops || desktops.length === 0) {
    return "";
  }
  const ids = [];
  for (let i = 0; i < desktops.length; ++i) {
    const id = canonicalDesktopId(desktops[i]);
    if (id) {
      ids.push(id);
    }
  }
  return ids.join(",");
}

function outputNameFor(window) {
  if (!window || window.output === undefined || window.output === null) {
    return "";
  }
  return window.output.name || "";
}

function serializeWindow(window) {
  if (!shouldTrack(window)) {
    return "";
  }
  const uuid = windowUuid(window);
  if (!uuid) {
    return "";
  }
  return [
    uuid,
    window.resourceClass || "",
    window.caption || "",
    desktopIdsFor(window),
    outputNameFor(window),
  ].join(FIELD_SEP);
}

function syncWindows() {
  try {
    const rows = [];
    for (const window of workspace.windowList()) {
      const row = serializeWindow(window);
      if (row) {
        rows.push(row);
      }
    }
    callDBus(BUS, PATH, IFACE, "notifyWindowList", rows.join(RECORD_SEP));
  } catch (error) {
    print("noctalia-active-window sync failed: " + error);
  }
}

function wireWindow(window) {
  if (!window) {
    return;
  }
  const updateActive = () => {
    if (workspace.activeWindow === window) {
      notify(window);
    }
  };
  const updateTracked = () => {
    syncWindows();
  };
  if (typeof window.captionChanged !== "undefined") {
    window.captionChanged.connect(updateActive);
    window.captionChanged.connect(updateTracked);
  }
  if (typeof window.desktopsChanged !== "undefined") {
    window.desktopsChanged.connect(updateTracked);
  }
  if (typeof window.outputChanged !== "undefined") {
    window.outputChanged.connect(updateTracked);
  }
}

workspace.windowActivated.connect(notify);
workspace.windowAdded.connect((window) => {
  wireWindow(window);
  syncWindows();
});
workspace.windowRemoved.connect(syncWindows);

for (const window of workspace.windowList()) {
  wireWindow(window);
}

notify(workspace.activeWindow);
syncWindows();
