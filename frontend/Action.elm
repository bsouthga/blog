module Action exposing (Action(..))

import Navigation
import Http


type Action
    = NewUrl String
    | UrlChange Navigation.Location
    | ApiResult (Result Http.Error String)
