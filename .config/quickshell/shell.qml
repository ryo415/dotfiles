import Quickshell
import "modules/notifications"
import "modules/power"
import "modules/services"
import "modules/bar"


ShellRoot {
  readonly property var systemStats: SystemStats

  Bars {}
  NotificationOverlay {}
  PowerMenu {}
}
