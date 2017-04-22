module View exposing (..)

import HtmlTree exposing (HtmlTree, assembleHtml, leaf, appendText, appendChild, textWrapper, opaque,textAsMarkdown)
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

render : String -> Html msg
render str =
  assembleHtml
    <| assembleHtmlTree str

assembleHtmlTree : String -> HtmlTree msg
assembleHtmlTree str =
  List.foldl applyStyle (leaf "div") (splitDefault str)


applyStyle : Either -> HtmlTree msg -> HtmlTree msg
applyStyle either htmltree = case either of
  Text str -> htmltree
    |> appendChild ( str  |> textWrapper "div" |> textAsMarkdown)
  MathTex str -> htmltree
    |> appendChild (KaTeX.render str|> opaque )
