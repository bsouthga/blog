module View.Nav exposing (render)

import Html exposing (Html, text, button, li, ul, div, h2, span)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Types exposing (Action(..))
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"


items : List ( String, String )
items =
    [ ( "Visualizations", "/visualizations" )
    , ( "Posts", "/posts" )
    , ( "About", "/about" )
    ]


render : Html Action
render =
    div [ class [ Styles.Navbar ] ]
        (List.map navbarItem items)


navbarItem : ( String, String ) -> Html Action
navbarItem ( title, src ) =
    span
        [ onClick (NewUrl src)
        , class [ Styles.NavItem, Styles.ButtonLink ]
        ]
        [ text title
        ]
