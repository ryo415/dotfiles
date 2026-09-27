pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property string script: Quickshell.shellPath("scripts/dashboard-data.py")
  property bool active: false
  property var gpu: ({})
  property var weather: ({})
  property var mounts: []
  property bool dockerOnline: false
  property bool networkOnline: false
  property string networkInterface: ""
  property real downloadMbps: 0
  property real uploadMbps: 0
  property int uptimeSeconds: 0
  property var previousNetwork: null

  onActiveChanged: {
    previousNetwork = null;
    downloadMbps = 0;
    uploadMbps = 0;
  }

  function launch(process) {
    if (!process.running) process.exec(process.command);
  }

  function decode(raw) {
    try { return JSON.parse(raw); }
    catch (error) {
      console.warn("DashboardData: invalid collector output:", error);
      return {};
    }
  }

  function weatherText(code) {
    if (code === undefined || code === null) return "Unavailable";
    if (code === 0) return "Clear sky";
    if (code <= 3) return "Cloudy";
    if (code <= 48) return "Fog";
    if (code <= 67) return "Rain";
    if (code <= 77) return "Snow";
    if (code <= 82) return "Showers";
    if (code <= 86) return "Snow showers";
    return "Thunderstorm";
  }

  Process {
    id: networkProcess
    command: ["python3", root.script, "network"]
    stdout: StdioCollector {
      onStreamFinished: {
        const data = root.decode(text);
        const now = Date.now();
        root.networkOnline = data.connected === true;
        root.networkInterface = data.interface || "";
        if (root.previousNetwork && root.networkOnline &&
            root.previousNetwork.interface === data.interface && now > root.previousNetwork.time) {
          const seconds = (now - root.previousNetwork.time) / 1000;
          root.downloadMbps = Math.max(0, (data.received - root.previousNetwork.received) * 8 / seconds / 1000000);
          root.uploadMbps = Math.max(0, (data.sent - root.previousNetwork.sent) * 8 / seconds / 1000000);
        } else {
          root.downloadMbps = 0;
          root.uploadMbps = 0;
        }
        root.previousNetwork = root.networkOnline ? {
          interface: data.interface, received: data.received, sent: data.sent, time: now
        } : null;
      }
    }
  }

  Process {
    id: gpuProcess
    command: ["python3", root.script, "gpu"]
    stdout: StdioCollector { onStreamFinished: root.gpu = root.decode(text) }
  }

  Process {
    id: storageProcess
    command: ["python3", root.script, "storage"]
    stdout: StdioCollector { onStreamFinished: root.mounts = root.decode(text).mounts || [] }
  }

  Process {
    id: serviceProcess
    command: ["python3", root.script, "services"]
    stdout: StdioCollector {
      onStreamFinished: {
        const data = root.decode(text);
        root.dockerOnline = data.docker === true;
        root.networkOnline = data.network === true;
      }
    }
  }

  Process {
    id: weatherProcess
    command: ["python3", root.script, "weather"]
    stdout: StdioCollector { onStreamFinished: root.weather = root.decode(text) }
  }

  Process {
    id: uptimeProcess
    command: ["python3", root.script, "uptime"]
    stdout: StdioCollector { onStreamFinished: root.uptimeSeconds = root.decode(text).seconds || 0 }
  }

  Timer { interval: 1000; running: root.active; repeat: true; triggeredOnStart: true
    onTriggered: root.launch(networkProcess) }
  Timer { interval: 2000; running: root.active; repeat: true; triggeredOnStart: true
    onTriggered: root.launch(gpuProcess) }
  Timer { interval: 60000; running: root.active; repeat: true; triggeredOnStart: true
    onTriggered: { root.launch(storageProcess); root.launch(uptimeProcess); } }
  Timer { interval: 20000; running: root.active; repeat: true; triggeredOnStart: true
    onTriggered: root.launch(serviceProcess) }
  Timer { interval: 1200000; running: root.active; repeat: true; triggeredOnStart: true
    onTriggered: root.launch(weatherProcess) }
}
