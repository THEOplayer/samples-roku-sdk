sub init()
    m.itemImage = m.top.findNode("itemImage") 
    m.itemText = m.top.findNode("itemText") 
end sub

sub itemContentChanged()
    itemData = m.top.itemContent
    m.itemImage.uri = itemData.sdPosterUrl
    m.itemText.text = itemData.title
end sub
    
  