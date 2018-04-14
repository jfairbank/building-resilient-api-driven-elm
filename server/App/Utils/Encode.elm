module App.Utils.Encode exposing (maybe)

import Json.Encode as Encode exposing (Value)


maybe : (a -> Value) -> Maybe a -> Value
maybe encodeValue =
    Maybe.map encodeValue
        >> Maybe.withDefault Encode.null
