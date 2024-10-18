/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import "modules/Opal/About"

ChangelogList {
    ChangelogItem {
        version: "1.1.0-1"
        date: "2024-10-18"
        paragraphs: [
            "- Updated translations: Chinese (Simplified), Estonian, German, Russian, Swedish, Ukrainian<br>" +
            "- Added a shiny support page asking for donations and contributions, and an in-app changelog<br>" +
            "- Added a new sailfishy tomato icon with an option to choose either a monochrome or colorful version<br>" +
            "- Added notifications telling you when you should take a break<br>" +
            "- Added a remorse timer when choosing \"reset\" from the pulley menu<br>" +
            "- Added a note explaining broken vibration settings which may or may not work again with Sailfish 4.6<br>" +
            "- Fixed missing translations so that all available translations are actually shippped!<br>" +
            "- Fixed time in interval descriptions<br>" +
            "- Fixed negative interval times that could happen after changing the interval while the timer was running<br>" +
            "- Improved settings descriptions<br>" +
            "- Updated Opal modules, packaging stuff, and general maintenance"
        ]
    }
    ChangelogItem {
        version: '1.0.0-1'
        date: "2022-03-30"
        paragraphs: [
            'Initial release.'
        ]
    }
}
