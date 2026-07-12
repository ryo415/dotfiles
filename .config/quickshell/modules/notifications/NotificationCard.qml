import Quickshell.Services.Notifications
import QtQuick

Rectangle {
  id: card

  required property var notification

  readonly property color accentColor: {
    if (notification.urgency === NotificationUrgency.Critical) {
      return "#ffb4ab";
    }

    if (notification.urgency === NotificationUrgency.Low) {
      return "#8a9296";
    }

    return "#88d1ec";
  }

  width: 360
  height: content.implicitHeight + 24
  radius: 10
  color: "#ee1b2023"
  border.width: notification.urgency === NotificationUrgency.Critical ? 2 : 1
  border.color: accentColor

  Column {
    id: content

    anchors {
      left: parent.left
      right: parent.right
      verticalCenter: parent.verticalCenter
      margins: 12
    }
    spacing: 5

    Text {
      width: parent.width
      text: card.notification.appName
      color: card.accentColor
      font.pixelSize: 12
      font.bold: true
      elide: Text.ElideRight
      textFormat: Text.PlainText
    }

    Text {
      width: parent.width
      text: card.notification.summary
      color: "#e2e2e6"
      font.pixelSize: 15
      font.bold: true
      wrapMode: Text.Wrap
      textFormat: Text.PlainText
      visible: text.length > 0
    }

    Text {
      width: parent.width
      text: card.notification.body
      color: "#c3c7c9"
      font.pixelSize: 13
      wrapMode: Text.Wrap
      textFormat: Text.PlainText
      visible: text.length > 0
    }
  }

  Timer {
    interval: 5000
    running: true
    onTriggered: card.notification.expire()
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: card.notification.dismiss()
  }
}
