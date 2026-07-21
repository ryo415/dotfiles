pragma Singleton

import Quickshell

Singleton {
  // Check available names with: hyprctl monitors
  readonly property string mainMonitorName: "HDMI-A-2"

  function workspaceIdsFor(monitorName, singleMonitor) {
    if (singleMonitor) {
      return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    switch (monitorName) {
    case "DP-5":
      return [1, 2, 3, 4, 5];
    case "HDMI-A-2":
      return [6, 7, 8, 9, 10];
    default:
      return [];
    }
  }
}
