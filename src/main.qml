import QtQuick 2.0
import QtQuick.Window 2.0
import QtWebEngine 1.0

Window {
    visible: true
    width: 890
    height: 600
    
    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    WebEngineView {
        anchors.fill: parent
        url: "https://bitmovin.com/demos/drm"
    }
}
