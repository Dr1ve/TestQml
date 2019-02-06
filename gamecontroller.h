#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include <QObject>
#include <memory>

namespace Game {
    namespace Internal {
        class GameControllerPrivate;
    }

    class GameController final : public QObject
    {
        Q_OBJECT

    public:
        explicit GameController(QObject *parent = nullptr);
        ~GameController();

        bool init();

    public slots:
        void shutdown();

    private:
        Q_DISABLE_COPY(GameController)

        const std::unique_ptr<Internal::GameControllerPrivate> d;

        friend class Internal::GameControllerPrivate;
    };
} // namespace Game

#endif // GAMECONTROLLER_H
