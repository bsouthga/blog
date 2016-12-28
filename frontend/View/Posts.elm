module View.Posts exposing (renderPost, renderPostList)

import Html exposing (Html, text, div, h1)
import Markdown

-- Individual blog post


renderPost : String -> Html msg
renderPost id =
    Markdown.toHtml [] """
# test

in markdown!
"""



-- List of available blog posts


renderPostList : Html msg
renderPostList =
    div []
        [ h1 []
            [ text "Posts"
            ]
        , div []
            [ text """
                Blah.
                """
            ]
        ]
