module View.Posts exposing (renderPost, renderPostList)

import Html exposing (Html, text, div, h1, ul, li, button)
import Html.Events exposing (onClick)
import Markdown
import Types exposing (PostMetadata, Action(..))
import KaTeX


-- Individual blog post


renderPost : Maybe String -> Html action
renderPost data =
    case data of
        Just markdown ->
            Markdown.toHtml [] (compileLaTeX markdown)

        Nothing ->
            text "(no post found)"



-- List of available blog posts


renderPostList : List PostMetadata -> Html Action
renderPostList postList =
    div []
        [ h1 []
            [ text "Posts"
            ]
        , ul []
            (List.map renderPostListItem postList)
        ]


renderPostListItem : PostMetadata -> Html Action
renderPostListItem p =
    li []
        [ button [ onClick (NewUrl ("/posts/" ++ p.filename)) ]
            [ text p.title ]
        ]


compileLaTeX : String -> String
compileLaTeX markdown =
    String.split "@@@" markdown
        |> compileExpressions 1
        |> String.join ""


compileExpressions : Int -> List String -> List String
compileExpressions index components =
    case components of
        current :: remaining ->
            if index % 2 == 0 then
                let
                    compiled =
                        KaTeX.renderToString current
                in
                    compiled :: compileExpressions (index + 1) remaining
            else
                current :: compileExpressions (index + 1) remaining

        _ ->
            components
