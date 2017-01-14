module View.Footer exposing (render)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (href, style)
import Html.CssHelpers
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"


render : Html action
render =
    div [ class [ Styles.Footer ] ]
        [ text "Ben Southgate, 2017"
        , a
            [ href "https://github.com/bsouthga/blog"
            , style [ ( "margin-left", "5px" ) ]
            ]
            [ text "source" ]
        ]
