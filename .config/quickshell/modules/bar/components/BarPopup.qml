pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick

PopupWindow {
  id: popup

  required property var barWindow
  property Item triggerItem: null
  property string section: ""

  function toggle(name, item) {
    if (section === name) {
      close();
    } else {
      triggerItem = item;
      section = name;
    }
  }

  function close() { section = ""; }

  anchor.window: barWindow
  anchor.rect.x: {
    if (!triggerItem) return 8;
    const point = triggerItem.mapToItem(barWindow.contentItem, triggerItem.width / 2, 0);
    return Math.max(8, Math.min(barWindow.width - width - 8, point.x - width / 2));
  }
  anchor.rect.y: barWindow.height + 6
  implicitWidth: 340
  implicitHeight: content.implicitHeight + 32
  color: "transparent"
  visible: section !== ""
  onVisibleChanged: {
    if (visible) {
      body.forceActiveFocus();
      // Wait for the popup surface before grabbing: the bar is already mapped.
      Qt.callLater(() => { if (popup.visible) grab.active = true; });
    } else {
      grab.active = false;
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [popup.barWindow, popup]
    onCleared: popup.close()
  }

  Rectangle {
    id: body
    anchors.fill: parent
    radius: 16
    color: popup.barWindow.surface
    border.color: popup.barWindow.outline
    border.width: 1
    focus: true
    Keys.onEscapePressed: popup.close()

    Loader {
      id: content
      x: 16
      y: 16
      width: parent.width - 32
      sourceComponent: popup.section === "calendar" ? calendarComponent
        : popup.section === "audio" ? audioComponent
        : popup.section === "cpu" || popup.section === "ram" ? statsComponent : null
    }
  }

  Component {
    id: statsComponent
    ResourcePanel { theme: popup.barWindow; memory: popup.section === "ram" }
  }
  Component {
    id: calendarComponent
    CalendarPanel { theme: popup.barWindow }
  }
  Component {
    id: audioComponent
    AudioPanel { theme: popup.barWindow }
  }
}
