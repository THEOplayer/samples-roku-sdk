# verizon-app

This is a sample Roku channel utilizing the THEOplayer Roku SDK.
This channel is focused on the Verizon-based sources. NOTE: This
can only be used with SDK versions before 9.0.0.

Table of contents:

1. [Directory structure](#directory-structure)
2. [Setup guide](#setup-guide)
3. [How to configure the reference app](#how-to-configure-the-reference-app)

The THEOplayer Roku SDK integrates features offered by the Verizon Media Platform, as demonstrated by this reference application.

The channel presents a THEOplayer with two main options:

- chromeless: view THEOplayer without the default playback controls.
- chromefull: view THEOplayer with the default, slightly customized Roku Video UI.

## Directory structure

- `components` contains all the components of basic Verizon reference application.
- `images` directory contains the channel artworks.
- `source` directory contains the `main.brs` file, a starting point for the Roku channel.
- `manifest` file is required by Roku platform, contains the configuration of Roku channel.
- `README.md` file is available in the root folder.

## Setup guide

1. Open this `verizon-app` folder in an editor. (e.g. Atom/Visual Studio/Eclipse with Roku and/or BrightScript plugins)
2. Have a Roku device with [developer mode](https://blog.roku.com/developer/developer-setup-guide) turned on.

## How to configure the reference app

1. Clone (or download) this repository.
2. Get the THEOplayer Roku SDK from [https://portal.theoplayer.com](https://portal.theoplayer.com). The SDK is a `.pkg` package.
3. Place the downloaded package into `verizon-app/components/` and rename it to `THEOplayerSDK.pkg`.
4. Paste the THEOplayer license in `verizon-app/components/ChromefullView/ChromefullView.brs` and `verizon-app/components/ChromelessView/ChromelessView.brs` instead of the blank string:
   ```brightscript
   m.player.configuration = {
       "license": ""
   }
   ```

Documentation on how to deploy (or publish) this reference application is excluded.
Refer to Roku's article on ["Developer environment setup"](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md) for more information.
