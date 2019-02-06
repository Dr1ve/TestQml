#ifndef GAME_H
#define GAME_H

#include <QObject>

QT_BEGIN_NAMESPACE
class QQmlApplicationEngine;
QT_END_NAMESPACE

#include <memory>

namespace Game {
    namespace Internal {
        class GamePrivate;

        class Game final : public QObject
        {
            Q_OBJECT
        public:
            explicit Game(QQmlApplicationEngine *qmlEngine, QObject *parent = nullptr);
            ~Game();

            bool init();

        private:
            Q_DISABLE_COPY(Game)

            const std::unique_ptr<GamePrivate> d;

            friend class GamePrivate;
        };
    } // namespace Internal
} // namespace Game

#endif // GAME_H
