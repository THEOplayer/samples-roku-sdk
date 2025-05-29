' ===== Sources and Content Metadata =====
function getSourceDescriptionArray() as object
    defaultPosterUrl = "http://devtools.web.roku.com/samples/images/Landscape_1.jpg"
    hlsMimeType = "application/x-mpegurl"
    dashMimeType = "application/dash+xml"

    vodAdSource = {
            integration: "csai",
            sources: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/vmap_ad_samples&sz=640x480&cust_params=sample_ar%3Dpremidpost&ciu_szs=300x250&gdfp_req=1&ad_rule=1&output=vmap&unviewed_position_start=1&env=vp&impl=s&cmsid=496&vid=short_onecue&correlator=",
    }

    content = [
        {
            "poster": defaultPosterUrl,
            "live": true,
            "title": "HLS Color Bars - Live"
            "sources": {
                "src": "https://demo.unified-streaming.com/k8s/live/scte35.isml/.m3u8",
                "type": hlsMimeType
            }
        },
        {
            "poster": defaultPosterUrl,
            "live": true,
            "title": "DASH Color Bars - Live"
            "sources": {
                "src": "https://demo.unified-streaming.com/k8s/live/scte35.isml/.mpd",
                "type": dashMimeType
            }
        },
        {
            "poster": defaultPosterUrl,
            "live": false,
            "title": "Angel One - VOD",
            "sources": {
                "src": "https://storage.googleapis.com/shaka-demo-assets/angel-one/dash.mpd",
                "type": dashMimeType
            },
            "ads": [vodAdSource]
        },
        {
            "poster": defaultPosterUrl,
            "live": false,
            "title": "Big Buck Bunny - VOD",
            "sources": {
                "src": "https://contentserver.prudentgiraffe.com/videos/hls/big_buck_bunny/big_buck_bunny.m3u8",
                "type": hlsMimeType
            },
            "ads": [vodAdSource]
        },
        {
            "poster": defaultPosterUrl,
            "live": false,
            "title": "Audio Only - VOD"
            "sources": {
                "src": "https://cdn.theoplayer.com/video/indexcom/index.m3u8",
                "type": hlsMimeType
            },
            "ads": [vodAdSource]
        }
    ]

    return content
end function


function generateContentMetadata(sourceDescription as object) as object
    if sourceDescription.live
        contentType = "DVR"
        aepContentType = "Live"
    else
        contentType = "VOD"
        aepContentType = contentType
    end if

    c3 = {
        cm: {
            contentType: contentType,
            name: "CMS",
            id: "003b094d-fc5c-3d5a-8ed0-301bf848291e",
            showTitle: sourceDescription.title,
        }
    }
    convivaMetadata = {
        customMetadata: { myCustomTag: "THEO Roku SDK", c3: c3 },
        playerName: "THEO Roku Reference Sample App",
        assetName: sourceDescription.title,
        encodedFramerate: 24
    }

    nullValue = "*null"
    duration = 3600000
    if sourceDescription.live = false
        duration = 600000
    end if
    comscoreMetadata = {
        adLoadFlag: false,
        assetId: c3.cm.assetId,
        clipLength: duration,
        completeEpisodeFlag: false,
        contentGenre: nullValue,
        digitalAirDate: nullValue,
        episodeNumber: nullValue,
        episodeSeasonNumber: nullValue,
        episodeTitle: sourceDescription.title,
        programTitle: nullValue,
        publisherBrandName: nullValue,
        stationTitle: nullValue,
        tvAirDate: nullValue
    }

    aepSessionDetails = {
        name: "12345", 
        friendlyName: sourceDescription.title,
        streamType: "video",
        contentType: aepContentType,
        length: duration / 1000
    }

    return {
        aep: aepSessionDetails,
        comscore: comscoreMetadata,
        conviva: convivaMetadata
    }
end function

function getCdnMappings()
    return {
        akamai: ["akamaized.net"],
        theo: ["cdn.theoplayer.com", "theoads.live", "prudentgiraffe.com"]
        unifiedStreaming: ["demo.unified-streaming.com"]
    }
end function

' ===== Utility Methods =====

function getContentNodeArray() as object
    sourceDescriptions = getSourceDescriptionArray()
    contentNodes = []
    for each sourceDesc in sourceDescriptions
        contentNodes.push( convertSourceToContentNode(sourceDesc) )
    end for

    return contentNodes
end function

function getContentNode() as object
    gridContent = createObject("roSGNode","ContentNode")
    rowContent = gridContent.CreateChild("ContentNode")
    rowContent.title = "Test Streams"
    contentNodes = getContentNodeArray()
    for each contentNode in contentNodes
        rowContent.appendChild(contentNode)
    end for

    return gridContent
end function

function convertSourceToContentNode( sourceDescription as object ) as object
    videoContent = CreateObject("RoSGNode", "ContentNode")
    source = sourceDescription.Lookup("sources")

    SDBifUrl = source.Lookup("SDBifUrl")
    if IsString(SDBifUrl)
        videoContent["SDBifUrl"] = SDBifUrl
    end if
    HDBifUrl = source.Lookup("HDBifUrl")
    if IsString(HDBifUrl)
        videoContent["HDBifUrl"] = HDBifUrl
    end if
    FHDBifUrl = source.Lookup("FHDBifUrl")
    if IsString(FHDBifUrl)
        videoContent["FHDBifUrl"] = FHDBifUrl
    end if

    if sourceDescription.poster <> Invalid
        videoContent["SDPosterUrl"] = sourceDescription.poster 
        videoContent["SDGRIDPOSTERURL"] = sourceDescription.poster 
        videoContent["HDPosterUrl"] = sourceDescription.poster 
        videoContent["HDGRIDPOSTERURL"] = sourceDescription.poster 
        videoContent["FHDPosterUrl"] = sourceDescription.poster 
    end if

    videoContent["Title"] = safeLookup(sourceDescription, "Title", "")
    videoContent["ShortDescriptionLine1"] = safeLookup(sourceDescription, "Title", "")
    videoContent["Description"] = safeLookup(sourceDescription, "Description", "")

    'enable live stream rewind
    defaultPlayStart = 0
    if sourceDescription.live = True
        videoContent["Live"] = True
        defaultPlayStart = -1
    end if

    videoContent["PlayStart"] = safeLookup(source, "PlayStart", defaultPlayStart)

    streamFormat = source.Lookup("type")
    if Type(streamFormat) <> "roString"
        streamFormat = ""
    end if

    if LCase(streamFormat) = LCase("application/dash+xml")
        streamFormat = "dash"
    else if LCase(streamFormat) = LCase("application/x-mpegURL")
        streamFormat = "hls"
    end if
    videoContent["streamformat"] = streamFormat

    src = source.Lookup("src")
    videoContent["url"] = src

    videoContent.LiveBoundsPauseBehavior = "pause"

    return videoContent
end function


' returns boolean which determines whether the passed value is of String or roString type
'
' @param data Dynamic - data to test
' @return boolean - true if data is of type String or roString
' @since version 1.0.0
function IsString(data as Dynamic) as Boolean
  return Type(data) = "String" or Type(data) = "roString"
end function

' returns value of data.key if present otherwise default value
'
' @param data Object - roAssociativeArray in wchich key will be searched
' @param key String - key wchich will be searched inside data
' @param default Dynamic - if key not exist inside the associative array, the function returns default
' @return Dynamic - if key exist inside the associative array, the function returns corresponding value otherwise returns default
' @since version 1.0.0
function safeLookup(data as Object, key as String, default as Dynamic) as Dynamic
  ret = default
  if Type(data) = "roAssociativeArray" or Type(data) = "roSGNode"
    if data.DoesExist(key)
      ret = data[key]
    end if
  end if
  return ret
end function
