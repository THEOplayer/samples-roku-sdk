' Function is automatically called every time when new instance of inputTask component is created <br/>
'
' @since version 1.0.0
sub Init()
    m.top.functionName = "inputLoop"
end sub

' function creates loop which waits for deep link event, if any occurred opens chromefull or chromeless player depends on what is passed through deep link
'
' @since version 1.0.0
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