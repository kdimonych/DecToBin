import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RowLayout{
    id: root
    spacing: 0

    property int devidendVal: 0
    property int deviderVal: 2
    property int partialVal: Math.floor(root.devidendVal/root.deviderVal)
    property int substractedNumberVal: root.partialVal * root.deviderVal
    property int restVal: root.devidendVal - root.substractedNumberVal
    property bool isFinal: root.partialVal <= 1
    property int nextDeviderWidth: 0
    property int animationDuration: 300
    property bool continueAllowed: false

    property alias devidendColumnWidth: devidendColumn.width
    readonly property Item child: childEntity.item

    readonly property int nextDeviderX: {
        return root.x + resultContentColumn.x
    }

    readonly property int nextDeviderY: {
        return root.y + resultContentColumn.y
    }

    function doContinue(){
        root.continueAllowed = true;
        if(root.state === "waitForContinue")
        {
            animationTimer.nextStep();
            animationTimer.restart();
        }
    }

    function isCompleted(){
        return root.state === "done";
    }

    function isRedyToShowPartial(){
        return root.state === "showPartial"
                || root.state === "showSubstractedNumber"
                || root.state === "showRest"
                || root.isCompleted();
    }

    //signals
    signal showPartial()
    signal done()

    //protected properties
    property alias _devidendVisible: devidend.visible
    property alias _substractedNumberVisible: substractedNumber.visible
    property alias _restVisible: rest.visible
    property alias _devider: devider.visible
    property bool _partialVisible: false

    property var stateSequence: [
        "initial",
        "showDevidend",
        "waitForContinue",
        "showDevider",
        "showPartial",
        "showSubstractedNumber",
        "showRest",
        "done"
    ]

    state: "initial"
    onStateChanged: {
        if(state === "showPartial")
            root.showPartial();
        else if(state === "done")
            root.done();
    }

    property int nextStateIndex: 1

    Timer{
        id: animationTimer
        interval: 500
        repeat: false
        running: false

        function nextStep()
        {
            root.state = root.stateSequence[root.nextStateIndex];
            ++root.nextStateIndex;
        }

        onTriggered: {
            if(root.stateSequence[root.nextStateIndex] === "waitForContinue")
            {
                if(root.continueAllowed)
                    ++root.nextStateIndex; //skip step
                else
                {
                    animationTimer.nextStep();
                    return;
                }
            }
            animationTimer.nextStep();
            if(!root.isCompleted())
                animationTimer.restart();
        }
    }

    states: [
        State {
            name: "initial"
            PropertyChanges { target: root
                _devidendVisible: false
                _substractedNumberVisible: false
                _restVisible: false
                _devider: false
                _partialVisible: false
            }
            PropertyChanges { target: animationTimer; running: true; interval:0}
        },
        State {
            name: "showDevidend"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: false
                _restVisible: false
                _devider: false
                _partialVisible: false
            }
        },
        State {
            name: "waitForContinue"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: false
                _restVisible: false
                _devider: false
                _partialVisible: false
            }
        },
        State {
            name: "showDevider"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: false
                _restVisible: false
                _devider: true
                _partialVisible: false
            }
        },
        State {
            name: "showPartial"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: false
                _restVisible: false
                _devider: true
                _partialVisible: true
            }
        },
        State {
            name: "showSubstractedNumber"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: true
                _restVisible: false
                _devider: true
                _partialVisible: true
            }
        },
        State {
            name: "showRest"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: true
                _restVisible: true
                _devider: true
                _partialVisible: true
            }
        },
        State {
            name: "done"
            PropertyChanges { target: root
                _devidendVisible: true
                _substractedNumberVisible: true
                _restVisible: true
                _devider: true
                _partialVisible: true
            }
        }
    ]

    ColumnLayout{
        id: devidendColumn
        spacing:0
        Layout.alignment: Qt.AlignTop

        ColumnLayout{
            id: subtructionField
            spacing: 0

            Behavior on Layout.preferredWidth { SmoothedAnimation{velocity:  root.animationDuration;} }

            Text {
                id: devidend

                clip: true
                visible: false

                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 2
                Layout.minimumHeight: contentHeight
                Layout.minimumWidth: contentWidth

                text: root.devidendVal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight

                opacity: visible ? 1.0 : 0.0

                Behavior on opacity { PropertyAnimation {duration : root.animationDuration;} }
            }

            Rectangle{
                id: minus

                color: "black"
                Layout.alignment: Qt.AlignLeft
                Layout.preferredHeight: devidend.font.bold ? 2 : 1
                Layout.preferredWidth: devidend.font.pixelSize * 0.7
                Layout.rightMargin: visible ? devidend.width + Layout.leftMargin : 0
                Layout.leftMargin: visible ? 4 : 0

                visible: devidend.visible && substractedNumber.visible
                opacity: visible ? 1.0 : 0.0

                Behavior on Layout.rightMargin { SmoothedAnimation{velocity:  root.animationDuration;} }
                Behavior on Layout.leftMargin { SmoothedAnimation{velocity:  root.animationDuration;} }
                Behavior on opacity { PropertyAnimation {duration : root.animationDuration;} }
            }

            Text {
                id: substractedNumber
                clip: true

                Layout.alignment: Qt.AlignRight

                Layout.rightMargin: 2
                Layout.minimumHeight: contentHeight
                Layout.minimumWidth: contentWidth

                visible: false
                opacity: visible ? 1.0 : 0.0

                text: root.substractedNumberVal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight

                Behavior on opacity { PropertyAnimation {duration : root.animationDuration;} }
            }
        }

        Rectangle{
            id: devidentHDelimiter

            color: "black"
            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: visible ? devidendColumn.width : 0
            Layout.preferredHeight: 1

            visible: substractedNumber.visible && rest.visible
            opacity: visible ? 1.0 : 0.0

            Behavior on Layout.preferredWidth { SmoothedAnimation{velocity:  root.animationDuration;} }
        }

        Text {
            id: rest

            clip: true

            Layout.alignment: Qt.AlignRight

            Layout.rightMargin: 2
            Layout.minimumHeight: contentHeight
            Layout.minimumWidth: contentWidth

            visible: false
            opacity: visible ? 1.0 : 0.0

            text: root.restVal
            font.bold: true
            color: "red"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight

            Behavior on opacity { PropertyAnimation {duration : root.animationDuration;} }
        }
    }

    Rectangle{
        id: verticalDelimiter
        color: "black"
        Layout.preferredWidth: 1
        Layout.preferredHeight: visible ? Math.max (subtructionField.height, devisorColumn.height) : 0
        Layout.maximumHeight: Layout.preferredHeight
        Layout.leftMargin: 2
        Layout.alignment: Qt.AlignTop

        visible: devidend.visible && devider.visible
        opacity: visible ? 1.0 : 0.0

        Behavior on Layout.preferredHeight { SmoothedAnimation{velocity:  root.animationDuration;} }
    }

    ColumnLayout{
        id: resultContentColumn
        Layout.alignment:  Qt.AlignTop | Qt.AlignLeft
        spacing: 0

        ColumnLayout{
            id: devisorColumn

            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            spacing: 0

            Text {
                id: devider

                clip: true
                Layout.alignment: Qt.AlignRight

                Layout.preferredWidth: 16
                Layout.preferredHeight: contentHeight
                Layout.minimumHeight: contentHeight
                Layout.minimumWidth: contentWidth

                text: root.deviderVal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight

                visible: false
                opacity: visible ? 1.0 : 0.0

                Behavior on opacity { PropertyAnimation {duration : root.animationDuration;} }
            }

            Rectangle{
                id: deviderHDelimiter

                color: "black"
                Layout.alignment: Qt.AlignLeft
                Layout.preferredHeight: 1
                Layout.preferredWidth: visible ? Math.max(devisorColumn.width, root.nextDeviderWidth) : 0

                visible: devider.visible
                opacity: visible ? 1.0 : 0.0

                Behavior on Layout.preferredWidth { SmoothedAnimation{velocity:  root.animationDuration;} }
            }

            Text {
                id: partialValText

                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: contentHeight
                Layout.preferredWidth: visible ? contentWidth : 0

                width: contentWidth
                height: contentHeight
                color: "red"
                font.bold: true

                visible: root.isFinal && root._partialVisible
                opacity: visible ? 1.0 : 0.0
                text: root.partialVal

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                Behavior on opacity { PropertyAnimation {duration : root.animationDuration;} }
                Behavior on Layout.preferredWidth { SmoothedAnimation{velocity:  root.animationDuration;} }
            }
        }

        Item {
            id: loaderWrapper
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: (childEntity.item !== null) ?  childEntity.width : 0
            Layout.preferredHeight: (childEntity.item !== null) ?  childEntity.height : 0
            Layout.leftMargin:  (childEntity.item !== null) ? Math.max(devisorColumn.width - childEntity.item.devidendColumnWidth, 2) : 0

            Loader{
                id: childEntity
                active: !root.isFinal

                asynchronous: true

                onLoaded: {
                    if(status === Loader.Ready){
                        childEntity.item.devidendVal = root.partialVal;
                        root.nextDeviderWidth = Qt.binding(function () {return childEntity.item.devidendColumnWidth;});
                    }
                }

                Behavior on Layout.preferredWidth { SmoothedAnimation{velocity:  root.animationDuration;} }
            }
        }
    }

    function addChild(childComponent, doneCb)
    {
        var onDone = function(obj)
        {
            if(typeof doneCb === "function")
                doneCb(obj);
        }

        childEntity.sourceComponent = childComponent;
        childEntity.loaded.connect(function(){
            onDone(childEntity.item);
        });
    }
}
