import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../services"

ColumnLayout {
  id: root
  required property var theme
  spacing: 14

  Text {
    text: "音量"
    color: root.theme.textColor
    font.family: root.theme.fontFamily
    font.pixelSize: 16
    font.bold: true
  }
  Text {
    Layout.fillWidth: true
    text: AudioState.sinkReady ? (AudioState.sink.description || AudioState.sink.name) : "出力デバイスがありません"
    textFormat: Text.PlainText
    elide: Text.ElideRight
    color: root.theme.mutedText
    font.family: root.theme.fontFamily
    font.pixelSize: 12
  }
  RowLayout {
    Layout.fillWidth: true
    StatusPill {
      text: AudioState.sinkMuted ? "󰝟 ミュート中" : "󰕾 ミュート"
      foreground: AudioState.sinkMuted ? root.theme.accent : root.theme.textColor
      interactive: AudioState.sinkReady
      onClicked: AudioState.sink.audio.muted = !AudioState.sinkMuted
    }
    Item { Layout.fillWidth: true }
    Text {
      text: AudioState.sinkReady ? Math.round(AudioState.sinkVolume * 100) + "%" : "—"
      color: root.theme.accent
      font.family: root.theme.fontFamily
      font.pixelSize: 20
    }
  }
  Slider {
    id: volume
    Layout.fillWidth: true
    from: 0
    to: 1
    stepSize: 0.01
    enabled: AudioState.sinkReady
    value: AudioState.sinkVolume
    onMoved: {
      if (AudioState.sinkReady) AudioState.sink.audio.volume = value;
    }
    background: Rectangle {
      x: volume.leftPadding
      y: volume.topPadding + volume.availableHeight / 2 - height / 2
      width: volume.availableWidth
      height: 6
      radius: 3
      color: root.theme.surfaceVariant
      Rectangle {
        width: volume.visualPosition * parent.width
        height: parent.height
        radius: 3
        color: root.theme.accent
      }
    }
    handle: Rectangle {
      x: volume.leftPadding + volume.visualPosition * (volume.availableWidth - width)
      y: volume.topPadding + volume.availableHeight / 2 - height / 2
      implicitWidth: 18
      implicitHeight: 18
      radius: 9
      color: volume.pressed ? root.theme.textColor : root.theme.accent
    }
  }
}
