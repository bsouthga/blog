module View.Posts exposing (post, postList)

import Html exposing (Html, text)


-- Individual blog post


post : String -> Html msg
post id =
    text ( "post: " ++ id )



-- List of available blog posts


postList : Html msg
postList =
    text "postList!"
