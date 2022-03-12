/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: 2022 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Reset")
                onDelayedClick: appWindow.reset()
            }
        }

        PushUpMenu {
            quickSelect: true
            enabled: !appWindow.isRunning

            MenuItem {
                text: qsTr("Start")
                onClicked: appWindow.notifyStart()
                onDelayedClick: appWindow.start()
            }
        }

        Column {
            id: column

            width: page.width
            height: page.height
            spacing: Theme.paddingLarge

            PageHeader {
                id: header

                Item {
                    anchors {
                        left: parent.left; right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    parent: header.extraContent
                    height: header.height

                    Label {
                        anchors {
                            right: parent.right
                            verticalCenter: intervalRow.verticalCenter
                        }
                        color: palette.highlightColor
                        text: appWindow.wallClock ? Format.formatDate(appWindow.wallClock.time, Formatter.TimeValue) : ''
                        font.pixelSize: Theme.fontSizeLarge
                    }

                    Row {
                        id: intervalRow
                        anchors {
                            verticalCenterOffset: 2*Theme.paddingMedium
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        height: page.orientation & Orientation.PortraitMask ?
                                    parent.height - 3*Theme.paddingMedium : parent.height - 1*Theme.paddingMedium

                        Label {
                            visible: appWindow.finishedIntervals >= 5
                            font {
                                pixelSize: Theme.fontSizeExtraLarge
                                bold: true
                                family: Theme.fontFamilyHeading
                            }
                            anchors {
                                verticalCenter: parent.verticalCenter
                                verticalCenterOffset: Theme.paddingSmall
                            }
                            color: palette.highlightColor
                            text: "%1 ✕".arg(appWindow.finishedIntervals)
                        }

                        Repeater {
                            model: appWindow.finishedIntervals < 5 ? appWindow.finishedIntervals : 1
                            delegate: HighlightImage {
                                height: parent.height
                                fillMode: Image.PreserveAspectFit
                                source: "../images/icon-tomato.png"
                                color: palette.highlightColor
                            }
                        }
                    }
                }
            }
        }

        Label {
            id: timerLabel
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            x: Theme.horizontalPageMargin
            y: page.height / 2 - height
            width: parent.width - 2*x

            highlighted: timerLabelMouse.containsPress

            color: {
                if (highlighted && appWindow.timeStatus === appWindow.timeStatusType.work) palette.highlightColor
                else if (highlighted) Qt.tint(palette.secondaryHighlightColor, appWindow.breakTintColor)
                else if (!appWindow.isRunning && appWindow.timeStatus === appWindow.timeStatusType.work) palette.primaryColor
                else if (!appWindow.isRunning) Qt.tint(palette.secondaryColor, appWindow.breakTintColor)
                else if (appWindow.timeStatus === appWindow.timeStatusType.work) palette.highlightColor
                else Qt.tint(palette.secondaryHighlightColor, appWindow.breakTintColor)
            }

            font {
                pixelSize: 2*Theme.fontSizeHuge
                family: Theme.fontFamilyHeading
                bold: true
            }

            text: formatRemainingTime()
        }

        MouseArea {
            // This mouse area only fills almost the whole screen. You can roughly tap anywhere
            // to start the timer but there is some distance to other interactive elements.
            id: timerLabelMouse
            enabled: !appWindow.isRunning
            anchors {
                top: column.top
                topMargin: header.height * 2
                bottom: counterRow.top
                bottomMargin: counterRow.height
                left: parent.left
                right: parent.right
            }

            onClicked: {
                appWindow.notifyStart()
                appWindow.start()
            }
        }

        Label {
            id: statusTextLabel
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            anchors {
                top: timerLabel.bottom
                topMargin: Theme.paddingLarge
            }
            color: appWindow.timeStatus === appWindow.timeStatusType.work ?
                       palette.secondaryHighlightColor :
                       Qt.tint(palette.secondaryHighlightColor, appWindow.breakTintColor)
            font {
                pixelSize: Theme.fontSizeHuge
                family: Theme.fontFamilyHeading
                bold: false
            }

            text: appWindow.timeStatusText
        }


        Item {
            id: counterRow

            anchors {
                bottom: parent.bottom
                bottomMargin: Theme.horizontalPageMargin + 2*Theme.paddingMedium
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }
            height: header.height

            MouseArea {
                enabled: appWindow.isRunning
                width: childrenRect.width
                height: parent.height
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                opacity: enabled ? 1.0 : Theme.opacityHigh
                onClicked: appWindow.starsCounted += 1
                onPressAndHold: if (appWindow.starsCounted > 0) appWindow.starsCounted -= 1

                HighlightImage {
                    id: starImage
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../images/icon-star.png"
                    highlightColor: palette.highlightColor
                    color: parent.enabled ? palette.primaryColor : palette.secondaryHighlightColor
                    highlighted: parent.containsPress
                    opacity: Theme.opacityHigh
                }

                Label {
                    font {
                        pixelSize: Theme.fontSizeExtraLarge
                        bold: true
                        family: Theme.fontFamilyHeading
                    }
                    anchors {
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.paddingMedium
                        left: starImage.right
                    }
                    color: parent.enabled ? (highlighted ? palette.highlightColor : palette.primaryColor) : palette.secondaryHighlightColor
                    highlighted: parent.containsPress
                    text: "✕%1".arg(appWindow.starsCounted)
                }
            }

            MouseArea {
                enabled: appWindow.isRunning
                width: childrenRect.width
                height: parent.height
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                opacity: enabled ? 1.0 : Theme.opacityHigh
                onClicked: appWindow.circlesCounted += 1
                onPressAndHold: if (appWindow.circlesCounted > 0) appWindow.circlesCounted -= 1

                Label {
                    id: circleLabel
                    font {
                        pixelSize: Theme.fontSizeExtraLarge
                        bold: true
                        family: Theme.fontFamilyHeading
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    color: parent.enabled ? (highlighted ? palette.highlightColor : palette.primaryColor) : palette.secondaryHighlightColor
                    highlighted: parent.containsPress
                    text: "%1 ✕".arg(appWindow.circlesCounted)
                }

                HighlightImage {
                    anchors {
                        leftMargin: Theme.paddingMedium
                        left: circleLabel.right
                        verticalCenter: parent.verticalCenter
                    }
                    source: "../images/icon-circle.png"
                    highlightColor: palette.highlightColor
                    color: parent.enabled ? palette.primaryColor : palette.secondaryHighlightColor
                    highlighted: parent.containsPress
                    opacity: Theme.opacityHigh
                }
            }
        }
    }
}
