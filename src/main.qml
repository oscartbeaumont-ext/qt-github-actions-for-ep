// TODO: Update these as much as possible
import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.2 as OldControls
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.0
import QtWebEngine 1.11
import QtWebChannel 1.11
import QtQml 2.2
import QtQuick.Dialogs 1.2

OldControls.ApplicationWindow {
    id: window
    title: "ElectronPlayer"
    color: "#343434"
    visible: true
    
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
        property var windowX
        property var windowY
        property var windowWidth
        property var windowHeight
        property string lastURL

        // User Settings
        property alias restoreWindowPosition: settingRestoreWindowPosition.checked
        property alias restorePage: settingRestorePage.checked
    }

    Component.onCompleted: function() {
        window.width = settings.restoreWindowPosition ? settings.windowWidth : 890
        window.height = settings.restoreWindowPosition ? settings.windowHeight : 600
        window.x = settings.restoreWindowPosition ? settings.windowX : (Screen.width / 2 - width / 2)
        window.y = settings.restoreWindowPosition ? settings.windowY : (Screen.height / 2 - height / 2)
        browser.url = settings.restorePage ? settings.lastURL : "qrc:/menu/menu.html"
    }

    Component.onDestruction: function() {
        settings.windowX = window.x
        settings.windowY = window.y
        settings.windowWidth = window.width
        settings.windowHeight = window.height
        settings.lastURL = browser.url
    }

    menuBar: OldControls.MenuBar {
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
            }

            OldControls.MenuItem {
                id: settingRestorePage
                text: "Restore Page on Start"
                checkable: true
                checked: false
            }

            OldControls.MenuItem {
                text: "Reset"
                onTriggered: resetConfirmationPopup.open()
            }
        }

        OldControls.Menu {
            title: 'Actions'

            OldControls.MenuItem {
                text: "Open URL"
                shortcut: "Ctrl+O"
                onTriggered: openUrlPopup.open()
            }

            OldControls.MenuItem {
                text: "Back"
                shortcut: "Alt+Left"
                onTriggered: browser.goBack()
            }

            OldControls.MenuItem {
                text: "Forward"
                shortcut: "Alt+Right"
                onTriggered: browser.goForward()
            }

            OldControls.MenuItem {
                text: "Reload"
                shortcut: "Ctrl+R"
                onTriggered: browser.reload()
            }

            OldControls.MenuItem {
                text: "Stop"
                shortcut: "Esc"
                onTriggered: browser.stop()
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

    MessageDialog {
        id: resetConfirmationPopup
        title: "Reset Settings"
        text: "<font color='white' size='3em'>Reset Settings</font>"
        informativeText: "<font color='white'>Are you sure you would like to reset your settings to the applications default. This includes your configured services!</font>"
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: () => {
            settings.setValue("resetSettingsToDefault", 1)
            core.restartApplication()
        }
    }

    Popup {
        id: openUrlPopup
        x: Math.round((window.width - width) / 2)
        y: 0
        width: 300
        height: 100
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Text {
            text: "Open Custom URL:"
        }

        TextField {
            id: urlInput
            width: 275
            height: 25
            y: 25
            focus: true
            placeholderText: "https://google.com"
            Keys.onReturnPressed: openUrlBtn.onPressed()
        }

        Button {
            id: openUrlBtn
            y: 55
            height: 25
            width: 275
            text: "Open"
            onPressed: () => {
                browser.url = urlInput.text == "" ? urlInput.placeholderText : urlInput.text
                openUrlPopup.close();
            }
        }
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
        id: loader
        visible: false
        anchors.fill: parent
        url: "./loader/loader.html"
        webChannel: channel

        onLoadingChanged: function(loadRequest) {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                this.visible = true
            }
        }
    }

    WebEngineView {
        id: browser
        visible: false
        anchors.fill: parent
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
                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    currentURL = loadRequest.url;
                }
                this.visible = true
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
