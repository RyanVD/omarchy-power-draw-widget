# Power Draw Indicator

This is a simple [Omarchy](https://omarchy.org/) bar widget that shows your laptop battery's current charge or discharge rate in watts. Clicking the widget opens the power panel (if `omarchy.power` is on your bar).

Every 10 seconds, the widget gets a new reading from `omarchy-battery-status` and displays it in the Omarchy bar. On a left or right bar, the reading is stacked and rounded to a whole number.

An up arrow means the battery is charging, and a down arrow means it is discharging. While charging, the number is the power going into the battery, not what the laptop is using. When the battery is fully charged, the widget shows "Full". While it is plugged in but held at a charge limit, the widget hides.

## Install

    omarchy plugin add https://github.com/RyanVD/omarchy-power-draw-widget.git --enable

## Update

    omarchy plugin update io.github.ryanvd.power-draw-widget

## Remove

    omarchy plugin remove io.github.ryanvd.power-draw-widget

## Requirements

Targets Omarchy 4.5. Needs a battery. The widget runs
`omarchy-battery-status`, which ships with Omarchy, and stays hidden when there
is no battery reading.
