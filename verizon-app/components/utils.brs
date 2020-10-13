function Contains(data as Object, key as String) as Boolean
    for each d in data
        if d = key
            return true
        end if
    end for

    return false
end function

function GetNestedValue(array as Object, keys as Object) as Dynamic
    ' check parameters START'
    if Type(array) <> "roAssociativeArray"
        return Invalid
    end if
    if Type(keys) <> "roArray"
        return Invalid
    end if
    ' check parameters STOP'

    value = array
    for each key in keys
        if Type(value) <> "roAssociativeArray"
            return value
        end if
        value = value.Lookup(key)
        if value = Invalid
            return Invalid
        end if
    end for

    return value
end function
