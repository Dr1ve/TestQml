#include "game.h"

#include "mainmenu.h"

#include <QDebug>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QQuickWindow>

static const char *const MAIN_WINDOW_FILE_PATH = "qrc:/main.qml";

static const char *const MAINMENU_OBJECT_NAME = "MainMenu";

namespace Game {
    namespace Internal {
        class GamePrivate final
        {
        public:
            GamePrivate(Game *parent, QQmlApplicationEngine *qmlEngine);

            Game *const q;
            QQmlApplicationEngine *const m_qmlEngine;
            QQuickWindow *m_windowItem;
            std::unique_ptr<MainMenu> m_mainMenu;
        };

        GamePrivate::GamePrivate(Game *parent, QQmlApplicationEngine *qmlEngine)
            : q(parent),
              m_qmlEngine(qmlEngine),
              m_windowItem(nullptr)
        {

        }

        Game::Game(QQmlApplicationEngine *qmlEngine, QObject *parent)
            : QObject(parent),
              d(std::make_unique<GamePrivate>(this, qmlEngine))
        {
            connect(d->m_qmlEngine, &QQmlApplicationEngine::objectCreated, this, &Game::onRootObjectCreated);
        }

        Game::~Game()
        {

        }

        bool Game::init()
        {
            d->m_qmlEngine->load(QUrl(QLatin1Literal(MAIN_WINDOW_FILE_PATH)));
            if (d->m_qmlEngine->rootObjects().isEmpty())
            {
                qCritical() << "Can't find QML root objects";
                return false;
            }

            return true;
        }

        void Game::onRootObjectCreated(QObject *object, const QUrl &url)
        {
            Q_UNUSED(url)

            // Получаю объект основного окна
            d->m_windowItem = q_check_ptr(qobject_cast<QQuickWindow*>(object));
            d->m_windowItem->installEventFilter(this);

            // Получаю объект меню
            QQuickItem *mainMenuItem = q_check_ptr(object->findChild<QQuickItem*>(QLatin1Literal(MAINMENU_OBJECT_NAME)));
            d->m_mainMenu = std::make_unique<MainMenu>(mainMenuItem);
        }
    }
}
