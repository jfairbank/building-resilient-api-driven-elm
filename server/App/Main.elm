module App.Main exposing (..)

import App.Album as Album exposing (Album)
import App.Event as Event
import App.Request as Request exposing (Request)
import App.Response as Response exposing (Response)
import Json.Decode as Json


---- MODEL ----


type alias Model =
    { albums : List Album }


type alias Flags =
    Model


init : Flags -> ( Model, Cmd msg )
init model =
    ( model, Cmd.none )



---- UPDATE ----


type Msg
    = RequestMsg Request
    | NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        RequestMsg request ->
            ( model
            , handleRequest request model
                |> Response.send
            )

        NoOp ->
            ( model, Cmd.none )


handleRequest : Request -> Model -> Response
handleRequest request model =
    case request of
        Request.FindAlbum requestId title ->
            -- Response.Album requestId (Album.findByTitle title model.albums)
            Response.Album requestId (Album.firstMatchingByTitle title model.albums)

        Request.AlbumTitles requestId ->
            Response.AlbumTitles requestId (List.map .title model.albums)



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    Event.request <|
        Json.decodeValue (Json.map RequestMsg Request.decode)
            >> Result.withDefault NoOp



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Platform.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
