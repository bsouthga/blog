module Api exposing (getPost, getPostList, getVizList)

import Types exposing (Action(..), PostMetadata, GraphicMetadata)
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
            "/api/graphics"

        request =
            Http.get url (Dec.list decodeGraphicMetadata)
    in
        Http.send GraphicMetadataResponse request


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


decodeGraphicMetadata : Dec.Decoder GraphicMetadata
decodeGraphicMetadata =
    decode GraphicMetadata
        |> required "url" Dec.string
        |> required "title" Dec.string
        |> optional "github" (Dec.nullable Dec.string) Nothing
        |> required "image" Dec.string


encodeGraphicMetadata : GraphicMetadata -> Enc.Value
encodeGraphicMetadata record =
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
