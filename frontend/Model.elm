module Model exposing (Model, update)

import Model.Route exposing (Route(..), route)
import Action exposing (Action(..))
import Navigation
import UrlParser as Url
import View.Posts exposing (getPost)

type alias Model =
    { page : Maybe Route
    , post : String
    }


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

                cmd = case page of
                    Just (BlogPost id) ->
                        getPost id
                    _ ->
                        Cmd.none
            in
                ( { model | page = page }, cmd )

        ApiResult (Ok markdown) ->
            ( { model | post = markdown }, Cmd.none )

        ApiResult (Err _) ->
            ( { model | post = "Error" }, Cmd.none )



