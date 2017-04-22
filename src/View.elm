module View exposing (..)

import Html exposing (..)
import KaTeX


type Either = Text String | MathTex String

splitDefault:  String -> List (Either)
splitDefault  str = splitWith "$$" str


splitWith: String -> String -> List (Either)
splitWith spl str =
  String.split spl str
    |>  wrap (Text, MathTex) []

wrap : ((String -> Either),(String -> Either)) -> List(Either) -> List (String) -> List(Either)
wrap (fn1, fn2)  eithers  list = case list of
  [] -> eithers
  x::xs -> wrap (fn2,fn1) (eithers ++ [fn1 x]) xs

render : String -> List (Html msg)
render str = List.map applyStyle (splitDefault str)


applyStyle : Either  -> Html msg
applyStyle either  = case either of
  Text str -> text str
  MathTex str -> KaTeX.render str
