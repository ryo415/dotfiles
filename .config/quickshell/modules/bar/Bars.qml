import Quickshell
import Quickshell.Hyprland
import QtQuick

Scope {
  id: root

  readonly property var fallbackScreen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
  readonly property bool configuredMainConnected: hasScreenNamed(BarConfig.mainMonitorName)

  // Layout changes do not always trigger a workspace refresh in Quickshell.
  // Share one refresh timer across all monitors, including special workspaces.
  Timer {
    interval: 500
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      Hyprland.refreshMonitors();
      Hyprland.refreshWorkspaces();
    }
  }

  function hasScreenNamed(name) {
    for (const screen of Quickshell.screens) {
      if (screen.name === name) {
        return true;
      }
    }

    return false;
  }

  function isMainScreen(screen) {
    if (configuredMainConnected) {
      return screen.name === BarConfig.mainMonitorName;
    }

    return screen === fallbackScreen;
  }

  Variants {
    model: Quickshell.screens

    delegate: Loader {
      id: barLoader

      required property var modelData

      sourceComponent: root.isMainScreen(modelData) ? fullBarComponent : miniBarComponent

      Component {
        id: fullBarComponent

        FullBar {
          screen: barLoader.modelData
        }
      }

      Component {
        id: miniBarComponent

        MiniBar {
          screen: barLoader.modelData
        }
      }
    }
  }
}
