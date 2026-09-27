import QtQuick
import QtQuick.Layouts
import "../services"

ColumnLayout {
  id: row
  property string label: ""
  property string value: "N/A"
  property real progress: -1
  Layout.fillWidth: true
  spacing: 5

  RowLayout {
    Layout.fillWidth: true
    Text {
      text: row.label
      color: Theme.mutedText
      font.family: Theme.fontFamily
      font.pixelSize: 13
    }
    Item { Layout.fillWidth: true }
    Text {
      text: row.value
      color: Theme.textColor
      font.family: Theme.fontFamily
      font.pixelSize: 15
      font.bold: true
    }
  }

  Rectangle {
    visible: row.progress >= 0
    Layout.fillWidth: true
    implicitHeight: 4
    radius: 2
    color: Theme.surfaceVariant
    Rectangle {
      width: parent.width * Math.max(0, Math.min(1, row.progress))
      height: parent.height
      radius: parent.radius
      color: Theme.accent
    }
  }
}
