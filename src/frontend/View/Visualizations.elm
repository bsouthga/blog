module View.Visualizations exposing (render)

import Html exposing (Html, text, ul, li, h1, div, img, a)
import Html.Attributes exposing (src, style, href)
import Types exposing (VisualizationMetadata)
import Html.CssHelpers
import Styles


{ class } =
    Html.CssHelpers.withNamespace "main"



-- List of viz


render : Maybe (List VisualizationMetadata) -> Html action
render visualizations =
    case visualizations of
        Nothing ->
            text "unable to retrieve viz"

        Just visList ->
            div []
                [ h1 [] [ text "Visualizations" ]
                , div [] (List.map vizItem visList)
                ]


vizItem : VisualizationMetadata -> Html action
vizItem metadata =
    a
        [ class [ Styles.VizItem ]
        , href metadata.url
        , style [ ( "filter", "grayscale(100%)" ) ]
        ]
        [ div [] [ text metadata.title ]
        , div
            [ class [ Styles.VizImage ]
            , style
                [ ( "background-image", "url(" ++ metadata.image ++ ")" )
                ]
            ]
            []
        ]
