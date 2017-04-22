module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import View


all : Test
all =
    describe "Sample Test Suite"
        [ describe "Unit test examples"
            [ test "Split " <|
                \() ->
                    Expect.equal (View.splitDefault  "cat$$dog"  ) [View.Text "cat", View.MathTex "dog"]
            ,test "Split start" <|
                \() ->
                    Expect.equal (View.splitWith "$$" "$$cat$$dog"  ) [View.Text "",View.MathTex "cat",View.Text"dog"]
            ,test "Split end" <|
                \() ->
                    Expect.equal (View.splitWith "$$" "cat$$dog$$"  ) [View.Text"cat",View.MathTex "dog",View.Text""]
            ,test "Split double " <|
                \() ->
                    Expect.equal (View.splitWith "$$" "cat$$$$dog"  ) [View.Text"cat",View.MathTex "",View.Text"dog"]
            ]
        ]
