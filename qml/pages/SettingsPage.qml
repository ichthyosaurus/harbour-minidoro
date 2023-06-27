/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: 2022-2023 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Opal.LinkHandler 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { flickable: flick }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("Intervals")
            }

            // -- NOTE: although it would be more fitting to use a time picker for
            //          picking times, it is unfeasible because Silica's picker does
            //          not support picking only minutes or minutes with seconds.
            // ValueButton {
            //     label: qsTr("Work duration")
            //     value: appWindow.config.workDuration
            //     description: qsTr("Length of a work interval in minutes")
            //     onClicked: {
            //         var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
            //             hour: 0,
            //             minute: 0,
            //             hourMode: DateTime.TwentyFourHours
            //         })
            //         dialog.accepted.connect(function() {
            //             label = "You chose: " + dialog.timeText
            //         })
            //     }
            // }

            Slider {
                width: parent.width
                minimumValue: 1.0
                maximumValue: 60.0
                valueText: qsTr("%n min", "as in “x minutes”", value)
                stepSize: 1.0
                label: qsTr("Work duration")
                value: appWindow.config.workDuration / 60

                onSliderValueChanged: {
                    if (sliderValue * 60 !== appWindow.config.workDuration) {
                        appWindow.config.workDuration = sliderValue * 60
                    }
                }
            }

            Slider {
                width: parent.width
                minimumValue: 1.0
                maximumValue: 30.0
                valueText: qsTr("%n min", "as in “x minutes”", value)
                stepSize: 1.0
                label: qsTr("Break duration")
                value: appWindow.config.breakDuration / 60

                onSliderValueChanged: {
                    if (sliderValue * 60 !== appWindow.config.breakDuration) {
                        appWindow.config.breakDuration = sliderValue * 60
                    }
                }
            }

            Slider {
                width: parent.width
                minimumValue: 1.0
                maximumValue: 60.0
                valueText: qsTr("%n min", "as in “x minutes”", value)
                stepSize: 1.0
                label: qsTr("Long break duration")
                value: appWindow.config.longBreakDuration / 60

                onSliderValueChanged: {
                    if (sliderValue * 60 !== appWindow.config.longBreakDuration) {
                        appWindow.config.longBreakDuration = sliderValue * 60
                    }
                }
            }

            Slider {
                width: parent.width
                minimumValue: 1.0
                maximumValue: 10.0
                stepSize: 1.0
                valueText: "%1 🍅".arg(value)
                label: qsTr("Long break after %n interval(s)", "", value)
                value: appWindow.config.longBreakAfter

                onSliderValueChanged: {
                    if (sliderValue !== appWindow.config.longBreakAfter) {
                        appWindow.config.longBreakAfter = sliderValue
                    }
                }
            }

            SectionHeader {
                text: qsTr("Notifications")
            }

            TextSwitch {
                text: qsTr("Enable notifications")
                description: qsTr("Show notifications when the current " +
                                  "interval is finished " +
                                  "and you may start the next interval.")
                checked: appWindow.config.enableNotifications
                onCheckedChanged: appWindow.config.enableNotifications = checked
            }

            TextSwitch {
                text: qsTr("Enable sounds")
                description: qsTr("Play an alarm sound when the current " +
                                  "interval is finished.") +
                             " " + qsTr("Note: make sure the device is not set to “mute”.")
                checked: appWindow.config.enableAudioFeedback
                onCheckedChanged: appWindow.config.enableAudioFeedback = checked
            }

            TextSwitch {
                id: switchEnableHaptic
                enabled: appWindow.haveFeedbackEffect && appWindow.haveRumbleEffect
                text: qsTr("Enable vibrations")
                description: qsTr("Vibrate the device when an interval starts " +
                                  "or the current interval is finished.")
                checked: appWindow.config.enableHapticFeedback
                onCheckedChanged: appWindow.config.enableHapticFeedback = checked
            }

            ComboBox {
                enabled: appWindow.config.enableHapticFeedback && switchEnableHaptic.enabled
                width: parent.width
                label: qsTr("Vibrations intensity")
                currentIndex: {
                    var value = appWindow.config.hapticIntensity
                    if (value >= 0.9) return 3
                    else if (value >= 0.7) return 2
                    else if (value >= 0.4) return 1
                    else if (value >= 0.2) return 0
                    else return 0
                }
                description: qsTr("It is advised to choose a low setting in quiet areas. " +
                                  "The medium setting is intended for busy environments " +
                                  "and concentrated work.")

                property bool isInitial: true
                onCurrentItemChanged: {
                    if (isInitial) {
                        isInitial = false
                        return
                    }

                    appWindow.rumbleDemo(currentItem.value)
                    appWindow.config.hapticIntensity = currentItem.value
                }

                menu: ContextMenu {
                    MenuItem { text: qsTr("Quiet"); property real value: 0.2 }
                    MenuItem { text: qsTr("Modest"); property real value: 0.4 }
                    MenuItem { text: qsTr("Medium"); property real value: 0.8 }
                    MenuItem { text: qsTr("Strong"); property real value: 1.0 }
                }
            }

            Label {
                enabled: appWindow.config.enableHapticFeedback && switchEnableHaptic.enabled
                opacity: enabled ? 1.0 : Theme.opacityLow
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Note: since SailfishOS 4.3, vibrations only work if " +
                           "the “Touchscreen vibration” setting in the system " +
                           "settings is enabled. This is a " +
                           '<a href="%1">known bug</a> and should hopefully be fixed ' +
                           "in the next version after SailfishOS 4.5.").
                    arg('https://forum.sailfishos.org/t/4-3-vibration-in-applications-' +
                        'including-hardware-tests-does-not-work/8920/7')
                color: Theme.secondaryHighlightColor
                linkColor: Theme.secondaryColor
                onLinkActivated: LinkHandler.openOrCopyUrl(link, qsTr("Bug report"))
            }

            Label {
                visible: !appWindow.haveFeedbackEffect || !appWindow.haveRumbleEffect
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Note: the haptic feedback module could not be initialized. " +
                           "This should not happen and most probably is a bug. " +
                           "Please report this problem to the author.")
                color: Theme.secondaryColor
            }

            SectionHeader {
                text: qsTr("General")
            }

            TextSwitch {
                text: qsTr("Keep the display on")
                description: qsTr("Make sure the display does " +
                                  "not turn off while you are working.")
                checked: appWindow.config.keepDisplayOn
                onCheckedChanged: appWindow.config.keepDisplayOn = checked
            }

            TextSwitch {
                text: qsTr("Use color icons")
                description: qsTr("Disable this option if you prefer " +
                                  "icons that fit more into the system " +
                                  "ambience.")
                checked: appWindow.config.useColorIcons
                onCheckedChanged: appWindow.config.useColorIcons = checked
            }

            Item {
                width: parent.width
                height: Theme.horizontalPageMargin
            }
        }
    }
}
