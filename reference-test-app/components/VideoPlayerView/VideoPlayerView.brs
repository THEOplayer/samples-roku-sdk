
' This function is automatically called every time when a new instance of the VideoPlayerView component is created. <br/>
' The function will execute following steps: </br>
' * sets THEOplayer configuration</br>
' * sets THEOplayer event listener</br>
' * add some event listeners</br>
'
' @since version 1.0.0
sub Init()
    ' Grab references to our main components
    m.player = m.top.findNode("VideoPlayerNativeControls")
    m.convivaConnector = m.top.findNode("THEOConvivaConnector")
    m.convivaConnector.callFunc("addPlayer", m.player)
    m.convivaConnector.callFunc("monitorCdnChanges", getCdnMappings())

    ' License field needs to be filled in order to run THEOplayerSDK
    m.player.configuration = {
        "license": "<MY_THEO_LICENSE>"
    }

    m.inAdBreak = false

    addPlayerEventListeners()
end sub

sub addPlayerEventListeners()
    m.player.listener = m.top

    m.player.callFunc("addEventListener", m.player.Event.ended, "callbackOnEventPlayerEnded")

    m.player.callFunc("addEventListener", m.player.Event.addedaudiotrack, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.addedtexttrack, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.bitratechange, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.canplay, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.canplaythrough, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.destroy, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.durationchange, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.emptied, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.error, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.loadeddata, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.loadedmetadata, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.pause, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.play, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.playing, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.seeked, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.seeking, "eventCallbackHandler", m.top)
    m.player.callFunc("addEventListener", m.player.Event.sourcechange, "eventCallbackHandler", m.top)
    ' m.player.callFunc("addEventListener", m.player.Event.timeupdate, "eventCallbackHandler", m.top)
end sub

' callback for all events fired in THEOplayerSDK, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
sub eventCallbackHandler(eventData)
    ? "Event <"+eventData.type+">: "; eventData
end sub

' function destroys THEOplayer
'
' @since version 1.0.0
sub destroy()
    m.convivaConnector.callFunc("destroy")
    m.convivaConnector = Invalid

    m.player.callFunc("destroy")
    m.player = Invalid
end sub

' function sets a source of THEOplayer
'
' @since version 1.0.0
sub setSource( sourceDescription as object )
    m.player.controls = false
    m.player.enableTrickPlay = true
    m.player.source = sourceDescription

    contentMetadata = generateContentMetadata(sourceDescription)

    m.convivaConnector.callFunc("startSession", contentMetadata)
end sub

' Show the component.
'
' @since version 1.0.0
sub show()
    m.top.setFocus(true)
    m.player.setFocus(true)

    if m.player.source <> invalid
        m.player.callFunc("play")
    end if
end sub

' Function which will be executed every time when remote button will be pressed, function is responsible for:</br>
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
            m.convivaConnector.callFunc("endSession")
        else if key = "up"
            m.inAdBreak = NOT m.inAdBreak
            if m.inAdBreak
                m.convivaConnector.callFunc("onAdBreakBegin", {})
            else
                m.convivaConnector.callFunc("onAdBreakEnd", {})
            end if
        end if
    end if

    return handled
end function

' When the video has ended, end the conviva session
'
' @param eventData object - contains event data
' @since version 1.0.0
sub callbackOnEventPlayerEnded(eventData)
    eventCallbackHandler(eventData)
    m.convivaConnector.callFunc("endSession")
end sub
