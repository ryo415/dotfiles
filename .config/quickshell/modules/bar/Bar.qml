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
  readonly property string fontFamily: Theme.fontFamily
  readonly property var currentMonitor: Hyprland.monitorFor(screen)
  readonly property var monitorWorkspaceIds: currentMonitor === null ? [] : BarConfig.workspaceIdsFor(currentMonitor.name, Quickshell.screens.length === 1)
  readonly property var layoutWorkspace: {
    if (!currentMonitor) return null;
    const special = currentMonitor.lastIpcObject.specialWorkspace;
    if (special && special.id !== 0) {
      return workspaceForId(special.id);
    }
    return currentMonitor.activeWorkspace;
  }
  readonly property string layoutName: layoutWorkspace ? (layoutWorkspace.lastIpcObject.tiledLayout || "") : ""

  // Muted blue-gray surfaces with a restrained Material You lavender accent.
  readonly property color transparent: Theme.transparent
  readonly property color surface: Theme.surface
  readonly property color surfaceVariant: Theme.surfaceVariant
  readonly property color surfaceHover: Theme.surfaceHover
  readonly property color outline: Theme.outline
  readonly property color accent: Theme.accent
  readonly property color activeText: Theme.activeText
  readonly property color textColor: Theme.textColor
  readonly property color mutedText: Theme.mutedText
  readonly property color dimText: Theme.dimText
  readonly property color warning: Theme.warning
  readonly property color powerColor: Theme.powerColor

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
    statusPopup.close();
    powerMenuToggle.startDetached();
  }

  Process {
    id: powerMenuToggle
    command: ["quickshell", "ipc", "call", "powerMenu", "toggle"]
  }

  BarPopup {
    id: statusPopup
    barWindow: bar
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

  StatusPill {
    id: layoutPill

    anchors.left: workspaceIsland.right
    anchors.leftMargin: 6
    anchors.verticalCenter: workspaceIsland.verticalCenter
    text: bar.layoutName ? bar.layoutName.charAt(0).toUpperCase() + bar.layoutName.slice(1) : "—"
    foreground: bar.layoutName === "scrolling" ? bar.accent : bar.mutedText
    surfaceColor: bar.surface
    fontFamily: bar.fontFamily
  }

  ClockTab {
    id: clockIsland

    visible: !bar.miniMode
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    tabHeight: bar.panelHeight - 2
    horizontalPadding: 12
    surfaceColor: bar.surface
    outlineColor: bar.outline

    StatusPill {
      id: fullClockPill
      text: bar.clockText()
      foreground: bar.textColor
      surfaceColor: bar.transparent
      hoverColor: "#663e4656"
      fontFamily: bar.fontFamily
      interactive: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.RightButton) bar.longClock = !bar.longClock;
        else statusPopup.toggle("calendar", fullClockPill);
      }
    }
  }

  BarIsland {
    id: miniClockIsland

    visible: bar.miniMode
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.right: parent.right
    anchors.rightMargin: 8
    islandHeight: bar.islandHeight
    horizontalPadding: 12
    surfaceColor: bar.surface
    outlineColor: bar.outline

    StatusPill {
      id: miniClockPill
      text: bar.clockText()
      foreground: bar.textColor
      surfaceColor: bar.transparent
      hoverColor: "#663e4656"
      fontFamily: bar.fontFamily
      interactive: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.RightButton) bar.longClock = !bar.longClock;
        else statusPopup.toggle("calendar", miniClockPill);
      }
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
      surfaceColor: "#33323845"
      hoverColor: "#663e4656"
      fontFamily: bar.fontFamily
      interactive: true
      onClicked: bar.showIpv6 = !bar.showIpv6
    }

    StatusPill {
      id: cpuPill
      interactive: true
      onClicked: statusPopup.toggle("cpu", cpuPill)
      text: bar.cpuText
      foreground: bar.textColor
      surfaceColor: "#33323845"
      fontFamily: bar.fontFamily
    }

    StatusPill {
      id: ramPill
      interactive: true
      onClicked: statusPopup.toggle("ram", ramPill)
      text: bar.memoryText
      foreground: bar.textColor
      surfaceColor: "#33323845"
      fontFamily: bar.fontFamily
    }

    StatusPill {
      text: bar.temperatureText
      foreground: bar.mutedText
      surfaceColor: "#33323845"
      fontFamily: bar.fontFamily
    }

    StatusPill {
      id: audioPill
      text: AudioState.sinkReady ? (AudioState.sinkMuted ? "󰝟 " : "󰕾 ") + Math.round(AudioState.sinkVolume * 100) + "%" : "󰝟 —"
      foreground: AudioState.sinkMuted ? bar.dimText : bar.textColor
      surfaceColor: "#33323845"
      fontFamily: bar.fontFamily
      interactive: true
      onClicked: statusPopup.toggle("audio", audioPill)
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
      color: hovered ? "#663e4656" : bar.transparent

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
