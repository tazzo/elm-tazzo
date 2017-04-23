module View exposing (..)

import Html exposing (..)
-- import KaTeX
import Regex exposing (..)
import Maybe exposing (..)

type Either = Text String | MathTex String

toStr : String -> String
toStr str =
  searchHeader str
  |> searchLink
  |> searchBold

searchHeader : String -> String
searchHeader str = replace All (regex "(#+)(.*)") applyHeader  str

applyHeader : Match -> String
applyHeader match =
  let
    n =
      case match.submatches of
        [sb1,sb2] ->
          withDefault "" sb1
          |> String.length
          |> toString
        _ -> "1"
    text =
      case match.submatches of
        [sb1,sb2] ->
          withDefault "" sb2
        _ -> ""
  in
   "<h" ++ n ++ ">" ++ text ++"</h" ++ n ++ ">"


searchLink : String -> String
searchLink str = replace All (regex "\\[([^\\[]+)\\]\\(([^\\)]+)\\)") applyLink  str

applyLink : Match -> String
applyLink match =
  let
    link =
      case match.submatches of
        [sb1,sb2] ->
          withDefault "" sb2
        _ -> ""
    text =
      case match.submatches of
        [sb1,sb2] ->
          withDefault "" sb1
        _ -> ""
  in
   "<a href=\"" ++ link ++ "\">" ++ text ++"</a>"

searchBold : String -> String
searchBold str = replace All (regex "(\\*\\*|__)(.*?)\\1") applyBold  str

applyBold : Match -> String
applyBold match =
  let
    text =
      case match.submatches of
        [sb1,sb2] ->
          withDefault "" sb2
        _ -> ""
  in
   "<strong>" ++ text ++"</strong>"

render : String -> List(Html msg)
render str = [text str]
