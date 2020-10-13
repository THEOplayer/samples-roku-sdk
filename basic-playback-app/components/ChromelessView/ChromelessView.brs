' Function is automatically called every time when new instance of chromeless component is created <br/>
' function will call following methods: </br>
' SetupUI,
' SetupObservers,
' SetupEventListeners</br>
'
' @since version 1.0.0
function Init()
    SetupUI()
    SetupObservers()
    SetupEventListeners()
    m.player.callFunc("setCopyGuardManagementSystem", 2)
    m._dt = CreateObject("roDateTime")
end function

' Function sets local variables containing component scene graph nodes,
' function will call SetupPlayerPosition and SetMenusPosition methods
'
' @since version 1.0.0
function SetupUI()
    m.buttonPlay = m.top.findNode("ButtonPlay")
    m.buttonPause = m.top.findNode("ButtonPause")
    m.buttonSeekBackward = m.top.findNode("ButtonSeekBackward")
    m.buttonSeekForward = m.top.findNode("ButtonSeekForward")
    m.buttonStop = m.top.findNode("ButtonStop")
    m.buttonSettings = m.top.findNode("ButtonSettings")
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

    ' license field needs to be filled in order to run THEOplayerSDK
    m.player.configuration = {
        "license": ""
    }

    m.timelineProgress.width = 1

    m.seekingInfo = ""

    m.player.callFunc("setMaxVideoResolution", 1920, 1080)

    SetupPlayerPosition()
    SetMenusPosition()
end function

' Function will set component internal observers (button press etc.) along with player fields observer
'
' @since version 1.0.0
function SetupObservers()
    m.player.observeField("audioTracks","onEventAudioTracksChanged")
    m.player.observeField("textTracks","onEventTextTracksChanged")

    m.buttonPlay.observeField("buttonSelected", "OnEventPlay")
    m.buttonPause.observeField("buttonSelected", "OnEventPause")
    m.buttonSeekBackward.observeField("buttonSelected", "OnEventSeekBackward")
    m.buttonSeekForward.observeField("buttonSelected", "OnEventSeekForward")
    m.buttonSeekForward.observeField("focusedChild", "OnSeekForwardFocusChange")
    m.buttonStop.observeField("buttonSelected", "OnEventStop")
    m.buttonSettings.observeField("buttonSelected", "OnEventSettings")

    m.buttonCategoryFirst.observeField("buttonSelected", "OnEventCategoryFirst")
    m.buttonGroupCategoryFirst.observeField("itemFocused", "OnEventCategoryFirstFocusedItem")
    m.buttonGroupCategoryFirst.observeField("checkedItem", "OnEventCategoryFirstSelectedItem")

    m.buttonCategorySecond.observeField("buttonSelected", "OnEventCategorySecond")
    m.buttonGroupCategorySecond.observeField("itemFocused", "OnEventCategorySecondFocusedItem")
    m.buttonGroupCategorySecond.observeField("checkedItem", "OnEventCategorySecondSelectedItem")

    m.hideOptionsTimer.ObserveField("fire","hideOptions")
end function

' Function will add event listeners to THEOplayer instance and sets listener to player
'
' @since version 1.0.0
function SetupEventListeners()
    m.player.listener = m.top

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
    m.player.callFunc("addEventListener", m.player.Event.seeked, "callbackOnEventPlayerSeeked")
    m.player.callFunc("addEventListener", m.player.Event.seeking, "callbackOnEventPlayerSeeking")
    m.player.callFunc("addEventListener", m.player.Event.sourcechange, "eventCallbackHandler")
    m.player.callFunc("addEventListener", m.player.Event.timeupdate, "callbackOnEventPlayerTimeupdate")
end function

' Function sets THeoplayer position in the middle of screen
'
' @since version 1.0.0
function SetupPlayerPosition()
    uiRes = m.top.getScene().currentDesignResolution
    m.uiRes = uiRes
    ' center video time'
    rect = m.labelPosition.boundingRect()
    centerX = (m.uiRes.width - rect.width) / 2
    m.labelPosition.translation = [centerX, 30]
    ' center video'
    m.player = m.top.findNode("VideoPlayerChromeless")

    m.playerRect = {
        width: 1280,
        height: 720,
        x: (m.uiRes.width - 1280) / 2,
        y: (m.uiRes.height - 720) / 2
    }
    ' to enable fullscrean mode please uncomment bellow m.playerRect definition and comment the earlier definition
    ' m.playerRect = {
    '     width: 0,
    '     height: 0,
    '     x: 0,
    '     y: 0
    ' }

    m.player.callFunc("setDestinationRectangle", m.playerRect)
end function

' Function sets positions of menu elements to fit nicely into player.
'
' @since version 1.0.0
function SetMenusPosition()
    m.buttons = [m.buttonSeekBackward, m.buttonPlay, m.buttonPause, m.buttonStop, m.buttonSeekForward, m.buttonSettings]
    buttonsWidth = 0

    for each button in m.buttons
        ' get rid of focus footprint on the buttons
        button.removeChildIndex(1)

        ' -20 because of buttons ovelaping and scale
        buttonsWidth += button.minWidth - 20
    end for

    uiRes = m.top.getScene().currentDesignResolution
    ' center video time'
    CenterVideoTime()
    ' center video'
    if m.playerRect.width = 0
        m.playerRect = m.player.boundingRect()
    end if
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
    m.buttonGroupOptions.translation = [centerX, 3]

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

' Function sets positions of closed captions menu elements to fit nicely into player.
'
' @since version 1.0.0
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

' Function sets positions of audio menu elements to fit nicely into player.
'
' @since version 1.0.0
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

' callback for all events fired in THEOplayerSDK, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
function eventCallbackHandler(eventData)
    ? "Event <"+eventData.type+">: "; eventData
end function

' callback for seeked event, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
function callbackOnEventPlayerSeeked(eventData)
    eventCallbackHandler(eventData)

    SetupSeekingInfo(false)
end function

' callback for seeking event, displays event name and data
'
' @param eventData object - contains event data
' @since version 1.0.0
function callbackOnEventPlayerSeeking(eventData)
    eventCallbackHandler(eventData)

    SetupSeekingInfo(true)
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

' function sets labels proper text and sets proper timeline positions and width
'
' @param seeking boolean - whenever player is in seeking state
' @since version 1.0.0
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
        m.labelPosition.text = Substitute("{0} {1}", m.currentTime, m.seekingInfo)
    else
        m.labelPosition.text = Substitute("{0} / {1} {2}", m.currentTime, m.durationTime, m.seekingInfo)
    end if

    CenterVideoTime()
end function

' callback for time update event, displays event name and data</br>
' sets proper timeline positions and width and labels proper text
'
' @param eventData object - contains event data
' @since version 1.0.0
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
end function

' function sets time progress label proper position
'
' @since version 1.0.0
function CenterVideoTime()
    uiRes = m.top.getScene().currentDesignResolution
    rect = m.labelPosition.boundingRect()
    centerX = (uiRes.width - rect.width) / 2
    m.labelPosition.translation = [centerX, 50]
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

' function which shows chromeless component, calls signal Beacon if deeplink was passed
'
' @since version 1.0.0
function show(fireBeacon as Boolean)
    setSource()
    m.buttonPlay.setFocus(true)
    if fireBeacon then
        m.top.signalBeacon("AppLaunchComplete")
    end if
    m.player.callFunc("play")
end function

' function sets source if was not yet set and calls play method of THEOplayer
'
' @since version 1.0.0
function OnEventPlay()
    if m.player.source = Invalid
        setSource()
    end if

    m.player.callFunc("play")
end function

' function hides navigation bar along with all sub menus
'
' @since version 1.0.0
function hideOptions()
    if m.groupOptionsVisible = true
        m.optionsBarAnimationFadeOut.control = "start"
        m.groupOptionsVisible = false
        hideCategoryFirst()
        hideCategorySecond()
        hideSettings()
    end if
end function

' function shows nav bar and starts timer which will hide options after defined time of user inactivity
'
' @since version 1.0.0
function showOptions()
    if m.groupOptionsVisible = false
        m.optionsBarAnimationFadeIn.control = "start"
        m.groupOptionsVisible = true
    end if
    m.hideOptionsTimer.control = "stop"
    m.hideOptionsTimer.control = "start"
end function

' function shows first category menu - closed captions menu
'
' @since version 1.0.0
function showCategoryFirst()
    hideSettings()
    m.categoryFirstOptions.visible = true
    m.buttonGroupCategoryFirst.setFocus(true)
end function

' function hides first category menu - closed captions menu
'
' @since version 1.0.0
function hideCategoryFirst()
    if  m.categoryFirstOptions.visible = true
        m.categoryFirstOptions.visible = false
        showSettings()
    end if
end function

' function shows second category menu - audio tracks menu
'
' @since version 1.0.0
function showCategorySecond()
    hideSettings()
    m.categoryFirstOptions.visible = true
    m.categorySecondButtonFirst.setFocus(true)
end function

' function hides second category menu - audio tracks menu
'
' @since version 1.0.0
function hideCategorySecond()
    if m.categorySecondOptions.visible = true
        m.categorySecondOptions.visible = false
        showSettings()
    end if
end function

' function shows settings menu
'
' @since version 1.0.0
function showSettings()
    m.settingsOptions.visible = true
    m.buttonCategoryFirst.setFocus(true)
end function

' function hides settings menu
'
' @since version 1.0.0
function hideSettings()
    if m.settingsOptions.visible = true
        m.settingsOptions.visible = false
        m.buttonSettings.setFocus(true)
    end if
end function

' function will be executed when pause button will be pressed from navigation bar
'
' @since version 1.0.0
function OnEventPause()
    m.player.callFunc("pause")
end function

' function will be executed when stop button will be pressed from navigation bar
'
' @since version 1.0.0
function OnEventStop()
    m.player.source = Invalid
end function

' function will be executed when seek backward button will be pressed from navigation bar. current time will be reduced by 60 s
'
' @since version 1.0.0
function OnEventSeekBackward()
    if m.player.source = Invalid
        return Invalid
    end if
    if m.player.currentTime = Invalid
        return Invalid
    end if

    newTime = m.player.currentTime - 60
    m.player.currentTime = newTime
end function

' function will be executed when fast forward button will be pressed from navigation bar. current time will be magnified by 60 s
'
' @since version 1.0.0
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

    newTime = m.player.currentTime + 60
    if newTime > m.player.duration
        newTime = m.player.duration
    end if

    m.player.currentTime = newTime
end function

' function will be executed when closed captions will be selected in options menu. Shows closed caption sub menu
'
' @since version 1.0.0
function OnEventCategoryFirst()
    isNode = Type(m.buttonGroupCategoryFirst.content) = "roSGNode"
    if isNode and m.fullScreen
        m.settingsOptions.visible = false
        m.categoryFirstOptions.visible = true
        m.buttonGroupCategoryFirst.setFocus(true)
    end if
end function

' function will be executed when audio tracks will be selected in options menu. Shows audio tracks sub menu
'
' @since version 1.0.0
function OnEventCategorySecond()
    isNode = Type(m.buttonGroupCategorySecond.content) = "roSGNode"
    if isNode
        m.settingsOptions.visible = false
        m.categorySecondOptions.visible = true
        m.buttonGroupCategorySecond.setFocus(true)
    end if
end function

' function will be executed when audio track will be selected, Sets current audio track through THEOplayer api
'
' @since version 1.0.0
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

' function will be executed when caption track will be selected, Sets current text track through THEOplayer api
'
' @since version 1.0.0
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
            option.id = track.id
            option.title = track.label
            option.description = track.language
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

' function will be executed when options button will be displayed,
'
' @since version 1.0.0
function OnEventSettings()
    if m.settingsOptions.visible = false
        m.settingsOptions.visible = true
        m.buttonCategoryFirst.setFocus(true)
    else
        m.settingsOptions.visible = false
    end if
end function

' function will be executed when seek forward button will receive or lost focus,</br>
' if settings menu is still visible function will hide this menu
'
' @since version 1.0.0
function OnSeekForwardFocusChange()
    if m.settingsOptions.visible = true
           m.settingsOptions.visible = false
    end if
end function

' function will be executed when first item in settings menu will receive or lost focus,</br>
' if settings menu is still visible function will hide this menu
'
' @since version 1.0.0
function OnEventCategoryFirstFocusedItem()
    showOptions()
end function

' function sets currently displayed captions using THEOplayer api
'
' @param language string - captions track to be enabled
' @since version 1.0.0
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

' function will be executed when item from closed captions menu will be selected, selected captions track will be set to showing using setCaptionsLanguage function
'
' @since version 1.0.0
function OnEventCategoryFirstSelectedItem()
    if m.player <> Invalid
        itemIndex = m.buttonGroupCategoryFirst.checkedItem
        item = m.buttonGroupCategoryFirst.content.getChild(itemIndex)
        setCaptionsLanguage(item.description)
    end if
end function

' calls showsOptions function
'
' @since version 1.0.0
function OnEventCategorySecondFocusedItem()
    showOptions()
end function

' Function will set curent audio track using THEOplayer api
'
' @param label string - audio track to be enabled
' @since version 1.0.0
function setAudioTrack(language as String)
    if m.player <> Invalid
        audioTracks =  m.player.audioTracks
        for i =  audioTracks.count() - 1 to 0 step -1
            if audioTracks[i].language = language
                audioTracks[i].enabled = True
            else
                audioTracks[i].enabled = False
            end if
        end for
        'required because roku deep-copied roAssociativeArray through fields (pass-by-value)
        'read more : https://developer.roku.com/en-gb/docs/developer-program/performance-guide/optimization-techniques.md#OptimizationTechniques-DataFlow
        m.player.audioTracks = audioTracks
    end if
end function

' function will be executed when item from audio menu will be selected, selected audio track will be set to showing using setAudioTrack function
'
' @since version 1.0.0
function OnEventCategorySecondSelectedItem()
    itemIndex = m.buttonGroupCategorySecond.checkedItem
    item = m.buttonGroupCategorySecond.content.getChild(itemIndex)
    setAudioTrack(item.description)
end function

' function which will be executed every time when remote button will be pressed, function is responsible for:</br>
' reseting timer (responsible for hiding navigation bar and options menus)</br>
' handling play, fast forward, seek back, instant reply, back remote buttons</br>
' navigating through navigation bar option menu and sub menus</br>
'
' @since version 1.0.0
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
        else if key = "right"
            if m.ButtonGroupOptions.isInFocusChain()
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
