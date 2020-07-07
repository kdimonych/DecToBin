import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle{
    id: root
    activeFocusOnTab: false
    onActiveFocusChanged: {
        //pass input focus to the interrnal TextInput
        if(activeFocus)
            textInput.forceActiveFocus();
    }

    property color backgroundColor: "white"
    property color textColor: "black"
    property color selectedTextColor: root.backgroundColor
    property color selectionColor: "#0099ff"

    border.color: ColorTools.adjustLightness(root.backgroundColor, -0.2);
    border.width: 1

    property alias inputMask: textInput.inputMask
    property alias text: textInput.text
    property alias maximumLength: textInput.maximumLength
    property alias validator: textInput.validator

    MouseArea{
        id: ma

        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    TextInput {
        id: textInput
        anchors.fill: parent
        anchors.margins: root.border.width

        leftPadding: 16
        rightPadding: 16

        verticalAlignment: TextInput.AlignVCenter
        color: root.textColor
        selectedTextColor: root.selectedTextColor
        selectionColor: root.selectionColor
    }

    state: {
        if(!root.enabled)
            return "disabled";

        var result = "normal";

        if(ma.containsMouse)
            result = "hovered"
        else if(root.activeFocus)
            result = "active_focus"

        return result;
    }

    states: [
        State {
            name: "normal"
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: root
                border.color: ColorTools.adjustLightness(root.backgroundColor, -0.1);
                border.width: 2
            }
        },
        State {
            name: "active_focus"
            PropertyChanges {
                target: root
                border.color: ColorTools.adjustLightness(root.backgroundColor, -0.15);
                border.width: 2
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: root
                border.color: ColorTools.toWB(root.backgroundColor);
                border.width: 1
            }
            PropertyChanges {
                target: textInput
                color: ColorTools.toWB(root.textColor);
                selectedTextColor: ColorTools.toWB(root.selectedTextColor);
                selectionColor: ColorTools.toWB(root.selectionColor);
            }
        }
    ]
}
