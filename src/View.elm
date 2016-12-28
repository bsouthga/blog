module View exposing (view)

import Html exposing (Html, a, button, code, div, h1, li, text, ul)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Model.Route exposing (Route(..))
import View.About exposing (about)
import View.Posts exposing (post, postList)
import View.Visualizations exposing (visualizations)
import Action exposing (Action(..))


view : Model -> Html Action
view model =
    div []
        [ h1 [] [ text "Links" ]
        , ul [] (List.map viewLink [ "/", "/blog/", "/visualizations" ])
        , h1 [] [ text "History" ]
        , ul [] [ viewRoute model.page ]
        ]


viewLink : String -> Html Action
viewLink url =
    li [] [ button [ onClick (NewUrl url) ] [ text url ] ]


viewRoute : Maybe Route -> Html action
viewRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            text "Invalid URL"

        Just route ->
            renderValidRoute route



{-

   Render correct view given a route

-}


renderValidRoute : Route -> Html action
renderValidRoute route =
    case route of
        Home ->
            about

        BlogPost id ->
            post

        BlogPostList ->
            postList

        Visualizations ->
            visualizations
