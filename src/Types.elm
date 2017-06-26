module Types exposing (..)

import Navigation
import Http


type Action
    = NewUrl String
    | UrlChange Navigation.Location
    | PostMarkdownResponse (Result Http.Error String)
    | PostMetadataResponse (Result Http.Error (List PostMetadata))
    | GraphicMetadataResponse (Result Http.Error (List GraphicMetadata))


type Route
    = About
    | Graphics
    | BlogPost String
    | BlogPostList


type alias Model =
    { page : Maybe Route
    , post : Maybe String
    , postList : Maybe (List PostMetadata)
    , vizList : Maybe (List GraphicMetadata)
    }


type alias PostMetadata =
    { date : String
    , subtitle : String
    , title : String
    , filename : String
    }


type alias GraphicMetadata =
    { url : String
    , title : String
    , github : Maybe String
    , image : String
    }
