# Release

The file describes the features set and how it changes between releases.

## [Unreleased]
- emit loadedmetadata, loadeddata events (waiting for the Roku OS 9.3 update which is rolling out to devices currently, the update introduces playStartInfo attribute we want to use; also we tried observing the following fields and that way detect the metadata loading progress:  
-audioTracks  
-textTracks  
-videoTracks and their qualities?  
-duration  
unfortunately duration changes just before the playback so we can't use that)
- eia 608 closed captions support

## [0.2.1] - 2020-05-19
### `Added`
- Ability to change current audio track through "enabled" field
- Ability to change current captions track through "mode" field
### `Changed`
- Incomplete docs, refined them and now they are up-to-date
### `Fixed`
- Bugs with the "play" event (primarily, it was not emitted at all)
- Bug with the order of "play" and "playing" events

## [0.2.0] - 2020-05-05
### `Added`
- ROKU-22 Added Deep Linking, signal beacons (channel certification requirements)
- ROKU-15 Add currentTime data to emptied event
### `Changed`
- ROKU-22 Changed artwork (splash, icons) (channel certification requirements)
### `Fixed`
- ROKU-15 Fix play head bug for HLS live stream + global refactor/cleanup

## [0.1.0] - 2020-04-28
### `Added`
- custom player component
- MVP presenting chromeless and chromefull variants of the custom player component
- trick play: play, pause, stop
- seeking for VOD: rewind, fast-forward
- seeking for live stream: rewind
- API for setting video dimensions, max resolution and copy guard management system
- event types
- API to add/remove event listener
- data emitted along with an event
- text tracks support
- audio tracks support
