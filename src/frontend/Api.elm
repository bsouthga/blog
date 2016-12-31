module Api exposing (getPost, getPostList, getVizList)

import Types exposing (Action(..), PostMetadata, VisualizationMetadata)
import Http
import Json.Encode as Enc
import Json.Decode as Dec
import Json.Decode.Pipeline exposing (decode, required, optional)


getPost : String -> Cmd Action
getPost id =
    let
        url =
            "/api/post/" ++ id

        request =
            Http.getString url
    in
        Http.send PostMarkdownResponse request


getPostList : Cmd Action
getPostList =
    let
        url =
            "/api/posts"

        request =
            Http.get url (Dec.list decodePostMetadata)
    in
        Http.send PostMetadataResponse request


getVizList : Cmd Action
getVizList =
    let
        url =
            "/api/visualizations"

        request =
            Http.get url (Dec.list decodeVisualizationMetadata)
    in
        Http.send VisualizationMetadataResponse request


decodePostMetadata : Dec.Decoder PostMetadata
decodePostMetadata =
    decode PostMetadata
        |> required "date" (Dec.string)
        |> required "subtitle" (Dec.string)
        |> required "title" (Dec.string)
        |> required "filename" (Dec.string)


encodePostMetadata : PostMetadata -> Enc.Value
encodePostMetadata record =
    Enc.object
        [ ( "date", Enc.string <| record.date )
        , ( "subtitle", Enc.string <| record.subtitle )
        , ( "title", Enc.string <| record.title )
        , ( "filename", Enc.string <| record.filename )
        ]


decodeVisualizationMetadata : Dec.Decoder VisualizationMetadata
decodeVisualizationMetadata =
    decode VisualizationMetadata
        |> required "url" Dec.string
        |> required "title" Dec.string
        |> optional "github" (Dec.nullable Dec.string) Nothing
        |> required "image" Dec.string


encodeVisualizationMetadata : VisualizationMetadata -> Enc.Value
encodeVisualizationMetadata record =
    let
        github =
            case record.github of
                Just str ->
                    Enc.string <| str

                Nothing ->
                    Enc.string <| ""
    in
        Enc.object
            [ ( "url", Enc.string <| record.url )
            , ( "title", Enc.string <| record.title )
            , ( "image", Enc.string <| record.image )
            , ( "github", github )
            ]
