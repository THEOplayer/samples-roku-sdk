# Table of content

1. [**Description**](#description)

2. [**Project's directory structure**](#projects-directory-structure)

3. [**Setup guide**](#setup-guide)

4. [**How to build the reference app**](#how-to-build-reference-app)

## Description
This repository contains two reference applications utilizing the THEOplayerSDK.
THEOplayerSDK is a custom component allowing channel developers to easily embed THEOplayer in a channel.

## Project's directory structure
 - `basic-playback-app` directory contains the reference application for basic streams playback.
 - `verizon-app` directory contains the reference application for Verizon-based sources. This application also contains basic showcase of the THEOplayerSDK integration for Verizon capabilities.
 - `README.md` and `RELEASE.md` files are available in root folder.

## Setup guide
1. Install some IDE e.g. Atom with Roku/Brightscript plugins.
2. Connect the Roku device and turn on the developer mode: https://blog.roku.com/developer/developer-setup-guide (in order to upload application zip through the GUI in the browser).

## How to build reference app

1. Clone the repository.
2. Get the THEOplayer ROKU SDK from the [Developer Portal](https://portal.theoplayer.com).
3. Place the downloaded package into `verizon-app/components/` or `basic-playback-app/components/` and rename it as "THEOplayerSDK.pkg".
4. Paste the THEOplayer license in the chosen reference application files instead of the blank string:
```brightscript
m.player.configuration = {
    "license": ""
}
```
5. Go to `verizon-app/` or `basic-playback-app/` and compress all the folders and files (except for `build/` and `README.md`).
6. Open browser (chrome, safari, etc.).
7. Go to the Roku device IP address (Development Application Installer), type in the Roku developer username and password.
8. Make sure you are in the Installer tab (top right corner), Upload zip file created in step 4, press replace or install button.
