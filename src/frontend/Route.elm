module Route exposing (route, routeToCommand)

import UrlParser exposing (Parser, oneOf, map, (</>), s, string, top)
import Api exposing (getPost, getPostList, getVizList)
import Types exposing (Action, Route(..))


route : Parser (Route -> a) a
route =
    oneOf
        [ map Home top
        , map BlogPostList (s "posts" </> top)
        , map BlogPost (s "posts" </> string)
        , map Visualizations (s "visualizations" </> top)
        ]


routeToCommand : Maybe Route -> Cmd Action
routeToCommand page =
    case page of
        Just (BlogPost id) ->
            getPost id

        Just BlogPostList ->
            getPostList

        Just Visualizations ->
            getVizList

        _ ->
            Cmd.none
