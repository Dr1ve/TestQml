import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: root

    title: qsTr("Invaders")

    visible: true
    width: 690
    height: 640

    Rectangle {
        id: contentRoot
        color: "black"
        anchors.fill: parent

        MainMenu {
            id: menu
            visible: true
            focus: true
            opacity: 100

            anchors.fill: parent

            onMenuItemSelected : root.menuItemSelected(selectedMenuItem)
        }

        //GameView {}

        //Highscores {}

        //Help {}
    }

    function menuItemSelected(selectedMenuItem)
    {
        if (selectedMenuItem === "Quit") {
            Qt.quit()
        }
    }
}
