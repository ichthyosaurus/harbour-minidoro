/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import "modules/Opal/About"

ChangelogList {
    ChangelogItem {
        version: "1.2.0-1"
        date: "2025-08-17"
        paragraphs: [
            "- Added translations: Portuguese (Brazil)<br>" +
            "- Updated translations: Indonesian, Spanish, Turkish, Ukrainian<br>" +
            "- Note: the app now needs the \"Audio\" permission to play sound effects<br>" +
            "- Added a new timer that reminds you to start the next interval (note: change interval durations if you e.g. find yourself always needing a longer break)<br>" +
            "- Added a sound effect when an interval is started so you can start an interval without looking at the screen<br>" +
            "- Added a new sound effect when an interval is finished<br>" +
            "- Fixed inverted portrait orientation<br>" +
            "- Fixed missing whitespace next to counters<br>" +
            "- Fixed interval settings not being blocked while an interval is running<br>" +
            "- Fixed reset menu entry showing up when there is nothing to reset<br>" +
            "- Fixed start menu entry missing in the top menu (you can tap, pull up, or pull down to start an interval)<br>" +
            "- Fixed formatting negative time intervals (e.g. when working longer than planned)<br>" +
            "- Fixed haptic feedback on interval start/finish on Sailfish 4.6<br>" +
            "- Fixed note about broken haptic feedback on Sailfish 4.3 to 4.5 (fixed on 4.6)<br>" +
            "- Updated Opal modules and many translations"
        ]
    }
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
