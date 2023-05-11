import QtQuick 2.12
import QtQuick.Window 2.12

import Ros 1.0
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

import "RAFv1.js" as GUI

Window {
    id: window
//    width: 1280       // Macbook fullscreen
//    height: 720
    width: 1920 / GUI.scale     // Monitor is 1920 x 1080
    height: 1080 / GUI.scale
    visible: true
    title: qsTr("Robot-Assisted Feeding v1")

    Rectangle {
        property double mousePosX: 0
        property double mousePosY: 0

        id: screen
        width: 1920 / GUI.scale
        height: 1080 / GUI.scale
        //width: parent.width
        //height: parent.height
        color: "#1a6850"
        state: "StartScreen"


        MouseArea {
            id: screen_MouseArea
            hoverEnabled: true
            anchors.fill: parent
            onPositionChanged: {
//              var globalPosition = mapToGlobal(mouse.x, mouse.y)
                var screenPosition = mapToItem(screen, mouse.x, mouse.y)
                screen.mousePosX = screenPosition.x
                screen.mousePosY = screenPosition.y
            }
          }

        SystemPalette { id: activePalette }

        Item {
            id: item_logo
            width: screen.width / 2
            height: screen.height / 1.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors { top: parent.top; }

            Image {
                id: chms_logo
                anchors.fill: parent
                source: "images/chms_logo.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            id: item_titleText
            width: titleText.width
            height: titleText.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: item_logo.bottom
            anchors.topMargin: 30 / GUI.scale

            Text {
                id: titleText
                width: screen.width
                color: "#ffffff"
                text: qsTr("Robot-Assisted Self-Feeding for Individuals with Spinal Cord Injury")
                font.pixelSize: 32
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Item {
            id: item_logoSmall
            width: screen.width / 10
            height: screen.height / 6
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: -10 / GUI.scale
            anchors.rightMargin: 30 / GUI.scale

            Image {
                id: chms_logoSmall
                anchors.fill: parent
                source: "images/chms_logo.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        RosStringSubscriber{
                id: raf_message_subscriber
                topic: "raf_message"
        }

        RosStringSubscriber{
                id: cursor_angle
                topic: "raf_cursor_angle"
        }

        Item {
            id: item_objectsHeader
            width: item_objects.width
            height: objectsText.height
            anchors.bottom: item_objects.top
            anchors.horizontalCenter: item_objects.horizontalCenter
            anchors.bottomMargin: 10 / GUI.scale

            Text {
                id: objectsText
                width: parent.width
                color: "#ffffff"
                text: raf_message_subscriber.text
                font.pixelSize: 36
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.right: parent.right
            }
        }

        Item {
            id: item_objects
            width: screen.width / 1.6
            height: width * 0.75
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100 / GUI.scale

            Image {
                id: armCamera
                cache: false
                anchors.fill: parent
                source: "image://rosimage/raf_visualization"
                fillMode: Image.PreserveAspectFit

                Timer {
                    interval: 50
                    repeat: true
                    running: true
                    //onTriggered: { armCamera.source = ""; armCamera.source = "image://rosimages/camera2/color/image_raw" }
                    onTriggered: { armCamera.source = ""; armCamera.source = "image://rosimage/raf_visualization" }
                }
            }
        }

        Item {
            id: estop
            x: 1680
            y: 800
            width: 200
            height: 200
            property bool hoverDisabled: false

            Image {
                id: stop_sign
                anchors.fill: parent
//                source: "images/stop_sign.png"
                source: ma.containsMouse ? "images/stop_sign_highlight.png" : "images/stop_sign.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    id: ma
                    enabled: !estop.hoverDisabled
                    hoverEnabled: true
                    anchors.fill: parent
                    onPositionChanged: {
//                        var globalPosition = mapToGlobal(mouse.x, mouse.y)
                        var screenPosition = mapToItem(screen, mouse.x, mouse.y)
                        screen.mousePosX = screenPosition.x
                        screen.mousePosY = screenPosition.y
                    }
                }
            }
        }

        StartButton {
            id: startButton
            text: "Click Here to Start"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 180 / GUI.scale
            anchors.horizontalCenter: parent.horizontalCenter
//            onClicked: console.log("Start Button Pressed")

            Connections {
                target: startButton
                //onClicked: screen.state = "State1"
                function onClicked(mouse) { screen.state = "SelectFoodItem" }
            }
        }

        BackButton {
            id: backButton
            text: "Back"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20 / GUI.scale
            anchors.topMargin: 20 / GUI.scale

            Connections {
                target: backButton
                //onClicked: screen.state = "State1"
                function onClicked(mouse) { screen.state = "StartScreen" }
            }
        }

        Cursor {
            id: cursor
            x: screen.mousePosX - (width / 2)
            y: screen.mousePosY - (height / 2)
            angle: parseFloat(cursor_angle.text)
        }


        states: [
            State {
                name: "StartScreen"

                PropertyChanges {
                    target: item_logoSmall
                    visible: false
                }

                PropertyChanges {
                    target: item_objects
                    visible: false
                }

                PropertyChanges {
                    target: item_objectsHeader
                    visible: false
                }

                PropertyChanges {
                    target: backButton
                    visible: false
                }

                PropertyChanges {
                    target: estop
                    visible: false
                }
            },
            State {
                name: "SelectFoodItem"

                PropertyChanges {
                    target: item_logo
                    visible: false
                }

                PropertyChanges {
                    target: item_titleText
                    visible: false
                }

                PropertyChanges {
                    target: startButton
                    visible: false
                }

                PropertyChanges {
                    target: estop
                    visible: true
                }
            }
        ]
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
