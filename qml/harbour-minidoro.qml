/*
 * This file is part of harbour-minidoro.
 * SPDX-FileCopyrightText: 2022-2025 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0
import Nemo.KeepAlive 1.2
import QtMultimedia 5.0
import "pages"

import Opal.About 1.0 as A
import Opal.SupportMe 1.0 as M

ApplicationWindow {
    id: appWindow

    function notifyStart() {
        if (haveFeedbackEffect && _rumbleCount > 1) _feedbackEffect.play()
    }

    function showMessage(msg, details, timeout) {
        if (!!details) {
            notification.expireTimeout = (!!timeout ? timeout : 0)
            notification.summary = msg
            notification.body = details
            notification.previewSummary = msg
            notification.previewBody = details
        } else {
            notification.expireTimeout = (!!timeout ? timeout : 0)
            notification.summary = ''
            notification.body = ''
            notification.previewSummary = ''
            notification.previewBody = msg
        }

        notification.replacesId = -1
        notification.publish()
    }

    function rumbleDemo(intensity) {
        var count = 0
        if (intensity > 1) count = 4
        else count = Math.round(intensity * 10 / 2.5)

        if (haveRumbleEffect) {
            _multiTimer.laps = count
            _multiTimer.callback = function() { _rumbleEffect.start() }
            _multiTimer.start()
        }
    }

    function start(notify) {
        if (!!notify) {
            notifyStart()
        }

        _supervisor.restart()
        overdraftMilliseconds = 0
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
        var prefix = millis < 0 ? "-" : ""
        var absoluteMillis = Math.abs(millis)
        var seconds = Math.round(absoluteMillis/1000)
        var minutes = Math.floor(seconds/60)
        seconds = seconds % 60

        if (seconds < 10) seconds = "0%1".arg(seconds)
        else seconds = String(seconds)

        if (minutes < 10) minutes = "0%1".arg(minutes)
        else minutes = String(minutes)

        return "%1%2:%3".arg(prefix).arg(minutes).arg(seconds)
    }

    function formatRemainingTime() {
        // this is only needed if it is possible the change intervals while
        // timers are running
        /*if (appWindow.currentInterval - appWindow.timer.elapsed < 0) {
            // WARNING side effect!
            // TODO BUG the current interval is stopped correctly but
            // the next interval has the new duration of the current
            // (i.e. last) interval
            appWindow.timer.elapsed = 0
            _supervisor.stop()
            _supervisor.triggered()
        }*/

        return formatTime(appWindow.currentInterval - appWindow.timer.elapsed)
    }

    function formatAbsoluteInterval() {
        // format the current interval as absolute times,
        // e.g. ["10:00", "10:15"]

        var now = new Date()
        var then = new Date()
        var timeFormat = qsTr("h:mm", "time format, as in “10:15” without “o'clock”")

        then.setSeconds(then.getSeconds() + (currentInterval / 1000))

        now = now.toLocaleTimeString(Qt.locale(), timeFormat)
        then = then.toLocaleTimeString(Qt.locale(), timeFormat)

        return [now, then]
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

        if (config.enableNotifications) {
            var interval = formatAbsoluteInterval()

            if (timeStatus === timeStatusType.pause ||
                    timeStatus === timeStatusType.longPause) {
                var minutes = (timeStatus === timeStatusType.pause
                               ? config.breakDuration : config.longBreakDuration) / 60
                showMessage(qsTr("%n minute(s) break", "",
                                 Math.round(minutes)),
                            qsTr("Take a break until %1 o'clock.").
                            arg(interval[1]))
            } else {
                showMessage(qsTr("%n minute(s) of work", "",
                                 Math.round(config.workDuration / 60)),
                            qsTr("Work until %1 o'clock.").
                            arg(interval[1]))
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
        property bool useColorIcons: true
    }

    property int finishedIntervals: 0
    property int _finishedSinceLastLongBreak: 0
    property int starsCounted: 0
    property int circlesCounted: 0
    property int overdraftMilliseconds: 0

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
    property bool haveWallClock: wallClock != null
    property bool haveFeedbackEffect: _feedbackEffect != null
    property bool haveRumbleEffect: _rumbleEffect != null

    readonly property int currentInterval: {
        var newInterval = 0
        if (timeStatus === timeStatusType.work) {
            newInterval = config.workDuration
        } else if (timeStatus === timeStatusType.pause) {
            newInterval = config.breakDuration
        } else if (timeStatus === timeStatusType.longPause) {
            newInterval = config.longBreakDuration
        }

        return newInterval * 1000 // seconds -> milliseconds
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
        id: _overdraft
        interval: 1000
        running: !isRunning && finishedIntervals > 0
        repeat: true
        onTriggered: overdraftMilliseconds += interval
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

    Notification {
        id: notification
        expireTimeout: 4000
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

    A.ChangelogNews {
        changelogList: Qt.resolvedUrl("Changelog.qml")
    }

    M.AskForSupport {
        contents: Component {
            MySupportDialog {}
        }
    }

    Component.onCompleted: {
        // Extensions that are not crucial and are generally not allowed in
        // Jolla's Harbour store are loaded dynamically. The app will handle
        // it gracefully if loading fails.

        // Avoid hard dependency on Nemo.Time and load it in a complicated
        // way to make Jolla's validator script happy.
        wallClock = Qt.createQmlObject("
            import QtQuick 2.0
            import %1 1.0
            WallClock {
                enabled: Qt.application.active
                updateFrequency: WallClock.Minute
            }".arg("Nemo.Time"), appWindow, 'WallClock')

        // QtFeedback is not declared stable but may be allowed in Harbour.
        // Still, loading it dynamically may be safer because then breaking
        // the API does not break the whole app.
        // See: https://docs.sailfishos.org/Develop/Apps/Harbour/Allowed_APIs/#qtfeedback-hasnt-been-declared-stable-but-we-allow-a-restricted-part
        // Checked: 2025-08-17, 2022-03-13

        // This only works if "Touchscreen vibration" is enabled in system settings.
        // Checked: Sailfish 4.6, 4.3
        /*_feedbackEffect = Qt.createQmlObject("
            import QtQuick 2.0
            import QtFeedback 5.0
            ThemeEffect {
                effect: ThemeEffect.PressStrong
            }", appWindow, 'ThemeEffect')*/

        // This works even without "Touchscreen vibration" in system settings.
        // Checked: Sailfish 4.6
        _feedbackEffect = Qt.createQmlObject("
            import QtQuick 2.0
            import QtFeedback 5.0
            HapticsEffect {
                attackIntensity: 0.0
                attackTime: 0
                intensity: 1.0
                duration: 50
                fadeTime: 0
                fadeIntensity: 0.0
                period: 0

                function play() { start() }
            }", appWindow, 'RumbleEffect')

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
