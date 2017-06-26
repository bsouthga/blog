module View.Nav exposing (render)

import Html exposing (Html, text, button, li, ul, div, h2, span, a)
import Html.Attributes exposing (href, style)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Types exposing (Action(..))
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"


items : List ( String, String )
items =
    [ ( "Graphics", "/graphics" )
    , ( "Posts", "/posts" )
    , ( "About", "/about" )
    ]


render : Html Action
render =
    div [ class [ Styles.Navbar ] ]
        ((List.map navbarItem items)
            ++ [ linkNavItem ( "Github", "https://github.com/bsouthga" )
               ]
        )


navbarItem : ( String, String ) -> Html Action
navbarItem ( title, src ) =
    span
        [ onClick (NewUrl src)
        , class [ Styles.NavItem, Styles.ButtonLink ]
        ]
        [ text title
        ]


linkNavItem : ( String, String ) -> Html Action
linkNavItem ( name, url ) =
    span
        [ class [ Styles.NavItem, Styles.ButtonLink ]
        ]
        [ a
            [ href url
            , style [ ( "color", "black" ), ( "text-decoration", "none" ) ]
            ]
            [ text name ]
        ]
