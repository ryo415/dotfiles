import QtQuick
import QtQuick.Layouts

Rectangle {
  id: island

  default property alias content: contentRow.data
  property alias spacing: contentRow.spacing
  property color surfaceColor: "#ef1e1e2e"
  property color outlineColor: "#6645475a"
  property int horizontalPadding: 12
  property int islandHeight: 34

  implicitWidth: contentRow.implicitWidth + horizontalPadding * 2
  implicitHeight: islandHeight
  radius: islandHeight / 2
  color: surfaceColor
  border.width: 1
  border.color: outlineColor

  RowLayout {
    id: contentRow

    anchors.centerIn: parent
    spacing: 8
  }
}
