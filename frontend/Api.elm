module Api exposing (getPost, getPostList)

import Types exposing (Action(..), PostMetadata)
import Http
import Json.Encode
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Json.Decode


-- elm-package install -- yes noredink/elm-decode-pipeline

import Json.Decode.Pipeline


decodePostMetadata : Json.Decode.Decoder PostMetadata
decodePostMetadata =
    Json.Decode.Pipeline.decode PostMetadata
        |> Json.Decode.Pipeline.required "date" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "subtitle" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "title" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "filename" (Json.Decode.string)


encodePostMetadata : PostMetadata -> Json.Encode.Value
encodePostMetadata record =
    Json.Encode.object
        [ ( "date", Json.Encode.string <| record.date )
        , ( "subtitle", Json.Encode.string <| record.subtitle )
        , ( "title", Json.Encode.string <| record.title )
        , ( "filename", Json.Encode.string <| record.filename )
        ]


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
            Http.get url (Json.Decode.list decodePostMetadata)
    in
        Http.send PostMetadataResponse request
