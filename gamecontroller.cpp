#include "game.h"

#include "gamecontroller.h"

#include <QQmlApplicationEngine>

namespace Game {
    using Game = Internal::Game;

    namespace Internal {
        class GameControllerPrivate final
        {
        public:
            explicit GameControllerPrivate(GameController *parent);

            GameController *const q;
            const std::unique_ptr<QQmlApplicationEngine> m_qmlEngine;
            const std::unique_ptr<Game> m_game;

        };

        GameControllerPrivate::GameControllerPrivate(GameController *parent)
            : q(parent),
              m_qmlEngine(std::make_unique<QQmlApplicationEngine>(parent)),
              m_game(std::make_unique<Game>(m_qmlEngine.get(), parent))
        {

        }
    } // namespace Internal

    GameController::GameController(QObject *parent)
        : QObject(parent),
          d(std::make_unique<Internal::GameControllerPrivate>(this))
    {

    }

    GameController::~GameController()
    {

    }

    bool GameController::init()
    {
        return d->m_game->init();
    }

    void GameController::shutdown()
    {

    }
} // namespace Game
