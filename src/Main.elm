{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
   buttons. Use this as a starting point for using elm-mdl components in your own
   app.
-}


module Main exposing (..)


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
    = Mdl (Material.Msg Msg)


-- Boilerplate: Msg clause for internal Mdl messages.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model


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

white : Options.Property c m
white =
  Color.text Color.white

viewBody : Model -> Html Msg
viewBody model = Lists.ul []
 [ Lists.li [] [ Lists.content [] [ card1 ] ]
 , Lists.li [] [ Lists.content [] [ card2 ] ]
 ]

card1 = Card.view
  [ Color.background (Color.color Color.DeepOrange Color.S400)
  , css "width" "192px"
  , css "height" "192px"
  ]
  [ Card.title [ ] [ Card.head [ white ] [ text "Roskilde Festival" ] ]
  , Card.text [ white ] [ text "Buy tickets before May" ]
  , Card.actions
      [ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
      [ Button.render Mdl [8,1] model.mdl
          [ Button.icon, Button.ripple ]
          [ Icon.i "favorite_border" ]
      , Button.render Mdl [8,2] model.mdl
          [ Button.icon, Button.ripple ]
          [ Icon.i "event_available" ]
      ]
  ]

card2 = Card.view
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
          [ Card.head [ white ] [ text "Artificial Heart" ]
          , Card.subhead [ white ] [ text "Jonathan Coulton" ]
          ]
      , Options.img
          [ Options.attribute <| Html.Attributes.src "assets/images/artificial-heart.jpg"
          , css "height" "96px"
          , css "width" "96px"
          ]
          []
      ]
  ]

main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Layout.sub0 Mdl )
        , view = view
        , subscriptions = .mdl >> Layout.subs Mdl
        , update = update
        }
