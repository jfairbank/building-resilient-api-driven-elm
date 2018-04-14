module App.Album
    exposing
        ( Album
        , Id
        , encode
        , findByTitle
        , firstMatchingByTitle
        )

import App.Utils.List as List
import App.Utils.Operators exposing ((=>))
import Json.Encode as Encode exposing (Value)


type alias Id =
    Int


type alias Album =
    { id : Id
    , title : String
    , artists : List String
    , coverUrl : String
    }


encode : Album -> Value
encode { id, title, artists, coverUrl } =
    Encode.object
        [ "id" => Encode.int id
        , "title" => Encode.string title
        , "artists" => Encode.list (List.map Encode.string artists)
        , "coverUrl" => Encode.string coverUrl
        ]


findByTitle : String -> List Album -> Maybe Album
findByTitle title =
    -- List.find <|
    --     .title
    --         >> String.toLower
    --         >> (==) (String.toLower title)
    let
        lowerTitle =
            String.toLower title
    in
    List.find <|
        \album -> String.toLower album.title == lowerTitle


firstMatchingByTitle : String -> List Album -> Maybe Album
firstMatchingByTitle title =
    let
        lowerTitle =
            String.toLower title
    in
    List.find <|
        \album ->
            album.title
                |> String.toLower
                |> String.startsWith lowerTitle
