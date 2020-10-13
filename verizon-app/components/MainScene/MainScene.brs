function Init()
    SetupUI()

    SetupObservers()

    SetupDeeplinks()
end function

function SetupUI()
    m.buttonChromeless = m.top.findNode("ButtonChromeless")
    m.buttonChromefull = m.top.findNode("ButtonChromefull")
    m.buttonGroupOptions = m.top.findNode("buttonGroupOptions")
    m.theoSDKComponentLibrary = m.top.findNode("THEOsdk")
    m.theoSDKComponentLibrary.observeField("loadStatus", "onComponentLibraryLoadStatusChanged")
    m.THEOsdkLoaded = false

    m.buttons = [m.buttonChromeless, m.buttonChromefull]
    buttonsWidth = 0
    for each button in m.buttons
        ' get rid of focus footprint on the buttons
        button.removeChildIndex(1)

        buttonsWidth += button.minWidth
    end for
    uiRes = m.top.currentDesignResolution
    'center buttons'
    m.groupPlayerConfig = m.top.findNode("GroupPlayerConfig")
    centerX = (uiRes.width - buttonsWidth) / 2
    centerY = (uiRes.height - m.buttonChromeless.height) - 50
    m.groupPlayerConfig.translation = [centerX, centerY]

    m.buttonChromeless.setFocus(true)
    m.integration = "verizon-media"
end function

function onComponentLibraryLoadStatusChanged()
    if m.theoSDKComponentLibrary.loadStatus = "ready"
        m.THEOsdkLoaded = true
        ? "component library is loaded properly"
    else if m.theoSDKComponentLibrary.loadStatus = "failed"
        m.THEOsdkLoaded = false
        ? "failed to load component library, please check URL."
    end if
end function

function SetupObservers()
    m.buttonChromeless.observeField("buttonSelected", "OnEventChromeless")
    m.buttonChromefull.observeField("buttonSelected", "OnEventChromefull")
end function

function SetupDeeplinks()
    'handling deep link from url, while app is running
    m.taskInput = createObject("roSgNode", "TaskInput")
    m.taskInput.observefield("data", "OnTaskInput")
    m.taskInput.control = "RUN"

    'handling deep link passed from Main.brs
    if m.global.deeplink <> invalid then
        handleDeepLink(m.global.deeplink, true)
    else
        m.top.signalBeacon("AppLaunchComplete")
    end if
end function

function handleDeepLink(deepLink, fireBeacon)
    if deepLink.contentID = "chromeless" then
        OnEventChromeless(fireBeacon)
    else deepLink.contentID = "chromefull"
        OnEventChromefull(fireBeacon)
    end if
end function

function OnEventChromeless(fireBeacon = false as Boolean)
    if m.THEOsdkLoaded
        m.groupChromeless = CreateObject("roSGNode", "ChromelessView")
        m.top.appendChild(m.groupChromeless)
        m.groupPlayerConfig.visible = false
        m.groupChromeless.callFunc("show", fireBeacon, false)
    else
        ? "Failed to load THEOsdk, please make sure that THEOsdk is present at 'pkg:/components/THEOplayerSDK.pkg'"
    end if
end function

function OnEventChromefull(fireBeacon = false as Boolean)
    if m.THEOsdkLoaded
        m.groupChromefull = CreateObject("roSGNode", "ChromefullView")
        m.top.appendChild(m.groupChromefull)

        m.groupPlayerConfig.visible = false
        m.groupChromefull.callFunc("show", fireBeacon, true)
    else
        ? "Failed to load THEOsdk, please make sure that THEOsdk is present at 'pkg:/components/THEOplayerSDK.pkg'"
    end if
end function

function OnTaskInput()
    if m.taskInput.data <> invalid then
        handleDeepLink(m.taskInput.data, false)
    end if
end function

' Main Remote keypress event loop
function OnKeyEvent(key, press) as Boolean
    handled = false
    if press
        if key = "options"
        else if m.groupPlayerConfig.visible = false and key = "back"
            if m.groupChromeless <> Invalid
                m.groupChromeless.callFunc("destroy")
                m.top.removeChild(m.groupChromeless)
                m.groupChromeless = Invalid
            end if
            if m.groupChromefull <> Invalid
                m.groupChromefull.callFunc("destroy")
                m.top.removeChild(m.groupChromefull)
                m.groupChromefull = Invalid
            end if
            m.groupPlayerConfig.visible = true
            m.buttonChromeless.setFocus(true)
            handled = true
        else if key = "right"
            if m.buttonGroupOptions.isInFocusChain()
                if m.buttons.count() > 0
                    for i = 0 to m.buttons.count() - 1
                        button = m.buttons[i]
                        if button.id = m.buttonGroupOptions.focusedChild.id
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
            if m.buttonGroupOptions.isInFocusChain()
                if m.buttons.count() > 0
                    for i = 0 to m.buttons.count() - 1
                        button = m.buttons[i]
                        if button.id = m.buttonGroupOptions.focusedChild.id
                            buttonToFocus = m.buttons[i-1]
                            if buttonToFocus <> Invalid
                                buttonToFocus.setFocus(true)
                            end if
                            exit for
                        end if
                    end for
                end if
            end if
        end if
    end if

    return handled

end function
