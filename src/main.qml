// TODO: Update these as much as possible
import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls 1.2 as OldControls
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.0
import QtWebEngine 1.9
import QtWebChannel 1.9
import QtQml 2.2

OldControls.ApplicationWindow {
    id: window
    width: settings.restoreWindowPosition ? settings.width : 890
    height: settings.restoreWindowPosition ? settings.height : 600
    x: settings.restoreWindowPosition ? settings.x : (Screen.width / 2 - width / 2)
    y: settings.restoreWindowPosition ? settings.y : (Screen.height / 2 - height / 2)
    title: "ElectronPlayer"
    color: "#343434"
    visible: true

    // TEMP
    maximumHeight: 600
    maximumWidth: 890
    minimumHeight: 600
    minimumWidth: 890
    
    Settings {
        id: settings

        // Streaming Services
        property var services: [
            {
                "enabled": true,
                "name": "Menu",
                "url": "qrc:/menu/menu.html",
                "color": "#000000"
            },
            {
                "enabled": true,
                "name": "Netflix",
                "url": "https://www.netflix.com/browse",
                "logo": "../../services/netflix.png",
                "color": "#e50914"
            },
            {
                "enabled": true,
                "name": "YouTube",
                "url": "https://youtube.com",
                "logo": "../../services/youtube.svg",
                "color": "#ff0000"
            }
        ]

        // Restore Window Position and Size
        // readonly property alias x: window.x
        // readonly property alias y: window.y
        // readonly property alias width: window.width
        // readonly property alias height: window.height
        property string url

        // User Settings
        property alias restoreWindowPosition: settingRestoreWindowPosition.checked
        property alias restorePage: settingRestorePage.checked
    }

    menuBar: OldControls.MenuBar { // Should attach natively
		OldControls.Menu {
            id:contextMenu
			title: 'Services'

            Instantiator {
                model: settings.services.length
                OldControls.MenuItem {
                    text: settings.services[index].name
                    shortcut: settings.services[index].name == "Menu" ? "Ctrl+M" : (index <= 10 ? "Ctrl+" + index : "")
                    onTriggered: manager.openService(settings.services[index].name)
                }

                onObjectAdded: contextMenu.insertItem(index, object)
                onObjectRemoved: contextMenu.removeItem(object)
            }
		}

        OldControls.Menu {
            title: 'Settings'

            OldControls.MenuItem {
                id: settingRestoreWindowPosition
                text: "Restore Window Position on Start"
                checkable: true
                checked: false
                enabled: false // TEMP
            }

            OldControls.MenuItem {
                id: settingRestorePage
                text: "Restore Page on Start"
                checkable: true
                checked: false
            }

            OldControls.MenuItem {
                text: "Reset"
                onTriggered: core.resetSettings()
            }
        }

        OldControls.Menu {
            title: 'Help'

            OldControls.MenuItem {
                text: "Report Issue"
                onTriggered: core.openURL("https://github.com/oscartbeaumont/ElectronPlayer/issues")
            }

            OldControls.MenuItem {
                text: "Donate"
                onTriggered: core.openURL("https://github.com/sponsors/oscartbeaumont")
            }
        }
	}

    WebEngineView {
        id: loader
        visible: true
        anchors.fill: parent
        url: "./loader/loader.html"
        webChannel: channel
    }

    QtObject {
        id: manager
        WebChannel.id: "manager"

        signal serviceLoad(string serviceName);

        function getServices() {
            return settings.services;
        }

        function openService(serviceName) {
            let service = settings.services.find(service => service.name == serviceName);
            if (service == undefined || core.getURLDomain(browser.url) == core.getURLDomain(service.url)) {
                return
            }

            console.debug("Changing service to: " + serviceName);
            manager.serviceLoad(JSON.stringify(service));
            browser.url = service.url;
        }
    }

    WebEngineView {
        id: browser
        visible: false
        anchors.fill: parent
        url: settings.restorePage ? settings.url : "qrc:/menu/menu.html"
        profile:  WebEngineProfile{
            httpUserAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36"
        }
        webChannel: channel

        property var currentURL: browser.url

        onLoadingChanged: function(loadRequest) {
            if (loadRequest.status === WebEngineView.LoadStartedStatus) {
                if (core.getURLDomain(currentURL) != core.getURLDomain(loadRequest.url)) {
                    this.visible = false
                }
            } else {
                this.visible = true
                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    currentURL = loadRequest.url;
                    settings.url = loadRequest.url;
                }
            }
        }

        onFullScreenRequested: function(request) {
            if (request.toggleOn) {
                window.showFullScreen()
            } else {
                window.showNormal()
            }
            request.accept()
        }
    }

    WebChannel {
        id: channel
        registeredObjects: [manager]
    }
}
