#include "game.h"

#include <QDebug>
#include <QQmlApplicationEngine>

static const char *const MAIN_WINDOW_FILE_PATH = "qrc:/main.qml";

namespace Game {
    namespace Internal {
        class GamePrivate final
        {
        public:
            GamePrivate(Game *parent, QQmlApplicationEngine *qmlEngine);

            Game *const q;
            QQmlApplicationEngine *const m_qmlEngine;
        };

        GamePrivate::GamePrivate(Game *parent, QQmlApplicationEngine *qmlEngine)
            : q(parent),
              m_qmlEngine(qmlEngine)
        {

        }

        Game::Game(QQmlApplicationEngine *qmlEngine, QObject *parent)
            : QObject(parent),
              d(std::make_unique<GamePrivate>(this, qmlEngine))
        {

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
    }
}
