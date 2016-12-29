module View.Nav exposing (navbar)

import Html exposing (Html, text, a, li, ul, div, h2)
import Html.Attributes exposing (href)


items : List ( String, String )
items =
    [ ( "Home", "/" )
    , ( "Posts", "/posts" )
    , ( "Visualizations", "/visualizations" )
    ]


navbar : Html action
navbar =
    div []
        [ h2 [] [ text "Navigation" ]
        , ul [] (List.map navbarItem items)
        ]


navbarItem : ( String, String ) -> Html msg
navbarItem ( title, src ) =
    li []
        [ a [ href src ] [ text title ]
        ]
