
' Function is automatically called every time when new instance of chromefull component is created <br/>
' function will execute following steps: </br>
' sets THEOplayer configuration</br>
' sets THEOplayer event listener</br>
' add some event listeners</br>
'
' @since version 1.0.0
function Init()
    ' center video'
    uiRes = m.top.getScene().currentDesignResolution
    m.player = m.top.findNode("VideoPlayerChromefull")
    ' license field needs to be filled in order to run THEOplayerSDK
    m.player.callFunc("configure", { license: "" })

    m.player.callFunc("addEventListener", m.player.Event.addedaudiotrack, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.addedtexttrack, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.bitratechange, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplay, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplaythrough, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.destroy, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.durationchange, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.emptied, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.ended, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.error, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadeddata, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadedmetadata, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.pause, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.play, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.playing, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.seeked, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.seeking, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.sourcechange, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.timeupdate, m.top, "eventCallbackHandler")

end function

' callback for all events fired in THEOplayerSDK, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
function eventCallbackHandler(eventData)
    ? "Event <"+eventData.type+">: "; eventData
end function

' function destroys THEOplayer
'
' @since version 1.0.0
function destroy()
    m.player.callFunc("destroy")
    m.player = Invalid
end function

' function sets a source of THEOplayer
'
' @since version 1.0.0
function setSource()
    m.player.source = {
        "sources": {
            "src": "https://cdn.theoplayer.com/video/big_buck_bunny_encrypted/stream-800/index.m3u8",
            "type": "application/x-mpegurl"
        }
    }
end function

' function which shows chromefull component, calls signal Beacon if deeplink was passed
'
' @since version 1.0.0
function show(fireBeacon as Boolean)
    setSource()
    m.top.setFocus(true)
    m.player.setFocus(true)
    if fireBeacon then
        m.top.signalBeacon("AppLaunchComplete")
    end if
    m.player.callFunc("play")
end function

' function which will be executed every time when remote button will be pressed, function is responsible for:</br>
' handling back remote button</br>
'
' @since version 1.0.0
function OnKeyEvent(key, press) as Boolean
    handled = false
    if press
        if key = "options"
        else if key = "play"
            m.player.callFunc("play")
        else if m.player.visible = true and key = "back"
            m.player.source = Invalid
        end if
    end if

    return handled
end function
