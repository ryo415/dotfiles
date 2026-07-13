import QtQuick
import QtQuick.Layouts

Rectangle {
  id: button

  signal clicked()

  property int workspaceId: 0
  property bool active: false
  property bool occupied: false
  property bool urgent: false
  property color accentColor: "#b4befe"
  property color activeTextColor: "#1e1e2e"
  property color surfaceColor: "#45475a"
  property color hoverColor: "#585b70"
  property color textColor: "#cdd6f4"
  property color mutedColor: "#7f849c"
  property color warningColor: "#f9e2af"
  property string fontFamily: "FiraCode Nerd Font Mono"
  property bool hovered: false

  Layout.alignment: Qt.AlignVCenter
  Layout.preferredWidth: active ? 42 : 32
  Layout.preferredHeight: 24
  radius: 12
  color: active ? accentColor : (urgent ? Qt.rgba(warningColor.r, warningColor.g, warningColor.b, 0.22) : (hovered ? hoverColor : surfaceColor))
  border.width: urgent && !active ? 1 : 0
  border.color: warningColor

  Text {
    anchors.centerIn: parent
    color: button.active ? button.activeTextColor : (button.urgent ? button.warningColor : (button.occupied ? button.textColor : button.mutedColor))
    font.family: button.fontFamily
    font.pixelSize: 14
    font.weight: button.active ? Font.DemiBold : Font.Medium
    text: button.workspaceId
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: button.clicked()
    onEntered: button.hovered = true
    onExited: button.hovered = false
  }

  Behavior on Layout.preferredWidth {
    NumberAnimation {
      duration: 140
      easing.type: Easing.OutCubic
    }
  }
}
