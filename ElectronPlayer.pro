TEMPLATE = app
QT += webengine webenginewidgets webchannel

SOURCES += src/main.cpp \
    src/core.cpp
HEADERS += \
    src/core.h
RESOURCES += src/qml.qrc

RC_ICONS = build/icon.ico
ICON = build/icon.icns