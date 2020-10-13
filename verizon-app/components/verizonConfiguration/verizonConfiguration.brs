function Init()
    setupUI()

    initializeAdsMarkupList()
    initializeDrmMarkupList()
    initializeLiveMarkupList()
    m.configurationChanged = false

    m.adsList.observeField("itemSelected", "adItemSelected")
    m.drmList.observeField("itemSelected", "drmItemSelected")
    m.liveList.observeField("itemSelected", "liveItemSelected")
    m.changeSourceTimer.ObserveField("fire","copySource")

    m.lastFocusedList = m.adsList
    m.top.currentTab = "ads"
end function

function setupUI()
    m.screanRect = CreateObject("roDeviceInfo").GetDisplaySize()

    m.theoLogoContainer = m.top.findNode("theoLogoContainer")

    m.changeSourceTimer = m.top.findNode("changeSourceTimer")

    m.verizonLogoContainer = m.top.findNode("verizonLogoContainer")
    m.verizonLogoContainerRect = m.verizonLogoContainer.boundingRect()
    m.verizonLogoVerticalSeparator = m.top.findNode("verizonLogoVerticalSeparator")
    m.verizonLogoHorizontalSeparator = m.top.findNode("verizonLogoHorizontalSeparator")

    m.configurationHeader = m.top.findNode("configurationHeader")
    m.configurationHeader.translation = [0, m.verizonLogoContainerRect.height]
    m.configurationHeaderRect = m.configurationHeader.boundingRect()
    m.drmHeader = m.top.findNode("drmHeader")
    m.adsHeader = m.top.findNode("adsHeader")
    m.liveHeader = m.top.findNode("liveHeader")
    m.headerCursor = m.top.findNode("headerCursor")

    m.drmList = m.top.findNode("drmList")
    m.adsList = m.top.findNode("adsList")
    m.liveList = m.top.findNode("liveList")

    m.drmGroup = m.top.findNode("drmGroup")
    m.adsGroup = m.top.findNode("adsGroup")
    m.liveGroup = m.top.findNode("liveGroup")

    m.top.width = 500
    m.top.lostFocus = "false"
    m.top.height = m.screanRect.h

    m.top.translation = [m.screanRect.w - m.top.width, 0]

    m.verizonLogoVerticalSeparator.height = m.verizonLogoContainerRect.height
    m.verizonLogoHorizontalSeparator.width = m.configurationHeaderRect.width
    m.verizonLogoHorizontalSeparator.translation = [0, m.verizonLogoContainerRect.height]

    m.theoLogoContainer.width =  m.screanRect.w - m.configurationHeaderRect.width
    m.theoLogoContainer.translation =  [-m.screanRect.w + m.top.width, 0]

    m.drmHeader.translation = [0, 40]
    m.adsHeader.translation = [m.drmHeader.width , 40]
    m.liveHeader.translation = [m.drmHeader.width + m.adsHeader.width, 40]
    setActiveTab("ads")

    m.drmGroup.translation = [0, m.configurationHeaderRect.height + m.configurationHeaderRect.y + 80 ]
    m.adsGroup.translation = [0, m.configurationHeaderRect.height + m.configurationHeaderRect.y + 80 ]
    m.liveGroup.translation = [0, m.configurationHeaderRect.height + m.configurationHeaderRect.y + 80 ]
end function

function manageFocus()
    m.lastFocusedList.setFocus(true)
end function

function setActiveTab( kind )
    if kind = "live"
        tabList = m.liveList
        tabHeader = m.liveHeader
    else if kind = "ads"
        tabList = m.adsList
        tabHeader = m.adsHeader
    else if kind = "drm"
        tabList = m.drmList
        tabHeader = m.drmHeader
    end if
    rect = tabHeader.boundingRect()

    m.headerCursor.width = rect.width
    m.headerCursor.translation = [ rect.x, rect.y + rect.height + 15 ]

    m.liveList.unobserveField("focusedChild")
    m.adsList.unobserveField("focusedChild")
    m.drmList.unobserveField("focusedChild")
    tabList.observeField("focusedChild", "restartSourcetTimer")
    m.drmHeader.color = "0x757575FF"
    m.adsHeader.color = "0x757575FF"
    m.liveHeader.color = "0x757575FF"
    tabHeader.color = "0x333333FF"
end function

function initializeAdsMarkupList()
    m.adsConfiguration = [
        {
            "type" : "select",
            "title" : "skip offset",
            "options" : "-1;0;1;2;3;4;5;6;7;8;9;10",
            "value" : "6",
            "HDPosterUrl" : "ssss"
        },
        {
            "type" : "select",
            "title" : "seek over ad",
            "options" : "play-all;play-last;play-none",
            "value" : "play-all"
        },
        {
            "type" : "checkbox",
            "title" : "Coming up notification",
            "options" : "",
            "value" : "false"
        },
        {
            "type" : "checkbox",
            "title" : "Ad notification",
            "options" : "",
            "value" : "false"
        },
        {
            "type" : "checkbox",
            "title" : "Show asset markers",
            "options" : "",
            "value" : "false"
        },
        {
            "type" : "checkbox",
            "title" : "Show ad break markers",
            "options" : "",
            "value" : "false"
        }
    ]
    m.adsList.content = generateMarkupListContent(m.adsConfiguration)
end Function

function initializeDrmMarkupList()
    m.drmConfiguration = [
        {
            "type" : "checkbox",
            "title" : "Coming up notification",
            "options" : "",
            "value" : "false"
        },
        {
            "type" : "checkbox",
            "title" : "Show asset markers",
            "options" : "",
            "value" : "false"
        }
    ]
    m.drmList.content = generateMarkupListContent(m.drmConfiguration)
end Function

function initializeLiveMarkupList()
    m.liveConfiguration = [
        {
            "type" : "checkbox",
            "title" : "Coming up notification",
            "options" : "",
            "value" : "false"
        }
    ]
    m.liveList.content = generateMarkupListContent(m.liveConfiguration)
end Function

function adItemSelected()
    markupListItemSelected(m.adsList, m.adsConfiguration, "ads")
end function

function drmItemSelected()
    markupListItemSelected(m.drmList, m.drmConfiguration, "drm")
end function

function liveItemSelected()
    markupListItemSelected(m.liveList, m.liveConfiguration, "live")
end function

function changeSource(list, dataObj, id)
    configuration = {
        "onSeekOverAd": "play-none", 'available values: "play-none", "play-all", "play-last"
        "ui": {
            "contentNotification": true,
            "adNotification": false,
            "assetMarkers": true,
            "adBreakMarkers": false,
        },
        "defaultSkipOffset": 0,
        "test":[
            "sss",
            "ddd"
        ]
    }
    source = {}

    for each item in dataObj
        if item.title = "Show ad break markers"
            configuration.ui.adBreakMarkers = strToBoolean(item.value)
        else if item.title = "Ad notification"
            configuration.ui.adNotification = strToBoolean(item.value)
        else if item.title = "Show asset markers"
            configuration.ui.assetMarkers = strToBoolean(item.value)
        else if item.title = "Coming up notification"
            configuration.ui.contentNotification = strToBoolean(item.value)
        else if item.title = "seek over ad"
            configuration.onSeekOverAd = item.value
        else if item.title = "skip offset"
            configuration.defaultSkipOffset = StrToI(item.value)
        end if
    end for

    if id = "drm"
        source = {
            "sources": [
                {
                    "assetType": "asset",
                    "contentProtected": true,
                    "id":  [
                        "e973a509e67241e3aa368730130a104d",
                        "e70a708265b94a3fa6716666994d877d"
                    ],
                    "integration": "verizon-media",
                        "preplayParameters":  {
                        "manifest": "mpd"
                    }
                }
            ]
        }
    else if id = "ads"
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
    else if id = "live"
        source = {
            "sources": [
                {
                    "assetType": "channel",
                    "contentProtected": true,
                    "id": "3c367669a83b4cdab20cceefac253684",
                    "integration": "verizon-media",
                    "preplayParameters": {
                    "ad": "cleardashnew",
                        "ad.cping": "1",
                        "ad.pingf": "4",
                        "manifest": "mpd"
                    }
                }
            ],
            "live": true
        }
    end if
    m.source = source
    m.configuration = configuration
    m.configurationChanged = true
end function

function restartSourcetTimer()
    m.changeSourceTimer.control = "stop"
    m.changeSourceTimer.control = "start"
end function

function copySource()
    if m.configurationChanged
        m.top.source = m.source
        m.top.configuration = m.configuration
        m.configurationChanged = false
    end if
end function

function strToBoolean(value)
    if value = "false"
        return false
    else
        return true
    end if
end function

function markupListItemSelected(list, dataObj, id)
    index = list.itemSelected
    item = dataObj[index]

    if item["type"] = "button"
        if item.options = "changeSource"
            changeSource(list, dataObj, id)
        end if
    else if item["type"] = "select"
        options = item.options.split(";")
        newValue = options[0]
        oldVAlue = ""
        for each option in options
            if oldVAlue <> ""
                newValue = option
                exit for
            end if
            if option = item.value
                oldValue = option
            end if
        end for
        item.value = newValue
    else if item["type"] = "checkbox"
        if item.value = "false"
            item.value = "true"
        else
            item.value = "false"
        end if
    end if

    dataObj[index] = item

    list.content = generateMarkupListContent(dataObj)

    list.jumpToItem = index
    changeSource(list, dataObj, id)
end function

function generateMarkupListContent( obj )
    contentNode = CreateObject("roSGNode", "ContentNode")
    for each item in obj
        contentIitem = CreateObject("roSGNode", "MarkupListContentNode")

        for each key in item
            contentIitem[key] = item[key]
        end for

        contentNode.appendChild(contentIitem)
    end for
    return contentNode
end function

function OnKeyEvent(key, press) as Boolean
    handled = false

    if m.configurationChanged
        restartSourcetTimer()
    end if

    if press
        if key = "right"
            if m.drmGroup.isInFocusChain()
                m.adsList.setFocus(true)
                m.lastFocusedList = m.adsList
                m.top.currentTab = "ads"
                m.adsGroup.visible = true
                setActiveTab("ads")
                m.drmGroup.visible = false
            else if m.adsGroup.isInFocusChain()
                m.liveList.setFocus(true)
                m.lastFocusedList = m.liveList
                m.top.currentTab = "live"
                setActiveTab("live")
                m.liveGroup.visible = true
                m.adsGroup.visible = false
            end if
        end if

        if key = "left"
            if m.adsGroup.isInFocusChain()
                m.drmList.setFocus(true)
                m.lastFocusedList = m.drmList
                m.top.currentTab = "drm"
                m.drmGroup.visible = true
                setActiveTab("drm")
                m.adsGroup.visible = false
            else if m.liveGroup.isInFocusChain()
                m.adsList.setFocus(true)
                m.lastFocusedList = m.adsList
                m.top.currentTab = "ads"
                setActiveTab("ads")
                m.adsGroup.visible = true
                m.liveGroup.visible = false
            end if
        end if

        if key = "back"
            m.top.lostFocus = "true"
            handled = true
            m.top.lostFocus = "false"
        end if
    end if

    return handled
end function
