import QtQuick
import QtQuick.Layouts

Rectangle {
  id: pill

  signal clicked(var mouse)

  property alias text: label.text
  property color foreground: "#cdd6f4"
  property color surfaceColor: "#3345475a"
  property color hoverColor: "#66585b70"
  property string fontFamily: "FiraCode Nerd Font Mono"
  property bool interactive: false
  property int acceptedButtons: Qt.LeftButton
  property bool hovered: false

  Layout.alignment: Qt.AlignVCenter
  implicitWidth: label.implicitWidth + 14
  implicitHeight: 26
  radius: 13
  color: hovered && interactive ? hoverColor : surfaceColor

  Text {
    id: label

    anchors.centerIn: parent
    color: pill.foreground
    font.family: pill.fontFamily
    font.pixelSize: 14
    font.weight: Font.Medium
    textFormat: Text.PlainText
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: pill.acceptedButtons
    cursorShape: pill.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
    enabled: pill.interactive
    hoverEnabled: pill.interactive
    onClicked: mouse => pill.clicked(mouse)
    onEntered: pill.hovered = true
    onExited: pill.hovered = false
  }
}
