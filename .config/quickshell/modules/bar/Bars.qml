import Quickshell
import QtQuick

Scope {
  id: root

  readonly property var fallbackScreen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
  readonly property bool configuredMainConnected: hasScreenNamed(BarConfig.mainMonitorName)

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
