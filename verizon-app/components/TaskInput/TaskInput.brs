sub Init()
    m.top.functionName = "inputLoop"
end sub

function inputLoop()
    port = createObject("roMessagePort")
    inputObj = createObject("roInput")
    inputObj.setMessagePort(port)

    while true
      msg = port.waitMessage(0)
      if type(msg) = "roInputEvent" then
        if msg.isInput()
          input = msg.getInfo()

          ' expose deepLink to parent component
          if input.mediaType <> invalid and input.contentID <> invalid then
            deepLink = {
                contentID: input.contentID,
                mediaType: input.mediaType
            }
            m.top.data = deepLink
          end if
        end if
      end if
    end while
end function