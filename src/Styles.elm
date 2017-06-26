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
    | VizImage
    | VizItem
    | ButtonLink
    | PostListItem


mainColor : Color
mainColor =
    hex "#000000"


linkColor : Color
linkColor =
    hex "#4DA6C2"


css : Stylesheet
css =
    (stylesheet << namespace "main")
        [ body
            [ fontFamily sansSerif
            , fontWeight normal
            ]
        , a
            [ color linkColor
            , textDecoration none
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
            , border (px 0)
            , height (px 1)
            , color mainColor
            , backgroundColor mainColor
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
        , (.) Main
            [ height (pct 100)
            , padding (px 30)
            ]
        , (.) Content
            [ maxWidth (px 800)
            , margin2 (px 0) auto
            ]
        , (.) PostListItem
            [ margin2 (px 20) (px 0)
            ]
        , (.) ButtonLink
            [ hover
                [ borderBottom3 (px 1) solid mainColor
                , cursor pointer
                ]
            ]
        , (.) Navbar
            [ textAlign center
            , marginTop (px 30)
            ]
        , (.) NavItem
            [ margin2 (px 0) (px 10)
            ]
        , (.) Current
            []
        , (.) Footer
            [ textAlign center
            ]
        , (.) VizItem
            [ marginTop (px 30)
            , display block
            , width (pct 100)
            , color mainColor
            , textDecoration none
            , hover
                [ cursor pointer
                ]
            ]
        , (.) VizImage
            [ maxWidth (pct 100)
            , marginTop (px 5)
            , height (px 100)
            , border3 (px 1) solid mainColor
            , backgroundSize cover
            ]
        ]
