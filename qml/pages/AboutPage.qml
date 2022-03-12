/*
 * This file is part of harbour-minidoro.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Mirian Margiani
 */

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import "../modules/Opal/About" as A

A.AboutPageBase {
    id: page

    appName: appWindow.appName
    appIcon: Qt.resolvedUrl("../images/harbour-minidoro.png")
    appVersion: APP_VERSION
    appRelease: APP_RELEASE
    description: qsTr("Minidoro is a minimalist Pomodoro® Technique timer helping to get things done.")

    // note: don't use qsTr() for names in real applications
    mainAttributions: ["2022 Mirian Margiani"]
    sourcesUrl: "https://github.com/ichthyosaurus/harbour-minidoro"
    // translationsUrl: "https://weblate.com/"
    // homepageUrl: "https://example.org/my/forum"

    licenses: A.License { spdxId: "GPL-3.0-or-later" }

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
            // Opal modules and other GPL software must be listed here.
            // All Opal modules provide an Attribution section to be copy-pasted.
            name: "Opal.About"
            entries: "2018-2022 Mirian Margiani"
            licenses: A.License { spdxId: "GPL-3.0-or-later" }
            sources: "https://github.com/Pretty-SFOS/opal-about"
            homepage: "https://github.com/Pretty-SFOS/opal"
        }
    ]

    // donations.text: donations.defaultTextCoffee
    // donations.services: [
    //     A.DonationService {
    //         name: "LiberaPay"
    //         url: "https://liberapay.com/"
    //     },
    //     A.DonationService {
    //         name: "Other Service"
    //         url: "https://example.org/"
    //     }
    // ]

    extraSections: [
        A.InfoSection {
            title: qsTr("How it works")
            smallPrint: qsTr("The Pomodoro® Technique is an extremely simple but efficient time management technique developed by Francesco Cirillo. " +
                             "The basic idea is it's simpler to concentrate on work for a relatively short period, keeping in mind you can take a rest or switch to another activity afterwards.<br>" +
                             "<li>· Split your work for 25 minute intervals, separated by short break periods.</li>" +
                             "<li>· In these 25 minute intervals try to focus on your work as much as possible, try to not distract yourself and to avoid other distractions.</li>" +
                             "<li>· After a 25 minute interval take a 5 minute break. During this break do any other activities except for the previous work.</li>" +
                             "<li>· Return to the work after the break.</li>" +
                             "<li>· Take a long break of about 10–30 minutes after every 4 work intervals.</li>" +
                             "<br>")
            buttons: [
                A.InfoButton {
                    text: qsTr("Website")
                    onClicked: page.openOrCopyUrl("https://francescocirillo.com/pages/pomodoro-technique")
                }
            ]
        },
        A.InfoSection {
            title: qsTr("Acknowledgments")
            smallPrint: qsTr("This app is modelled after Minidoro for Android by Yury Pavlov.")
        }
    ]

    // contributionSections: [
    //     A.ContributionSection {
    //         title: qsTr("Development")
    //         groups: [
    //             A.ContributionGroup {
    //                 title: qsTr("Programming")
    //                 entries: ["Mirian Margiani"]
    //             },
    //             A.ContributionGroup {
    //                 title: qsTr("Icon Design")
    //                 entries: ["Mirian Margiani", "Jolla"]
    //             }
    //         ]
    //     },
    //     A.ContributionSection {
    //         title: qsTr("Translations")
    //         groups: [
    //             A.ContributionGroup {
    //                 title: qsTr("English")
    //                 entries: ["Mirian Margiani"]
    //             },
    //             A.ContributionGroup {
    //                 title: qsTr("German")
    //                 entries: ["Mirian Margiani"]
    //             }
    //         ]
    //     }
    // ]
}