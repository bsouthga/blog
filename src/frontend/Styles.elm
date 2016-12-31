module Styles exposing (css, CssClasses(..))

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)


type CssClasses
    = Main
    | Content
    | Navbar
    | NavItem
    | Current
    | Footer


mainColor : Color
mainColor =
    (hex "#000000")


css : Stylesheet
css =
    (stylesheet << namespace "main")
        [ body
            [ fontFamily sansSerif
            ]
        , (.) Main
            [ height (pct 100)
            , padding (px 30)
            ]
        , (.) Content
            [ maxWidth (px 800)
            , margin2 (px 0) auto
            ]
        , (.) Navbar
            [ textAlign center
            , marginTop (px 30)
            ]
        , (.) NavItem
            [ margin2 (px 0) (px 10)
            , hover
                [ borderBottom3 (px 1) solid mainColor
                , cursor pointer
                ]
            ]
        , (.) Current
            []
        , (.) Footer
            [ textAlign center
            ]
        , pre
            [ marginTop (px 60)
            , marginBottom (px 60)
            ]
        , img
            [ maxWidth (pct 60)
            , margin2 (px 20) auto
            , display block
            ]
        , hr
            [ margin2 (px 30) (px 0)
            ]
        , h1
            [ fontWeight normal
            ]
        , h2
            [ fontWeight normal
            ]
        , h3
            [ fontWeight normal
            ]
        , p
            [ lineHeight (em 1.5)
            ]
        ]
