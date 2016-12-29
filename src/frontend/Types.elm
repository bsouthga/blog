module Types exposing (..)

import Navigation
import Http


type Action
    = NewUrl String
    | UrlChange Navigation.Location
    | PostMarkdownResponse (Result Http.Error String)
    | PostMetadataResponse (Result Http.Error (List PostMetadata))


type Route
    = Home
    | Visualizations
    | BlogPost String
    | BlogPostList


type alias Model =
    { page : Maybe Route
    , post : Maybe String
    , postList : List PostMetadata
    }


type alias PostMetadata =
    { date : String
    , subtitle : String
    , title : String
    , filename : String
    }
