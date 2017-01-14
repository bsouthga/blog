module View.Graphics exposing (render)

import Html exposing (Html, text, ul, li, h1, div, img, a, span)
import Html.Attributes exposing (src, style, href)
import Types exposing (GraphicMetadata)
import Html.CssHelpers
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"



-- List of viz


render : Maybe (List GraphicMetadata) -> Html action
render graphics =
    case graphics of
        Nothing ->
            text "unable to retrieve viz"

        Just visList ->
            div []
                [ h1 [] [ text "Graphics" ]
                , div [] (List.map vizItem visList)
                ]


vizItem : GraphicMetadata -> Html action
vizItem metadata =
    a
        [ class [ Styles.VizItem ]
        , href metadata.url
        ]
        [ div []
            [ text metadata.title
            , githubLink metadata
            ]
        , div
            [ class [ Styles.VizImage ]
            , style
                [ ( "background-image", "url(" ++ metadata.image ++ ")" )
                , ( "filter", "grayscale(100%)" )
                ]
            ]
            []
        ]


githubLink : GraphicMetadata -> Html action
githubLink metadata =
    case metadata.github of
        Just url ->
            a
                [ href url
                , style [ ( "margin-left", "5px" ) ]
                ]
                [ text "(github)" ]

        Nothing ->
            span [] []
