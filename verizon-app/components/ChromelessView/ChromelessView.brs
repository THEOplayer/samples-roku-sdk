function Init()
    SetupUI()
    SetupObservers()
    SetupEventListeners()

    m.player.callFunc("setCopyGuardManagementSystem", 2)
    m._dt = CreateObject("roDateTime")
    m.skippingAd = false
end function

function setUpAdMarkers()
    adsGroup = m.top.findNode("adsMarkers")
    if adsGroup <> Invalid
        m.GroupOptions.removeChild(adsGroup)
    end if
    if m.player.verizonMedia.count() = 0 or m.player.configuration.verizonMedia.ui.adBreakMarkers <> true
        return Invalid
    end if
    adBreaks = GetNestedValue(m.player.verizonMedia, ["ads", "adBreaks"])
    progressBG = m.timelineBackground
    progresRect = progressBG.boundingRect()
    duration = m.player.duration

    adsGroup = createObject("roSGNode", "Group")
    adsGroup.id = "adsMarkers"
    m.GroupOptions.appendChild(adsGroup)
    if adBreaks <> Invalid
        for each ad in adBreaks
            adMarker = createObject("roSGNode", "Rectangle")
            adMarker.height = progresRect.height * 3
            adMarker.width = progresRect.width * ( ad.duration / duration )
            adMarker.translation = [ progresRect.width * ( ad.startTime / duration ) , progresRect.y - progresRect.height ]
            adMarker.color = "0xFF0000"
            adMarker.opacity = 0.8
            adsGroup.appendChild(adMarker)
        end for
    end if
end function

function setUpAssetMarkers()
    assets = m.player.verizonMedia.Lookup("assets")
    if assets = Invalid
        return Invalid
    end if

    assetsGroup = m.top.findNode("assetMarkers")
    if assetsGroup <> Invalid
        m.GroupOptions.removeChild(assetsGroup)
    end if

    isVerizonMediaProvided = assets.count() > 0
    isMissingVerizonConfiguration = Type(m.player.configuration) = Invalid or Type(m.player.configuration.verizonMedia) = Invalid
    isAssetMarkersDisabled = m.player.configuration.verizonMedia.ui.assetMarkers <> true

    if isVerizonMediaProvided <> true or isMissingVerizonConfiguration or isAssetMarkersDisabled
        return Invalid
    end if

    progressBG = m.timelineBackground
    progresRect = progressBG.boundingRect()
    duration = m.player.duration
    markerWidth = 2
    assetsGroup = createObject("roSGNode", "Group")
    assetsGroup.id = "assetMarkers"
    m.GroupOptions.appendChild(assetsGroup)

    assetMarker = createObject("roSGNode", "Rectangle")
    assetMarker.height = progresRect.height * 5
    assetMarker.width = markerWidth
    markerX = progresRect.x
    markerY = progresRect.y - assetMarker.height / 2
    assetMarker.translation = [markerX , markerY]
    assetMarker.color = "0xFFFFFF"
    assetMarker.opacity = 0.4
    assetsGroup.appendChild(assetMarker)
    for each asset in assets
        assetMarker = createObject("roSGNode", "Rectangle")
        assetMarker.height = progresRect.height * 5
        assetMarker.width = markerWidth
        markerX = progresRect.x + progresRect.width * ( asset.endTime / duration ) - markerWidth / 2
        markerY = progresRect.y - assetMarker.height / 2
        assetMarker.translation = [markerX , markerY]
        assetMarker.color = "0xFFFFFF"
        assetMarker.opacity = 0.4
        assetsGroup.appendChild(assetMarker)
    end for
end function

function setUpBusySpinnerPosition()
    if m.busySpinner.poster.loadStatus = "ready"
        centerx = (m.playerRect.width - m.busySpinner.poster.bitmapWidth) / 2
        centery = (m.playerRect.height - m.busySpinner.poster.bitmapHeight) / 2
        m.busySpinner.translation = [m.playerRect.x + centerx, m.playerRect.y + centery]
        m.busySpinner.poster.unobserveField("loadStatus")
    end if
end function

function SetupUI()
    m.VerizonConfiguration = m.top.findNode("VerizonConfiguration")
    m.buttonPlay = m.top.findNode("ButtonPlay")
    m.buttonSeekBackward = m.top.findNode("ButtonSeekBackward")
    m.buttonSeekForward = m.top.findNode("ButtonSeekForward")
    m.playIcon = m.top.findNode("playIcon")
    m.categoryFirstHeaderBackground = m.top.findNode("CategoryFirstHeaderBackground")
    m.labelPosition = m.top.findNode("LabelPosition")
    m.settingsOptions = m.top.findNode("SettingsOptions")
    m.buttonCategoryFirst = m.top.findNode("ButtonCategoryFirst")
    m.buttonCategorySecond = m.top.findNode("ButtonCategorySecond")
    m.hideOptionsTimer = m.top.findNode("HideOptionsTimer")
    m.categoryFirstButtonFirst = m.top.findNode("CategoryFirstButtonFirst")
    m.categorySecondButtonFirst = m.top.findNode("CategorySecondButtonFirst")
    m.optionsBarAnimationFadeIn = m.top.findNode("OptionsBarAnimationFadeIn")
    m.optionsBarAnimationFadeOut = m.top.findNode("OptionsBarAnimationFadeOut")
    m.player = m.top.findNode("VideoPlayerChromeless")
    m.timelineProgress = m.top.findNode("TimelineProgress")

    m.busySpinner = m.top.findNode("BusySpinner")

    m.skipAdRectangle = m.top.findNode("SkipAdRectangle")
    m.buttonSkipAd = m.top.findNode("SkipAdButton")

    m.seekingInfo = ""

    m.player.callFunc("setMaxVideoResolution", 1920, 1080)

    m.latestFocusedMenuButton = m.buttonPlay

    SetupPlayerPosition()
    SetupSkipAdPosition()
    SetMenusPosition()
    CenterVideoTime()
end function

function SetupObservers()
    m.player.observeField("audioTracks", "onEventAudioTracksChanged")
    m.player.observeField("textTracks", "onEventTextTracksChanged")
    m.player.observeField("verizonMedia", "onEventVerizonMediaChanged")

    m.busySpinner.poster.ObserveField("loadStatus", "setUpBusySpinnerPosition")

    m.buttonPlay.observeField("buttonSelected", "OnEventPlay")
    m.buttonSeekBackward.observeField("buttonSelected", "OnEventSeekBackward")
    m.buttonSeekForward.observeField("buttonSelected", "OnEventSeekForward")
    m.buttonSeekForward.observeField("focusedChild", "OnSeekForwardFocusChange")
    m.buttonSkipAd.observeField("buttonSelected", "OnEventSkipAd")

    m.buttonGroupOptions.observeField("focusedChild", "OnEventButtonGroupOptionsFocusedChildChanged")
    m.buttonCategoryFirst.observeField("buttonSelected", "OnEventCategoryFirst")
    m.buttonGroupCategoryFirst.observeField("itemFocused", "OnEventCategoryFirstFocusedItem")
    m.buttonGroupCategoryFirst.observeField("checkedItem", "OnEventCategoryFirstSelectedItem")

    m.buttonCategorySecond.observeField("buttonSelected", "OnEventCategorySecond")
    m.buttonGroupCategorySecond.observeField("itemFocused", "OnEventCategorySecondFocusedItem")
    m.buttonGroupCategorySecond.observeField("checkedItem", "OnEventCategorySecondSelectedItem")

    m.hideOptionsTimer.ObserveField("fire","hideOptions")

    m.VerizonConfiguration.observeField("lostFocus", "receiveFocus")
    m.VerizonConfiguration.observeField("configuration", "onVerizonConfigurationChanged")
end function

function receiveFocus()
    if m.VerizonConfiguration.lostFocus = "true"
        m.latestFocusedMenuButton.setFocus(true)
    end if
end function

function SetupEventListeners()
    m.player.listener = m.top

    ' generic events
    m.player.callFunc("addEventListener", m.player.Event.addedaudiotrack, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.addedtexttrack, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.bitratechange, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.canplay, "callbackOnEventPlayerCanplay")
    m.player.callFunc("addEventListener", m.player.Event.canplaythrough, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.destroy, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.durationchange, "callbackOnEventPlayerDurationchange")
    m.player.callFunc("addEventListener", m.player.Event.emptied, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.ended, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.error, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadeddata, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.loadedmetadata, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.pause, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.play, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.playing, "callbackOnEventPlayerPlaying")
    m.player.callFunc("addEventListener", m.player.Event.seeked, "callbackOnEventPlayerSeeked")
    m.player.callFunc("addEventListener", m.player.Event.seeking, "callbackOnEventPlayerSeeking")
    m.player.callFunc("addEventListener", m.player.Event.sourcechange, "callbackOnEventPlayerSourcechange")
    m.player.callFunc("addEventListener", m.player.Event.timeupdate, "callbackOnEventPlayerTimeupdate")

    ' verizon events
    m.player.callFunc("addEventListener", m.player.Event.adbegin, "callbackOnEventPlayerVerizonAdbegin")
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

function SetupPlayerPosition()
    uiRes = m.top.getScene().currentDesignResolution
    m.uiRes = uiRes

    m.player = m.top.findNode("VideoPlayerChromeless")

    ' 500 stands for width of verizon configuration
    width = m.uiRes.width - 500
    ' 85 stands for height of THEO logo and background
    height = m.uiRes.height - 85
    m.playerRect = {
        width: width,
        height: height,
        x: 0,
        y: m.uiRes.height - height
    }
    m.player.callFunc("setDestinationRectangle", m.playerRect)
end function

function SetMenusPosition()
    m.buttons = [m.buttonSeekBackward, m.buttonPlay, m.buttonSeekForward]
    buttonsWidth = 0

    for each button in m.buttons
        ' get rid of focus footprint on the buttons
        button.removeChildIndex(1)
    end for

    uiRes = m.top.getScene().currentDesignResolution
    playerRect = m.playerRect
    playerBottomX = playerRect.width + playerRect.x
    playerBottomY = playerRect.height + playerRect.y
    m.groupOptions = m.top.findNode("GroupOptions")
    m.buttonGroupOptions = m.top.findNode("ButtonGroupOptions")
    m.groupOptionsVisible = true
    buttonGroupOptionsRect = m.buttonGroupOptions.boundingRect()
    centerY = playerRect.y + playerRect.height - buttonGroupOptionsRect.height
    centerX = playerRect.x
    m.groupOptions.translation = [centerX, centerY]
    centerX = (playerRect.width - buttonsWidth / 2) / 2

    CenterVideoTime()

    m.optionsBackground = m.top.findNode("OptionsBackground")
    m.optionsBackground.width = playerRect.width
    m.timelineBackground = m.top.findNode("TimelineBackground")
    m.timelineBackground.width = playerRect.width

    m.settingsOptions = m.top.findNode("SettingsOptions")
    m.buttonGroupSettings = m.top.findNode("ButtonGroupSettings")
    settingsRect = m.settingsOptions.boundingRect()
    buttonGroupSettingsRect = m.buttonGroupSettings.boundingRect()
    groupOptionsRect = m.groupOptions.boundingRect()
    centerX = playerBottomX - buttonGroupSettingsRect.x - settingsRect.width - 20
    centerY = playerBottomY - buttonGroupSettingsRect.y - settingsRect.height - 20
    m.settingsOptions.translation = [centerX, centerY ]


    m.categoryFirstOptions = m.top.findNode("CategoryFirstOptions")
    m.categoryFirstBackground = m.top.findNode("CategoryFirstBackground")
    m.buttonGroupCategoryFirst = m.top.findNode("ButtonGroupCategoryFirst")
    SetClosedCaptionsMenuPosition()

    m.categorySecondOptions = m.top.findNode("CategorySecondOptions")
    m.categorySecondBackground = m.top.findNode("CategorySecondBackground")
    m.buttonGroupCategorySecond = m.top.findNode("ButtonGroupCategorySecond")
    SetAudioMenuPosition()
end function

function SetupSkipAdPosition()
    playerRect = m.player.boundingRect()
    skipAdRect = m.skipAdRectangle.boundingRect()

    xOffset = playerRect.x + playerRect.width - skipAdRect.width * 1.5
    yOffset = playerRect.y + playerRect.height - skipAdRect.height * 2
    m.skipAdRectangle.translation = [xOffset, yOffset]
end function

function SetClosedCaptionsMenuPosition()
    playerRect = m.player.boundingRect()
    playerBottomX = playerRect.width + playerRect.x
    playerBottomY = playerRect.height + playerRect.y
    categoryFirstRect = m.categoryFirstOptions.boundingRect()
    categoryFirstButtonGroupRect = m.buttonGroupCategoryFirst.boundingRect()
    centerX = playerBottomX - categoryFirstButtonGroupRect.x - categoryFirstRect.width - 20
    centerY = playerBottomY - categoryFirstButtonGroupRect.y - categoryFirstRect.height - m.categoryFirstHeaderBackground.height - 20
    m.categoryFirstOptions.translation = [centerX, centerY]
    m.categoryFirstBackground.height = categoryFirstRect.height + 30 ' added 30 because radio group shows separator
    if playerRect.x = 0 or playerRect.y = 0 or playerRect.width = m.uiRes.width or playerRect.height = m.uiRes.height then
        m.fullScreen = true
        if m.player.textTracks.count() > 0
            m.buttonCategoryFirst.textColor = "0xFFFFFFFF"
            m.buttonCategoryFirst.focusedTextColor = "0xFFFFFFFF"
        else
            m.buttonCategoryFirst.textColor = "0x666666FF"
            m.buttonCategoryFirst.focusedTextColor = "0x666666FF"
        end if
    else
        m.fullScreen = false
        m.buttonCategoryFirst.textColor = "0x666666FF"
        m.buttonCategoryFirst.focusedTextColor = "0x666666FF"
    end if
end function

function SetAudioMenuPosition()
    playerRect = m.player.boundingRect()
    playerBottomX = playerRect.width + playerRect.x
    playerBottomY = playerRect.height + playerRect.y
    categorySecondOptionsRect = m.categorySecondOptions.boundingRect()
    categorySecondButtonGroupRect = m.buttonGroupCategorySecond.boundingRect()
    centerX = playerBottomX - categorySecondButtonGroupRect.x - categorySecondOptionsRect.width - 20
    centerY = playerBottomY - categorySecondButtonGroupRect.y - categorySecondOptionsRect.height - 20
    m.categorySecondOptions.translation = [centerX, centerY]
    m.categorySecondBackground.height = categorySecondOptionsRect.height
    isNode = Type(m.buttonGroupCategorySecond.content) = "roSGNode"
    if isNode then
        m.buttonCategorySecond.textColor = "0xFFFFFFFF"
        m.buttonCategorySecond.focusedTextColor = "0xFFFFFFFF"
    else
        m.buttonCategorySecond.textColor = "0x666666FF"
        m.buttonCategorySecond.focusedTextColor = "0x666666FF"
    end if
end function

function showSpinner()
    setUpBusySpinnerPosition()
    m.busySpinner.control = "start"
    m.busySpinner.visible = true
end function

function hideSpinner()
    m.busySpinner.visible = false
    m.busySpinner.control = "stop"
end function

' callback for all events fired in THEOplayerSDK, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
function eventCallbackHandler(eventData)
    if eventData.type = m.player.Event.adbreakend OR eventData.type = m.player.Event.adbreakskip
        m.currentAd = Invalid
        m.latestFocusedMenuButton.setFocus(true)
    end if
    if eventData.type = m.player.Event.error
        ? "error Object: "; eventData.errorObject
    end if
    ? "Event <"+eventData.type+">: "; eventData
end function

function callbackOnEventPlayerCanplay(eventData)
    eventCallbackHandler(eventData)
    showSpinner()
end function

function callbackOnEventPlayerDurationchange(eventData)
    eventCallbackHandler(eventData)
    hideSpinner()
end function

function callbackOnEventPlayerPlaying(eventData)
    setUpAdMarkers()
    setUpAssetMarkers()
    hideSpinner()
    eventCallbackHandler(eventData)
end function

function callbackOnEventPlayerSeeked(eventData)
    eventCallbackHandler(eventData)
    hideSpinner()

    SetupSeekingInfo(false)
end function

function callbackOnEventPlayerSeeking(eventData)
    eventCallbackHandler(eventData)
    showSpinner()

    SetupSeekingInfo(true)
end function

function SetupSeekingInfo(seeking as Boolean)
    if m.durationTime = Invalid
        return Invalid
    end if

    seekingInfo = ""
    if seeking = true
        seekingInfo = "seeking"
    end if
    m.seekingInfo = seekingInfo

    isLive = _getIsLive()

    if isLive
        m.durationTime = ""
        m.labelPosition.text = Substitute("{0} {1}", m.currentTime, m.seekingInfo)
    else
        m.labelPosition.text = Substitute("{0} / {1} {2}", m.currentTime, m.durationTime, m.seekingInfo)
    end if

    CenterVideoTime()
end function

function callbackOnEventPlayerSourcechange(eventData)
    showSpinner()
    eventCallbackHandler(eventData)
end function

function callbackOnEventPlayerTimeupdate(eventData)
    eventCallbackHandler(eventData)

    m._dt.FromSeconds(m.player.currentTime)

    tH = m._dt.GetHours().ToStr()
    if Len(tH) = 1
        tH = "0" + tH
    end if
    tM = m._dt.GetMinutes().ToStr()
    if Len(tM) = 1
        tM = "0" + tM
    end if
    tS = m._dt.GetSeconds().ToStr()
    if Len(tS) = 1
        tS = "0" + tS
    end if
    m.currentTime = Substitute("{0}:{1}:{2}", tH, tM, tS)

    isLive = _getIsLive()

    if isLive
        m.durationTime = ""
        m.labelPosition.text = Substitute("{0} {1}", m.currentTime, m.seekingInfo)
    else
        m._dt.FromSeconds(m.player.duration)

        dH = m._dt.GetHours().ToStr()
        if Len(dH) = 1
            dH = "0" + dH
        end if
        dM = m._dt.GetMinutes().ToStr()
        if Len(dM) = 1
            dM = "0" + dM
        end if
        dS = m._dt.GetSeconds().ToStr()
        if Len(dS) = 1
            dS = "0" + dS
        end if
        m.durationTime = Substitute("{0}:{1}:{2}", dH, dM, dS)
        m.labelPosition.text = Substitute("{0} / {1} {2}", m.currentTime, m.durationTime, m.seekingInfo)
    end if

    CenterVideoTime()

    'update movie timeline bar
    if m.player.duration > 0 and m.player.currentTime <= m.player.duration
        m.timelineProgress.width = m.playerRect.width * ( m.player.currentTime / m.player.duration )
    end if
    if m.currentAd <> Invalid
        handleSkipAd(m.player.currentTime)
    end if
end function

function _getIsLive() as Boolean
    sourceExists = (Type(m.player.source) = "roAssociativeArray")
    if not sourceExists
        return False
    end if
    sourceLive = m.player.source.Lookup("live")
    sourceLive = (Type(sourceLive) = "roBoolean" and sourceLive = True)
    return sourceLive
end function

function handleSkipAd(position)
    if m.skipAdRectangle.visible = false or m.buttonSkipAd.hasFocus() = false
        ad = GetNestedValue(m.player.verizonMedia, ["ads", "currentAdBreak"])
        adStartTime = ad.startTime
        adEndTime = ad.endTime
        adSkipOffset = ad.skipOffset

        if adSkipOffset = Invalid
            adSkipOffset = -1
        end if

        if adSkipOffset = -1
            skippable = false
        else if adSkipOffset = 0
            skippable = true
        else if adSkipOffset < position - adStartTime
            skippable = true
        else
            skippable = false
        end if
        if m.skippingAd = false
            m.buttonSkipAd.setFocus(true)
        end if
        if skippable and position < adEndTime and m.seekingInfo <> "seeking"
            m.skipAdRectangle.visible = true
        end if
    end if
end function

function callbackOnEventPlayerVerizonAdbegin(eventData)
    hideOptions()
    eventCallbackHandler(eventData)
end function

function callbackOnEventPlayerVerizonPreplayresponse(eventData)
    eventCallbackHandler(eventData)
    hideSpinner()
    OnEventPlay()
    setUpAdMarkers()
    setUpAssetMarkers()
end function

function CenterVideoTime()
    labelRect = m.labelPosition.boundingRect()
    rect = m.groupOptions.boundingRect()
    buttonGroupRect = m.ButtonGroupOptions.boundingRect()
    x = buttonGroupRect.width + 20
    y = buttonGroupRect.height / 2 - labelRect.height / 2
    m.labelPosition.translation = [x, y]
end function

function destroy()
    m.player.callFunc("destroy")
    m.player = Invalid
end function

function show(fireBeacon as Boolean, adMarkers=false)
    source = {
        "sources": [
            {
                "assetType": "asset",
                "contentProtected": false,
                "id":[
                    "41afc04d34ad4cbd855db52402ef210e",
                    "c6b61470c27d44c4842346980ec2c7bd",
                    "588f9d967643409580aa5dbe136697a1",
                    "b1927a5d5bd9404c85fde75c307c63ad",
                    "7e9932d922e2459bac1599938f12b272",
                    "a4c40e2a8d5b46338b09d7f863049675",
                    "bcf7d78c4ff94c969b2668a6edc64278"
                ],
                "integration": "verizon-media",
                "preplayParameters": {
                    "ad": "adtest",
                    "ad.lib": "15_sec_spots"
                }
            }
        ]
    }
    showSpinner()

    m.player.source = source

    m.player.configuration = {
        "verizonMedia": {
            "onSeekOverAd": "play-all", 'available values: "play-none", "play-all", "play-last"
            "ui": {
                "contentNotification": false,
                "adNotification": false,
                "assetMarkers": false,
                "adBreakMarkers": false,
            },
            "defaultSkipOffset": 6
        },
        ' license field needs to be filled in order to run THEOplayerSDK
        "license": ""
    }
    m.buttonPlay.setFocus(true)
    if not _getIsLive()
        OnEventPlay()
    end if
    if fireBeacon then
        m.top.signalBeacon("AppLaunchComplete")
    end if
end function

function hideOptions()
    if m.groupOptionsVisible = true
        m.optionsBarAnimationFadeOut.control = "start"
        m.groupOptionsVisible = false
        hideCategoryFirst()
        hideCategorySecond()
        hideSettings()
    end if
end function

function showOptions()
    if m.skippingAd = true
        m.skippingAd = false
        return Invalid
    end if
    if m.groupOptionsVisible = false
        m.optionsBarAnimationFadeIn.control = "start"
        m.groupOptionsVisible = true
    end if
    m.hideOptionsTimer.control = "stop"
    m.hideOptionsTimer.control = "start"

    OptionsFocusedOut = m.buttonGroupOptions.isInFocusChain() = false
    settingsFocusedOut = m.settingsOptions.isInFocusChain() = false
    firstCategoryFocusedOut = m.categoryFirstOptions.isInFocusChain() = false
    firstCategoryFocusedOut = m.categorySecondOptions.isInFocusChain() = false
    verizonConfigurationFocusedOut = m.VerizonConfiguration.isInFocusChain() = false
    skipAdInfocus = m.skipAdRectangle.isInFocusChain() = true

    if OptionsFocusedOut and verizonConfigurationFocusedOut and not skipAdInfocus
        m.latestFocusedMenuButton.setFocus(true)
    end if
end function

function showCategoryFirst()
    hideSettings()
    m.categoryFirstOptions.visible = true
    m.buttonGroupCategoryFirst.setFocus(true)
end function

function hideCategoryFirst()
    if  m.categoryFirstOptions.visible = true
        m.categoryFirstOptions.visible = false
        showSettings()
    end if
end function

function showCategorySecond()
    hideSettings()
    m.categorySecondOptions.visible = true
    m.categorySecondButtonFirst.setFocus(true)
end function

function hideCategorySecond()
    if m.categorySecondOptions.visible = true
        m.categorySecondOptions.visible = false
        showSettings()
    end if
end function

function showSettings()
    m.settingsOptions.visible = true
    m.buttonCategoryFirst.setFocus(true)
end function

function hideSettings()
    if m.settingsOptions.visible = true
        m.settingsOptions.visible = false
        m.buttonSettings.setFocus(true)
    end if
end function

function OnEventPlay()
    if m.player.paused
        m.player.callFunc("play")
        m.playIcon.uri = "pkg:/images/pause.png"
    else
        m.player.callFunc("pause")
        m.playIcon.uri = "pkg:/images/play.png"
    end if
end function

function OnEventPause()
    m.player.callFunc("pause")
end function

function OnEventStop()
    m.player.source = Invalid
end function

function OnEventSeekBackward()
    if m.player.source = Invalid
        return Invalid
    end if
    if m.player.currentTime = Invalid
        return Invalid
    end if

    newTime = m.player.currentTime - 30
    m.player.currentTime = newTime
end function

function OnEventSeekForward()
    if m.player.source = Invalid
        return Invalid
    end if

    if m.player.currentTime = Invalid
        return Invalid
    end if
    if m.player.duration = Invalid
        return Invalid
    end if

    newTime = m.player.currentTime + 30
    if newTime > m.player.duration
        newTime = m.player.duration
    end if

    m.player.currentTime = newTime
end function

function OnEventButtonGroupOptionsFocusedChildChanged()
    if m.groupOptions.focusedChild <> Invalid
        m.latestFocusedMenuButton = m.groupOptions.focusedChild
        if m.latestFocusedMenuButton.id = "ButtonGroupOptions"
            m.latestFocusedMenuButton = m.buttonPlay
        end if
    end if
end function

function OnEventCategoryFirst()
    isNode = Type(m.buttonGroupCategoryFirst.content) = "roSGNode"
    if isNode and m.fullScreen
        m.settingsOptions.visible = false
        m.categoryFirstOptions.visible = true
        m.buttonGroupCategoryFirst.setFocus(true)
    end if
end function

function OnEventCategorySecond()
    isNode = Type(m.buttonGroupCategorySecond.content) = "roSGNode"
    if isNode
        m.settingsOptions.visible = false
        m.categorySecondOptions.visible = true
        m.buttonGroupCategorySecond.setFocus(true)
    end if
end function

function onEventAudioTracksChanged()
    list = createObject("RoSGNode","ContentNode")
    option = list.createChild("ContentNode")
    option.title = "default"
    option.description = "default"
    option.id = ""
    checkedItem = 0
    index = 1
    for each track in m.player.audioTracks
        option = list.createChild("ContentNode")
        option.id = track.id
        option.title = track.label
        option.description = track.language
        if track.enabled then
            checkedItem = index
        end if
        index +=1
    end for

    optionsCount = 0
    if Type(m.buttonGroupCategorySecond.content) <> "roInvalid" then
        optionsCount = m.buttonGroupCategorySecond.content.count()
    end if
    if list.count() <> optionsCount then
        m.buttonGroupCategorySecond.content = list
        m.buttonGroupCategorySecond.checkedItem = checkedItem
        setAudioMenuPosition()
    end if
end function

function onEventTextTracksChanged()
    list = createObject("RoSGNode","ContentNode")
    option = list.createChild("ContentNode")
    option.title = "default"
    option.description = "default"
    option.id = ""
    checkedItem = 0
    index = 1
    for each track in m.player.textTracks
        if track.kind = "captions"
            option = list.createChild("ContentNode")
            option.title = track.label
            option.description = track.language
            option.id = track.id
            if track.mode = "showing" then
                checkedItem = index
            end if
            index +=1
        end if
    end for

    optionsCount = 0
    if Type(m.buttonGroupCategoryFirst.content) <> "roInvalid" then
        optionsCount = m.buttonGroupCategoryFirst.content.count()
    end if
    if list.count() <> optionsCount then
        m.buttonGroupCategoryFirst.content = list
        m.buttonGroupCategoryFirst.checkedItem = checkedItem
        setClosedCaptionsMenuPosition()
    end if
end function

function onEventVerizonMediaChanged()
    currentAdBreak = GetNestedValue(m.player.verizonMedia, ["ads", "currentAdBreak"])
    if currentAdBreak <> Invalid
        m.currentAd = currentAdBreak
    else
        m.currentAd = Invalid
        if m.VerizonConfiguration.isInFocusChain() <> true
            m.latestFocusedMenuButton.setFocus(true)
        end if
        m.skipAdRectangle.visible = false
    end if

end function

function OnEventSettings()
    if m.settingsOptions.visible = false
        m.settingsOptions.visible = true
        m.buttonCategoryFirst.setFocus(true)
    else
        m.settingsOptions.visible = false
    end if
end function

function OnEventSkipAd()
    m.skippingAd = true
    m.player.callFunc("skipAds")
    m.skipAdRectangle.visible = false
    m.latestFocusedMenuButton.setFocus(true)
end function

function OnSeekForwardFocusChange()
    if m.settingsOptions.visible = true
           m.settingsOptions.visible = false
    end if
end function

function OnEventCategoryFirstFocusedItem()
    showOptions()
end function

function setCaptionsLanguage(language as String)
    textTracks =  m.player.textTracks
    for i =  textTracks.count() - 1 to 0 step -1
        if textTracks[i].kind = "captions" and textTracks[i].language = language then
            if m.fullScreen then
                textTracks[i].mode = "showing"
            else
                textTracks[i].mode = "hidden"
            end if
        else
            textTracks[i].mode = "disabled"
        end if
    end for
    'assigment of new roAssociativeArray is required because roku deep-copied roAssociativeArray through fields (pass-by-value)
    'read more : https://developer.roku.com/en-gb/docs/developer-program/performance-guide/optimization-techniques.md#OptimizationTechniques-DataFlow
    m.player.textTracks = textTracks
end function

function OnEventCategoryFirstSelectedItem()
    if m.player.instance <> Invalid
        itemIndex = m.buttonGroupCategoryFirst.checkedItem
        item = m.buttonGroupCategoryFirst.content.getChild(itemIndex)
        setCaptionsLanguage(item.description)
    end if
end function

function OnEventCategorySecondFocusedItem()
    showOptions()
end function

function setAudioTrack(language as String)
    audioTracks =  m.player.audioTracks
    for i =  audioTracks.count() - 1 to 0 step -1
        if audioTracks[i].language = language then
            audioTracks[i].enabled = true
        else
            audioTracks[i].enabled = false
        end if
    end for
    'required because roku deep-copied roAssociativeArray through fields (pass-by-value)
    'read more : https://developer.roku.com/en-gb/docs/developer-program/performance-guide/optimization-techniques.md#OptimizationTechniques-DataFlow
    m.player.audioTracks = audioTracks
end function

function OnEventCategorySecondSelectedItem()
    if m.player.instance <> Invalid
        itemIndex = m.buttonGroupCategorySecond.checkedItem
        item = m.buttonGroupCategorySecond.content.getChild(itemIndex)
        setAudioTrack(item.description)
    end if
end function

function onVerizonConfigurationChanged()
    m.player.callFunc("pause")
    m.player.source = Invalid
    m.currentVerizonTab = m.VerizonConfiguration.currentTab
    configuration = m.player.configuration
    m.playIcon.uri = "pkg:/images/play.png"

    showSpinner()

    source = m.VerizonConfiguration.source
    verizonConfiguration = m.VerizonConfiguration.configuration
    configuration.verizonMedia = verizonConfiguration

    m.player.source = source
    m.player.configuration = configuration
end function

function OnKeyEvent(key, press) as Boolean
    handled = false
    showOptions()
    if press
        if key = "options"
        else if press and key = "play"
            if m.player.ended = false and m.player.paused = true
                m.player.callFunc("play")
            end if
            if m.player.currentTime = 0 and m.player.paused = false
                m.player.callFunc("play")
            end if
            if m.player.ended = false and m.player.paused = false and m.player.currentTime <> 0
                m.player.callFunc("pause")
            end if
            handled = true
        else if press and key = "fastforward"
            handled = true
            OnEventSeekForward()
        else if press and key = "rewind"
            handled = true
            OnEventSeekBackward()
        else if press and key = "replay"
            handled = true
            if m.player.source <> Invalid and m.player.currentTime <> Invalid
                newTime = m.player.currentTime - 20
                m.player.currentTime = newTime
            end if
        else if m.player.visible = true and key = "back"
            ' Settings Menu opened
            if m.settingsOptions.visible = true
                hideSettings()
                handled = true
            ' category 1 Menu opened
            else if m.categoryFirstOptions.visible = true then
                hideCategoryFirst()
                handled = true
            ' category 2 Menu opened
            else if m.categorySecondOptions.visible = true then
                hideCategorySecond()
                handled = true
            else
                m.labelPosition.text = "00:00:00 / 00:00:00"
                m.player.source = Invalid
            end if
        else if key = "up"
            if m.settingsOptions.visible = true and m.buttonCategoryFirst.hasFocus() = true
                hideSettings()
                m.buttonSeekForward.setFocus(true)
                handled = true
            ' category 1 Menu opened
            ' else if m.categoryFirstOptions.visible = true and m.buttonGroupCategoryFirst.hasFocus() = true then
            '     hideCategoryFirst()
            '     handled = true
            ' category 2 Menu opened
            else if m.categorySecondOptions.visible = true and m.categorySecondButtonFirst.hasFocus() = true then
                hideCategorySecond()
                handled = true
            end if
        else if key = "down"
            if m.buttonSeekForward.hasFocus()
                m.VerizonConfiguration.callFunc("manageFocus")
            end if
        else if key = "right"
            if m.buttonSeekForward.hasFocus()
                m.VerizonConfiguration.callFunc("manageFocus")
            else if m.ButtonGroupOptions.isInFocusChain()
                if m.buttons.count() > 0
                    for i = 0 to m.buttons.count() - 1
                        button = m.buttons[i]
                        if button.id = m.ButtonGroupOptions.focusedChild.id
                            buttonToFocus = m.buttons[i+1]
                            if buttonToFocus <> Invalid
                                buttonToFocus.setFocus(true)
                                exit for
                            end if
                        end if
                    end for
                end if
            end if
        else if key = "left"
            if m.ButtonGroupOptions.isInFocusChain()
                if m.buttons.count() > 0
                    for i = 0 to m.buttons.count() - 1
                        button = m.buttons[i]
                        if button.id = m.ButtonGroupOptions.focusedChild.id
                            buttonToFocus = m.buttons[i-1]
                            if buttonToFocus <> Invalid
                                buttonToFocus.setFocus(true)
                                exit for
                            end if
                        end if
                    end for
                end if
            end if
        end if
    end if

    return handled
end function
