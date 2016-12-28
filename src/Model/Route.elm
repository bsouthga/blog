module Model.Route exposing (Route(..), route)

import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top)


type Route
    = Home
    | Visualizations
    | BlogPost Int
    | BlogPostList


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home top
        , Url.map BlogPostList (s "blog" </> top)
        , Url.map BlogPost (s "blog" </> int)
        , Url.map Visualizations (s "visualizations" </> top)
        ]
