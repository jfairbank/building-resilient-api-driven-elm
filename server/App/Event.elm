port module App.Event exposing (reply, request)

import Json.Encode exposing (Value)


port request : (Value -> msg) -> Sub msg


port reply : Value -> Cmd msg
