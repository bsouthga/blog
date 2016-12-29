module View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick)
import Types exposing (Action(..), Route(..), Model)
import View.About
import View.Posts
import View.Visualizations
import View.NotFound
import Styles
import Html.CssHelpers


{ class } =
    Html.CssHelpers.withNamespace "main"


view : Model -> Html Action
view model =
    div [ class [ Styles.Main ] ]
        [ div [ class [ Styles.Content ] ]
            [ h1 [] [ text "Links" ]
            , ul [] (List.map viewLink [ "/", "/posts/", "/posts/dynamic-reports-with-statex", "/visualizations" ])
            , renderRoute model
            ]
        ]


viewLink : String -> Html Action
viewLink url =
    li [] [ button [ onClick (NewUrl url) ] [ text url ] ]


renderRoute : Model -> Html action
renderRoute model =
    case model.page of
        Nothing ->
            View.NotFound.render

        Just route ->
            case route of
                Home ->
                    View.About.render

                BlogPost id ->
                    View.Posts.renderPost model.post

                BlogPostList ->
                    View.Posts.renderPostList model.postList

                Visualizations ->
                    View.Visualizations.render
