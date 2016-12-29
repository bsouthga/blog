port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Styles


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "./public/frontend.css", Css.File.compile [ Styles.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
