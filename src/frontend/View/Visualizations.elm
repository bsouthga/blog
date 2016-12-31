module View.Visualizations exposing (render)

import Html exposing (Html, text, ul, li, h1, div)
import Types exposing (VisualizationMetadata)


-- List of viz


render : Maybe (List VisualizationMetadata) -> Html action
render visualizations =
    case visualizations of
        Nothing ->
            text "unable to retrieve viz"

        Just visList ->
            div []
                [ h1 [] [ text "Visualizations" ]
                , ul []
                    (List.map vizItem visList)
                ]


vizItem : VisualizationMetadata -> Html action
vizItem metadata =
    li [] [ text metadata.title ]
