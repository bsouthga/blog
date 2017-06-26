module Main exposing (..)

import Navigation
import UrlParser as Url
import View
import Update exposing (update)
import Route exposing (route, routeToCommand)
import Types exposing (Action(..), Route(..), Model)


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


init : Navigation.Location -> ( Model, Cmd Action )
init location =
    let
        page =
            (Url.parsePath route location)

        cmd =
            routeToCommand page
    in
        ( { page = page
          , post = Nothing
          , postList = Nothing
          , vizList = Nothing
          }
        , cmd
        )


main : Program Never Model Action
main =
    Navigation.program UrlChange
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }
