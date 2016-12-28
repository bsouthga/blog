module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Model.Route exposing (Route(..))
import View.About exposing (about)
import View.Posts exposing (post, postList)
import View.Visualizations exposing (visualizations)
import View.NotFound exposing (notFound)
import Action exposing (Action(..))


mainStyle : Html.Attribute Action
mainStyle =
    style
        [ ( "height", "100%" )
        , ( "padding", "30px" )
        ]


view : Model -> Html Action
view model =
    div [ mainStyle ]
        [ h1 [] [ text "Links" ]
        , ul [] (List.map viewLink [ "/", "/blog/", "/blog/dynamic-reports-with-statex", "/visualizations" ])
        , renderRoute model.page
        ]


viewLink : String -> Html Action
viewLink url =
    li [] [ button [ onClick (NewUrl url) ] [ text url ] ]


renderRoute : Maybe Route -> Html action
renderRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            notFound

        Just route ->
            case route of
                Home ->
                    about

                BlogPost id ->
                    post id

                BlogPostList ->
                    postList

                Visualizations ->
                    visualizations
