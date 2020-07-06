import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RowLayout{
    id: root
    spacing: 0

    readonly property bool completed: root._childCompleted && root._completed

    readonly property int contentHeight: subtructionField.height
    readonly property int contentWidth: subtructionField.width

    property bool _completed: false
    property bool _childCompleted: false
    property int devidendVal: 0
    property int deviderVal: 2
    property int incomplatePartialVal: Math.floor(root.devidendVal/root.deviderVal)
    property int substractedNumberVal: root.incomplatePartialVal * root.deviderVal
    property int restVal: root.devidendVal - root.substractedNumberVal

    ColumnLayout{
        id: devidendColumn
        spacing:0

        ColumnLayout{
            id: subtructionField
            spacing: 0

            Layout.alignment: Qt.AlignRight

            Text {
                id: devidend

                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 2
                Layout.minimumHeight: contentHeight
                Layout.preferredHeight: contentHeight
                Layout.minimumWidth: contentWidth

                text: root.devidendVal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }

            Rectangle{
                id: minus

                color: "black"
                Layout.alignment: Qt.AlignLeft
                Layout.preferredHeight: devidend.font.bold ? 2 : 1
                Layout.preferredWidth: devidend.font.pixelSize * 0.7
                Layout.rightMargin: devidend.width + Layout.leftMargin
                Layout.leftMargin: 4

                visible: devidend.visible && substractedNumber.visible
                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { SmoothedAnimation{velocity: 200;} }
            }

            Text {
                id: substractedNumber

                Layout.alignment: Qt.AlignRight

                Layout.rightMargin: 2
                Layout.preferredHeight: contentHeight
                Layout.minimumHeight: contentHeight
                Layout.minimumWidth: contentWidth

                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { SmoothedAnimation{velocity: 200;} }

                text: root.substractedNumberVal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
        }

        Rectangle{
            id: devidentHDelimiter

            color: "black"
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            Behavior on width { SmoothedAnimation{velocity: 200;} }

            visible: substractedNumber.visible && rest.visible
            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { SmoothedAnimation{velocity: 200;} }
        }

        Text {
            id: rest

            Layout.alignment: Qt.AlignRight

            Layout.rightMargin: 2
            Layout.preferredHeight: contentHeight
            Layout.minimumHeight: contentHeight
            Layout.minimumWidth: contentWidth

            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { SmoothedAnimation{velocity: 200;} }

            text: root.restVal
            font.bold: true
            color: "red"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }
    }

    Rectangle{
        id: verticalDelimiter
        color: "black"
        Layout.preferredWidth: 1
        Layout.preferredHeight: subtructionField.height
        Layout.leftMargin: 2
        Layout.alignment: Qt.AlignTop

        Behavior on height { SmoothedAnimation{velocity: 200;} }
    }

    ColumnLayout{
        id: devisorColumn

        Layout.alignment:  Qt.AlignTop
        spacing: 0

        Text {
            id: devider

            Layout.alignment: Qt.AlignRight

            Layout.preferredWidth: 16
            Layout.preferredHeight: contentHeight
            Layout.minimumHeight: contentHeight
            Layout.minimumWidth: contentWidth

            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { SmoothedAnimation{velocity: 200;} }

            text: root.deviderVal
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }

        Rectangle{
            id: deviderHDelimiter

            color: "black"
            Layout.preferredHeight: 1
            Layout.fillWidth: true

            Behavior on width { SmoothedAnimation{velocity: 200;} }

            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { SmoothedAnimation{velocity: 200;} }
        }

        Component{
            id: simplePartialComponent

            Text {

                readonly property bool completed: true

                width: contentWidth
                height: contentHeight
                color: "red"
                font.bold: true

                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { SmoothedAnimation{velocity: 200;} }

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
        }

        Item {
            id: container
            //Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: devider.height
            Layout.minimumWidth: container.newWidth

            property int newWidth: devider.width
            property var object: null

            function destroyPreviousObject()
            {
                if(container.object !== null)
                {
                    container.newWidth = Qt.binding(function () { return devider.width;});
                    container.object.destroy();
                    container.object = null;
                }
            }

            function loadManualDevider()
            {
                var createObject = function (newComponent){
                    container.destroyPreviousObject();

                    container.object = newComponent.createObject(container, {
                        "devidendVal" : root.incomplatePartialVal
                    });
                    if(container.object !== null)
                    {
                        container.newWidth = Qt.binding(function () { return container.object.contentWidth;});
                        container.object.x = 0;
                    }
                }

                var newComponent = Qt.createComponent("ManualDevider.qml", Component.PreferSynchronous, container);
                if(newComponent.status === Component.Ready)
                    createObject(newComponent);
                else
                {
                    newComponent.statusChanged.connect(function(){
                        if(newComponent.status === Component.Ready)
                            createObject(newComponent);
                    });
                }
            }

            function loadPartial()
            {
                var createObject = function (newComponent){
                    container.destroyPreviousObject();
                    container.object = newComponent.createObject(container, {
                                                  "text" : root.incomplatePartialVal
                                              });
                    if(container.object !== null)
                    {
                        container.object.x = Qt.binding(function () { return Math.max(0, container.width - container.object.contentWidth);});
                    }
                }

                var newComponent = simplePartialComponent;
                if(newComponent.status === Component.Ready)
                    createObject(newComponent);
                else
                {
                    newComponent.statusChanged.connect(function(){
                        if(newComponent.status === Component.Ready)
                            createObject(newComponent);
                    });
                }
            }

            function showSubBit(){
                if(root.incomplatePartialVal > 1)
                    loadManualDevider();
                else
                    loadPartial();
            }

            Timer{
                id: startTimer
                interval: 80
                repeat: false
                running: true
                onTriggered: {
                    container.showSubBit();
                }
            }
        }
    }
}
