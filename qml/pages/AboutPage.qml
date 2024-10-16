/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: 2022-2023 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/*
 * Translators:
 * Please add yourself to the list of translators in TRANSLATORS.json.
 * If your language is already in the list, add your name to the 'entries'
 * field. If you added a new translation, create a new section in the 'extra' list.
 *
 * Other contributors:
 * Please add yourself to the relevant list of contributors below.
 *
*/

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A

A.AboutPageBase {
    id: root

    appName: appWindow.appName
    appIcon: Qt.resolvedUrl("../images/%1.png".arg(Qt.application.name))
    appVersion: APP_VERSION
    appRelease: APP_RELEASE

    allowDownloadingLicenses: false
    sourcesUrl: "https://github.com/ichthyosaurus/%1".arg(Qt.application.name)
    homepageUrl: "https://forum.sailfishos.org/t/apps-by-ichthyosaurus/15753"
    translationsUrl: "https://hosted.weblate.org/projects/%1".arg(Qt.application.name)
    changelogList: Qt.resolvedUrl("../Changelog.qml")
    licenses: A.License { spdxId: "GPL-3.0-or-later" }

    donations.text: donations.defaultTextCoffee
    donations.services: [
        A.DonationService {
            name: "Liberapay"
            url: "https://liberapay.com/ichthyosaurus"
        }
    ]

    description: qsTr("Minidoro is a minimalist Pomodoro® Technique " +
                      "timer helping to get things done.")
    mainAttributions: ["2022-%1 Mirian Margiani".arg((new Date()).getFullYear())]
    autoAddOpalAttributions: true

    attributions: [
        A.Attribution {
            name: "Minidoro for Android"
            entries: ["used as inspiration", "2021 Yury Pavlov"]
            licenses: A.License { spdxId: "MIT" }
            homepage: "https://f-droid.org/en/packages/com.github.ympavlov.minidoro"
            sources: "https://github.com/ympavlov/minidoro"
        },
        A.Attribution {
            name: "Saildoro"
            entries: ["used as inspiration", "2016 Petr Vytovtov"]
            licenses: A.License { spdxId: "GPL-3.0-or-later" }
            homepage: "https://openrepos.net/content/osanwe/saildoro"
            sources: "https://github.com/osanwe/saildoro"
        },
        A.Attribution {
            name: "Noto Color Emoji"
            entries: ["Google", "tomato icon adapted by Mirian Margiani"]
            licenses: A.License { spdxId: "OFL-1.1" }
            homepage: "https://fonts.google.com/noto/specimen/Noto+Emoji"
        }
    ]

    extraSections: [
        A.InfoSection {
            title: qsTr("How it works")
            smallPrint: qsTr(
                "The Pomodoro® Technique is an extremely simple but efficient " +
                "time management technique developed by Francesco Cirillo. " +
                "The basic idea is it's simpler to concentrate on work for a " +
                "relatively short period, keeping in mind you can take a rest or " +
                "switch to another activity afterwards.<br>" +
                "<li>· Split your work for 25 minute intervals, " +
                    "separated by short break periods.</li>" +
                "<li>· In these 25 minute intervals try to focus on " +
                    "your work as much as possible, try to not distract yourself " +
                    "and to avoid other distractions.</li>" +
                "<li>· After a 25 minute interval take a 5 minute break. " +
                    "During this break do any other activities except for " +
                    "the previous work.</li>" +
                "<li>· Return to the work after the break.</li>" +
                "<li>· Take a long break of about 10–30 minutes after " +
                    "every 4 work intervals.</li>" +
                "<br>")
            buttons: [
                A.InfoButton {
                    text: qsTr("Website")
                    onClicked: root.openOrCopyUrl(
                        "https://francescocirillo.com/" +
                        "pages/pomodoro-technique")
                }
            ]
        },
        A.InfoSection {
            title: qsTr("Counters")
            smallPrint: qsTr("There are two counters at the bottom of the main page. " +
                "For example, you can use the left counter (star) to count " +
                "external interruptions, i.e. someone interrupting you. " +
                "Then use the right counter (circle) to count internal interruptions, " +
                "i.e. how often you interrupt yourself. " +
                "You can also use one counter to keep track of ideas you have " +
                "while working that are not relevant for your current task. " +
                "In the break, you can then take a note for each idea you counted."
            )
        },
        A.InfoSection {
            title: qsTr("Acknowledgments")
            smallPrint: qsTr("This app is modelled after Minidoro for " +
                             "Android by Yury Pavlov.")
        }
    ]

    contributionSections: [
        A.ContributionSection {
            title: qsTr("Development")
            groups: [
                A.ContributionGroup {
                    title: qsTr("Programming")
                    entries: ["Mirian Margiani"]
                },
                A.ContributionGroup {
                    title: qsTr("Icon Design")
                    entries: ["Mirian Margiani", "Google"]
                }
            ]
        },

        //>>> GENERATED LIST OF TRANSLATION CREDITS
        //<<< GENERATED LIST OF TRANSLATION CREDITS
    ]
}
