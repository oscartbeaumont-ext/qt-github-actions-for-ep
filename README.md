## ElectronPlayer
#### This repoistory contains the Qt version of the application until completed migration from Electron.

[![Build Status](https://travis-ci.org/oscartbeaumont/ElectronPlayer.svg?branch=master)](https://travis-ci.org/oscartbeaumont/ElectronPlayer)
[![ElectronPlayer](https://snapcraft.io/electronplayer/badge.svg)](https://snapcraft.io/electronplayer)

A Qt Based Web Video Services Player. Supporting Netflix, Youtube, Twitch, Floatplane, Hulu, Amazon Prime Video And More. This is the successor to [Netflix-Desktop](https://github.com/oscartbeaumont/Netflix-Desktop).

![ElectronPlayer Menu](docs/ElectronPlayer.png)

_The apps main menu interface_

# Features

- Multiple Streaming Services Support (JSON Configuration to add extra)
- Adblock
- Always On Top Window
- Set Startup Page (Any Service or Remember Last Opended Page)
- Frameless Window
- Rough Mac Picture in Picture Support (Floating Window, Above All Desktop and Fullscreen Applications)
- Full Screen Window on Startup

# Installation

Coming soon

# Analytics

This application has analytics built in which is used to help the developers make a better product. [Simple Analytics](https://simpleanalytics.com) was chosen due to their strong views on keeping users private. They are also GDPR, CCPA, & PECR compliant. The data collected by the app can be viewed by anyone [here](https://simpleanalytics.com/electronplayer.otbeaumont.me).

# Contributors

A huge thanks to the following people for contributing and helping shape this project.

- [Austin Kregel](https://github.com/austinkregel)
- [Rasmus Lindroth](https://github.com/RasmusLindroth)
- [Scrumplex](https://github.com/Scrumplex)

# Developing

```bash
git clone https://github.com/oscartbeaumont/ElectronPlayer.git
cd ElectronPlayer/
qmake
make

# Run Compiled Application:
./ElecronPlayer # Linux
open ./ElectronPlayer.app # macOS
ElectronPlayer.exe # Windows
```