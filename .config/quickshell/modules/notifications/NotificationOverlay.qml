import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Scope {
  id: root

  NotificationServer {
    id: notificationServer

    bodySupported: true
    bodyMarkupSupported: false
    keepOnReload: false

    onNotification: notification => {
      notification.tracked = true;
    }
  }

  PanelWindow {
    anchors {
      top: true
      right: true
    }

    margins {
      top: 12
      right: 12
    }

    // Keep a minimal surface alive while idle. A window created at 0x0 and
    // hidden may not be mapped again when the first notification arrives.
    implicitWidth: 360
    implicitHeight: Math.max(1, notificationColumn.implicitHeight)
    exclusiveZone: 0
    aboveWindows: true
    color: "transparent"
    visible: true

    Column {
      id: notificationColumn

      spacing: 8

      Repeater {
        model: notificationServer.trackedNotifications

        NotificationCard {
          required property var modelData

          notification: modelData
        }
      }
    }
  }
}
