import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
  id: tab

  default property alias content: contentRow.data
  property color surfaceColor: "#252932"
  property color outlineColor: "#4b5363"
  property int horizontalPadding: 12
  property int taperInset: 30
  property int tabHeight: 42
  readonly property real bottomY: height - 1

  implicitWidth: Math.ceil((contentRow.implicitWidth + horizontalPadding * 2 + taperInset * 2) / 2) * 2
  implicitHeight: tabHeight

  Shape {
    anchors.fill: parent

    ShapePath {
      fillColor: tab.surfaceColor
      strokeColor: "#00000000"
      startX: 0
      startY: 0

      PathLine {
        x: tab.width
        y: 0
      }

      PathCubic {
        x: tab.width - tab.taperInset - 12
        y: tab.bottomY
        control1X: tab.width - 24
        control1Y: 0
        control2X: tab.width - 4
        control2Y: tab.bottomY
      }

      PathLine {
        x: tab.taperInset + 12
        y: tab.bottomY
      }

      PathCubic {
        x: 0
        y: 0
        control1X: 4
        control1Y: tab.bottomY
        control2X: 24
        control2Y: 0
      }
    }

    ShapePath {
      fillColor: "#00000000"
      strokeColor: tab.outlineColor
      strokeWidth: 1
      startX: tab.width
      startY: 0

      PathCubic {
        x: tab.width - tab.taperInset - 12
        y: tab.bottomY
        control1X: tab.width - 24
        control1Y: 0
        control2X: tab.width - 4
        control2Y: tab.bottomY
      }

      PathLine {
        x: tab.taperInset + 12
        y: tab.bottomY
      }

      PathCubic {
        x: 0
        y: 0
        control1X: 4
        control1Y: tab.bottomY
        control2X: 24
        control2Y: 0
      }
    }
  }

  RowLayout {
    id: contentRow

    anchors.centerIn: parent
    anchors.verticalCenterOffset: 3
  }
}
