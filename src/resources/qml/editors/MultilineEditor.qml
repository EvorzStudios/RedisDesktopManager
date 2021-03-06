import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import "./formatters/formatters.js" as Formatters

ColumnLayout
{
    id: root
    property alias text: textArea.originalText
    property alias binaryArray: textArea.binaryArray
    property alias enabled: textArea.enabled
    property alias textColor: textArea.textColor
    property alias style: textArea.style
    property bool showFormatters: true

    function getText() {
        return textArea.formatter.getRaw(textArea.text)
    }

    RowLayout{
        visible: showFormatters

        Text {
            text: "Value:"
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: "View value as:"
        }

        ComboBox {
            id: formatterSelector
            width: 200
            model: ListModel {
                id: formattersModel
                ListElement { text: "Plain Text"; formatter: "plain" }
                ListElement { text: "HEX (read-only)"; formatter: "hex" }
                ListElement { text: "JSON"; formatter: "json" }
                ListElement { text: "MSGPACK"; formatter: "msgpack" }
                ListElement { text: "PHP Serializer"; formatter: "php-serialized" }                                                
            }

            onCurrentIndexChanged: {
                Formatters.defaultFormatter = currentIndex
                console.log("APP ROOT: " + Formatters.defaultFormatter)
            }

            Component.onCompleted: {
                currentIndex = Formatters.defaultFormatter                
            }
        }
    }

    TextArea
    {
        id: textArea
        Layout.fillWidth: true        
        Layout.fillHeight: true
        Layout.preferredHeight: 100        
        textFormat: formatter.readOnly? TextEdit.RichText : TextEdit.PlainText
        readOnly: formatter.readOnly

        text: {
            var currentFormatter = formattersModel.get(formatterSelector.currentIndex).formatter
            if (currentFormatter === "msgpack" || currentFormatter === "hex") {
                console.log('Binary array:', binaryArray)
                console.log('Current formatter:', currentFormatter)
                var formatted = binaryArray? formatter.getFormatted(binaryArray) : ''                
                return formatted
            } else {
                return formatter.getFormatted(originalText)
            }
        }
        property string originalText
        property var binaryArray
        property var formatter: Formatters.get(formattersModel.get(formatterSelector.currentIndex).formatter)
    }
}
