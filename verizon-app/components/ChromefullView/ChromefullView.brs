function Init()
    ' center video'
    uiRes = m.top.getScene().currentDesignResolution
    m.player = m.top.findNode("VideoPlayerChromefull")

    ' simply testing removeEventListener works'
    m.player.listener = m.top

    ' generic events
    m.player.callFunc("addEventListener", m.player.Event.addedaudiotrack, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.addedtexttrack, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.bitratechange, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplay, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplaythrough, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.destroy, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.durationchange, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.emptied, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.ended, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.error, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadeddata, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadedmetadata, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.pause, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.play, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.playing, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.seeked, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.seeking, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.sourcechange, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.timeupdate, "eventCallbackHandler")

    ' verizon events
    m.player.callFunc("addEventListener", m.player.Event.adbegin, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adbreakbegin, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adbreakend, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adbreakskip, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adcomplete, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.addadbreak, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.addasset, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adend, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adfirstquartile, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.admidpoint, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.adthirdquartile, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.assetinforesponse, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.pingerror, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.pingresponse, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.preplayresponse, "callbackOnEventPlayerVerizonPreplayresponse")
    m.player.callFunc("addEventListener", m.player.Event.removead, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.removeadbreak, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.removeasset, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.updateadbreak, "eventCallbackHandler")

end function

function callbackOnEventPlayerVerizonPreplayresponse(eventData)
    m.player.callFunc("play")

    eventCallbackHandler(eventData)
end function

' callback for all events fired in THEOplayerSDK, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
function eventCallbackHandler(eventData)
    ? "Event <"+eventData.type+">: "; eventData
    if eventData.type = "error"
        ? eventData.errorObject
        ?"=================="
    end if
end function

function destroy()
    m.player.callFunc("destroy")
    m.player = Invalid
end function

function show(fireBeacon as Boolean, adMarkers=true)
    source = {
        "sources": [
            {
                "integration": "verizon-media",
                "id": ["f5c78c6b457f4fc39b33887c3275c336"],
                "contentProtected": false
            }
        ]
    }

    m.player.configuration = {
        "verizonMedia": {
            "onSeekOverAd": "play-none", 'available values: "play-none", "play-all", "play-last"
            "ui": {
                "contentNotification": false,
                "adNotification": true,
                "assetMarkers": false,
                "adBreakMarkers": true,
            },
            "defaultSkipOffset": 4
        },
        ' license field needs to be filled in order to run THEOplayerSDK
        "license": ""
    }

    m.player.source = source
    m.player.callFunc("play")

    m.top.setFocus(true)
    m.player.setFocus(true)
    if fireBeacon then
        m.top.signalBeacon("AppLaunchComplete")
    end if
end function

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
