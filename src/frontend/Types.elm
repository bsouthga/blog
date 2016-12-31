module Types exposing (..)

import Navigation
import Http


type Action
    = NewUrl String
    | UrlChange Navigation.Location
    | PostMarkdownResponse (Result Http.Error String)
    | PostMetadataResponse (Result Http.Error (List PostMetadata))
    | VisualizationMetadataResponse (Result Http.Error (List VisualizationMetadata))


type Route
    = About
    | Visualizations
    | BlogPost String
    | BlogPostList


type alias Model =
    { page : Maybe Route
    , post : Maybe String
    , postList : Maybe (List PostMetadata)
    , vizList : Maybe (List VisualizationMetadata)
    }


type alias PostMetadata =
    { date : String
    , subtitle : String
    , title : String
    , filename : String
    }


type alias VisualizationMetadata =
    { url : String
    , title : String
    , github : Maybe String
    , image : String
    }
