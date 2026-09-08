pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root
  required property var theme
  property date displayedMonth: new Date(today.date.getFullYear(), today.date.getMonth(), 1)
  readonly property int firstWeekday: displayedMonth.getDay()
  spacing: 12

  function shiftMonth(delta) {
    displayedMonth = new Date(displayedMonth.getFullYear(), displayedMonth.getMonth() + delta, 1);
  }
  function dateForCell(index) {
    return new Date(displayedMonth.getFullYear(), displayedMonth.getMonth(), index - firstWeekday + 1);
  }

  SystemClock { id: today; precision: SystemClock.Minutes }

  RowLayout {
    Layout.fillWidth: true
    StatusPill {
      text: "‹"; interactive: true
      foreground: root.theme.textColor
      onClicked: root.shiftMonth(-1)
    }
    Text {
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      text: Qt.formatDate(root.displayedMonth, "yyyy年 M月")
      color: root.theme.textColor
      font.family: root.theme.fontFamily
      font.pixelSize: 16
      font.bold: true
    }
    StatusPill {
      text: "›"; interactive: true
      foreground: root.theme.textColor
      onClicked: root.shiftMonth(1)
    }
  }
  GridLayout {
    columns: 7
    rowSpacing: 4
    columnSpacing: 4
    Layout.fillWidth: true
    Repeater {
      model: ["日", "月", "火", "水", "木", "金", "土"]
      Text {
        required property string modelData
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: modelData
        color: root.theme.mutedText
        font.pixelSize: 12
      }
    }
    Repeater {
      model: 42
      Rectangle {
        required property int index
        readonly property date cellDate: root.dateForCell(index)
        readonly property bool isToday: cellDate.toDateString() === today.date.toDateString()
        Layout.fillWidth: true
        implicitHeight: 32
        radius: 8
        color: isToday ? root.theme.accent : "transparent"
        Text {
          anchors.centerIn: parent
          text: parent.cellDate.getDate()
          color: parent.isToday ? root.theme.activeText : parent.cellDate.getMonth() === root.displayedMonth.getMonth() ? root.theme.textColor : root.theme.dimText
          font.family: root.theme.fontFamily
          font.pixelSize: 13
        }
      }
    }
  }
  StatusPill {
    Layout.alignment: Qt.AlignHCenter
    text: "今日に戻る"
    foreground: root.theme.accent
    interactive: true
    onClicked: root.displayedMonth = new Date(today.date.getFullYear(), today.date.getMonth(), 1)
  }
}
