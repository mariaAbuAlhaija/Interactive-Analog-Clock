import QtQuick 2.15
import QtQuick.Layouts 1.15

import "./components/"

//* Main Window of the Analog Clock application
Window {
    visible: true
    width: 400
    height: 400
    title: "Interactive Analog Clock"
    color: "black"

    //* Properties to manage active hand and editing mode
    property string activeHand: "second"
    property var hours: null
    property var minutes: null
    property var seconds: null


    //* Main clock face design
    Rectangle {
        id: clockFace
        width: parent.width / 1.5
        height: parent.height / 1.5
        color: "#292929"
        radius: width / 2
        anchors.centerIn: parent

        //* Canvas for drawing hour marks
        Canvas {
            id: marksCanvas
            width: parent.width
            height: parent.height
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d"); //* Getting 2D drawing context
                var centerX = width / 2;
                var centerY = height / 2;
                var radius = Math.min(centerX, centerY) * 0.9;
                ctx.strokeStyle = "#ffffff";
                ctx.lineWidth = 3;
                ctx.beginPath(); //* Starting path for drawing
                for (var i = 0; i < 12; i++) {
                    var angle = (i - 3) * (Math.PI * 2) / 12; //* Calculating angle for each mark
                    var startX = centerX + Math.cos(angle) * (radius - 10); //* Starting X coordinate of the mark
                    var startY = centerY + Math.sin(angle) * (radius - 10); //* Starting Y coordinate of the mark
                    var endX = centerX + Math.cos(angle) * radius; //* Ending X coordinate
                    var endY = centerY + Math.sin(angle) * radius; //* Ending Y coordinate
                    ctx.moveTo(startX, startY); //* Moving to start position
                    ctx.lineTo(endX, endY); //* Drawing line to end position
                }
                ctx.stroke();
            }
        }

        //* Canvas for minute marks
        Canvas {
            id: marksCanvasMinutes
            width: parent.width
            height: parent.height
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                var centerX = width / 2;
                var centerY = height / 2;
                ctx.strokeStyle = "#C3D4E3";
                var radius = Math.min(centerX, centerY) * 0.9;
                ctx.beginPath();
                for (var i = 0; i < 60; i++) {
                    if(i % 5==0)
                       continue;
                    var angle = (i - 15) * (Math.PI * 2) / 60;
                    var startX = centerX + Math.cos(angle) * (radius - 10); //* Starting X coordinate of the mark
                    var startY = centerY + Math.sin(angle) * (radius - 10); //* Starting Y coordinate of the mark
                    var endX = centerX + Math.cos(angle) * radius; //* Ending X coordinate
                    var endY = centerY + Math.sin(angle) * radius; //* Ending Y coordinate
                     ctx.moveTo(startX, startY); //* Moving to start position
                     ctx.lineTo(endX, endY);  //* Drawing line to end position
                }
                ctx.stroke();
            }
        }

        //* Repeater for placing numerical hour indicators (1 to 12)
        Repeater {
             model: 12
                delegate: Text {
                    text: String(index + 1)
                    font.pixelSize: 16
                    color: "white"
                    rotation: 0
                     //* Calculating X and Y to position each number correctly around the clock face
                    x: clockFace.width / 2 + Math.cos(((index+1) - 3) * 2 * Math.PI / 12) * (clockFace.width / 2.1 - 30) - width / 2
                    y: clockFace.height / 2 + Math.sin(((index+1) - 3) * 2 * Math.PI / 12) * (clockFace.height / 2.1 - 30) - height / 2
                    }
        }

        //* Clock hands and mouse area interactions are defined similarly,
        //* with logic to handle rotation and active hand selection
        ClockHand {
                id: hourHand
                handType: "hour"
                handWidth: 6
                handHeight: clockFace.height * 0.2

        }

        ClockHand {
            id : minuteHand
            handType: "minte"
            handWidth: 4
            handHeight: clockFace.height * 0.3
            handColor: "black"
        }

        ClockHand {
            id : secondHand
            handType: "minte"
            handWidth: 2
            handHeight: 90
            handColor: "red"
        }

        MouseArea {
                   anchors.fill: parent
                   enabled:  !clockTimer.running
                   onPressed: {
                       activeHand = activeHand ===  "hour" ? "minute" : "hour" ;
                   }
                   onPositionChanged: {
                       if (mouse.buttons & Qt.LeftButton) {
                           let centerX = clockFace.width / 2;
                           let centerY = clockFace.height / 2;
                           let angleRadians = Math.atan2(mouseY - centerY, mouseX - centerX);
                           let angleDegrees = (angleRadians * 180 / Math.PI) + 90;

                           if (activeHand === "hour") {

                               hourHand.rotation = angleDegrees;
                               hours = Math.floor(hourHand.rotation / 30) % 12;

                           } else if (activeHand === "minute") {

                               minuteHand.rotation = angleDegrees;
                               minutes = Math.floor(minuteHand.rotation / 6) % 60;

                           }

                       }
                   }
               }

        Rectangle {
                width: 10
                height: 10
                color: "#C3D4E3"
                radius: width / 2
                anchors.centerIn: parent
        }

        //* This RowLayout at the bottom will contain two custom buttons for additional controls
        //* such as resetting or editing time.
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: -15
            spacing: 100

                CustomButton {
                    buttonLabel: "Reset"
                    buttonWidth: 26
                    buttonHeight: 116
                    buttonColor: "black"
                    borderColor: "#C3D4E3"
                    onButtonClicked:  {

                        var now = new Date();
                        hours = now.getHours();
                        minutes = now.getMinutes();
                    }
                }

                CustomButton {
                    buttonLabel:  clockTimer.running ? "Edit Time": "OK"
                    buttonWidth: 26
                    buttonHeight: 116
                    buttonColor: "#C3D4E3"
                    onButtonClicked:  {
                       clockTimer.running = !clockTimer.running
                    }}

                }
            }
        //* Timer that triggers every second to update the clock hands according to current time
        Timer {
            id: clockTimer
            interval: 1000
            repeat: true
            running: true
            onTriggered: updateClock()
        }

        //* Function to update clock hands based on current or specified time
        function updateClock() {

            var now = new Date();

            var hoursRotation = hours ?? now.getHours();
            var minutesRotation = minutes ?? now.getMinutes();
            var secondsRotation = seconds ?? now.getSeconds();


            hourHand.rotation = (hoursRotation % 12 + minutesRotation / 60) * 30;
            minuteHand.rotation = (minutesRotation + secondsRotation / 60) * 6; // 360 / 60 = 6
            secondHand.rotation = secondsRotation * 6; // 360 / 60 = 6
        }
}
