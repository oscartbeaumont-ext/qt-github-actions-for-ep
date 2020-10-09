#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qtwebengineglobal.h>
#include <QWebEngineView>
#include <QSettings>
#include <QMainWindow>
#include <QQmlEngine>
#include <QQmlContext>
#include <QMenu>
#include <QMenuBar>

#include "core.h"

int main(int argc, char *argv[])
{
    qInfo("ElectronPlayer created by Oscar Beaumont!");
    QCoreApplication::setOrganizationName("Oscar Beaumont");
    QCoreApplication::setOrganizationDomain("me.otbeaumont.ElectronPlayer");
    QCoreApplication::setApplicationName("ElectronPlayer");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    QSettings settings;
    if (settings.value("resetSettingsToDefault", 0).toInt() == 1) {
        qDebug() << "Reset";
        settings.clear();
    }

    QScopedPointer<Core> core(new Core);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.rootContext()->setContextProperty("core", core.data());

    return app.exec();
}

