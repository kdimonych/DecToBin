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



                contentHeight: result.childrenRect.height; contentWidth:result.childrenRect.width

                Loader{
                    id: result
                }

                Component{
                    id: resultComponent
                    ManualDevider{
                        //devidendVal:
                    }
                }

                ScrollBar.vertical: ScrollBar {}
                ScrollBar.horizontal: ScrollBar {}
            }
        }

        function resultUpdate()
        {
            result.sourceComponent = null
            result.sourceComponent = resultComponent;

            var setValue = function (){
                result.loaded.disconnect(setValue);
                result.item.devidendVal = parseInt(inputField.text);
            };

            if(result.status === Loader.Ready)
                setValue();
            else
                result.loaded.connect(setValue);

        }
    }
}
