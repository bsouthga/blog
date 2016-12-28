module Model exposing (Model, update)

import Model.Route exposing (Route, route)
import Action exposing (Action(..))
import Navigation
import UrlParser as Url


type alias Model =
    { page : Maybe Route
    }


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NewUrl url ->
            ( model
            , Navigation.newUrl url
            )

        UrlChange location ->
            ( { model | page = (Url.parsePath route location) }
            , Cmd.none
            )
