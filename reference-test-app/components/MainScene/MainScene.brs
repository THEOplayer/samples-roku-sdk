' Function is automatically called every time when new instance of main scene component is created, function will follow below steps: <br/>
' creates loval variables</br>
' sets observers for pressing butotns</br>
' center buttons</br>
' handle deep link parameters if reference app was started through deep link</br>
'
' @since version 1.0.0
sub Init()
    m.THEOsdkLoaded = false
    m.allLibrariesLoaded = false
    m.librariesToLoad = ["THEOConvivaConnector", "THEOComscoreConnector", "THEOAEPConnector"]
    m.loadedLibraries = []

    initPosterGrid()
    populatePosterGrid()

    m.top.observeField("playRequested", "onMediaPlayRequest")

    m.groupSelectionUI = m.top.findNode("SelectionGroup")

    m.theoSDKComponentLibrary = m.top.findNode("THEOsdk")
	m.theoSDKComponentLibrary.observeField("loadStatus", "onSdkComponentLibraryLoaded")
    
    for each libraryName in m.librariesToLoad
        libraryNode = m.top.findNode(libraryName)
        libraryNode.observeField("loadStatus", "onLibraryLoadStatusChanged")
    end for
end sub

sub initPosterGrid()
    itemWidth = 392
    itemHeight = 426
    
    m.mediaGrid = m.top.findNode("contentPosterGrid")
    m.mediaGrid.itemComponentName = "SimpleRowListItem"
    m.mediaGrid.numRows = 1
    m.mediaGrid.itemSize = [itemWidth * getSourceDescriptionArray().Count() + 20 * 2, itemHeight]
    m.mediaGrid.rowHeights = [itemHeight]
    m.mediaGrid.rowItemSize = [itemWidth, itemHeight]
    m.mediaGrid.itemSpacing = [ 0, 80 ]
    m.mediaGrid.rowItemSpacing = [ [40, 0] ]
    m.mediaGrid.rowLabelOffset = [ [0, 30] ]
    m.mediaGrid.rowFocusAnimationStyle = "floatingFocus"
    m.mediaGrid.showRowLabel = [true, true]
    m.mediaGrid.rowLabelColor="0xffc50fff"
    m.mediaGrid.ObserveField("rowItemSelected", "onItemSelected")
end sub

sub populatePosterGrid()
    posterGridContent = getContentNode()
    m.mediaGrid.content = posterGridContent
    m.mediaGrid.visible = true
    m.mediaGrid.setFocus(true)
end sub

sub onSdkComponentLibraryLoaded()
    if m.theoSDKComponentLibrary.loadStatus = "ready"
        m.THEOsdkLoaded = true
		? "SDK component library has loaded properly."
    else if m.theoSDKComponentLibrary.loadStatus = "failed"
        m.THEOsdkLoaded = false
		? "Failed to load the SDK component library. Please check the URL. "; m.theoSDKComponentLibrary.uri 
	end if
end sub

sub onLibraryLoadStatusChanged(event as object)
    libraryNode = event.getROSGNode()

    if libraryNode = invalid
        return
    end if

    libraryName = libraryNode.id
    if libraryNode.loadStatus = "ready"
        m.loadedLibraries.push(libraryName)
        ? "Component library " + libraryName + " is loaded properly."
        if m.loadedLibraries.count() = m.librariesToLoad.count()
            ? "All component libraries loaded"
            m.allLibrariesLoaded = true
        end if
    else if libraryNode.loadStatus = "failed"
        ? "Failed to load component library " + libraryName + ", please check URL. "; libraryNode.uri
    end if
end sub

' Handle an item being selected in the grid of media assets
'
' @since version 1.0.0
sub onItemSelected()
    col = m.mediaGrid.rowItemSelected[1]
    sourceDescription = getSourceDescriptionArray()[col]
    onMediaPlayRequest(sourceDescription)
end sub

' If the libraries are loaded, will switch to the video player view and play the requested media
'
' @since version 1.0.0
sub onMediaPlayRequest(sourceDescription as object)
    if m.THEOsdkLoaded and m.allLibrariesLoaded
        m.videoPlayerView = CreateObject("roSGNode", "VideoPlayerView")
        m.top.appendChild(m.videoPlayerView)
        
        m.videoPlayerView.callFunc("setSource", sourceDescription)
        m.groupSelectionUI.visible = false
        m.videoPlayerView.callFunc("show")
    else
        ? "Failed to load THEOsdk or connectors, please make sure that URLs for the libraries are correct."
    end if
end sub

' Main Remote keypress event loop which handles remote buttons events in main scene
'
' @since version 1.0.0
Function OnKeyEvent(key, press) as Boolean
    handled = false
    if press
        if key = "options"
        else if m.groupSelectionUI.visible = false and key = "back"
            
            m.groupSelectionUI.visible = true
            m.mediaGrid.setFocus(true)

            if m.videoPlayerView <> Invalid
                m.videoPlayerView.callFunc("destroy")
                m.top.removeChild(m.videoPlayerView)
                m.videoPlayerView = Invalid
            end if
            
            handled = true
        end if
    end if

    return handled

End Function
