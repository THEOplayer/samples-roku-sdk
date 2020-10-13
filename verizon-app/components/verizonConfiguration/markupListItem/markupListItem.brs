sub init()
    m.buttonGroup = m.top.findNode("buttonGroup")
    m.buttonLabel = m.top.findNode("buttonLabel")
    m.buttonBackground = m.top.findNode("buttonBackground")

    m.selectGroup = m.top.findNode("selectGroup")
    m.selectLabel = m.top.findNode("selectLabel")
    m.selectValueLabel = m.top.findNode("selectValueLabel")

    m.checkboxGroup = m.top.findNode("checkboxGroup")
    m.checkboxLabel = m.top.findNode("checkboxLabel")
    m.switcher = m.top.findNode("switcher")

    m.itemCursor = m.top.findNode("itemCursor")
    m.cursorRect = m.itemCursor.boundingRect()

    m.rect = m.top.boundingRect()
end sub

sub showcontent()
    m.selectGroup.visible = false
    m.checkboxGroup.visible = false
    m.buttonGroup.visible = false

    itemContent = m.top.itemContent

    if itemContent.type = "button"
        m.buttonGroup.visible = true
        m.buttonLabel.text = itemContent.title
        labelRect = m.buttonLabel.boundingRect()

        labelsY = m.rect.height / 2 - labelRect.height / 2
        labelsX = m.rect.width / 2 - labelRect.width / 2
        m.buttonLabel.translation = [labelsX, labelsY]
        m.buttonBackground.translation = [labelsX - 20 , labelsY - 15]
        m.buttonBackground.width = labelRect.width + 40
        m.buttonBackground.height = labelRect.height + 30

        m.itemCursor.translation = [0, m.rect.height - m.cursorRect.height]
    else if itemContent.type = "select"
        m.selectGroup.visible = true
        m.selectLabel.text = itemContent.title + ": "
        m.selectValueLabel.text = itemContent.value
        labelRect = m.selectLabel.boundingRect()

        labelsY = m.rect.height / 2 - labelRect.height / 2
        m.selectLabel.translation = [10, labelsY]
        m.selectValueLabel.translation = [labelRect.width + 20, labelsY]
        m.itemCursor.translation = [0, m.rect.height - m.cursorRect.height]
    else if itemContent.type = "checkbox"
        m.checkboxGroup.visible = true
        if itemContent.value = "false"
            m.switcher.uri = "pkg:/images/switcherOff.png"
        else
            m.switcher.uri = "pkg:/images/switcherOn.png"
        end if
        labelRect = m.checkboxLabel.boundingRect()
        switcherRect = m.switcher.boundingRect()
        groupRect = m.checkboxGroup.boundingRect()

        m.checkboxLabel.text = itemContent.title

        m.checkboxLabel.translation = [switcherRect.width + 10, switcherRect.height / 2 - labelRect.height / 2 ]
        m.itemCursor.translation = [0, m.rect.height - m.cursorRect.height]
    end if
end sub

sub showfocus()
    m.itemCursor.opacity = m.top.focusPercent
end sub
