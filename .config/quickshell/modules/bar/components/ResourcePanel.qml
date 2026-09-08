import QtQuick
import QtQuick.Layouts
import "../../services"

ColumnLayout {
  id: root
  required property var theme
  property bool memory: false
  readonly property real usage: memory ? SystemStats.ramUsage : SystemStats.cpuUsage
  spacing: 12

  Text {
    text: root.memory ? "メモリ" : "CPU"
    color: root.theme.textColor
    font.family: root.theme.fontFamily
    font.pixelSize: 16
    font.bold: true
  }
  Text {
    text: Math.round(root.usage * 100) + "%"
    color: root.theme.accent
    font.family: root.theme.fontFamily
    font.pixelSize: 32
  }
  Rectangle {
    visible: root.memory
    Layout.fillWidth: true
    implicitHeight: 10
    radius: 5
    color: root.theme.surfaceVariant
    Rectangle {
      width: parent.width * root.usage
      height: parent.height
      radius: 5
      color: root.theme.accent
    }
  }
  Canvas {
    id: graph
    visible: !root.memory
    Layout.fillWidth: true
    Layout.preferredHeight: 90
    property var samples: SystemStats.cpuHistory
    onSamplesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onPaint: {
      const ctx = getContext("2d");
      ctx.clearRect(0, 0, width, height);
      ctx.strokeStyle = root.theme.outline;
      ctx.lineWidth = 1;
      for (let i = 0; i < 3; ++i) {
        const y = 1 + i * (height - 2) / 2;
        ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke();
      }
      if (samples.length < 1) return;
      ctx.beginPath();
      const start = (60 - samples.length) * width / 59;
      ctx.moveTo(start, height - 2 - samples[0] * (height - 4));
      for (let i = 1; i < samples.length; ++i) {
        ctx.lineTo(start + i * width / 59, height - 2 - samples[i] * (height - 4));
      }
      ctx.strokeStyle = root.theme.accent;
      ctx.lineWidth = 2;
      ctx.stroke();
    }
  }
  Text {
    Layout.fillWidth: true
    wrapMode: Text.WordWrap
    text: root.memory
      ? (SystemStats.ramTotal > 0 ? (SystemStats.ramUsed / 1073741824).toFixed(1) + " / " + (SystemStats.ramTotal / 1073741824).toFixed(1) + " GiB 使用中" : "容量を取得中…")
      : "温度  " + Math.round(SystemStats.temp) + "°C  ·  過去約2分"
    color: root.theme.mutedText
    font.family: root.theme.fontFamily
    font.pixelSize: 12
  }
}
