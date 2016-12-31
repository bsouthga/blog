module View.Visualizations exposing (render)

import Html exposing (Html, text, ul, li, h1, div)
import Types exposing (VisualizationMetadata)


-- List of viz


render : List VisualizationMetadata -> Html action
render visualizations =
    div []
        [ h1 [] [ text "Visualizations" ]
        , ul []
            (List.map vizItem visualizations)
        ]


vizItem : VisualizationMetadata -> Html action
vizItem metadata =
    li [] [ text metadata.title ]
