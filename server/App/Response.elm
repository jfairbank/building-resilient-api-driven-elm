module App.Response exposing (Response(..), send)

import App.Album as Album exposing (Album)
import App.Event as Event
import App.Utils.Encode as Encode
import App.Utils.Operators exposing ((=>))
import Json.Encode as Encode exposing (Value)


type alias Id =
    String


type Response
    = Album Id (Maybe Album)
    | AlbumTitles Id (List String)


send : Response -> Cmd msg
send response =
    Event.reply (encode response)


encode : Response -> Value
encode response =
    let
        ( id, encodedPayload ) =
            case response of
                Album id maybeAlbum ->
                    ( id
                    , Encode.maybe Album.encode maybeAlbum
                    )

                AlbumTitles id titles ->
                    ( id
                    , Encode.list (List.map Encode.string titles)
                    )
    in
    Encode.object
        [ "id" => Encode.string id
        , "payload" => encodedPayload
        ]
