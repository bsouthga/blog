module Update exposing (update)

import Route exposing (route, routeToCommand)
import Types exposing (Action(..), Model)
import Navigation
import UrlParser as Url
import Debug


{-
   TODO: gracefully handle api errors
-}


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NewUrl url ->
            ( model
            , Navigation.newUrl url
            )

        UrlChange location ->
            let
                page =
                    (Url.parsePath route location)

                cmd =
                    routeToCommand page
            in
                ( { model | page = page, post = Just "(loading...)" }, cmd )

        PostMarkdownResponse (Ok markdown) ->
            ( { model | post = Just markdown }, Cmd.none )

        PostMarkdownResponse (Err _) ->
            ( { model | post = Nothing }, Cmd.none )

        PostMetadataResponse (Ok postList) ->
            ( { model | postList = postList }, Cmd.none )

        PostMetadataResponse (Err _) ->
            ( { model | postList = [] }, Cmd.none )

        VisualizationMetadataResponse (Ok vizList) ->
            ( { model | vizList = vizList }, Cmd.none )

        VisualizationMetadataResponse (Err a) ->
            ( { model | vizList = [] }, Cmd.none )
