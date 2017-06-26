module Route exposing (route, routeToCommand)

import UrlParser exposing (Parser, oneOf, map, (</>), s, string, top)
import Api exposing (getPost, getPostList, getVizList)
import Types exposing (Action, Route(..))


route : Parser (Route -> a) a
route =
    oneOf
        [ map About (s "about" </> top)
        , map BlogPostList (s "posts" </> top)
        , map BlogPost (s "posts" </> string)
        , map Graphics (s "graphics" </> top)
        , map Graphics top
        ]


routeToCommand : Maybe Route -> Cmd Action
routeToCommand page =
    case page of
        Just (BlogPost id) ->
            getPost id

        Just BlogPostList ->
            getPostList

        Just Graphics ->
            getVizList

        _ ->
            Cmd.none
