module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import View



all : Test
all =
    describe "Sample Test Suite"
        [ describe "Unit test markdown math"
                [ test "Header 1 " <|
                    \() ->
                        Expect.equal (View.toStr  "#Title"  ) "<h1>Title</h1>"
                ,test "Header 2 " <|
                    \() ->
                        Expect.equal (View.toStr  "#Title1\n##Title2"  ) "<h1>Title1</h1>\n<h2>Title2</h2>"
                ,test "Header 2 " <|
                    \() ->
                        Expect.equal (View.toStr  "##Title"  ) "<h2>Title</h2>"
                ,test "Header 2 " <|
                    \() ->
                        Expect.equal (View.toStr  "##Title\n ciao"  ) "<h2>Title</h2>\n ciao"
                ,test "Link  " <|
                    \() ->
                        Expect.equal (View.toStr  "ciao [a link](http://www.google.com)"  ) """ciao <a href="http://www.google.com">a link</a>"""
                ,test "Link  and Header " <|
                    \() ->
                        Expect.equal (View.toStr  """#ciao [a link](http://www.google.com)"""  ) """<h1>ciao <a href="http://www.google.com">a link</a></h1>"""
                ,test "Bold **" <|
                    \() ->
                        Expect.equal (View.toStr  "__me bold__"  ) "<strong>me bold</strong>"
                ,test "Bold __" <|
                    \() ->
                        Expect.equal (View.toStr  "**me bold**"  ) "<strong>me bold</strong>"
                ,test "Bold *****" <|
                    \() ->
                        Expect.equal (View.toStr  "*****"  ) "<strong>*</strong>"
                ,test "No Bold ** __" <|
                    \() ->
                        Expect.equal (View.toStr  "**me bold__"  ) "**me bold__"
                ,test "Emphasis *" <|
                    \() ->
                        Expect.equal (View.toStr  "*me em*"  ) "<em>me em</em>"
                ,test "Emphasis _ " <|
                    \() ->
                        Expect.equal (View.toStr  "_me em_"  ) "<em>me em</em>"
                ,test "Emphasis ***" <|
                    \() ->
                        Expect.equal (View.toStr  "***"  ) "<em>*</em>"
                ,test "Emphasis***" <|
                    \() ->
                        Expect.equal (View.toStr  "****"  ) "<em>**</em>"
                ,test "Del" <|
                    \() ->
                        Expect.equal (View.toStr  "~~ciao~~"  ) "<del>ciao</del>"
                ,test "Del" <|
                    \() ->
                        Expect.equal (View.toStr  "~~~~"  ) "~~~~"
                ]
        ]
