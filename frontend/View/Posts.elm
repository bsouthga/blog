module View.Posts exposing (renderPost, renderPostList, getPost)

import Action exposing (Action(..))
import Html exposing (Html, text, div, h1)
import Markdown
import Http

-- Individual blog post


renderPost : String -> Html action
renderPost markdown =
    Markdown.toHtml [] markdown


-- List of available blog posts


renderPostList : Html action
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


getPost : String -> Cmd Action
getPost id =
  let
    url =
      "/api/post/" ++ id

    request =
      Http.getString url
  in
    Http.send ApiResult request
