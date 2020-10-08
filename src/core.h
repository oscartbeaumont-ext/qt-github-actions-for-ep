#ifndef CORE_H
#define CORE_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QDesktopServices>
#include <QSettings>
#include <QApplication>
#include <QProcess>

class Core : public QObject
{
    Q_OBJECT
public:
    explicit Core(QObject *parent = nullptr);

    Q_INVOKABLE QString getURLDomain(QString rawUrl);
    Q_INVOKABLE void openURL(QString url);
    Q_INVOKABLE void resetSettings();

signals:

};

#endif // CORE_H
