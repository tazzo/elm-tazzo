{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
   buttons. Use this as a starting point for using elm-mdl components in your own
   app.
-}


port module Main exposing (..)


import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Color as Color
import Material.Icon as Icon
import Material.Card as Card
import Material.List as Lists
import Material.Menu as Menu
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Button as Button
-- PORTS

-- port for sending strings out to JavaScript
port mathjax : String -> Cmd msg



-- You have to add a field to your model where you track the `Material.Model`.
-- This is referred to as the "model container"
type alias Model =
    { count : Int
    , mdl :
        Material.Model
        -- Boilerplate: model store for any and all Mdl components you use.
    , text : String
    }


initModel : Model
initModel =
    { count = 0
    , mdl =
        Material.model
    , text = ""
    }


-- ACTION, UPDATE


-- You need to tag `Msg` that are coming from `Mdl` so you can dispatch them
-- appropriately.
type Msg
    = Mdl (Material.Msg Msg)
    | InputChange String
    | Preview



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model
        InputChange str ->
          ({model| text = str},  Cmd.none )
        Preview ->
          (model, mathjax "alpha")


-- VIEW


type alias Mdl =
    Material.Model




view : Model -> Html Msg
view model =
          Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ,Layout.fixedDrawer
            ]
            { header = header model
            , drawer = drawer
            , tabs =  (  [ ],[ ]  )
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
                , menu model
                ]
            ]
        ]


menu : Model -> Html Msg
menu model = Menu.render Mdl [0,1] model.mdl
  [ Menu.ripple, Menu.bottomRight]
  [ Menu.item
      [ ]
      [ text "English (US)" ]
  , Menu.item
      [ ]
      [ text "français" ]
  , Menu.item
      [ ]
      [ text "中文" ]
  ]


viewBody : Model -> Html Msg
viewBody model = Lists.ul []
 [ Lists.li [] [ Lists.content [] [ tf model ] ]
 , Lists.li [] [ Lists.content [] [ fab model ] ]
 , Lists.li [] [ Lists.content [] [ text model.text ] ]
 , Lists.li [] [ Lists.content [] [ card2 model ] ]
 , Lists.li [] [ Lists.content [] [ card1 model ] ]
 ]

fab model = Button.render Mdl [0,11] model.mdl
  [ Button.raised
  , Options.onClick Preview
  ]
  [ text "preview"]



tf model = Textfield.render Mdl [0,9] model.mdl
  [ Textfield.label "Multiline with 6 rows"
  , Textfield.floatingLabel
  , Textfield.textarea
  , Textfield.rows 6
  ,Options.onInput InputChange
  ]
  []

card1 : Model -> Html Msg
card1 model = Card.view
  [ Color.background (Color.color Color.DeepOrange Color.S400)
  , css "width" "192px"
  , css "height" "192px"
  ]
  [ Card.title [ ] [ Card.head [ Color.text Color.white ] [ text "Roskilde Festival" ] ]
  , Card.text [ Color.text Color.white ] [ text "Buy tickets before May" ]
  , Card.actions
      [ Card.border, css "vertical-align" "center", css "text-align" "right", Color.text Color.white ]
      [ Button.render Mdl [8,1] model.mdl
          [ Button.icon, Button.ripple ]
          [ Icon.i "favorite_border" ]
      , Button.render Mdl [8,2] model.mdl
          [ Button.icon, Button.ripple ]
          [ Icon.i "event_available" ]
      ]
  ]
card2 : Model -> Html Msg
card2 model = Card.view
  [ css "width" "400px"
  , Color.background (Color.color Color.Amber Color.S600)
  ]
  [ Card.title
      [ css "align-content" "flex-start"
      , css "flex-direction" "row"
      , css "align-items" "flex-start"
      , css "justify-content" "space-between"
      ]
      [ Options.div
          []
          [ Card.head [ Color.text Color.white  ] [ text "$$\\displaystyle\\sum_{i=1}^{10} t_i$$" ]
          , Card.subhead [ Color.text Color.white  ] [ text "Jonathan Coulton" ]
          ]
      , Options.img
          [ Options.attribute <| Html.Attributes.src "images/artificial-heart.jpg"
          , css "height" "96px"
          , css "width" "96px"
          ]
          []
      ]
  ]

main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Layout.sub0 Mdl )
        , view = view
        , subscriptions = .mdl >> Layout.subs Mdl
        , update = update
        }
