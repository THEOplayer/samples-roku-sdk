# samples-roku-sdk

This repository contains three reference applications utilizing the THEOplayer Roku SDK.
The THEOplayer Roku SDK is a custom component allowing channel developers to easily embed THEOplayer in a channel.

**Note**: developers still need to manually add their THEOplayer SDK, and configure their `license` string, as explained throughout the various `README.md` files.

Table of contents:

1. [Directory structure](#directory-structure)
2. [Setup guide](#setup-guide)
3. [How to configure a reference app](#how-to-configure-a-reference-app)

## Directory structure

- `basic-playback-app`: this directory contains the reference application for basic playback.
- `verizon-app`: this directory contains the reference application for Verizon-based streams. This application also contains a basic showcase of features related to the Verizon Media Platform. NOTE: this is only for Roku SDK earlier than 9.0.
- [`reference-test-app`](reference-test-app/README.md): this directory contains the reference application for testing with the THEOplayer SDK and THEOConvivaConnector. This application also has multiple media sources to play.
- [`hello-world`](hello-world/README.md): this directory contains a modified version of Roku's `hello-world` sample channel.
  This sample channel is related to our official [getting started guide](https://docs.theoplayer.com/getting-started/01-sdks/09-roku/00-getting-started.md) on the THEOplayer Roku SDK.
- `README.md`: this file is available in the root folder.

## Setup guide

1. Open the relevant folder in an editor. (e.g. VS Code/Atom/Visual Studio/Eclipse with Roku and/or BrightScript plugins)
2. Have a Roku device with [developer mode](https://blog.roku.com/developer/developer-setup-guide) turned on.

## How to configure a reference app

1. Clone (or download) the repository.
2. Get the THEOplayer Roku SDK from [https://portal.theoplayer.com](https://portal.theoplayer.com). The SDK is a `.pkg` package.
3. Place the downloaded package into `verizon-app/components/` or `basic-playback-app/components/` and rename it to `THEOplayerSDK.pkg`.
4. Paste the THEOplayer license in the chosen reference application files instead of the blank string:
   ```brightscript
   m.player.configuration = {
       "license": ""
   }
   ```

Documentation on how to deploy (or publish) this reference application is excluded.
Refer to Roku's article on ["Developer environment setup"](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md) for more information.
