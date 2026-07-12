pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

Scope {
  id: root

  property bool open: false
  property int resetGeneration: 0

  function close() {
    open = false;
    resetGeneration++;
  }

  function toggle() {
    if (open) {
      close();
    } else {
      open = true;
    }
  }

  function run(command) {
    close();
    Quickshell.execDetached(command);
  }

  IpcHandler {
    target: "powerMenu"

    function toggle(): void {
      root.toggle();
    }

    function open(): void {
      root.open = true;
    }

    function close(): void {
      root.close();
    }
  }

  PanelWindow {
    id: overlay

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: true
    color: "transparent"
    visible: root.open
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-power-menu"

    Rectangle {
      anchors.fill: parent
      color: "#cc0c0c0c"

      MouseArea {
        anchors.fill: parent
        onClicked: root.close()
      }
    }

    FocusScope {
      id: focusScope

      anchors.fill: parent
      focus: overlay.visible
      Keys.onEscapePressed: root.close()

      Rectangle {
        anchors.centerIn: parent
        width: buttonRow.implicitWidth + 48
        height: buttonRow.implicitHeight + 48
        radius: 18
        color: "#f21b2023"
        border.width: 1
        border.color: "#40484c"

        MouseArea {
          anchors.fill: parent
        }

        Row {
          id: buttonRow

          anchors.centerIn: parent
          spacing: 12

          Repeater {
            id: powerButtons

            model: [
              { label: "Lock", icon: "/usr/share/wlogout/icons/lock.png", command: ["hyprlock"], confirm: false },
              { label: "Logout", icon: "/usr/share/wlogout/icons/logout.png", command: ["uwsm", "stop"], confirm: true },
              { label: "Shutdown", icon: "/usr/share/wlogout/icons/shutdown.png", command: ["systemctl", "poweroff"], confirm: true },
              { label: "Suspend", icon: "/usr/share/wlogout/icons/suspend.png", command: ["systemctl", "suspend"], confirm: true },
              { label: "Reboot", icon: "/usr/share/wlogout/icons/reboot.png", command: ["systemctl", "reboot"], confirm: true }
            ]

            PowerButton {
              required property var modelData

              label: modelData.label
              iconSource: modelData.icon
              command: modelData.command
              confirmationRequired: modelData.confirm
              resetGeneration: root.resetGeneration
              onTriggered: command => root.run(command)
            }
          }
        }
      }
    }
  }
}
