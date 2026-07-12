import QtQuick

Rectangle {
  id: button

  required property string label
  required property string iconSource
  required property var command
  required property bool confirmationRequired
  required property int resetGeneration

  property bool confirming: false

  signal triggered(var command)

  onResetGenerationChanged: confirming = false

  implicitWidth: 150
  implicitHeight: 170
  radius: 12
  color: confirming ? "#553700b3" : (mouseArea.containsMouse ? "#3700b3" : "#1e1e1e")
  border.width: confirming ? 2 : 1
  border.color: confirming ? "#c3c3eb" : "#40484c"

  Column {
    anchors.centerIn: parent
    spacing: 14

    Image {
      anchors.horizontalCenter: parent.horizontalCenter
      width: 64
      height: 64
      source: button.iconSource
      fillMode: Image.PreserveAspectFit
    }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: button.confirming ? "Click again" : button.label
      color: "#ffffff"
      font.pixelSize: 15
      font.bold: true
    }
  }

  Timer {
    id: confirmationTimer

    interval: 3000
    onTriggered: button.confirming = false
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (!button.confirmationRequired || button.confirming) {
        button.triggered(button.command);
        return;
      }

      button.confirming = true;
      confirmationTimer.restart();
    }
  }
}
