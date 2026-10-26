// واجهتنا: الرف العائم + المشغّل.
// QML لغة وصفية: تكتب "ما تريد أن تراه" وليس "كيف ترسمه".

import Quickshell
import QtQuick

ShellRoot {
    id: root

    // هل قائمة المشغّل مفتوحة؟
    property bool launcherOpen: false

    // قائمة التطبيقات: n الاسم، l الحرف على الأيقونة، c اللون، cmd الأمر
    property var apps: [
        { n: "Terminal",  l: "T", c: "#4C7BDE", cmd: ["foot"] },
        { n: "Browser",  l: "W", c: "#E8714F", cmd: ["firefox-esr"] },
        { n: "Network",   l: "N", c: "#3FA77A", cmd: ["foot", "-e", "nmtui"] }
    ]

    // ساعة النظام: تتحدث كل دقيقة
    SystemClock { id: clock; precision: SystemClock.Minutes }

    // ───── الرف السفلي ─────
    PanelWindow {
        anchors { bottom: true; left: true; right: true }
        margins { bottom: 12; left: 14; right: 14 }   // هذا يخليه "عائم"
        implicitHeight: 52
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: height / 2                        // حواف دائرية بالكامل
            color: "#F4F6FB"

            // زر ابدأ: حلقة فاضية من الوسط
            Rectangle {
                width: 22; height: 22; radius: 11
                anchors.left: parent.left
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                border.width: 3
                border.color: "#4C7BDE"
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.launcherOpen = !root.launcherOpen
                }
            }

            // التطبيقات المثبتة في المنتصف
            Row {
                anchors.centerIn: parent
                spacing: 10
                Repeater {
                    model: root.apps
                    delegate: Rectangle {
                        required property var modelData
                        width: 30; height: 30; radius: 10
                        color: modelData.c
                        Text {
                            anchors.centerIn: parent
                            text: modelData.l
                            color: "white"
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(modelData.cmd)
                        }
                    }
                }
            }

            // الوقت على اليمين
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 76; height: 32; radius: 16
                color: "#E3E9F6"
                Text {
                    anchors.centerIn: parent
                    text: Qt.formatTime(clock.date, "hh:mm")
                    color: "#1F2433"
                    font.pixelSize: 13
                }
            }
        }
    }

    // ───── نافذة المشغّل ─────
    PanelWindow {
        visible: root.launcherOpen
        anchors { bottom: true; left: true }
        margins { bottom: 76; left: 14 }
        implicitWidth: 340
        implicitHeight: 220
        exclusionMode: ExclusionMode.Ignore           // لا تحجز مساحة من الشاشة
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: 22
            color: "#FFFFFF"

            Flow {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 4
                Repeater {
                    model: root.apps
                    delegate: Item {
                        required property var modelData
                        width: 76; height: 84
                        Rectangle {
                            id: icon
                            width: 44; height: 44; radius: 14
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 8
                            color: modelData.c
                            Text {
                                anchors.centerIn: parent
                                text: modelData.l
                                color: "white"
                                font.pixelSize: 18
                            }
                        }
                        Text {
                            anchors.top: icon.bottom
                            anchors.topMargin: 6
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.n
                            color: "#1F2433"
                            font.pixelSize: 12
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Quickshell.execDetached(modelData.cmd)
                                root.launcherOpen = false
                            }
                        }
                    }
                }
            }
        }
    }
}
