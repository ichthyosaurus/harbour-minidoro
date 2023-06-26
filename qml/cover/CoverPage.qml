/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: 2022 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        anchors.centerIn: parent
        width: parent.width
        spacing: Theme.paddingMedium

        Label {
            font.pixelSize: Theme.fontSizeHuge
            text: appWindow.formatRemainingTime()
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            color: {
                if (!appWindow.isRunning && appWindow.timeStatus === appWindow.timeStatusType.work) palette.secondaryHighlightColor
                else if (!appWindow.isRunning) Qt.tint(palette.secondaryHighlightColor, appWindow.breakTintColor)
                else if (appWindow.timeStatus === appWindow.timeStatusType.work) palette.secondaryColor
                else Qt.tint(palette.secondaryColor, appWindow.breakTintColor)
            }
        }

        Label {
            font.pixelSize: Theme.fontSizeLarge
            text: appWindow.timeStatusText
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            color: appWindow.timeStatus === appWindow.timeStatusType.work ?
                       palette.secondaryHighlightColor :
                       Qt.tint(palette.secondaryHighlightColor, appWindow.breakTintColor)
        }
    }


    CoverActionList {
        id: coverAction
        enabled: !appWindow.isRunning

        CoverAction {
            iconSource: "image://theme/icon-cover-play"
            onTriggered: appWindow.start(true)
        }
    }
}
