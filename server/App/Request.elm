module App.Request exposing (Id, Request(..), decode)

import Json.Decode as Json exposing (Decoder)


type alias Id =
    String


type alias Payload =
    String


type Request
    = FindAlbum Id String
    | AlbumTitles Id


decode : Decoder Request
decode =
    Json.andThen identity <|
        Json.map3
            decodeRequestHelp
            (Json.field "id" Json.string)
            (Json.field "type" Json.string)
            (Json.field "payload" Json.string)


decodeRequestHelp : Id -> String -> Payload -> Decoder Request
decodeRequestHelp id type_ payload =
    case type_ of
        "FIND_ALBUM" ->
            Json.succeed (FindAlbum id payload)

        "ALBUM_TITLES" ->
            Json.succeed (AlbumTitles id)

        _ ->
            Json.fail "Unknown request type"
