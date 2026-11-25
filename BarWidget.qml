import QtQuick
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.ryanvd.power-draw-widget"

  property string rate: ""
  property string batteryState: ""

  readonly property string arrow: batteryState === "charging" ? "\u2191"
    : batteryState === "discharging" ? "\u2193" : ""

  readonly property bool full: batteryState === "fully-charged"

  // Side bars are too narrow for one line, so stack the parts and drop the decimal.
  // Plugged in but idle (full, or held at a charge limit) the rate is a
  // near-zero reading, so show "Full" when full and nothing otherwise.
  readonly property string label: {
    if (full) return vertical ? "F\nu\nl\nl" : "Full"
    if (rate === "" || arrow === "") return ""
    if (!vertical) return arrow + " " + rate
    return arrow + "\n" + Math.round(parseFloat(rate)) + "\nW"
  }

  visible: label !== ""
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // The same reading Omarchy's battery panel shows.
  Process {
    id: statusProc
    command: ["omarchy-battery-status", "--shell"]
    stdout: StdioCollector {
      onStreamFinished: {
        var match = text.match(/^rate\t([0-9]+(\.[0-9]+)?W)$/m)
        var stateMatch = text.match(/^state\t([a-z-]+)$/m)
        root.batteryState = stateMatch ? stateMatch[1] : ""
        root.rate = match ? match[1] : ""
      }
    }
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!statusProc.running) statusProc.running = true
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    tooltipText: root.full ? "Fully charged"
      : root.batteryState === "charging" ? "Charging" : "Discharging"
    onPressed: if (root.bar) root.bar.run("omarchy-shell omarchy.power show")
  }
}
