#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qtwebengineglobal.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("ElectronPlayer");
    QCoreApplication::setApplicationName("ElectronPlayer");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QtWebEngine::initialize();
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

