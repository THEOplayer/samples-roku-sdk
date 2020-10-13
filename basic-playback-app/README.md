# Table of content

1. [** Description**](#description)

2. [** Project's directory structure**](#projects-directory-structure)

3. [** Setup guide**](#setup-guide)

4. [** How to build THEOplayerSDK and reference app**](#how-to-build-theoplayersdk-and-reference-app)
    - [**How to build THEOplayerSDK**](#how-to-build-theoplayersdk)
    - [**How to build reference app**](#how-to-build-reference-app)

## Description
This is a sample Roku channel utilizing the THEOplayerSDK.
THEOplayerSDK is a custom component allowing channel developers to easily embed the THEOplayer in a channel.
The component is based on the native Roku video player.
The channel presents a THEOplayer with two main options:

 - chromeless
 - chromefull

The first option allows to view the THEOplayerSDK without the playback controls.  
The second allows to view the THEOplayerSDK with the default, slightly customized Roku Video UI.

## Project's directory structure
 - `build` directory contains the compressed basic playback reference application.
 - `components` contains all the components of basic playback reference application.
 - `images` directory contains the channel artworks.
 - `source` directory contains the 'main.brs' file, a starting point for the Roku channel.
 - `manifest` file is required by the Roku platform, contains the configuration of the Roku channel.
 - `README.md` and `RELEASE.md` files are available in root folder.

## Setup guide
1. Install some IDE e.g. Atom with Roku/Brightscript plugins.
2. Connect the Roku device and turn on the developer mode: https://blog.roku.com/developer/developer-setup-guide (in order to upload application zip through the GUI in the browser).

## How to build THEOplayerSDK and reference app
### How to build THEOplayerSDK
1. Clone the THEOplayerSDK repository - https://bitbucket.org/r8szq0vy/theoplayer-roku-sdk/src/master/.
2. Go to the repository and find the manifest file (`src/manifest`).
3. Change the `verizon_support` flag to desired value (`false`).
4. Enter the `src` folder and zip all the contents.
5. Open a browser (chrome, safari, etc.).
6. Go to the Roku device IP address (Development Application Installer), type in the Roku developer username and password.
7. Make sure you are in the Installer tab (top right corner), Upload zip file created in step 4, press replace or install button.
8. Go to the Packager tab (top right corner), if there is no Packager option please generate a developer key in the console.
https://developer.roku.com/en-gb/docs/developer-program/publishing/packaging-channels.md
9. Enter the app name as "THEOsdk" and the password generated for the specific device id.
10. After submit, a link should appear - download THEOplayer package.

### How to build reference app
1. Clone the reference app repository - https://bitbucket.org/r8szq0vy/roku-reference-app/src/master/.
2. Get the .pkg file (generate it as stated in previous section).
3. Place the downloaded package into `basic-playback-app/components/` and rename it as "THEOplayerSDK.pkg".
4. Paste the THEOplayer license in the chosen reference application files instead of the blank string:
    ```brightscript
    m.player.configuration = {
        "license": ""
    }
    ```
5. Go to `basic-playback-app/` and compress all the folders and files (except for `build/`, `README.md` and `RELEASE.md`).
6. Upload the compressed file into installer as stated in previous section.
