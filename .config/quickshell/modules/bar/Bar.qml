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

PanelWindow {
  id: bar

  readonly property int barHeight: 30
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property var persistentWorkspaces: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

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

  property string cpuText: "--% "
  property string memoryText: "--% "
  property string temperatureText: ""
  property bool longClock: false

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

  function parseStatus(output) {
    const values = {};
    for (const line of output.trim().split("\n")) {
      const index = line.indexOf("=");
      if (index > 0) {
        values[line.slice(0, index)] = line.slice(index + 1);
      }
    }

    cpuText = (values.cpu || "--") + "% ";
    memoryText = (values.memory || "--") + "% ";
    temperatureText = values.temperature || "";
  }

  function workspaceForId(id) {
    for (const workspace of Hyprland.workspaces.values) {
      if (workspace.id === id) {
        return workspace;
      }
    }

    return null;
  }

  function activateWorkspace(id) {
    const workspace = workspaceForId(id);
    if (workspace !== null) {
      workspace.activate();
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
    const sink = Pipewire.defaultAudioSink;
    if (sink === null || sink.audio === null) {
      return "--% ";
    }

    if (sink.audio.muted) {
      return "󰅶";
    }

    const volume = Math.round(sink.audio.volume * 100);
    return volume + "% " + volumeIcon(volume);
  }

  function sourceText() {
    const source = Pipewire.defaultAudioSource;
    if (source === null || source.audio === null) {
      return "--% ";
    }

    if (source.audio.muted) {
      return "";
    }

    return Math.round(source.audio.volume * 100) + "% ";
  }

  function networkText() {
    for (const device of Networking.devices.values) {
      if (!device.connected) {
        continue;
      }

      for (const network of device.networks.values) {
        if (network.connected && network.name.length > 0) {
          return network.name;
        }
      }

      if (device.name.length > 0) {
        return device.name;
      }
    }

    return "Disconnected";
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

  Component.onCompleted: statusProcess.exec(statusProcess.command)

  Process {
    id: launcher
  }

  Process {
    id: statusProcess
    command: ["sh", "-c", "exec ~/.config/quickshell/scripts/status.sh"]

    stdout: StdioCollector {
      onStreamFinished: bar.parseStatus(text)
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: statusProcess.exec(statusProcess.command)
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
            model: bar.persistentWorkspaces

            WorkspaceButton {
              required property int modelData

              workspaceId: modelData
              active: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData
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
          BarLabel {
            text: bar.networkText()
          }

          BarLabel {
            text: bar.bluetoothText()
          }
        }

        Capsule {
          BarLabel {
            text: bar.temperatureText
          }

          BarLabel {
            text: bar.cpuText
          }
        }

        Capsule {
          BarLabel {
            text: bar.memoryText
          }
        }

        Capsule {
          visible: SystemTray.items.values.length > 0

          Repeater {
            model: SystemTray.items

            Item {
              required property var modelData

              Layout.preferredWidth: 22
              Layout.preferredHeight: 22

              IconImage {
                anchors.centerIn: parent
                width: 20
                height: 20
                source: modelData.icon
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
    Layout.preferredHeight: 22
    implicitWidth: contentRow.implicitWidth + 12
    radius: 11
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
    font.pixelSize: 13
    textFormat: Text.PlainText
    verticalAlignment: Text.AlignVCenter
  }

  component IconButton: Text {
    signal clicked()

    property color foreground: bar.launcherGreen

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: 26
    color: foreground
    font.family: bar.fontFamily
    font.pixelSize: 18
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

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: active ? 44 : 32
    Layout.preferredHeight: 18
    radius: 9
    color: active ? bar.primary : "transparent"

    Text {
      anchors.centerIn: parent
      color: parent.active ? bar.onPrimaryColor : (parent.urgent ? bar.error : (parent.occupied ? bar.tertiary : bar.outlineVariant))
      font.family: bar.fontFamily
      font.pixelSize: 13
      text: parent.workspaceId
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      onClicked: parent.clicked()
      onEntered: if (!parent.active) parent.color = bar.surfaceContainerHighest
      onExited: if (!parent.active) parent.color = "transparent"
    }

    Behavior on Layout.preferredWidth {
      NumberAnimation {
        duration: 180
        easing.type: Easing.OutCubic
      }
    }
  }
}
