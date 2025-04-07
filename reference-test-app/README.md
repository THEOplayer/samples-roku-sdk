# Table of content

1. [** Description**](#description)

2. [** Project's directory structure**](#projects-directory-structure)

3. [** Setup guide**](#setup-guide)

## Description

This is a sample Roku channel utilizing the THEOplayerSDK and connectors.
THEOplayerSDK is a custom component allowing channel developers to easily embed the THEOplayer in a channel.
The channel presents a list of media to play using the THEOplayerSDK with the default, slightly customized Roku Video UI.

## Project's directory structure

- `components` contains all the components of basic playback reference application.
- `images` directory contains the channel artworks.
- `source` directory contains the `main.brs` file, a starting point for the Roku channel.
- `manifest` file is required by the Roku platform, contains the configuration of the Roku channel.
- `README.md` file is available in root folder.
- `package.sh` optional build script to make deploying easier

## Setup guide

1. Install an IDE, preferably VSCode with Brightscript extensions.
2. Connect the Roku device and turn on the developer mode: https://blog.roku.com/developer/developer-setup-guide in order to sideload the application zip onto the device.

### Configuring the reference app

1. Clone the reference app repository - https://github.com/THEOplayer/samples-roku-sdk.
1. Paste the THEOplayer license in the chosen reference application files instead of the placeholder:
   ```brightscript
   m.player.configuration = {
       "license": "<MY_THEO_LICENSE>"
   }
   ```
1. If using Conviva, paste your client key in the THEOConvivaConnector `configure` call in `components/VideoPlayerView.brs`. If you are testing and not doing production, also add your gateway URL and you may also enable Conviva debug. If doing production, remove the `gatewayUrl` and `debug` parameters.
   `m.convivaConnector.callFunc("configure", m.player, "<MY_CUSTOMER_KEY>", "<MY_GATEWAY_URL>", true)`
1. If using Comscore, paste your publisher ID and secret in the configuration object passed to the THEOComscoreConnector `configure` call in `components/VideoPlayerView.brs`.
   ```brightscript
   comscoreConfig = {
        publisherId: "<MY_PUBLISHER_ID>",
        publisherSecret: "<MY_PUBLISHER_SECRET>",
        applicationName: "THEO Roku Reference Sample App"
    }
    m.comscoreConnector.callFunc("configure", m.player, comscoreConfig)
   ```
1. If using Adobe Edge analytics, fill in the configuration object passed to the THEOAEPConnector `configure` call in `components/VideoPlayerView.brs`.
   ```brightscript
   aepConfig = {configId: "<MY_CONFIG_ID>", domainName: "<MY_EDGE_DOMAIN>", mediaChannel: "My Channel", mediaPlayerName: "My Player", mediaAppVersion: "1.0", logLevel: 3 }
    m.aepConnector.callFunc("configure", m.player, aepConfig)
   ```
1. If you would like to add your own content and metadata to the app, modify `components/configs/Content.brs`.

### Deploying the reference app

To manually deploy the app

1. Go to `reference-test-app/` and zip all the folders and files (except for `build/`, `package.sh`, `README.md` and `RELEASE.md`).
1. Go to the Roku device IP address in a browser. When prompted, type in the Roku developer username and password for that device.
1. Make sure you are in the Installer tab (top right corner), and upload the zip file, then click the replace or install button.

To use a script to deploy the app

1. If you haven't already, create a file called `env.sh` in the root of the project. The file should have the following vars defined:

```shell
export ROKU_HOST=<MY_ROKU_IP>
export ROKU_USERPASS=<MY_ROKU_PASSWORD>
```

2. If you're on Windows and do not have the `zip` application installed, you can also use `7zip` if you have it installed by adding the following variable in your `env.sh` file:
   `export ZIP_TOOL=7zip`
3. In a CLI, navigate to the `reference-test-app` directory and run the command `./package.sh`. The script will package and deploy the app to your Roku. On subsequent runs, all that is needed is to rerun `./package.sh`

To use VS Code to deploy the app

1. Install the Brightscript Language extension
1. In the `.vscode` directory, create a file called `variables.env`
1. In `variables.env` add your Roku's IP and password:

```
ROKU_IP=<MY_ROKU_IP>
ROKU_PASSWORD=<MY_ROKU_PASSWORD>
```

4. In VS Code's Run and Debug panel, select `Debug: reference-test-app` and click the play icon next to it. VS Code will package the app and deploy it to your Roku, additionally starting a debug session for your app.
