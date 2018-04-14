module Main exposing (main)

import Html exposing (Html, button, div, h1, h2, h3, img, input, text)
import Html.Attributes exposing (class, disabled, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)


type RemoteAlbum
    = Ready
    | Loading
    | Success Album
    | Fail String


type alias Album =
    { id : Int
    , title : String
    , artists : List String
    , coverUrl : String
    }


decodeAlbum : Decoder Album
decodeAlbum =
    decode Album
        |> required "id" int
        |> required "title" string
        |> required "artists" (list string)
        |> required "coverUrl" string


type alias Model =
    { query : String
    , album : RemoteAlbum
    }


initialModel : Model
initialModel =
    { query = ""
    , album = Ready
    }


view : Model -> Html Msg
view model =
    div [ class "album-app" ]
        [ h1 [] [ text "Find Jazz Albums" ]
        , viewForm model.query
        , viewContent model
        ]


viewContent : Model -> Html a
viewContent model =
    case model.album of
        Ready ->
            text ""

        Loading ->
            div [ class "loading" ]
                [ text "Loading..." ]

        Success album ->
            viewAlbum album

        Fail error ->
            div [ class "error" ]
                [ text error ]


viewAlbum : Album -> Html a
viewAlbum album =
    div [ class "album" ]
        [ h2 [] [ text album.title ]
        , img [ src album.coverUrl ] []
        , h3 [] [ text (String.join " - " album.artists) ]
        ]


viewForm : String -> Html Msg
viewForm query =
    div [ class "find-album" ]
        [ input
            [ type_ "text"
            , value query
            , onInput (\newQuery -> UpdateQuery newQuery)
            ]
            []
        , button
            [ disabled (query == "")
            , onClick FindAlbum
            ]
            [ text "Find" ]
        ]


type Msg
    = UpdateQuery String
    | FindAlbum
    | FoundAlbum (Result Http.Error Album)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateQuery query ->
            ( { model | query = query }
            , Cmd.none
            )

        FindAlbum ->
            ( { model | album = Loading }
            , findAlbum model.query
            )

        FoundAlbum (Ok album) ->
            ( { model | album = Success album }
            , Cmd.none
            )

        FoundAlbum (Err error) ->
            ( { model | album = Fail (errorMessage error) }
            , Cmd.none
            )


errorMessage : Http.Error -> String
errorMessage error =
    case error of
        Http.BadStatus response ->
            toString response.status.code

        Http.BadPayload message _ ->
            message

        _ ->
            "Unknown Error"


findAlbum : String -> Cmd Msg
findAlbum title =
    let
        url =
            "http://localhost:3001/albums/" ++ Http.encodeUri title
    in
    Http.get url decodeAlbum
        |> Http.send FoundAlbum


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
