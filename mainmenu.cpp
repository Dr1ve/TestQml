#include "mainmenu.h"

#include <QQuickItem>

namespace Game {
    namespace Internal {
        class MainMenuPrivate final
        {
        public:
            MainMenuPrivate(QQuickItem *mainMenuItem);

            QQuickItem *const m_mainMenu;
        };

        MainMenuPrivate::MainMenuPrivate(QQuickItem *mainMenuItem)
            : m_mainMenu(mainMenuItem)
        {

        }

        MainMenu::MainMenu(QQuickItem *mainMenuItem, QObject *parent)
            : QObject(parent),
              d(std::make_unique<MainMenuPrivate>(mainMenuItem))
        {

        }

        MainMenu::~MainMenu()
        {

        }
    }
}
