/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: 2022 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.KeepAlive 1.2
import QtMultimedia 5.0
import "pages"

ApplicationWindow {
    id: appWindow

    // TODO: implement notifications
    // TODO: finish about page, update description, update acknowledgments
    // FIXME: don't run rumbleDemo() immediately when entering the settings page

    function notifyStart() {
        if (_feedbackEffect && _rumbleCount > 1) _feedbackEffect.play()
    }

    function rumbleDemo(intensity) {
        var count = 0
        if (intensity > 1) count = 4
        else count = Math.round(intensity * 10 / 2.5)

        if (count > 1 && _feedbackEffect) _feedbackEffect.play()

        if (_rumbleEffect) {
            _multiTimer.laps = count
            _multiTimer.callback = function() { _rumbleEffect.start() }
            _multiTimer.start()
        }
    }

    function start() {
        _supervisor.restart()
    }

    function reset() {
        _supervisor.stop()
        finishedIntervals = 0
        circlesCounted = 0
        starsCounted = 0
        _finishedSinceLastLongBreak = 0
        timeStatus = timeStatusType.work
    }

    function formatTime(millis) {
        var seconds = Math.round(millis/1000)
        var minutes = Math.floor(seconds/60)
        seconds = seconds % 60

        if (seconds < 10) seconds = "0%1".arg(seconds)
        else seconds = String(seconds)

        if (minutes < 10) minutes = "0%1".arg(minutes)
        else minutes = String(minutes)

        return "%1:%2".arg(minutes).arg(seconds)
    }

    function formatRemainingTime() {
        return formatTime(appWindow.currentInterval - appWindow.timer.elapsed)
    }

    function _updateStatus() {
        if (config.enableAudioFeedback) {
            alarm.play()
        }

        if (config.enableHapticFeedback && _rumbleEffect) {
            _multiTimer.laps = _rumbleCount
            _multiTimer.callback = function() { _rumbleEffect.start() }
            _multiTimer.start()
        }

        if (timeStatus === timeStatusType.longPause) {
            _finishedSinceLastLongBreak = 0
            timeStatus = timeStatusType.work
        } else if (timeStatus === timeStatusType.pause) {
            timeStatus = timeStatusType.work
        } else {
            finishedIntervals += 1
            _finishedSinceLastLongBreak += 1

            if (_finishedSinceLastLongBreak === 3) {
                timeStatus = timeStatusType.longPause
            } else {
                timeStatus = timeStatusType.pause
            }
        }
    }

    property ConfigurationGroup config: ConfigurationGroup {
    // property QtObject config: QtObject {  // mock for debugging
        path: "/apps/harbour-minidoro"
        property int workDuration: 15*60
        property int breakDuration: 5*60
        property int longBreakDuration: 15*60
        property int longBreakAfter: 3
        property bool enableAudioFeedback: true
        property bool enableHapticFeedback: true
        property bool enableNotifications: true
        property real hapticIntensity: 0.8
        property bool keepDisplayOn: true
    }

    property int finishedIntervals: 0
    property int _finishedSinceLastLongBreak: 0
    property int starsCounted: 0
    property int circlesCounted: 0

    property Timer timer: Timer {
        property int elapsed: 0
        onRunningChanged: elapsed = 0

        interval: 1000
        running: _supervisor.running
        repeat: true
        onTriggered: elapsed += interval
    }

    property color breakTintColor: "#6000ff00"
    property bool isRunning: _supervisor.running

    readonly property int currentInterval: {
        var newInterval = 0
        if (timeStatus === timeStatusType.work) {
            newInterval = config.workDuration
        } else if (timeStatus === timeStatusType.pause) {
            newInterval = config.breakDuration
        } else if (timeStatus === timeStatusType.longPause) {
            newInterval = config.longBreakDuration
        }

        return newInterval * 1000 // minutes -> milliseconds
    }

    property int timeStatus: timeStatusType.work
    readonly property string timeStatusText: {
        if (timeStatus === timeStatusType.work) qsTr("Work")
        else if (timeStatus === timeStatusType.pause) qsTr("Break")
        else if (timeStatus === timeStatusType.longPause) qsTr("Long Break")
        else ""
    }

    property QtObject timeStatusType: QtObject {
        property int work: 1
        property int pause: 2  // "pause" because "break" is a keyword
        property int longPause: 3
    }

    property QtObject _feedbackEffect
    property QtObject _rumbleEffect
    readonly property int _rumbleCount: {
        if (config.hapticIntensity > 1) return 4
        else return Math.round(config.hapticIntensity * 10 / 2.5)
    }

    property QtObject wallClock
    readonly property string appName: qsTr("Minidoro")

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All

    Timer {
        id: _supervisor
        interval: currentInterval
        running: false
        repeat: false
        onTriggered: _updateStatus()
    }

    Timer {
        id: _multiTimer
        property int laps: 3
        property int _lapsDone: 0
        property var callback: function() {}
        interval: 500
        repeat: true
        running: false

        triggeredOnStart: true
        onTriggered: {
            _lapsDone += 1

            if (_lapsDone > laps) {
                repeat = false
                running = false
                _lapsDone = 0
            } else {
                repeat = true
                callback()
            }
        }
    }

    DisplayBlanking {
        preventBlanking: config.keepDisplayOn
    }

    KeepAlive {
        // required to keep timers running
        enabled: true
    }

    Audio {
        id: alarm
        source: "/usr/share/sounds/jolla-ringtones/stereo/jolla-calendar-alarm.ogg"
    }

    Component.onCompleted: {
        // avoid hard dependency on Nemo.Time
        wallClock = Qt.createQmlObject("
            import QtQuick 2.0
            import Nemo.Time 1.0
            WallClock {
                enabled: Qt.application.active
                updateFrequency: WallClock.Minute
            }", appWindow, 'WallClock')

        if (config.enableHapticFeedback) {
            _feedbackEffect = Qt.createQmlObject("
                import QtQuick 2.0
                import QtFeedback 5.0
                ThemeEffect {
                    effect: ThemeEffect.PressStrong
                }", appWindow, 'ThemeEffect')
        }

        _rumbleEffect = Qt.createQmlObject("
            import QtQuick 2.0
            import QtFeedback 5.0
            HapticsEffect {
                attackIntensity: 0.0
                attackTime: 250
                intensity: 1.0
                duration: 400
                fadeTime: 250
                fadeIntensity: 0.0
                period: 1000
            }", appWindow, 'RumbleEffect')
    }
}
