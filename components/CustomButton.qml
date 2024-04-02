import QtQuick 2.0

Item {


    signal buttonClicked()

    property real buttonHeight: 0
    property real buttonWidth: 0
    property string buttonColor: "white"
    property string borderColor: ""
    property string buttonLabel: ""


    Rectangle {
        width: buttonHeight
        height: buttonWidth
        color: buttonColor
        border.color: borderColor ?? buttonColor

        Text {
            id: label
            anchors.centerIn: parent
            text: buttonLabel
            color: borderColor ?? "black"
        }
        MouseArea {
            anchors.fill: parent
            onClicked:  buttonClicked()
        }
    }

}
