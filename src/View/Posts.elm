module View.Posts exposing (post, postList)

import Html exposing (Html, text)


-- Individual blog post


post : Html msg
post =
    text "post!"



-- List of available blog posts


postList : Html msg
postList =
    text "postList!"
