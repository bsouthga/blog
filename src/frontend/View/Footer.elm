module View.Footer exposing (render)

import Html exposing (Html, div, text)
import Html.CssHelpers
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"


render : Html action
render =
    div [ class [ Styles.Footer ] ]
        [ text "Ben Southgate, 2016"
        ]
