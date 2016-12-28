module Action exposing (Action(..))

import Navigation


type Action
    = NewUrl String
    | UrlChange Navigation.Location
