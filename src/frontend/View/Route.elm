module View.Route exposing (renderRoute)

import Html exposing (Html)
import View.About
import View.Posts
import View.Visualizations
import View.NotFound
import Types exposing (Route(..), Action, Model)


renderRoute : Model -> Html Action
renderRoute model =
    case model.page of
        Nothing ->
            View.NotFound.render

        Just route ->
            case route of
                About ->
                    View.About.render

                BlogPost id ->
                    View.Posts.renderPost model.post

                BlogPostList ->
                    View.Posts.renderPostList model.postList

                Visualizations ->
                    View.Visualizations.render model.vizList
