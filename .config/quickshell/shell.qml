import Quickshell
import "modules/notifications"
import "modules/power"
import "modules/services"
import "modules/bar"
import "modules/dashboard"


ShellRoot {
  readonly property var systemStats: SystemStats

  Bars {}
  NotificationOverlay {}
  PowerMenu {}
  DashboardWindow {}
}
