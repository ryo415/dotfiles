import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../services"

FloatingWindow {
  id: window
  title: "Quickshell Dashboard"
  implicitWidth: 1200
  implicitHeight: 900
  color: Theme.transparent

  readonly property var dashboardData: DashboardData
  readonly property var currentMonitor: Hyprland.monitorFor(screen)
  readonly property bool dashboardVisible: currentMonitor !== null && currentMonitor.activeWorkspace !== null && currentMonitor.activeWorkspace.name === "dashboard"

  Binding {
    target: DashboardData
    property: "active"
    value: window.dashboardVisible
  }

  function percent(value) {
    return Number.isFinite(value) ? Math.round(value) + "%" : "N/A";
  }
  function temperature(value) {
    return Number.isFinite(value) ? Math.round(value) + "°C" : "N/A";
  }
  function bytes(value) {
    if (!Number.isFinite(value)) return "N/A";
    return (value / 1073741824).toFixed(1) + " GB";
  }
  function uptimeText(seconds) {
    if (!seconds) return "N/A";
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor(seconds % 86400 / 3600);
    return days > 0 ? days + "d " + hours + "h" : hours + "h " + Math.floor(seconds % 3600 / 60) + "m";
  }

  SystemClock { id: clock; precision: SystemClock.Seconds }

  Flickable {
    anchors.fill: parent
    contentWidth: width
    contentHeight: dashboard.implicitHeight + 48
    clip: true

    ColumnLayout {
      id: dashboard
      x: Math.max(24, (parent.width - 1200) / 2)
      y: 24
      width: Math.min(parent.width - 48, 1200)
      spacing: 16

      GridLayout {
        id: grid
        Layout.fillWidth: true
        columns: dashboard.width < 760 ? 1 : 2
        columnSpacing: 16
        rowSpacing: 16

        DashboardCard {
          heading: "NOW"
          Layout.row: 0
          Layout.columnSpan: grid.columns
          Text {
            text: Qt.formatDateTime(clock.date, "HH:mm")
            color: Theme.textColor
            font.family: Theme.fontFamily
            font.pixelSize: 68
            font.bold: true
          }
          Text {
            text: Qt.formatDateTime(clock.date, "dddd, MMMM d, yyyy")
            color: Theme.mutedText
            font.family: Theme.fontFamily
            font.pixelSize: 20
          }
        }

        DashboardCard {
          heading: "WEATHER"
          Layout.row: 1
          Layout.column: 0
          Text {
            text: dashboardData.weatherText(dashboardData.weather.code)
            color: Theme.textColor
            font.family: Theme.fontFamily
            font.pixelSize: 26
            font.bold: true
          }
          MetricRow { label: "Now"; value: window.temperature(dashboardData.weather.temperature) }
          MetricRow { label: "High / Low"; value: window.temperature(dashboardData.weather.high) + " / " + window.temperature(dashboardData.weather.low) }
          MetricRow { label: "Rain"; value: window.percent(dashboardData.weather.rain) }
        }

        DashboardCard {
          heading: "SYSTEM"
          Layout.row: 2
          Layout.column: 0
          MetricRow { label: "CPU"; value: window.percent(SystemStats.cpuUsage * 100); progress: SystemStats.cpuUsage }
          MetricRow { label: "RAM"; value: window.percent(SystemStats.ramUsage * 100); progress: SystemStats.ramUsage }
          MetricRow { label: "CPU temp"; value: window.temperature(SystemStats.temp > 0 ? SystemStats.temp : undefined) }
          MetricRow { label: "Uptime"; value: window.uptimeText(dashboardData.uptimeSeconds) }
        }

        DashboardCard {
          heading: "NVIDIA GPU"
          Layout.row: grid.columns === 1 ? 3 : 2
          Layout.column: grid.columns === 1 ? 0 : 1
          MetricRow { label: "Utilization"; value: window.percent(dashboardData.gpu.utilization); progress: Number.isFinite(dashboardData.gpu.utilization) ? dashboardData.gpu.utilization / 100 : -1 }
          MetricRow { label: "VRAM"; value: window.bytes(Number.isFinite(dashboardData.gpu.memoryUsed) ? dashboardData.gpu.memoryUsed * 1048576 : undefined) + " / " + window.bytes(Number.isFinite(dashboardData.gpu.memoryTotal) ? dashboardData.gpu.memoryTotal * 1048576 : undefined) }
          MetricRow { label: "GPU temp"; value: window.temperature(dashboardData.gpu.temperature) }
          MetricRow { label: "Power"; value: Number.isFinite(dashboardData.gpu.power) ? Math.round(dashboardData.gpu.power) + " W" : "N/A" }
        }

        DashboardCard {
          heading: "NETWORK"
          Layout.row: grid.columns === 1 ? 4 : 3
          Layout.column: 0
          MetricRow { label: "Status"; value: dashboardData.networkOnline ? "Connected · " + dashboardData.networkInterface : "Offline" }
          MetricRow { label: "↓ Download"; value: dashboardData.downloadMbps.toFixed(1) + " Mbps" }
          MetricRow { label: "↑ Upload"; value: dashboardData.uploadMbps.toFixed(1) + " Mbps" }
        }

        DashboardCard {
          heading: "TODAY / CALENDAR"
          Layout.row: grid.columns === 1 ? 5 : 1
          Layout.column: grid.columns === 1 ? 0 : 1
          Text {
            text: "No events"
            color: Theme.mutedText
            font.family: Theme.fontFamily
            font.pixelSize: 18
          }
        }

        DashboardCard {
          heading: "STORAGE"
          Layout.row: grid.columns === 1 ? 6 : 4
          Layout.column: 0
          Layout.columnSpan: grid.columns
          Repeater {
            model: dashboardData.mounts
            MetricRow {
              required property var modelData
              label: modelData.path
              value: window.bytes(modelData.used) + " / " + window.bytes(modelData.total) + " · " + window.percent(modelData.used / modelData.total * 100)
              progress: modelData.used / modelData.total
            }
          }
          Text {
            visible: dashboardData.mounts.length === 0
            text: "Unavailable"
            color: Theme.mutedText
            font.family: Theme.fontFamily
          }
        }

        DashboardCard {
          heading: "SERVICES"
          Layout.row: grid.columns === 1 ? 7 : 3
          Layout.column: grid.columns === 1 ? 0 : 1
          MetricRow { label: "Docker"; value: dashboardData.dockerOnline ? "● Running" : "○ Stopped" }
          MetricRow { label: "Network"; value: dashboardData.networkOnline ? "● Connected" : "○ Offline" }
        }
      }
    }
  }
}
