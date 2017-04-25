module View exposing (..)

import Html exposing (..)

import Regex exposing (..)
import Maybe exposing (..)
import HtmlParser exposing (parse)
import HtmlParser.Util exposing (toVirtualDom )



render : String -> List(Html msg)
render str =
  toStr str
  |> parse
  |> toVirtualDom


toStr : String -> String
toStr str =
  searchHeader str
  |> searchLink
  |> searchBold
  |> searchEmphasis
  |> searchDel
  |> searchMath

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

searchEmphasis : String -> String
searchEmphasis str = replace All (regex "(\\*|_)(.*?)\\1") applyEmphasis  str

applyEmphasis : Match -> String
applyEmphasis match =
  let
    text =
      case match.submatches of
        [sb1,sb2] ->
          withDefault "" sb2
        _ -> ""
  in
   "<em>" ++ text ++"</em>"

searchDel : String -> String
searchDel str = replace All (regex "\\~\\~(.*?)\\~\\~") applyDel  str

applyDel : Match -> String
applyDel match =
  let
    text =
      case match.submatches of
        [sb1] ->
          withDefault "" sb1
        _ -> ""
  in
   "<del>" ++ text ++"</del>"

searchMath : String -> String
searchMath str = replace All (regex "\\$\\$(.*?)\\$\\$") applyMath  str

applyMath : Match -> String
applyMath match =
  let
    text =
      case match.submatches of
        [sb1] ->
          withDefault "" sb1
        _ -> ""
  in
    text
