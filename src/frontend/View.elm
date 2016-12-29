module View exposing (view)

import Html exposing (Html, div)
import Types exposing (Action, Model)
import Styles
import Html.CssHelpers
import View.Route
import View.Nav


{ class } =
    Html.CssHelpers.withNamespace "main"


view : Model -> Html Action
view model =
    div [ class [ Styles.Main ] ]
        [ div [ class [ Styles.Content ] ]
            [ View.Nav.navbar
            , View.Route.renderRoute model
            ]
        ]
