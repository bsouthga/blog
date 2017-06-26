module Update exposing (update)

import Route exposing (route, routeToCommand)
import Types exposing (Action(..), Model)
import Navigation
import UrlParser as Url


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

        {-
           api success
        -}
        PostMarkdownResponse (Ok markdown) ->
            ( { model | post = Just markdown }, Cmd.none )

        PostMetadataResponse (Ok postList) ->
            ( { model | postList = Just postList }, Cmd.none )

        GraphicMetadataResponse (Ok vizList) ->
            ( { model | vizList = Just vizList }, Cmd.none )

        {-
           api failure
        -}
        GraphicMetadataResponse (Err _) ->
            ( { model | vizList = Nothing }, Cmd.none )

        PostMarkdownResponse (Err _) ->
            ( { model | post = Nothing }, Cmd.none )

        PostMetadataResponse (Err _) ->
            ( { model | postList = Nothing }, Cmd.none )
