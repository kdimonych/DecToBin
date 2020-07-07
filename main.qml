import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    ColumnLayout{
        id: mainItem

        anchors.fill: parent
        anchors.margins: 32
        spacing: 10

        RowLayout{
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.maximumHeight: 48
            Layout.minimumHeight: 48

            spacing: 10

            InputField {
                id: inputField
                activeFocusOnTab: true
                Component.onCompleted: {
                    forceActiveFocus();
                }

                Layout.minimumHeight: 48
                Layout.maximumHeight: 48
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                Keys.onEnterPressed:  {mainItem.resultUpdate();}
                Keys.onReturnPressed:  {mainItem.resultUpdate();}
                validator: IntValidator{bottom: 0; top: 2147483647}
            }

            SubmitButton{
                id: button

                enabled: inputField.text.length > 0

                Layout.fillHeight: true
                Layout.minimumWidth: 100
                Layout.maximumWidth: 200
                Layout.alignment: Qt.AlignRight

                text: qsTr("To Binary")
                onClicked: {mainItem.resultUpdate();}
            }
        }


        Item{
            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
            Layout.fillWidth: true
            Layout.fillHeight: true

            Flickable {
                id: resultContainer
                anchors.fill: parent

                clip: true

                contentHeight: resultField.height; contentWidth:resultField.width

                Item{
                    id: resultField

                    width: firstEntity !== null ? firstEntity.width : 0
                    height: firstEntity !== null ? firstEntity.height : 0

                    Component{
                        id: entityComponent
                        ManualDevider{}
                    }

                    property ManualDevider firstEntity: null

                    function addSubEntity(parent, onDoneCb){
                        var onSubChildCreated = function (obj)
                        {
                            parent.done.connect(obj.doContinue);
                            if(!obj.isFinal)
                                obj.showPartial.connect(resultField.addSubEntity.bind(resultField, obj, onDoneCb));
                            else
                                onDoneCb();
                        }

                        parent.addChild(entityComponent, onSubChildCreated);
                    }

                    function onComponentComplaeteHandler(comp, onDoneCb)
                    {
                        if (comp.status === Component.Ready)
                        {
                            var obj = null;
                            obj = comp.createObject(resultField, {"devidendVal" : parseInt(inputField.text)});
                            if(obj !== null)
                            {
                                resultField.firstEntity = obj;
                                obj.doContinue();
                                if(!obj.isFinal)
                                    obj.showPartial.connect(resultField.addSubEntity.bind(resultField, obj, onDoneCb));
                                else
                                    onDoneCb();
                            }
                        }
                    }

                    function createFirstEntity(onDone)
                    {
                        var onDoneCb = function()
                        {
                            if(typeof onDone === "function")
                                onDone();
                        }

                        if (entityComponent.status === Component.Ready)
                            resultField.onComponentComplaeteHandler(entityComponent, onDoneCb);
                        else
                        {
                            var sigHandler = resultField.onComponentComplaeteHandler.bind(resultField, entityComponent, onDoneCb);
                            comp.statusChanged.connect(sigHandler);
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {}
                ScrollBar.horizontal: ScrollBar {}
            }
        }

        function resultUpdate()
        {
            if(resultField.firstEntity !== null)
            {
                resultField.firstEntity.destroy();
                resultField.firstEntity = null;
            }
            resultField.createFirstEntity(null);
        }
    }
}
