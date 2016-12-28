module View.About exposing (about)

import Html exposing (Html, text, div, h1, span)


-- About me


aboutText : String
aboutText =
    """
    I'm Ben, I live in Washington D.C. and currently work as a
    software engineer for Crosslead. I like tinkering with JavaScript, TypeScript,
    and Elm for web stuff and Python and R for data stuff.
    I'm open to fun part-time consulting projects, shoot me a proposal!
    """


about : Html msg
about =
    div []
        [ h1 []
            [ text "Me"
            ]
        , span []
            [ text aboutText
            ]
        ]
