{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
   buttons. Use this as a starting point for using elm-mdl components in your own
   app.
-}


module Main exposing (..)


import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Color as Color
import Material.Icon as Icon

-- MODEL


-- You have to add a field to your model where you track the `Material.Model`.
-- This is referred to as the "model container"
type alias Model =
    { count : Int
    , mdl :
        Material.Model
        -- Boilerplate: model store for any and all Mdl components you use.
    , selectedTab : Int
    }


model : Model
model =
    { count = 0
    , mdl =
        Material.model
        -- Boilerplate: Always use this initial Mdl model store.
    , selectedTab = 0
    }


-- ACTION, UPDATE


-- You need to tag `Msg` that are coming from `Mdl` so you can dispatch them
-- appropriately.
type Msg
    = Increase
    | Reset
    | Mdl (Material.Msg Msg)
    | SelectTab Int


-- Boilerplate: Msg clause for internal Mdl messages.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increase ->
            ( { model | count = model.count + 1 }
            , Cmd.none
            )

        Reset ->
            ( { model | count = 0 }
            , Cmd.none
            )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SelectTab num ->
            { model | selectedTab = num } ! []



-- VIEW


type alias Mdl =
    Material.Model




view : Model -> Html Msg
view model =
          Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ,Layout.fixedDrawer
            , Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            ]
            { header = header model
            , drawer = drawer
            , tabs =  (  [ text "Milk", text "Oranges" , text "Red" , text "Blue", text "Yellow", text "Brown"   ],
                        [ Color.background (Color.color Color.Indigo Color.S400) ]
                      )
            , main = [ viewBody model ]
            }

drawer : List (Html Msg)
drawer =
  [ Layout.title [] [ text "Example drawer" ]
  , Layout.navigation
    []
    [  Layout.link
        [ Layout.href "https://github.com/debois/elm-mdl" ]
        [ text "github" ]
    , Layout.link
        [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
        [ text "elm-package" ]
    , Layout.link
        [ Layout.href "#cards"
        , Options.onClick (Layout.toggleDrawer Mdl)
        ]
        [ text "Card component" ]
    ]
  ]

header : Model -> List (Html Msg)
header model =
    [ Layout.row
            [ css "transition" "height 333ms ease-in-out 0s"
            ]
            [ Layout.title [] [ text "elm-mdl" ]
            , Layout.spacer
            , Layout.navigation []
                [ Layout.link
                    [  ]
                    [ Icon.i "photo" ]
                , Layout.link
                    [ Layout.href "https://github.com/debois/elm-mdl" ]
                    [ span [] [ text "github" ] ]
                , Layout.link
                    [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
                    [ text "elm-package" ]
                ]
            ]
        ]




viewBody : Model -> Html Msg
viewBody model =
    case model.selectedTab of
        0 ->
            viewCounter model

        1 ->
            text "something else"

        _ ->
            text "404"


viewCounter : Model -> Html Msg
viewCounter model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ text ("Current count: " ++ toString model.count)
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick Increase
            , css "margin" "0 24px"
            ]
            [ text "Increase" ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick Reset ]
            [ text "Reset" ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Layout.sub0 Mdl )
        , view = view
        , subscriptions = .mdl >> Layout.subs Mdl
        , update = update
        }
