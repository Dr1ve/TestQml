import QtQuick 2.0

Rectangle {
    id: root

    width: parent.width
    height: parent.height

    color: "black"

    signal menuItemSelected(string selectedMenuItem)

    property int hoveredMenuItem: 99

    ListModel {
        id: menuModel

        ListElement { text: "New game"; highlighted: false; }
        ListElement { text: "Highscores"; highlighted: false; }
        ListElement { text: "Help"; highlighted: false; }
        ListElement { text: "Quit"; highlighted: false; }
    }

    Rectangle {
        id: borderContainer
        anchors.centerIn: parent

        color: "black"

        width: parent.width - 150
        height: parent.height

        Column {
            id: mainColumn
            anchors.centerIn: parent
            spacing: 50

            Column {
                id: menuContainer
                anchors.horizontalCenter: parent.horizontalCenter

                property int maxWidth: 0

                Repeater {
                    model: menuModel

                    MenuItem {
                        id: currentItem
                        buttonText: text
                        width: menuContainer.maxWidth
                        anchors.horizontalCenter: parent.horizontalCenter

                        Connections {
                            target: menuModel.get(index)
                            onHighlightedChanged: {
                                if (menuModel.get(index).highlighted){
                                    currentItem.highlighted = true;
                                } else {
                                    currentItem.highlighted = false;
                                }
                            }
                        }

                        onItemClicked: {
                            menuItemSelected(buttonText);
                        }

                        onHoveredChanged: {
                            if (currentItem.hovered) {
                                hoveredMenuItem = index;
                            }
                        }

                        onContentWidthChanged: {
                            menuContainer.maxWidth = Math.max(menuContainer.maxWidth, contentWidth) + 20;
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        hoveredMenuItem = 0;
    }

    onHoveredMenuItemChanged: {
        for(var modelIndex = 0; modelIndex < menuModel.count; ++modelIndex) {
            if(modelIndex !== hoveredMenuItem) {
                menuModel.setProperty(modelIndex, "highlighted", false);
            } else {
                menuModel.setProperty(modelIndex, "highlighted", true);
            }
        }
    }

    Keys.onReturnPressed: {
        menuItemSelected(menuModel.get(hoveredMenuItem).text);
    }

    Keys.onUpPressed: {
        if (hoveredMenuItem > 0) {
            --hoveredMenuItem;
        } else {
            hoveredMenuItem = menuModel.count - 1;
        }
    }

    Keys.onDownPressed: {
        if (hoveredMenuItem < menuModel.count - 1) {
            ++hoveredMenuItem;
        } else {
            hoveredMenuItem = 0;
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Q) {
            event.accepted = true;
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Q) {
            hoveredMenuItem = 3;
            event.accepted = true;
        }
    }
}
