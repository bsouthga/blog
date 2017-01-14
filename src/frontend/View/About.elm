module View.About exposing (render)

import Html exposing (Html, text, div, h1, p, ul, li, a)
import Html.Attributes exposing (href, style)


-- About me


aboutText : String
aboutText =
    """
    I'm Ben, I live in Washington D.C., work as a
    software engineer for Crosslead, and am a Grad Student in Statistics at George Washington University.
    I like tinkering with JavaScript, TypeScript, and Elm for web stuff and Python and R for data stuff.
    I'm open to fun part-time consulting projects, shoot me a proposal!
    """


social : List ( String, String )
social =
    [ ( "Github", "https://github.com/bsouthga" )
    , ( "LinkedIn", "https://www.linkedin.com/in/bensouthgate" )
    , ( "Twitter", "https://twitter.com/bsouthga" )
    ]


socialLink : ( String, String ) -> Html action
socialLink ( name, url ) =
    li [ style [ ( "margin-bottom", "10px" ) ] ]
        [ a
            [ href url
            ]
            [ text name ]
        ]


render : Html action
render =
    div []
        [ h1 []
            [ text "Me"
            ]
        , p []
            [ text aboutText
            ]
        , ul []
            (List.map socialLink social)
        ]
