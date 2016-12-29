module Styles exposing (css, CssClasses(..))

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = Main
    | Content
    | Navbar


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
        ]
