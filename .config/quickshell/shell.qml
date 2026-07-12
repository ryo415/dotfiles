import Quickshell
import "modules/notifications"
import "modules/power"

// import "modules/bar" // Uncomment together with Bar {} to restore the prototype.

ShellRoot {
  // Bar {} // Temporarily disabled while the Quickshell bar remains a prototype.
  NotificationOverlay {}
  PowerMenu {}
}
