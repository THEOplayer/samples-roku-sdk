
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
    m.convivaConnector.callFunc("configure", m.player, "<MY_CUSTOMER_KEY>", "<MY_GATEWAY_URL>", true)
    m.convivaConnector.callFunc("monitorCdnChanges", getCdnMappings())

    m.comscoreConnector = m.top.findNode("THEOComscoreConnector")
    comscoreConfig = {
        publisherId: "<MY_PUBLISHER_ID>",
        publisherSecret: "<MY_PUBLISHER_SECRET>",
        applicationName: "THEO Roku Reference Sample App"
    }
    m.comscoreConnector.callFunc("configure", m.player, comscoreConfig)

    m.aepConnector = m.top.findNode("THEOAEPConnector")
    aepConfig = {configId: "<MY_CONFIG_ID>", domainName: "<MY_EDGE_DOMAIN>", mediaChannel: "My Channel", mediaPlayerName: "My Player", mediaAppVersion: "1.0", logLevel: 3 }
    m.aepConnector.callFunc("configure", m.player, aepConfig)
    m.aepConnector.observeField("ecid", "_onECIDChanged")
    m.aepConnector.callFunc("getExperienceCloudId", _onECIDChanged, m)
    m.aepConnector.callFunc("updateUserConsent", "y")

    ' License field needs to be filled in order to run THEOplayerSDK
    m.player.callFunc("configure", { license: "<MY_THEO_LICENSE>" })

    m.inAdBreak = false

    addPlayerEventListeners()
end sub

sub addPlayerEventListeners()
    m.player.callFunc("addEventListener", m.player.Event.ended, m.top, "callbackOnEventPlayerEnded")

    m.player.callFunc("addEventListener", m.player.Event.addedaudiotrack, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.addedtexttrack, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.bitratechange, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplay, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplaythrough, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.destroy, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.durationchange, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.emptied, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.error, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadeddata, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadedmetadata, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.pause, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.play, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.playing, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.seeked, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.seeking, m.top, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.sourcechange, m.top, "eventCallbackHandler")
    ' m.player.callFunc("addEventListener", m.player.Event.timeupdate, m.top, "eventCallbackHandler")
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

    m.comscoreConnector.callFunc("destroy")
    m.comscoreConnector = Invalid

    m.aepConnector.callFunc("destroy")
    m.aepConnector = Invalid

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

    mediaType = m.comscoreConnector.MEDIA_TYPES.SHORT_FORM_ON_DEMAND
    if sourceDescription.live
        mediaType = m.comscoreConnector.MEDIA_TYPES.LIVE
    end if
    m.comscoreConnector.callFunc("startSession", mediaType, contentMetadata.comscore)
    m.convivaConnector.callFunc("startSession", contentMetadata.conviva)
    m.aepConnector.callFunc("startSession", contentMetadata.aep)
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
            m.comscoreConnector.callFunc("endSession")
            m.aepConnector.callFunc("endSession")
        else if key = "up"
            m.inAdBreak = NOT m.inAdBreak
            if m.inAdBreak
                m.convivaConnector.callFunc("onAdBreakBegin", {})
                m.comscoreConnector.callFunc("onAdBreakBegin", {})
                m.aep.callFunc("onAdBreakBegin", {})
            else
                m.convivaConnector.callFunc("onAdBreakEnd", {})
                m.comscoreConnector.callFunc("onAdBreakEnd", {})
                m.aepConnector.callFunc("onAdBreakEnd", {})
            end if
        end if
    end if

    return handled
end function

sub _onECIDChanged(event as object)
    print "Adobe ECID updated"; m.aepConnector.ecid
end sub

' When the video has ended, end the conviva session
'
' @param eventData object - contains event data
' @since version 1.0.0
sub callbackOnEventPlayerEnded(eventData)
    eventCallbackHandler(eventData)
    m.convivaConnector.callFunc("endSession")
    m.comscoreConnector.callFunc("endSession")
    m.aepConnector.callFunc("endSession")
end sub
