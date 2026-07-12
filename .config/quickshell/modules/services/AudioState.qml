pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource

  readonly property bool sinkReady: Pipewire.ready && sink !== null && sink.ready && sink.audio !== null
  readonly property bool sourceReady: Pipewire.ready && source !== null && source.ready && source.audio !== null

  readonly property real sinkVolume: sinkReady ? sink.audio.volume : 0.0
  readonly property real sourceVolume: sourceReady ? source.audio.volume : 0.0
  readonly property bool sinkMuted: sinkReady && sink.audio.muted
  readonly property bool sourceMuted: sourceReady && source.audio.muted

  PwObjectTracker {
    objects: [root.sink, root.source]
  }
}
