module View.Posts exposing (renderPost, renderPostList)

import Html exposing (Html, text, div, h1, ul, li, a)
import Html.Attributes exposing (href)
import Markdown
import Types exposing (PostMetadata)


-- Individual blog post


renderPost : Maybe String -> Html action
renderPost data =
    case data of
        Just markdown ->
            Markdown.toHtml [] markdown

        Nothing ->
            text "(no post found)"



-- List of available blog posts


renderPostList : List PostMetadata -> Html action
renderPostList postList =
    div []
        [ h1 []
            [ text "Posts"
            ]
        , ul []
            (List.map renderPostListItem postList)
        ]


renderPostListItem : PostMetadata -> Html action
renderPostListItem p =
    li []
        [ a [ href p.filename ]
            [ text p.title ]
        ]
