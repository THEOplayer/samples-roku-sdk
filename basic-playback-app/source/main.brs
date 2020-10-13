sub Main(args as Dynamic)
    ' standard Roku initialization
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    m.scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    deeplink = getDeepLinks(args)
    m.global.addField("deeplink", "assocarray", false)
    m.global.deeplink = deeplink
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while

end sub

function getDeepLinks(args)
    deeplink = invalid

    if args.contentid <> Invalid and args.mediaType <> Invalid
        deeplink = {
            contentID: args.contentId
            mediaType: args.mediaType
        }
    end if

    return deeplink
end function
