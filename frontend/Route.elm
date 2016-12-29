module Route exposing (route, routeToCommand)

import UrlParser as Url exposing ((</>), (<?>), s, int, string, top)
import Api exposing (getPost, getPostList)
import Types exposing (Action, Route(..))


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home top
        , Url.map BlogPostList (s "posts" </> top)
        , Url.map BlogPost (s "posts" </> string)
        , Url.map Visualizations (s "visualizations" </> top)
        ]


routeToCommand : Maybe Route -> Cmd Action
routeToCommand page =
    case page of
        Just (BlogPost id) ->
            getPost id

        Just BlogPostList ->
            getPostList

        _ ->
            Cmd.none
