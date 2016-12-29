module Main exposing (..)

import Navigation
import UrlParser as Url
import View
import View.Posts exposing (getPost)
import Model exposing (Model, update)
import Model.Route exposing (Route(..), route)
import Action exposing (Action(..))


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


init : Navigation.Location -> ( Model, Cmd Action )
init location =
    let
        page =
            (Url.parsePath route location)

        cmd =
            case page of
                Just (BlogPost id) ->
                    getPost id

                _ ->
                    Cmd.none
    in
        ( Model page "loading...", cmd )


main : Program Never Model Action
main =
    Navigation.program UrlChange
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }
