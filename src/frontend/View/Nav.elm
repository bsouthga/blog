module View.Nav exposing (navbar)

import Html exposing (Html, text, button, li, ul, div, h2)
import Html.Events exposing (onClick)
import Types exposing (Action(..))


items : List ( String, String )
items =
    [ ( "About", "/about" )
    , ( "Posts", "/posts" )
    , ( "Visualizations", "/visualizations" )
    ]


navbar : Html Action
navbar =
    div []
        [ h2 [] [ text "Navigation" ]
        , ul [] (List.map navbarItem items)
        ]


navbarItem : ( String, String ) -> Html Action
navbarItem ( title, src ) =
    li []
        [ button [ onClick (NewUrl src) ] [ text title ]
        ]
