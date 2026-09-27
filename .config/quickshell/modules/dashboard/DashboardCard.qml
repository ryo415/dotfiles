import QtQuick
import QtQuick.Layouts
import "../services"

Rectangle {
  id: card
  property string heading: ""
  default property alias content: body.data

  Layout.fillWidth: true
  Layout.fillHeight: true
  implicitHeight: body.implicitHeight + 36
  radius: 16
  color: Theme.surface
  border.width: 1
  border.color: Theme.outline

  ColumnLayout {
    id: body
    anchors.fill: parent
    anchors.margins: 18
    spacing: 12

    Text {
      text: card.heading
      color: Theme.mutedText
      font.family: Theme.fontFamily
      font.pixelSize: 13
      font.bold: true
    }
  }
}
