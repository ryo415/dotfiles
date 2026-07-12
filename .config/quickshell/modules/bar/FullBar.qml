import QtQuick

Bar {
  miniMode: false

  Component.onCompleted: console.info("FullBar:", screen.name)
}
