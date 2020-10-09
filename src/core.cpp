#include "core.h"

Core::Core(QObject *parent) : QObject(parent)
{}

QString Core::getURLDomain(QString rawUrl)
{
    QUrl url(rawUrl);
    return url.host();
}

void Core::openURL(QString url)
{
    QDesktopServices::openUrl(QUrl(url));
}

void Core::restartApplication()
{
    qApp->quit();
    QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
}