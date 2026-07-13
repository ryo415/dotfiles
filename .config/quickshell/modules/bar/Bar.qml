import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../services"
import "components"

PanelWindow {
  id: bar

  property bool miniMode: false
  property bool longClock: false
  property bool showIpv6: false

  readonly property int islandHeight: miniMode ? 30 : 34
  readonly property int panelHeight: miniMode ? 38 : 44
  readonly property string fontFamily: "FiraCode Nerd Font Mono"
  readonly property var currentMonitor: Hyprland.monitorFor(screen)
  readonly property var monitorWorkspaceIds: currentMonitor === null ? [] : BarConfig.workspaceIdsFor(currentMonitor.name)

  // Catppuccin Mocha surfaces with a restrained Material You lavender accent.
  readonly property color transparent: "#00000000"
  readonly property color surface: "#ef1e1e2e"
  readonly property color surfaceVariant: "#45475a"
  readonly property color surfaceHover: "#585b70"
  readonly property color outline: "#66585b70"
  readonly property color accent: "#b4befe"
  readonly property color activeText: "#1e1e2e"
  readonly property color textColor: "#cdd6f4"
  readonly property color mutedText: "#a6adc8"
  readonly property color dimText: "#7f849c"
  readonly property color warning: "#f9e2af"
  readonly property color powerColor: "#f2cdcd"

  readonly property string cpuText: "CPU " + Math.round(SystemStats.cpuUsage * 100) + "%"
  readonly property string memoryText: "RAM " + Math.round(SystemStats.ramUsage * 100) + "%"
  readonly property string temperatureText: Math.round(SystemStats.temp) + "°C"

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: panelHeight
  exclusiveZone: panelHeight
  aboveWindows: true
  color: transparent

  function workspaceForId(id) {
    for (const workspace of Hyprland.workspaces.values) {
      if (workspace.id === id && workspace.monitor === currentMonitor) {
        return workspace;
      }
    }

    return null;
  }

  function activateWorkspace(id) {
    if (!monitorWorkspaceIds.includes(id)) {
      return;
    }

    const workspace = workspaceForId(id);
    if (workspace !== null) {
      workspace.activate();
    } else if (Hyprland.usingLua) {
      Hyprland.dispatch('hl.dsp.focus({ workspace = "' + id + '" })');
    } else {
      Hyprland.dispatch("workspace " + id);
    }
  }

  function networkText() {
    const address = showIpv6 ? NetworkAddresses.ipv6 : NetworkAddresses.ipv4;
    if (address.length > 0) {
      return "󰖩 " + address;
    }

    return showIpv6 ? "󰖪 No IPv6" : "󰖪 No IPv4";
  }

  function clockText() {
    if (longClock) {
      return Qt.formatDateTime(clock.date, "yyyy年MM月dd日 (ddd) hh:mm");
    }

    return miniMode ? Qt.formatDateTime(clock.date, "hh:mm") : Qt.formatDateTime(clock.date, "MM/dd (ddd)  hh:mm");
  }

  function togglePowerMenu() {
    powerMenuToggle.startDetached();
  }

  Process {
    id: powerMenuToggle
    command: ["quickshell", "ipc", "call", "powerMenu", "toggle"]
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  BarIsland {
    id: workspaceIsland

    anchors.left: parent.left
    anchors.leftMargin: 8
    anchors.top: parent.top
    anchors.topMargin: miniMode ? 4 : 6
    islandHeight: bar.islandHeight
    horizontalPadding: miniMode ? 8 : 10
    surfaceColor: bar.surface
    outlineColor: bar.outline
    spacing: 4

    Repeater {
      model: bar.monitorWorkspaceIds

      WorkspaceButton {
        required property int modelData

        workspaceId: modelData
        active: {
          const workspace = bar.workspaceForId(modelData);
          return workspace !== null && workspace.active;
        }
        occupied: bar.workspaceForId(modelData) !== null
        urgent: {
          const workspace = bar.workspaceForId(modelData);
          return workspace !== null && workspace.urgent;
        }
        accentColor: bar.accent
        activeTextColor: bar.activeText
        surfaceColor: bar.surfaceVariant
        hoverColor: bar.surfaceHover
        textColor: bar.textColor
        mutedColor: bar.dimText
        warningColor: bar.warning
        fontFamily: bar.fontFamily
        onClicked: bar.activateWorkspace(modelData)
      }
    }
  }

  BarIsland {
    id: clockIsland

    anchors.top: parent.top
    anchors.topMargin: miniMode ? 4 : 6
    anchors.horizontalCenter: miniMode ? undefined : parent.horizontalCenter
    anchors.right: miniMode ? parent.right : undefined
    anchors.rightMargin: miniMode ? 8 : 0
    islandHeight: bar.islandHeight
    horizontalPadding: 12
    surfaceColor: bar.surface
    outlineColor: bar.outline

    StatusPill {
      text: bar.clockText()
      foreground: bar.textColor
      surfaceColor: bar.transparent
      hoverColor: "#44585b70"
      fontFamily: bar.fontFamily
      interactive: true
      onClicked: bar.longClock = !bar.longClock
    }
  }

  BarIsland {
    id: statusIsland

    visible: !bar.miniMode
    anchors.right: parent.right
    anchors.rightMargin: 8
    anchors.top: parent.top
    anchors.topMargin: 6
    islandHeight: bar.islandHeight
    horizontalPadding: 10
    surfaceColor: bar.surface
    outlineColor: bar.outline
    spacing: 5

    StatusPill {
      text: bar.networkText()
      foreground: bar.mutedText
      surfaceColor: "#3345475a"
      hoverColor: "#66585b70"
      fontFamily: bar.fontFamily
      interactive: true
      onClicked: bar.showIpv6 = !bar.showIpv6
    }

    StatusPill {
      text: bar.cpuText
      foreground: bar.textColor
      surfaceColor: "#3345475a"
      fontFamily: bar.fontFamily
    }

    StatusPill {
      text: bar.memoryText
      foreground: bar.textColor
      surfaceColor: "#3345475a"
      fontFamily: bar.fontFamily
    }

    StatusPill {
      text: bar.temperatureText
      foreground: bar.mutedText
      surfaceColor: "#3345475a"
      fontFamily: bar.fontFamily
    }

    RowLayout {
      visible: SystemTray.items.values.length > 0
      spacing: 2

      Repeater {
        model: SystemTray.items

        Item {
          required property var modelData
          readonly property bool useKeyboardFallback: String(modelData.icon).includes("input-keyboard-symbolic")

          Layout.preferredWidth: 26
          Layout.preferredHeight: 26

          IconImage {
            id: trayIcon

            anchors.centerIn: parent
            width: 20
            height: 20
            source: parent.useKeyboardFallback ? "" : modelData.icon
            visible: !parent.useKeyboardFallback && status !== Image.Error
          }

          Text {
            anchors.centerIn: parent
            color: bar.mutedText
            font.family: bar.fontFamily
            font.pixelSize: 15
            text: ""
            visible: parent.useKeyboardFallback || trayIcon.status === Image.Error
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor
            onClicked: mouse => {
              if (mouse.button === Qt.LeftButton) {
                modelData.activate();
              } else if (mouse.button === Qt.MiddleButton) {
                modelData.secondaryActivate();
              } else if (mouse.button === Qt.RightButton) {
                modelData.display(bar, x, y);
              }
            }
          }
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 18
      Layout.alignment: Qt.AlignVCenter
      color: bar.outline
    }

    Rectangle {
      id: powerButton

      property bool hovered: false

      Layout.preferredWidth: 28
      Layout.preferredHeight: 28
      Layout.alignment: Qt.AlignVCenter
      radius: 14
      color: hovered ? "#66585b70" : bar.transparent

      Text {
        anchors.centerIn: parent
        color: bar.powerColor
        font.family: bar.fontFamily
        font.pixelSize: 17
        text: ""
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: bar.togglePowerMenu()
        onEntered: powerButton.hovered = true
        onExited: powerButton.hovered = false
      }
    }
  }
}
