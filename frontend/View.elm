module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Model.Route exposing (Route(..))
import Action exposing (Action(..))
import View.About
import View.Posts
import View.Visualizations
import View.NotFound


mainStyle : Html.Attribute Action
mainStyle =
    style
        [ ( "height", "100%" )
        , ( "padding", "30px" )
        , ( "margin-bottom", "50px" )
        ]


contentStyle : Html.Attribute Action
contentStyle =
    style
        [ ( "max-width", "800px" )
        , ( "margin", "0 auto" )
        ]


view : Model -> Html Action
view model =
    div [ mainStyle ]
        [ div [ contentStyle ]
            [ h1 [] [ text "Links" ]
            , ul [] (List.map viewLink [ "/", "/blog/", "/blog/dynamic-reports-with-statex", "/visualizations" ])
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
                    View.Posts.renderPostList

                Visualizations ->
                    View.Visualizations.render
