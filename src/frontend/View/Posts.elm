module View.Posts exposing (renderPost, renderPostList)

import Html exposing (Html, text, div, h1, ul, li, button, span)
import Html.Events exposing (onClick)
import Markdown
import Types exposing (PostMetadata, Action(..))
import KaTeX
import Html.CssHelpers
import Types exposing (Action(..))
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"



-- Individual blog post


renderPost : Maybe String -> Html action
renderPost data =
    case data of
        Just markdown ->
            Markdown.toHtml [] (compileLaTeX markdown)

        Nothing ->
            text "(no post found)"



-- List of available blog posts


renderPostList : Maybe (List PostMetadata) -> Html Action
renderPostList posts =
    case posts of
        Nothing ->
            text "unable to retrieve posts"

        Just postList ->
            div []
                [ h1 []
                    [ text "Posts"
                    ]
                , ul []
                    (List.map renderPostListItem postList)
                ]


renderPostListItem : PostMetadata -> Html Action
renderPostListItem metadata =
    li [ class [ Styles.PostListItem ] ]
        [ span
            [ class [ Styles.ButtonLink ]
            , onClick (NewUrl ("/posts/" ++ metadata.filename))
            ]
            [ text ("(" ++ metadata.date ++ ") " ++ metadata.title) ]
        ]



{-
   split on @@@ delimited blocks and render latex
-}


compileLaTeX : String -> String
compileLaTeX markdown =
    String.split "@@@" markdown
        |> filterAndCompile 1
        |> String.join ""


filterAndCompile : Int -> List String -> List String
filterAndCompile index components =
    case components of
        current :: remaining ->
            let
                compiled =
                    -- after splitting, only the odd elements
                    -- should be expressions
                    if index % 2 == 0 then
                        compileExpression current
                    else
                        current
            in
                compiled :: filterAndCompile (index + 1) remaining

        _ ->
            components


compileExpression : String -> String
compileExpression expression =
    let
        rendered =
            KaTeX.renderToString expression
    in
        if String.startsWith "\\displaystyle" (String.trim expression) then
            -- TODO: is there a better way?
            "<div style=\"text-align: center;width: 100%;margin: 40px 0px;\">\n"
                ++ rendered
                ++ "</div>"
        else
            rendered
