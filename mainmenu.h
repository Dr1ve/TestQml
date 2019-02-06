#ifndef MAINMENU_H
#define MAINMENU_H

#include <QObject>

#include <memory>

QT_BEGIN_NAMESPACE
class QQuickItem;
QT_END_NAMESPACE

namespace Game {
    namespace Internal {

        class MainMenuPrivate;

        class MainMenu final : public QObject
        {
            Q_OBJECT
        public:
            explicit MainMenu(QQuickItem *mainMenuItem, QObject *parent = nullptr);
            ~MainMenu();

		private slots:
			void menuItemSelected(QString);

        private:
            Q_DISABLE_COPY(MainMenu)

            const std::unique_ptr<MainMenuPrivate> d;

            friend class MainMenuPrivate;
        };
    } // namespace Internal
} // namespace Game

#endif // MAINMENU_H
