' Function is automatically called every time when new instance of main scene component is created, function will follow below steps: <br/>
' creates loval variables</br>
' sets observers for pressing butotns</br>
' center buttons</br>
' create inputTask component to handle deep link events while reference app is running</br>
' handle deep link parameters if reference app was started through deep link</br>
'
' @since version 1.0.0
Function Init()
    m.THEOsdkLoaded = false
    m.buttonChromeless = m.top.findNode("ButtonChromeless")
    m.buttonChromefull = m.top.findNode("ButtonChromefull")
    m.buttonGroupOptions = m.top.findNode("buttonGroupOptions")

    m.top.observeField("eventChromeless", "OnEventChromeless")
    m.top.observeField("eventChromefull", "OnEventChromefull")

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

    'handling deep link from url, while app is running
    m.inputTask = createObject("roSgNode", "inputTask")
    m.inputTask.observefield("data", "OnInputTask")
    m.inputTask.control = "RUN"

    'handling deep link passed from Main.brs
    if m.global.deeplink <> invalid then
        handleDeepLink(m.global.deeplink, true)
    else
        m.top.signalBeacon("AppLaunchComplete")
    end if
    m.theoSDKComponentLibrary = m.top.findNode("THEOsdk")
	m.theoSDKComponentLibrary.observeField("loadStatus", "onComponentLibraryLoadStatusChanged")
End Function

function onComponentLibraryLoadStatusChanged()
    if m.theoSDKComponentLibrary.loadStatus = "ready"
        m.THEOsdkLoaded = true
		? "component library is loaded properly"
    else if m.theoSDKComponentLibrary.loadStatus = "failed"
        m.THEOsdkLoaded = false
		? "failed to load component library, please check URL."
	end if
end function

' handle deep link parameters if reference app was started through deep link</br>
' function will opens chromefull or chromeless component depends on parameters passed in deep link
'
' @param deepLink roAssociativeArray - deep link parameters object
' @param fireBeacon boolean - whenever fire beacon should be fired inside chromeless and chromefull components
' @since version 1.0.0
sub handleDeepLink(deepLink, fireBeacon as Boolean)
    if deepLink.contentID = "chromeless"
        OnEventChromeless(fireBeacon)
    else if deepLink.contentID = "chromefull"
        OnEventChromefull(fireBeacon)
    end if
end sub

' creates instance of chromeless player, and shows it on screen
'
' @param fireBeacon boolean - whenever fire beacon should be fired inside chromeless components
' @since version 1.0.0
sub OnEventChromeless(fireBeacon = false as Boolean)
    if m.THEOsdkLoaded
        m.groupChromeless = CreateObject("roSGNode", "ChromelessView")
        m.top.appendChild(m.groupChromeless)

        m.groupPlayerConfig.visible = false
        m.groupChromeless.callFunc("show", fireBeacon)
    else
        ? "Failed to load THEOsdk, please make sure that THEOsdk is present at 'pkg:/components/THEOplayerSDK.pkg'"
    end if
end sub

' creates instance of chromefull player, and shows it on screen
'
' @param fireBeacon boolean - whenever fire beacon should be fired inside chromefull components
' @since version 1.0.0
sub OnEventChromefull(fireBeacon = false as Boolean)
    if m.THEOsdkLoaded
        m.groupChromefull = CreateObject("roSGNode", "ChromefullView")
        m.top.appendChild(m.groupChromefull)

        m.groupPlayerConfig.visible = false
        m.groupChromefull.callFunc("show", fireBeacon)
    else
        ? "Failed to load THEOsdk, please make sure that THEOsdk is present at 'pkg:/components/THEOplayerSDK.pkg'"
    end if
end sub

' handles incoming deep link event
'
' @since version 1.0.0
sub OnInputTask()
    if m.inputTask.data <> invalid then
        handleDeepLink(m.inputTask.data, false)
    end if
end sub

' Main Remote keypress event loop,
' handles remote buttons events in main scene
'
' @since version 1.0.0
Function OnKeyEvent(key, press) as Boolean
    handled = false
    if press
        if key = "options"
        else if m.groupPlayerConfig.visible = false and key = "back"
            m.groupPlayerConfig.visible = true
            m.buttonChromeless.setFocus(true)
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
            handled = true
        else if key = "right"
            if m.buttonGroupOptions.isInFocusChain()
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
        else if key = "left"
            if m.buttonGroupOptions.isInFocusChain()
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

    return handled

End Function
