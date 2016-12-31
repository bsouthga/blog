module View exposing (view)

import Html exposing (Html, div, hr)
import Types exposing (Action, Model)
import Styles
import Html.CssHelpers
import View.Route
import View.Nav
import View.Footer


{ class } =
    Html.CssHelpers.withNamespace "main"


view : Model -> Html Action
view model =
    div [ class [ Styles.Main ] ]
        [ div [ class [ Styles.Content ] ]
            [ View.Nav.render
            , hr [] []
            , View.Route.renderRoute model
            , hr [] []
            , View.Footer.render
            ]
        ]
