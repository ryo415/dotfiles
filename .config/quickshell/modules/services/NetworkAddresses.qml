pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property string ipv4: internalIpv4
  readonly property string ipv6: internalIpv6

  property string internalIpv4: ""
  property string internalIpv6: ""

  function refresh() {
    if (!addressProcess.running) {
      addressProcess.exec(addressProcess.command);
    }
  }

  Process {
    id: addressProcess

    command: ["ip", "-j", "address", "show", "up"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const interfaces = JSON.parse(text);
          let ipv4 = "";
          let ipv6 = "";

          for (const networkInterface of interfaces) {
            if (networkInterface.ifname === "lo") {
              continue;
            }

            for (const address of networkInterface.addr_info || []) {
              if (address.scope !== "global") {
                continue;
              }

              const formatted = address.local + "/" + address.prefixlen;
              if (address.family === "inet" && ipv4.length === 0) {
                ipv4 = formatted;
              } else if (address.family === "inet6" && ipv6.length === 0) {
                ipv6 = formatted;
              }
            }
          }

          root.internalIpv4 = ipv4;
          root.internalIpv6 = ipv6;
        } catch (error) {
          console.warn("NetworkAddresses: failed to parse address output:", error);
        }
      }
    }

    stderr: StdioCollector {
      onStreamFinished: if (text.trim().length > 0) console.warn("NetworkAddresses:", text.trim())
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }
}
