import QtQuick 2.0

Item {
    id: clockHand

    property string handType: ""
    property real handWidth: 0
    property real handHeight: 0
    property string handColor: "black"

    width: parent.width
    height: parent.height

    Rectangle {
        id: handId
        width: handWidth
        height: handHeight
        color: handColor
        anchors.bottom: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        transformOrigin: Item.Bottom
        radius: width / 2
    }


}
