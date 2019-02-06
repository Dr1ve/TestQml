#include "gamecontroller.h"
#include <QDebug>
#include <QGuiApplication>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Organization");
    app.setApplicationName("Application");

    auto result = EXIT_FAILURE;

    {
        using GameController = Game::GameController;
        GameController gameController;
        QObject::connect(&app, &QGuiApplication::lastWindowClosed, &gameController, &GameController::shutdown);

        if (gameController.init()) {
            result = app.exec();
        } else {
            qDebug() << "The application was unable to start correctly";
        }
    }

    return result;
}
