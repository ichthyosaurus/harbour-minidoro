# This file is part of harbour-minidoro.
# SPDX-FileCopyrightText: 2022 Mirian Margiani
# SPDX-License-Identifier: GPL-3.0-or-later

# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-minidoro

CONFIG += sailfishapp

# Note: version number is configured in yaml
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"
include(libs/opal-cached-defines.pri)

QML_IMPORT_PATH += qml/modules

SOURCES += src/harbour-minidoro.cpp

DISTFILES += qml/harbour-minidoro.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/images/*.png \
    qml/modules/Opal/About/*.qml \
    qml/modules/Opal/About/private/*.qml \
    qml/modules/Opal/About/private/*.js \
    rpm/harbour-minidoro.changes.in \
    rpm/harbour-minidoro.changes.run.in \
    rpm/harbour-minidoro.spec \
    rpm/harbour-minidoro.yaml \
    translations/*.ts \
    harbour-minidoro.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-minidoro-de.ts
