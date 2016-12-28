module Main exposing (..)

import Navigation
import UrlParser as Url
import View
import Model exposing (Model, update)
import Model.Route exposing (Route(..), route)
import Action exposing (Action(..))


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


init : Navigation.Location -> ( Model, Cmd Action )
init location =
    ( Model (Url.parsePath route location)
    , Cmd.none
    )


main : Program Never Model Action
main =
    Navigation.program UrlChange
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }
