import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../services"

PanelWindow {
  id: bar

  property bool miniMode: false

  readonly property int barHeight: 36
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property var currentMonitor: Hyprland.monitorFor(screen)
  readonly property var monitorWorkspaceIds: currentMonitor === null ? [] : BarConfig.workspaceIdsFor(currentMonitor.name)

  readonly property color transparent: "#00000000"
  readonly property color surfaceContainer: "#1b2023"
  readonly property color surfaceContainerHigh: "#252b2d"
  readonly property color surfaceContainerHighest: "#303638"
  readonly property color primary: "#88d1ec"
  readonly property color onPrimaryColor: "#003544"
  readonly property color secondary: "#b3cad4"
  readonly property color tertiary: "#c3c3eb"
  readonly property color outline: "#8a9296"
  readonly property color outlineVariant: "#40484c"
  readonly property color error: "#ffb4ab"
  readonly property color launcherGreen: "#a6e3a1"

  readonly property string cpuText: Math.round(SystemStats.cpuUsage * 100) + "% "
  readonly property string memoryText: Math.round(SystemStats.ramUsage * 100) + "% "
  readonly property string temperatureText: temperatureIcon(SystemStats.temp) + " " + Math.round(SystemStats.temp) + "°C"
  property bool longClock: false
  property bool showIpv6: false

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: barHeight
  exclusiveZone: barHeight
  aboveWindows: true
  color: transparent

  function runDetached(command) {
    launcher.command = ["sh", "-lc", command];
    launcher.startDetached();
  }

  function temperatureIcon(temperature) {
    if (temperature >= 80) {
      return "󱇗";
    }
    if (temperature >= 60) {
      return "";
    }
    if (temperature >= 40) {
      return "";
    }
    return "";
  }

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

  function volumeIcon(volume) {
    if (volume < 35) {
      return "";
    }

    if (volume < 70) {
      return "";
    }

    return "";
  }

  function sinkText() {
    if (!AudioState.sinkReady) {
      return "--% ";
    }

    if (AudioState.sinkMuted) {
      return "󰅶";
    }

    const volume = Math.round(AudioState.sinkVolume * 100);
    return volume + "% " + volumeIcon(volume);
  }

  function sourceText() {
    if (!AudioState.sourceReady) {
      return "--% ";
    }

    if (AudioState.sourceMuted) {
      return "";
    }

    return Math.round(AudioState.sourceVolume * 100) + "% ";
  }

  function networkText() {
    const address = showIpv6 ? NetworkAddresses.ipv6 : NetworkAddresses.ipv4;
    if (address.length > 0) {
      return address;
    }

    return showIpv6 ? "No IPv6" : "No IPv4";
  }

  function bluetoothText() {
    const adapter = Bluetooth.defaultAdapter;
    if (adapter !== null && !adapter.enabled) {
      return "󰂲";
    }

    for (const device of Bluetooth.devices.values) {
      if (device.connected) {
        return "󰂱";
      }
    }

    return "󰂯";
  }

  function clockText() {
    if (longClock) {
      return Qt.formatDateTime(clock.date, "yyyy年MM月dd日 (ddd) hh:mm");
    }

    return Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm");
  }

  Process {
    id: launcher
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Rectangle {
    anchors.fill: parent
    color: bar.transparent

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 5
      anchors.rightMargin: 5
      spacing: 0

      RowLayout {
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.maximumWidth: parent.width / 3
        spacing: 6

        Capsule {
          spacing: 2

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
              onClicked: bar.activateWorkspace(modelData)
            }
          }
        }

        BarLabel {
          visible: !bar.miniMode
          Layout.fillWidth: true
          Layout.maximumWidth: 420
          elide: Text.ElideRight
          text: Hyprland.activeToplevel !== null && Hyprland.activeToplevel.title.length > 0 ? " " + Hyprland.activeToplevel.title : ""
        }
      }

      RowLayout {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillWidth: true
        spacing: 5

        Item {
          Layout.fillWidth: true
        }

        Capsule {
          interactive: true
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: bar.longClock = !bar.longClock

          BarLabel {
            text: bar.clockText()
          }
        }

        Capsule {
          visible: !bar.miniMode

          IconButton {
            text: ""
            foreground: bar.primary
            onClicked: bar.runDetached("wlogout")
          }

          IconButton {
            text: "󰆍"
            onClicked: bar.runDetached("wezterm")
          }

          IconButton {
            text: ""
            onClicked: bar.runDetached("steam")
          }

          IconButton {
            text: ""
            onClicked: bar.runDetached("discord")
          }

          IconButton {
            text: ""
            onClicked: bar.runDetached("notion-app")
          }
        }

        Item {
          Layout.fillWidth: true
        }
      }

      RowLayout {
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.maximumWidth: parent.width / 3
        spacing: 5

        Item {
          Layout.fillWidth: true
        }

        Capsule {
          visible: !bar.miniMode
          interactive: true
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
              bar.runDetached("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle");
            } else if (mouse.button === Qt.RightButton) {
              bar.runDetached("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle");
            }
          }

          BarLabel {
            text: bar.sinkText()
          }

          BarLabel {
            text: bar.sourceText()
          }
        }

        Capsule {
          visible: !bar.miniMode
          interactive: true
          onClicked: bar.showIpv6 = !bar.showIpv6

          BarLabel {
            text: bar.networkText()
          }

          BarLabel {
            text: bar.bluetoothText()
          }
        }

        Capsule {
          visible: !bar.miniMode

          BarLabel {
            text: bar.temperatureText
          }

          BarLabel {
            text: bar.cpuText
          }
        }

        Capsule {
          visible: !bar.miniMode

          BarLabel {
            text: bar.memoryText
          }
        }

        Capsule {
          visible: !bar.miniMode && SystemTray.items.values.length > 0

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
                width: 24
                height: 24
                source: parent.useKeyboardFallback ? "" : modelData.icon
                visible: !parent.useKeyboardFallback && status !== Image.Error
              }

              BarLabel {
                anchors.centerIn: parent
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
      }
    }
  }

  component Capsule: Rectangle {
    signal clicked(var mouse)

    default property alias content: contentRow.data
    property alias spacing: contentRow.spacing
    property string command: ""
    property bool interactive: false
    property int acceptedButtons: Qt.LeftButton

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: 28
    implicitWidth: contentRow.implicitWidth + 16
    radius: 14
    color: bar.surfaceContainer

    RowLayout {
      id: contentRow
      anchors.centerIn: parent
      spacing: 8
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: parent.acceptedButtons
      cursorShape: parent.command.length > 0 || parent.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
      enabled: parent.command.length > 0 || parent.interactive
      onClicked: mouse => {
        if (parent.command.length > 0) {
          bar.runDetached(parent.command);
        }

        parent.clicked(mouse);
      }
    }
  }

  component BarLabel: Text {
    Layout.alignment: Qt.AlignVCenter
    color: bar.secondary
    font.family: bar.fontFamily
    font.pixelSize: 15
    textFormat: Text.PlainText
    verticalAlignment: Text.AlignVCenter
  }

  component IconButton: Text {
    signal clicked()

    property color foreground: bar.launcherGreen

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: 30
    color: foreground
    font.family: bar.fontFamily
    font.pixelSize: 20
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: parent.clicked()
    }
  }

  component WorkspaceButton: Rectangle {
    signal clicked()

    property int workspaceId: 0
    property bool active: false
    property bool occupied: false
    property bool urgent: false
    property bool hovered: false

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: active ? 48 : 36
    Layout.preferredHeight: 22
    radius: 11
    color: active ? bar.primary : (hovered ? bar.surfaceContainerHighest : "transparent")

    Text {
      anchors.centerIn: parent
      color: parent.active ? bar.surfaceContainer : (parent.urgent ? bar.error : (parent.occupied ? bar.tertiary : bar.outlineVariant))
      font.family: bar.fontFamily
      font.pixelSize: 15
      font.weight: parent.active ? Font.Bold : Font.Normal
      text: parent.workspaceId
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      onClicked: parent.clicked()
      onEntered: parent.hovered = true
      onExited: parent.hovered = false
    }

    Behavior on Layout.preferredWidth {
      NumberAnimation {
        duration: 180
        easing.type: Easing.OutCubic
      }
    }
  }
}
