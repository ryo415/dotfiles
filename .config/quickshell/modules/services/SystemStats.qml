pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property real cpuUsage: internalCpuUsage
  readonly property real ramUsage: internalRamUsage
  readonly property real temp: internalTemp

  property real internalCpuUsage: 0.0
  property real internalRamUsage: 0.0
  property real internalTemp: 0.0

  Process {
    id: monitorProcess

    command: [Quickshell.shellPath("scripts/system-monitor"), "--interval", "2"]
    running: true

    onRunningChanged: {
      if (!running) {
        console.warn("SystemStats: monitor stopped; retrying in 2 seconds");
        restartTimer.restart();
      }
    }

    stdout: SplitParser {
      onRead: data => {
        try {
          const stats = JSON.parse(data);
          const cpu = Number(stats.cpu);
          const ram = Number(stats.ram);
          const temperature = Number(stats.temp);

          if (!Number.isFinite(cpu) || !Number.isFinite(ram) || !Number.isFinite(temperature)) {
            throw new Error("monitor values must be finite numbers");
          }

          root.internalCpuUsage = Math.max(0.0, Math.min(1.0, cpu / 100.0));
          root.internalRamUsage = Math.max(0.0, Math.min(1.0, ram / 100.0));
          root.internalTemp = temperature;
        } catch (error) {
          console.warn("SystemStats: failed to parse monitor output:", error, data);
        }
      }
    }

    stderr: SplitParser {
      onRead: data => console.warn("SystemStats:", data)
    }

  }

  Timer {
    id: restartTimer

    interval: 2000
    onTriggered: monitorProcess.running = true
  }
}
