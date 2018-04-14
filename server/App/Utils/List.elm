module App.Utils.List exposing (find)


find : (a -> Bool) -> List a -> Maybe a
find f list =
    case list of
        [] ->
            Nothing

        item :: rest ->
            if f item then
                Just item
            else
                find f rest
