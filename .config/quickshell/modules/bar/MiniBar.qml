import QtQuick

Bar {
  miniMode: true

  Component.onCompleted: console.info("MiniBar:", screen.name)
}
