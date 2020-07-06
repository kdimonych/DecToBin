import QtQuick 2.12
import QtQuick.Controls 2.12

AbstractButton {
    id: root
    objectName: "SubsmitButton"

    property double colorLightnessShiftRatio: 0.0
    property color foregroundColor: "white"
    property color backgroundColor: "#39d756"
    property color textColor: "white"

    property color implicitForegroundColor: root.foregroundColor
    property color implicitBackgroundColor:ColorTools.adjustLightness(root.backgroundColor, root.colorLightnessShiftRatio)

    background: Rectangle {
        id: bg

        color: root.implicitBackgroundColor
        border.color: ColorTools.adjustLightness(bg.color, -0.15)
        border.width: 2
    }

    contentItem: Text {
        id: caption
        text: root.text
        color: root.foregroundColor

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: root.font
    }

    state: {
        if(!root.enabled)
            return "disabled";

        var state = "normal";
        if(root.down)
            state = "down";
        else if(root.hovered)
            state = "hovered";
        else if(root.activeFocus)
            state = "active_focus";
        return state;
    }
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: root
                colorLightnessShiftRatio: 0.0
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: root
                colorLightnessShiftRatio: 0.25
            }
        },
        State {
            name: "active_focus"
            PropertyChanges {
                target: root
                colorLightnessShiftRatio: 0.15
            }
        },
        State {
            name: "down"
            PropertyChanges {
                target: root
                colorLightnessShiftRatio: -0.1
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: root
                colorLightnessShiftRatio: 0.0
                implicitForegroundColor: ColorTools.toWB(root.foregroundColor);
                implicitBackgroundColor:ColorTools.toWB(root.backgroundColor);
            }
        }
    ]
}
